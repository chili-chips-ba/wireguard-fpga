from typing import TYPE_CHECKING, Dict, Tuple, List, Optional, Any, cast, Type, Union, Set
from collections import OrderedDict

from ..parser.SystemRDLParser import SystemRDLParser

from .BaseVisitor import BaseVisitor
from .ExprVisitor import ExprVisitor
from .EnumVisitor import EnumVisitor
from .StructVisitor import StructVisitor
from .UDPVisitor import UDPVisitor
from .parameter import Parameter
from .helpers import get_ID_text, KW_TO_COMPONENT_MAP

from .. import ast
from ..source_ref import src_ref_from_antlr, SourceRefBase
from .. import component as comp
from .. import rdltypes

if TYPE_CHECKING:
    from ..compiler import RDLCompiler
    from antlr4.Token import CommonToken
    from antlr4 import ParserRuleContext

#===============================================================================
# Base Component visitor
#===============================================================================
class ComponentVisitor(BaseVisitor):
    comp_type = comp.Component
    component: comp.Component

    def __init__(self, compiler: 'RDLCompiler', comp_def: comp.Component, def_name: Optional[str]=None):
        super().__init__(compiler)

        self.component = comp_def
        self.component.type_name = def_name

        # Scratchpad of local property assignments encountered in body of component
        # format is:
        #   {
        #       prop_name : (prop_src_ref, prop_rhs)
        #   }
        self.property_dict: Dict[str, Tuple[SourceRefBase, Any]] = OrderedDict()

        # Scratchpad of dynamic property assignments encountered in body of component
        # format is:
        #   {
        #       target_path : (
        #           {prop_name, ...},
        #           {mutex_bin: prop_name, ...},
        #       )
        #   }
        self.assigned_properties_dynamic: Dict[str, Tuple[Set[str], Dict[str, str]]] = {}

        self.dpa_children_list_copied: Set[str] = set()
        self.dpa_children_copied: Set[str] = set()

        # Scratchpad to pass stuff down between visitor functions
        self._tmp_comp_def: comp.Component
        self._tmp_comp_inst: comp.Component
        self._tmp_inst_type: CommonToken
        self._tmp_alias_primary_inst: Optional[comp.Reg]

    #---------------------------------------------------------------------------
    # Component Definitions
    #---------------------------------------------------------------------------
    def visitComponent_body(self, ctx: SystemRDLParser.Component_bodyContext) -> comp.Component:
        self.compiler.namespace.enter_scope()

        self.component.def_src_ref = src_ref_from_antlr(ctx)

        # Re-Load any parameters into the local scope
        for param in self.component.parameters_dict.values():
            self.compiler.namespace.register_element(
                param.name,
                param,
                self.component,
                None
            )

        # Visit all component elements.
        # Their visitors will apply changes to the current component
        self.visitChildren(ctx)

        self.apply_local_properties()

        self.compiler.namespace.exit_scope()
        return self.component

    def visitComponent_def(self, ctx: SystemRDLParser.Component_defContext) -> None:
        """
        Create, and possibly instantiate a component
        """

        # Get definition. Returns Component
        if ctx.component_anon_def() is not None:
            comp_def = self.visit(ctx.component_anon_def())
        elif ctx.component_named_def() is not None:
            comp_def = self.visit(ctx.component_named_def())
        else:
            raise RuntimeError

        comp_def.parent_scope = self.component

        if ctx.component_insts() is not None:
            if isinstance(self, RootVisitor) and isinstance(comp_def, comp.Addrmap):
                self.msg.warning(
                    "Non-standard instantiation of an addrmap in root namespace will be ignored",
                    src_ref_from_antlr(ctx.component_insts().component_inst(0).ID())
                )
            else:
                # Component is instantiated one or more times
                if ctx.component_inst_type() is not None:
                    inst_type = self.visit(ctx.component_inst_type())
                else:
                    inst_type = None

                # Pass some temporary info to visitComponent_insts
                self._tmp_comp_def = comp_def
                self._tmp_inst_type = inst_type
                self._tmp_alias_primary_inst = None
                self.visit(ctx.component_insts())

    def visitComponent_named_def(self, ctx: SystemRDLParser.Component_named_defContext) -> comp.Component:
        type_token = self.visit(ctx.component_type())
        self.check_comp_def_allowed(type_token)
        comp_def = self.create_new_component(type_token)

        def_name = get_ID_text(ctx.ID())

        # Process any parameters for the component
        if ctx.param_def() is not None:
            self._tmp_comp_def = comp_def
            self.visit(ctx.param_def())

        # Recurse into the component definition body
        body = ctx.component_body()
        self.process_component_body(comp_def, body, type_token, def_name)

        # Since the definition is named, register it with the namespace
        self.compiler.namespace.register_type(def_name, comp_def, src_ref_from_antlr(ctx.ID()))

        # A named component's scope name is the same as its type name
        comp_def._scope_name = def_name

        return comp_def


    def visitComponent_anon_def(self, ctx: SystemRDLParser.Component_anon_defContext) -> comp.Component:
        type_token = self.visit(ctx.component_type())
        self.check_comp_def_allowed(type_token)
        comp_def = self.create_new_component(type_token)

        body = ctx.component_body()
        self.process_component_body(comp_def, body, type_token, None)

        return comp_def

    def check_comp_def_allowed(self, type_token: 'CommonToken') -> None:
        pass

    def create_new_component(self, type_token: 'CommonToken') -> comp.Component:
        """
        Given the component type keyword token (eg, ADDRMAP_kw), create an
        instance of the corresponding component class.
        """
        comp_cls = KW_TO_COMPONENT_MAP[type_token.type]
        return comp_cls()


    def process_component_body(self, comp_def: comp.Component, body: SystemRDLParser.Component_bodyContext, type_token: 'CommonToken', def_name: Optional[str]) -> None:
        """
        Given initial component definition info, recurse to another visitor to
        process the body of the component definition
        """
        visitor_cls = KW_TO_VISITOR_MAP[type_token.type]
        visitor = visitor_cls(self.compiler, comp_def, def_name)
        visitor.visit(body)

    #---------------------------------------------------------------------------
    # Component Instantiation
    #---------------------------------------------------------------------------
    def visitExplicit_component_inst(self, ctx: SystemRDLParser.Explicit_component_instContext) -> None:
        if ctx.component_inst_type() is not None:
            inst_type = self.visit(ctx.component_inst_type())
        else:
            inst_type = None

        comp_def = self.component_def_from_token(ctx.ID())

        if ctx.component_inst_alias() is not None:
            # Get instance that is being aliased
            alias_primary_inst = self.visit(ctx.component_inst_alias())

            if not isinstance(comp_def, comp.Reg):
                self.msg.error(
                    "Type of alias must be a 'reg' component",
                    src_ref_from_antlr(ctx.ID())
                )
                return
        else:
            alias_primary_inst = None

        # Pass some temporary info to visitComponent_insts
        self._tmp_comp_def = comp_def
        self._tmp_inst_type = inst_type
        self._tmp_alias_primary_inst = alias_primary_inst
        self.visit(ctx.component_insts())

    def visitComponent_inst_alias(self, ctx: SystemRDLParser.Component_inst_aliasContext) -> comp.Component:
        name = get_ID_text(ctx.ID())
        inst, _ = self.compiler.namespace.lookup_element(name)
        if inst is None:
            self.msg.fatal(
                "Reference to '%s' not found" % name,
                src_ref_from_antlr(ctx.ID())
            )
        elif not isinstance(inst, comp.Reg):
            self.msg.fatal(
                "Alias primary component '%s' must be of type 'reg'" % name,
                src_ref_from_antlr(ctx.ID())
            )
        elif inst.is_alias:
            self.msg.fatal(
                "Alias primary register '%s' cannot be another alias" % name,
                src_ref_from_antlr(ctx.ID())
            )
        return inst

    def visitComponent_insts(self, ctx: SystemRDLParser.Component_instsContext) -> None:
        # Unpack instance def info from parent
        comp_def = self._tmp_comp_def
        inst_type = self._tmp_inst_type
        alias_primary_inst = self._tmp_alias_primary_inst

        # Get a dictionary of parameter assignments
        if ctx.param_inst() is not None:
            param_assigns = self.visit(ctx.param_inst())
        else:
            param_assigns = {}

        # Do instantiations
        common_type_name = comp_def.type_name
        for inst_ctx in ctx.getTypedRuleContexts(SystemRDLParser.Component_instContext):
            # Make a copy of the definition for instantiation
            comp_inst = comp_def._copy_for_inst({})
            comp_inst.original_def = comp_def

            # Resolve whether instance is internal/external
            self.resolve_inst_external(ctx, comp_inst, inst_type)

            # Override parameters
            self.assign_inst_parameters(comp_inst, param_assigns)

            # Resolve type name
            if common_type_name is None:
                # 5.1.1-f: The first instance name of an anonymous definition is
                #   also used as the component type name.
                common_type_name = get_ID_text(inst_ctx.ID())
            comp_inst.type_name = common_type_name

            # If scope name was unset, then this was an anonymous declaration.
            # Use the common type name inherited by the first instantiation
            if comp_inst.original_def._scope_name is None:
                comp_inst.original_def._scope_name = common_type_name

            # Pass some temporary info to visitComponent_inst
            self._tmp_comp_inst = comp_inst
            self._tmp_alias_primary_inst = alias_primary_inst
            self.visit(inst_ctx)


    def assign_inst_parameters(self, comp_inst: comp.Component, param_assigns: Dict[str, Tuple[ast.ASTNode, SourceRefBase]]) -> None:
        for param_name, (assign_expr, src_ref) in param_assigns.items():
            # Lookup corresponding parameter in component
            if param_name in comp_inst.parameters_dict:
                param = comp_inst.parameters_dict[param_name]
            else:
                self.msg.fatal(
                    "Parameter '%s' not found in definition for component '%s'"
                    % (param_name, comp_inst.type_name),
                    src_ref
                )

            # Override the parameter's value
            assign_expr = ast.AssignmentCast(
                self.compiler.env,
                src_ref,
                assign_expr,
                param.param_type #pylint: disable=possibly-used-before-assignment
            )
            assign_expr.predict_type()
            param.expr = assign_expr


    def resolve_inst_external(self, ctx: SystemRDLParser.Component_instsContext, comp_inst: comp.Component, inst_type: 'CommonToken') -> None:
        """
        Given the instance type token (external/internal), resolve the
        Component.external boolean value specific to the component type
        """
        # Resolve internal/external instance type
        if isinstance(comp_inst, (comp.Field, comp.Signal)) and inst_type is not None:
            self.msg.error(
                "internal/external instance type is not valid for signal or field components",
                src_ref_from_antlr(inst_type)
            )
        elif isinstance(comp_inst, comp.Mem):
            comp_inst.external = True
            if (inst_type is None) or (inst_type.type != SystemRDLParser.EXTERNAL_kw):
                self.msg.error(
                    "mem components shall be instantiated as 'external'",
                    src_ref_from_antlr(ctx)
                )
        elif isinstance(comp_inst, comp.Addrmap):
            comp_inst.external = True
            if (inst_type is not None) and (inst_type.type == SystemRDLParser.INTERNAL_kw):
                self.msg.error(
                    "addrmap components are implicitly external. Cannot declare as internal",
                    src_ref_from_antlr(inst_type)
                )
        elif isinstance(comp_inst, comp.Reg):
            if inst_type is not None:
                if inst_type.type == SystemRDLParser.EXTERNAL_kw:
                    comp_inst.external = True
                elif inst_type.type == SystemRDLParser.INTERNAL_kw:
                    comp_inst.external = False
            else:
                # Leave as None. Elaborate step will resolve later.
                comp_inst.external = None

        elif isinstance(comp_inst, comp.Regfile):
            if inst_type is not None:
                if inst_type.type == SystemRDLParser.EXTERNAL_kw:
                    comp_inst.external = True
                elif inst_type.type == SystemRDLParser.INTERNAL_kw:
                    comp_inst.external = False
            else:
                # Leave as None. Elaborate step will resolve later.
                comp_inst.external = None


    def get_instance_assignment(self, ctx: Optional['ParserRuleContext']) -> Optional[ast.ASTNode]:
        """
        Gets the integer expression in any of the four instance assignment
        operators ('=' '@' '+=' '%=')
        """
        if ctx is None:
            return None

        visitor = ExprVisitor(self.compiler)
        expr = visitor.visit(ctx.expr())
        expr = ast.AssignmentCast(self.compiler.env, src_ref_from_antlr(ctx.op), expr, int)
        expr.predict_type()
        return expr

    def visitComponent_inst(self, ctx: SystemRDLParser.Component_instContext) -> None:
        # Unpack instance def info from parent
        comp_inst = self._tmp_comp_inst
        alias_primary_inst = self._tmp_alias_primary_inst

        inst_name = get_ID_text(ctx.ID())
        comp_inst.inst_name = inst_name
        comp_inst.inst_src_ref = src_ref_from_antlr(ctx.ID())

        # Get array or range suffix
        array_suffixes = []
        for as_ctx in ctx.getTypedRuleContexts(SystemRDLParser.Array_suffixContext):
            array_suffixes.append(self.visit(as_ctx))

        if ctx.range_suffix() is not None:
            range_suffix = self.visit(ctx.range_suffix())
        else:
            range_suffix = None

        # Check for invalid usage of array or range suffix
        if isinstance(comp_inst, comp.Field):
            # field can use a range, or a single array suffix
            if len(array_suffixes) > 1:
                self.msg.fatal(
                    "Instances of a field can only use one array suffix",
                    src_ref_from_antlr(ctx.array_suffix(1))
                )
        elif isinstance(comp_inst, comp.Signal):
            # signal can use a single array suffix
            if len(array_suffixes) > 1:
                self.msg.fatal(
                    "Instances of a signal can only use one array suffix",
                    src_ref_from_antlr(ctx.array_suffix(1))
                )
            if range_suffix is not None:
                self.msg.fatal(
                    "Unexpected range suffix after signal instance",
                    src_ref_from_antlr(ctx.range_suffix())
                )
        else:
            # Everything else can use any number of array suffixes
            if range_suffix is not None:
                self.msg.fatal(
                    "Unexpected range suffix after instance",
                    src_ref_from_antlr(ctx.range_suffix())
                )

        # Get all instance assignment expressions
        field_inst_reset = self.get_instance_assignment(ctx.field_inst_reset())
        inst_addr_fixed = self.get_instance_assignment(ctx.inst_addr_fixed())
        inst_addr_stride = self.get_instance_assignment(ctx.inst_addr_stride())
        inst_addr_align = self.get_instance_assignment(ctx.inst_addr_align())

        # Check for assignment expression incompatibility
        if isinstance(comp_inst, (comp.Field, comp.Signal)):
            err_token = None
            if inst_addr_fixed is not None:
                err_token = ctx.inst_addr_fixed().start
            elif inst_addr_stride is not None:
                err_token = ctx.inst_addr_stride().start
            elif inst_addr_align is not None:
                err_token = ctx.inst_addr_align().start

            if err_token is not None:
                self.msg.fatal(
                    "Unexpected address allocation operator for non-addressable instance",
                    src_ref_from_antlr(err_token)
                )

        if isinstance(comp_inst, comp.Signal):
            # none of these are allowed for signals
            if field_inst_reset is not None:
                self.msg.fatal(
                    "Unexpected field reset assignment for non-field instance",
                    src_ref_from_antlr(ctx.field_inst_reset().start)
                )
        elif not isinstance(comp_inst, comp.Field):
            # Otherwise, inst_addr_fixed and inst_addr_align are mutually exclusive
            if all([inst_addr_fixed, inst_addr_align]):
                self.msg.fatal(
                    "Fixed address allocator '@' cannot be used along with an alignment allocator '%='",
                    src_ref_from_antlr(ctx.inst_addr_fixed().start)
                )

            if field_inst_reset is not None:
                self.msg.fatal(
                    "Unexpected field reset assignment for non-field instance",
                    src_ref_from_antlr(ctx.field_inst_reset().start)
                )


        # Specifying stride is only allowed if an array suffix is used
        if (inst_addr_stride is not None) and (not array_suffixes):
            self.msg.fatal(
                "Unexpected address stride allocator '+=' on non-array instance",
                src_ref_from_antlr(ctx.inst_addr_stride().start)
            )

        # Do instantiation
        comp_inst.is_instance = True
        if isinstance(comp_inst, comp.VectorComponent):
            if range_suffix is not None:
                comp_inst.msb, comp_inst.lsb = range_suffix
            if array_suffixes:
                comp_inst.width = array_suffixes[0]

            # directly override field reset property
            if (field_inst_reset is not None) and (type(comp_inst == comp.Field)):
                comp_inst.properties['reset'] = field_inst_reset

        elif isinstance(comp_inst, comp.AddressableComponent):
            # Cast to pre-elaborated variant to satisfy type hinting
            comp_inst = cast(comp.AddressableComponent_PreExprElab, comp_inst)

            comp_inst.addr_offset = inst_addr_fixed
            comp_inst.addr_align = inst_addr_align
            if array_suffixes:
                comp_inst.is_array = True
                comp_inst.array_dimensions = array_suffixes
                comp_inst.array_stride = inst_addr_stride
        else:
            raise RuntimeError

        if alias_primary_inst is not None:
            if isinstance(comp_inst, comp.Reg):
                comp_inst.is_alias = True
                comp_inst.alias_primary_inst = alias_primary_inst
            else:
                raise RuntimeError

        self.component.children.append(comp_inst)

        self.compiler.namespace.register_element(
            inst_name, comp_inst, self.component,
            src_ref_from_antlr(ctx.ID())
        )

    #---------------------------------------------------------------------------
    # Parameters
    #---------------------------------------------------------------------------
    def visitParam_def(self, ctx: SystemRDLParser.Param_defContext) -> None:
        """
        Parameter Definition block
        """
        self.compiler.namespace.enter_scope()
        for elem in ctx.getTypedRuleContexts(SystemRDLParser.Param_def_elemContext):
            self.visit(elem)
        self.compiler.namespace.exit_scope()

    def visitParam_def_elem(self, ctx: SystemRDLParser.Param_def_elemContext) -> None:
        """
        Individual parameter definition elements
        """
        comp_def = self._tmp_comp_def # component definition of incoming component

        # Construct parameter type
        data_type_token = self.visit(ctx.data_type())
        param_data_type = self.datatype_from_token(data_type_token)
        param_type: Union[Type[Union[int, str, bool, rdltypes.BuiltinEnum, rdltypes.UserEnum, rdltypes.UserStruct, rdltypes.references.RefType, comp.Component]], rdltypes.ArrayedType]
        if ctx.array_type_suffix() is None:
            # Non-array type
            param_type = param_data_type
        else:
            # Array-like type
            param_type = rdltypes.ArrayedType(param_data_type)

        # Get parameter name
        param_name = get_ID_text(ctx.ID())

        # Get expression for parameter default, if any
        if ctx.expr() is not None:
            visitor = ExprVisitor(self.compiler)
            default_expr = visitor.visit(ctx.expr())
            default_expr = ast.AssignmentCast(
                self.compiler.env,
                src_ref_from_antlr(ctx.ID()),
                default_expr,
                param_type
            )
            default_expr.predict_type()
        else:
            default_expr = None

        # Create Parameter object
        param = Parameter(param_type, param_name, default_expr)

        # Register it in the parameter def namespace scope
        self.compiler.namespace.register_element(
            param_name,
            param,
            comp_def,
            src_ref_from_antlr(ctx.ID())
        )

        # Add it to the new component's definition
        comp_def.parameters_dict[param_name] = param

    def visitParam_inst(self, ctx: SystemRDLParser.Param_instContext) -> Dict[str, Tuple[ast.ASTNode, Optional[SourceRefBase]]]:
        param_assigns = {}
        for assignment in ctx.getTypedRuleContexts(SystemRDLParser.Param_assignmentContext):
            param_name, assign_expr = self.visit(assignment)

            src_ref = src_ref_from_antlr(assignment.ID())

            if param_name in param_assigns:
                self.msg.fatal(
                    "Duplicate assignment to parameter '%s'" % param_name,
                    src_ref
                )

            param_assigns[param_name] = (assign_expr, src_ref)
        return param_assigns

    def visitParam_assignment(self, ctx: SystemRDLParser.Param_assignmentContext) -> Tuple[str, ast.ASTNode]:
        param_name = get_ID_text(ctx.ID())

        visitor = ExprVisitor(self.compiler)
        # Note: AssignmentCast is handled in the visitComponent_insts Visitor
        assign_expr = visitor.visit(ctx.expr())
        return param_name, assign_expr

    #---------------------------------------------------------------------------
    # Property Assignments
    #---------------------------------------------------------------------------
    def visitLocal_property_assignment(self, ctx: SystemRDLParser.Local_property_assignmentContext) -> None:

        default = ctx.DEFAULT_kw() is not None

        if ctx.normal_prop_assign() is not None:
            prop_src_ref, prop_name, rhs = self.visit(ctx.normal_prop_assign())
        elif ctx.encode_prop_assign() is not None:
            prop_src_ref, prop_name, rhs = self.visit(ctx.encode_prop_assign())
        elif ctx.prop_mod_assign() is not None:
            prop_src_ref, prop_mod = self.visit(ctx.prop_mod_assign())

            # Implies assignment to intr=true
            # Do not check for multiple assignments to intr
            if default:
                self.compiler.namespace.register_default_property(
                    "intr", True, prop_src_ref,
                    overwrite_ok=True
                )
            else:
                self.property_dict["intr"] = (prop_src_ref, True)

            if prop_mod == "nonsticky":
                # Implies assignment stickybit = false;
                prop_name = "stickybit"
                rhs = False
            else:
                # Assign interrupt type modifier
                prop_name = "intr type"
                rhs = rdltypes.InterruptType[prop_mod]

        else:
            raise RuntimeError

        if default:
            self.compiler.namespace.register_default_property(prop_name, rhs, prop_src_ref)
        else:
            # Check if multiple assignments in current scope.
            # Exclude "intr" property from this check since interrupt prop mod assignments
            # make this messy.
            if (prop_name in self.property_dict) and (prop_name != "intr"):
                self.msg.fatal(
                    "Property '%s' was already assigned in this scope" % prop_name,
                    prop_src_ref
                )

            self.property_dict[prop_name] = (prop_src_ref, rhs)

    def visitDynamic_property_assignment(self, ctx: SystemRDLParser.Dynamic_property_assignmentContext) -> None:

        # List of component instance names in the hierarchical path
        name_tokens = self.visit(ctx.instance_ref())

        if ctx.normal_prop_assign() is not None:
            prop_src_ref, prop_name, rhs = self.visit(ctx.normal_prop_assign())
        elif ctx.encode_prop_assign() is not None:
            prop_src_ref, prop_name, rhs = self.visit(ctx.encode_prop_assign())
        else:
            raise RuntimeError

        # Lookup component instance being assigned
        current_component = self.component
        is_first_lvl = True
        target_path: str = ""
        for name_token in name_tokens:
            inst_name = get_ID_text(name_token)
            target_path += "." + inst_name # yes this result in a leading '.', i don't care
            child_idx = get_child_comp_index(current_component, inst_name)
            if child_idx is None:
                # Not found!
                self.msg.fatal(
                    "Could not resolve hierarchical reference to '%s'" % inst_name,
                    src_ref_from_antlr(name_token)
                )

            if not is_first_lvl:
                # Is not the first iteration of this loop

                # Traversing deeper "through" an intermediate component.
                # Mark the prior one, denoting that this happened
                current_component._dyn_assigned_children.add(inst_name)

                # DPA is going to modify one of the children. Make a copy of the child,
                # as well as the list that contains it to ensure this lineage is
                # distinct from others.
                # This is not necessary for the first level (immediate children
                # of self.component) since these were just recently instantiated,
                # and therefore were already copied once for this scope.
                # Also, it is possible to skip copies if they were already performed in this scope
                if target_path not in self.dpa_children_list_copied:
                    current_component.children = current_component.children.copy()
                    self.dpa_children_list_copied.add(target_path)
                if target_path not in self.dpa_children_copied:
                    current_component.children[child_idx] = current_component.children[child_idx]._copy_for_inst({})
                    self.dpa_children_copied.add(target_path)

            # Advance to next level
            current_component = current_component.children[child_idx]
            is_first_lvl = False

        # Path traversal is done. current_component is the assignment target
        rule = self.compiler.env.property_rules.lookup_property(prop_name)
        if rule is None:
            self.msg.fatal(
                "Unrecognized property '%s'" % prop_name,
                prop_src_ref
            )

        # Is dynamic assignment allowed?
        if not rule.dyn_assign_allowed:
            self.msg.fatal(
                "Dynamic assignment to property '%s' is not allowed" % prop_name,
                prop_src_ref
            )

        assigned_props, assigned_mutex_bins = self.assigned_properties_dynamic.get(target_path, (set(), {}))

        # Check for mutex collisions
        if rule.mutex_group is not None and rule.mutex_group in assigned_mutex_bins:
            # Already saw something in this mutex group
            self.msg.fatal(
                "Properties '%s' and '%s' cannot be assigned in the same component"
                % (prop_name, assigned_mutex_bins[rule.mutex_group]),
                prop_src_ref
            )

        # Check if property already assigned from this scope
        if prop_name in assigned_props:
            self.msg.fatal(
                "Property '%s' was already assigned to component '%s' from within this scope"
                % (prop_name, get_ID_text(name_tokens[-1])),
                prop_src_ref
            )

        # Apply property
        rule.assign_value(current_component, rhs, prop_src_ref)
        assigned_props.add(prop_name)
        if rule.mutex_group is not None:
            assigned_mutex_bins[rule.mutex_group] = prop_name
        current_component._dyn_assigned_props.add(prop_name)
        self.assigned_properties_dynamic[target_path] = (assigned_props, assigned_mutex_bins)

    def visitInstance_ref(self, ctx: SystemRDLParser.Instance_refContext) -> List['CommonToken']:
        name_tokens = []
        for ref_elem in ctx.getTypedRuleContexts(SystemRDLParser.Instance_ref_elementContext):
            name_tokens.append(self.visit(ref_elem))
        return name_tokens

    def visitInstance_ref_element(self, ctx: SystemRDLParser.Instance_ref_elementContext) -> 'CommonToken':
        name_token = ctx.ID()

        # Intentionally not supporting array references in dynamic assignments
        # due to heterogeneous array complications.
        for as_ctx in ctx.getTypedRuleContexts(SystemRDLParser.Array_suffixContext):
            self.msg.fatal(
                "Use of array suffixes in dynamic property assignments is not supported",
                src_ref_from_antlr(as_ctx)
            )

        return name_token

    def visitNormal_prop_assign(self, ctx: SystemRDLParser.Normal_prop_assignContext) -> Tuple[Optional[SourceRefBase], str, Optional[ast.ASTNode]]:

        # Get property string
        if ctx.prop_keyword() is not None:
            prop_token = self.visit(ctx.prop_keyword())
            prop_name = prop_token.text
        else:
            prop_token = ctx.ID()
            prop_name = get_ID_text(prop_token)

        if ctx.prop_assignment_rhs() is not None:
            rhs = self.visit(ctx.prop_assignment_rhs())
        else:
            # No explicit RHS
            # What this implies is resolved later
            rhs = None

        return src_ref_from_antlr(prop_token), prop_name, rhs

    def visitEncode_prop_assign(self, ctx: SystemRDLParser.Encode_prop_assignContext) -> Tuple[SourceRefBase, str, rdltypes.UserEnum]:
        # Get property string
        prop_token = ctx.ENCODE_kw()
        prop_name = get_ID_text(prop_token)

        enum_name = get_ID_text(ctx.ID())

        enum_type = self.compiler.namespace.lookup_type(enum_name)
        if enum_type is None:
            self.msg.fatal(
                "Type '%s' is not defined" % enum_name,
                src_ref_from_antlr(ctx.ID())
            )
        if not rdltypes.is_user_enum(enum_type):
            self.msg.fatal(
                "Assignment to encode property is not an enum type",
                src_ref_from_antlr(ctx.ID())
            )
        rhs = enum_type

        return src_ref_from_antlr(prop_token), prop_name, rhs # type: ignore


    def visitProp_mod_assign(self, ctx: SystemRDLParser.Prop_mod_assignContext) -> Tuple[Optional[SourceRefBase], str]:
        prop_mod_token = self.visit(ctx.prop_mod())
        prop_mod = prop_mod_token.text

        intr_token = ctx.ID()

        if intr_token.getText() != "intr":
            self.msg.fatal(
                "extraneous input '%s' expecting 'intr'" % intr_token.getText(),
                src_ref_from_antlr(intr_token)
            )

        return src_ref_from_antlr(prop_mod_token), prop_mod

    def visitProp_assignment_rhs(self, ctx: SystemRDLParser.Prop_assignment_rhsContext) -> Any:

        if ctx.expr() is not None:
            visitor = ExprVisitor(self.compiler)
            rhs = visitor.visit(ctx.expr())
        else:
            rhs = self.visit(ctx.precedencetype_literal())

        return rhs

    def visitPrecedencetype_literal(self, ctx: SystemRDLParser.Precedencetype_literalContext) -> rdltypes.PrecedenceType:
        return rdltypes.PrecedenceType[ctx.kw.text]

    def apply_local_properties(self) -> None:

        # First, apply default property assignments inherited from namespace
        for prop_name, (prop_src_ref, prop_rhs) in self.compiler.namespace.get_default_properties(type(self.component)).items():
            rule = self.compiler.env.property_rules.lookup_property(prop_name)
            if rule is None:
                self.msg.fatal(
                    "Unrecognized property '%s'" % prop_name,
                    prop_src_ref
                )
            rule.assign_value(self.component, prop_rhs, prop_src_ref)

        # Apply locally-assigned properties
        mutex_bins: Dict[str, str] = {}
        for prop_name, (prop_src_ref, prop_rhs) in self.property_dict.items():
            rule = self.compiler.env.property_rules.lookup_property(prop_name)
            if rule is None:
                self.msg.fatal(
                    "Unrecognized property '%s'" % prop_name,
                    prop_src_ref
                )

            # Check for mutex collisions
            if rule.mutex_group is not None:
                # Is mutually exclusive with other props. Check for collision
                if rule.mutex_group in mutex_bins:
                    # Already saw something in this mutex group
                    self.msg.fatal(
                        "Properties '%s' and '%s' cannot be assigned in the same component"
                        % (prop_name, mutex_bins[rule.mutex_group]),
                        prop_src_ref
                    )
                else:
                    mutex_bins[rule.mutex_group] = prop_name

            # Apply property
            rule.assign_value(self.component, prop_rhs, prop_src_ref)

        # Clear out pending assignments now that they have been resolved
        self.property_dict = {}

    #---------------------------------------------------------------------------
    # Array and Range suffixes
    #---------------------------------------------------------------------------
    def visitRange_suffix(self, ctx: SystemRDLParser.Range_suffixContext) -> Tuple[ast.ASTNode, ast.ASTNode]:
        visitor = ExprVisitor(self.compiler)
        expr1 = visitor.visit(ctx.expr(0))
        expr1 = ast.AssignmentCast(self.compiler.env, src_ref_from_antlr(ctx.expr(0)), expr1, int)
        expr1.predict_type()

        expr2 = visitor.visit(ctx.expr(1))
        expr2 = ast.AssignmentCast(self.compiler.env, src_ref_from_antlr(ctx.expr(1)), expr2, int)
        expr2.predict_type()

        return expr1, expr2

    def visitArray_suffix(self, ctx: SystemRDLParser.Array_suffixContext) -> ast.ASTNode:
        visitor = ExprVisitor(self.compiler)
        expr = visitor.visit(ctx.expr())
        expr = ast.AssignmentCast(self.compiler.env, src_ref_from_antlr(ctx.expr()), expr, int)
        expr.predict_type()
        return expr

    #---------------------------------------------------------------------------
    # Type Handling
    #---------------------------------------------------------------------------

    def component_def_from_token(self, id_token: 'CommonToken') -> comp.Component:
        def_name = get_ID_text(id_token)
        comp_def = self.compiler.namespace.lookup_type(def_name)
        if comp_def is None:
            self.msg.fatal(
                "Type '%s' is not defined" % def_name,
                src_ref_from_antlr(id_token)
            )
        if not isinstance(comp_def, comp.Component):
            self.msg.fatal(
                "Type '%s' is not a component type" % def_name,
                src_ref_from_antlr(id_token)
            )

        return comp_def

    #---------------------------------------------------------------------------
    # User-defined enum
    #---------------------------------------------------------------------------
    def visitEnum_def(self, ctx: SystemRDLParser.Enum_defContext) -> None:
        visitor = EnumVisitor(self.compiler, self.component)
        enum_type, name, src_ref = visitor.visit(ctx)
        self.compiler.namespace.register_type(name, enum_type, src_ref)

    #---------------------------------------------------------------------------
    # User-defined struct
    #---------------------------------------------------------------------------
    def visitStruct_def(self, ctx: SystemRDLParser.Struct_defContext) -> None:
        visitor = StructVisitor(self.compiler, self.component)
        struct_type, name, src_ref = visitor.visit(ctx)
        self.compiler.namespace.register_type(name, struct_type, src_ref)

    #---------------------------------------------------------------------------
    # Constraint Definition
    #---------------------------------------------------------------------------
    def visitConstraint_def(self, ctx: SystemRDLParser.Constraint_defContext) -> None:
        # TODO: Implement constraints
        pass

#===============================================================================
# Root meta-component visitor
#===============================================================================
class RootVisitor(ComponentVisitor):
    comp_type = comp.Root
    component: comp.Root

    def visitRoot(self, ctx: SystemRDLParser.RootContext) -> None:
        self.visitChildren(ctx)

    def visitLocal_property_assignment(self, ctx: SystemRDLParser.Local_property_assignmentContext) -> None:
        # The only local assignments allowed in Root are default assignments
        if ctx.DEFAULT_kw() is None:
            self.msg.error(
                "Illegal property assignment in root namespace",
                src_ref_from_antlr(ctx)
            )
        super().visitLocal_property_assignment(ctx)


    def process_component_body(self, comp_def: comp.Component, body: SystemRDLParser.Component_bodyContext, type_token: 'CommonToken', def_name: Optional[str]) -> None:
        super().process_component_body(comp_def, body, type_token, def_name)

        if def_name is not None:
            self.component.comp_defs[def_name] = comp_def

    def visitComponent_anon_def(self, ctx: SystemRDLParser.Component_anon_defContext) -> comp.Component:
        type_token = self.visit(ctx.component_type())
        if type_token.type == SystemRDLParser.ADDRMAP_kw:
            self.msg.fatal(
                "Definitions of addrmap components in the root namespace must declare a type name.",
                src_ref_from_antlr(type_token)
            )
        return super().visitComponent_anon_def(ctx)

    def visitComponent_insts(self, ctx: SystemRDLParser.Component_instsContext) -> None:
        # Unpack instance def info from parent
        comp_def = self._tmp_comp_def

        if not isinstance(comp_def, comp.Signal):
            self.msg.fatal(
                "Instantiation of '%s' components not allowed in the root namespace"
                % type(comp_def).__name__.lower(),
                src_ref_from_antlr(ctx.component_inst(0).ID())
            )

        super().visitComponent_insts(ctx)

    #---------------------------------------------------------------------------
    # User-defined Properties
    #---------------------------------------------------------------------------
    def visitUdp_def(self, ctx: SystemRDLParser.Udp_defContext) -> None:
        visitor = UDPVisitor(self.compiler)
        visitor.visit(ctx)

#===============================================================================
# Field Component visitor
#===============================================================================
class FieldComponentVisitor(ComponentVisitor):
    comp_type = comp.Field
    component: comp.Field

    def visitComponent_insts(self, ctx: SystemRDLParser.Component_instsContext) -> None:
        # Unpack instance def info from parent
        comp_def = self._tmp_comp_def

        # 9.2-a: No other types of structural components shall be defined within a field component.
        # 9.1: ... however, signal, enumeration (enum), and constraint components can be defined within a field component
        # (and i assume this implies they can be instantiated, otherwise that would make no sense)
        if not isinstance(comp_def, comp.Signal):
            self.msg.fatal(
                "Instantiation of '%s' components not allowed inside a field definition"
                % type(comp_def).__name__.lower(),
                src_ref_from_antlr(ctx.component_inst(0).ID())
            )
        super().visitComponent_insts(ctx)

    def check_comp_def_allowed(self, type_token: 'CommonToken') -> None:
        comp_type = KW_TO_COMPONENT_MAP[type_token.type]

        # 9.2-a: No other types of structural components shall be defined within a field component.
        # 9.1: ... however, signal, enumeration (enum), and constraint components can be defined within a field component
        if comp_type is not comp.Signal:
            self.msg.fatal(
                "Definitions of '%s' components not allowed inside a field definition"
                % comp_type.__name__.lower(),
                src_ref_from_antlr(type_token)
            )

#===============================================================================
# Reg Component visitor
#===============================================================================
class RegComponentVisitor(ComponentVisitor):
    comp_type = comp.Reg
    component: comp.Reg

    def visitComponent_insts(self, ctx: SystemRDLParser.Component_instsContext) -> None:
        # Unpack instance def info from parent
        comp_def = self._tmp_comp_def

        # 10.2-b-1-ii: Component instantiations are limited to field, constraint, and signal instances
        if not isinstance(comp_def, (comp.Signal, comp.Field)):
            self.msg.fatal(
                "Instantiation of '%s' components not allowed inside a reg definition"
                % type(comp_def).__name__.lower(),
                src_ref_from_antlr(ctx.component_inst(0).ID())
            )
        super().visitComponent_insts(ctx)

    def check_comp_def_allowed(self, type_token: 'CommonToken') -> None:
        comp_type = KW_TO_COMPONENT_MAP[type_token.type]

        # 10.2-b-1-i: Component definitions are limited to field, constraint, signal, and enum components
        if comp_type not in [comp.Signal, comp.Field]:
            self.msg.fatal(
                "Definitions of '%s' components not allowed inside a reg definition"
                % comp_type.__name__.lower(),
                src_ref_from_antlr(type_token)
            )

#===============================================================================
# Regfile Component visitor
#===============================================================================
class RegfileComponentVisitor(ComponentVisitor):
    comp_type = comp.Regfile
    component: comp.Regfile

    def visitComponent_insts(self, ctx: SystemRDLParser.Component_instsContext) -> None:
        # Unpack instance def info from parent
        comp_def = self._tmp_comp_def

        # 12.1-b-1-ii: Component instantiations are limited to reg, regfile, constraint, and signal instances
        if not isinstance(comp_def, (comp.Signal, comp.Reg, comp.Regfile)):
            self.msg.fatal(
                "Instantiation of '%s' components not allowed inside a regfile definition"
                % type(comp_def).__name__.lower(),
                src_ref_from_antlr(ctx.component_inst(0).ID())
            )
        super().visitComponent_insts(ctx)

    def check_comp_def_allowed(self, type_token: 'CommonToken') -> None:
        comp_type = KW_TO_COMPONENT_MAP[type_token.type]

        # 12.1-b-1-i: Component definitions are limited to field, reg, regfile, signal, constraint, and enum
        if comp_type not in [comp.Field, comp.Reg, comp.Regfile, comp.Signal]:
            self.msg.fatal(
                "Definitions of '%s' components not allowed inside a regfile definition"
                % comp_type.__name__.lower(),
                src_ref_from_antlr(type_token)
            )
#===============================================================================
# Addrmap Component visitor
#===============================================================================
class AddrmapComponentVisitor(ComponentVisitor):
    comp_type = comp.Addrmap
    component: comp.Addrmap

    def visitComponent_insts(self, ctx: SystemRDLParser.Component_instsContext) -> None:
        # Unpack instance def info from parent
        comp_def = self._tmp_comp_def

        # 13.3-a: The components instantiated within an address map shall be
        #   registers, register files, memories, address maps, or signals.
        if not isinstance(comp_def, (comp.Reg, comp.Regfile, comp.Mem, comp.Addrmap, comp.Signal)):
            self.msg.fatal(
                "Instantiation of '%s' components not allowed inside an addrmap definition"
                % type(comp_def).__name__.lower(),
                src_ref_from_antlr(ctx.component_inst(0).ID())
            )
        super().visitComponent_insts(ctx)

#===============================================================================
# Mem Component visitor
#===============================================================================
class MemComponentVisitor(ComponentVisitor):
    comp_type = comp.Mem
    component: comp.Mem

    def visitComponent_insts(self, ctx: SystemRDLParser.Component_instsContext) -> None:
        # Unpack instance def info from parent
        comp_def = self._tmp_comp_def

        # 11.1-b-a-ii: Component instantiations are limited to reg and constraint instances.
        if not isinstance(comp_def, comp.Reg):
            self.msg.fatal(
                "Instantiation of '%s' components not allowed inside a mem definition"
                % type(comp_def).__name__.lower(),
                src_ref_from_antlr(ctx.component_inst(0).ID())
            )
        super().visitComponent_insts(ctx)

    def check_comp_def_allowed(self, type_token: 'CommonToken') -> None:
        comp_type = KW_TO_COMPONENT_MAP[type_token.type]

        # 11.1-b-a-i: Component definitions are limited to field, reg, constraint, and enum components.
        if comp_type not in [comp.Field, comp.Reg]:
            self.msg.fatal(
                "Definitions of '%s' components not allowed inside a mem definition"
                % comp_type.__name__.lower(),
                src_ref_from_antlr(type_token)
            )
#===============================================================================
# Signal Component visitor
#===============================================================================
class SignalComponentVisitor(ComponentVisitor):
    comp_type = comp.Signal
    component: comp.Signal

    def visitComponent_insts(self, ctx: SystemRDLParser.Component_instsContext) -> None:
        self.msg.fatal(
            "Instantiation of components not allowed inside a signal definition",
            src_ref_from_antlr(ctx.component_inst(0).ID())
        )

    def check_comp_def_allowed(self, type_token: 'CommonToken') -> None:
        self.msg.fatal(
            "Definitions of components not allowed inside a signal definition",
            src_ref_from_antlr(type_token)
        )


#===============================================================================
KW_TO_VISITOR_MAP: Dict[int, Type[ComponentVisitor]] = {
    SystemRDLParser.FIELD_kw    : FieldComponentVisitor,
    SystemRDLParser.REG_kw      : RegComponentVisitor,
    SystemRDLParser.REGFILE_kw  : RegfileComponentVisitor,
    SystemRDLParser.ADDRMAP_kw  : AddrmapComponentVisitor,
    SystemRDLParser.SIGNAL_kw   : SignalComponentVisitor,
    SystemRDLParser.MEM_kw      : MemComponentVisitor,
}

def get_child_comp_index(parent: comp.Component, inst_name: str) -> Optional[int]:
    for i, child in enumerate(parent.children):
        if child.inst_name == inst_name:
            return i
    return None
