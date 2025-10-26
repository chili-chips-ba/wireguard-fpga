from typing import List, Type, TYPE_CHECKING
import inspect

from ..parser.SystemRDLParser import SystemRDLParser

from .BaseVisitor import BaseVisitor
from .ExprVisitor import ExprVisitor
from .helpers import get_ID_text

from ..properties.user_defined import PureUserProperty
from .. import ast

from ..source_ref import src_ref_from_antlr
from .. import component as comp
from .. import rdltypes

if TYPE_CHECKING:
    from typing import Optional, Union, Any, Set
    from ..compiler import RDLCompiler

class UDPVisitor(BaseVisitor):
    def __init__(self, compiler: 'RDLCompiler') -> None:
        super().__init__(compiler)

        self._constr_componentwidth: Optional[bool] = None
        self._default_assignment: Any = None
        self._valid_type: Optional[Type[Union[int, str, bool, rdltypes.BuiltinEnum, rdltypes.UserEnum, rdltypes.UserStruct, comp.Component, rdltypes.references.RefType]]] = None
        self._bindable_to: Optional[Set[Type[comp.Component]]] = None

    def visitUdp_def(self, ctx: SystemRDLParser.Udp_defContext) -> None:
        udp_name = get_ID_text(ctx.ID())

        # Collect all attributes
        for attr_ctx in ctx.getTypedRuleContexts(SystemRDLParser.Udp_attrContext):
            self.visit(attr_ctx)

        # Check attribute rules
        # 15.1.1.b: A user-defined property definition shall include the
        #   component property specification.
        if self._valid_type is None:
            self.msg.fatal(
                "User-defined property '%s' does not specify the 'type' attribute"
                % udp_name,
                src_ref_from_antlr(ctx.ID())
            )

        # 15.1.1.c: A user-defined property definition shall include its type definition
        if self._bindable_to is None:
            self.msg.fatal(
                "User-defined property '%s' does not specify the 'component' attribute"
                % udp_name,
                src_ref_from_antlr(ctx.ID())
            )

        # 15.1 Table 30: Currently limited to componentwidth for type bit
        if self._constr_componentwidth:
            if self._valid_type != int:
                self.msg.fatal(
                    "Constraint 'componentwidth' is only valid for properties of type 'bit'",
                    src_ref_from_antlr(ctx.ID())
                )

        # Evaluate default value, if any
        if self._default_assignment is not None:
            expr_ctx = self._default_assignment

            visitor = ExprVisitor(self.compiler)
            expr = visitor.visit(expr_ctx)
            expr_type = expr.predict_type()

            # temporarily expand valid_type into an array
            if inspect.isclass(self._valid_type) and issubclass(self._valid_type, rdltypes.references.RefType):
                valid_types = self._valid_type.expanded
            else:
                valid_types = (self._valid_type,) # type: ignore

            # 15.1.1-e: The default value shall be assignment compatible with
            # the property type
            for valid_type in valid_types:
                if ast.is_castable(expr_type, valid_type):
                    if isinstance(expr, ast.ASTNode):
                        # Found a type-compatible match. (first match is best match)
                        # Wrap the expression with an explicit assignment cast
                        expr = ast.AssignmentCast(
                            self.compiler.env, src_ref_from_antlr(expr_ctx),
                            expr, valid_type
                        )
                    break
            else:
                self.msg.fatal(
                    "Property default is incompatible with property type",
                    src_ref_from_antlr(expr_ctx)
                )

            self._default_assignment = expr

        constr_componentwidth = self._constr_componentwidth
        if constr_componentwidth is None:
            constr_componentwidth = False

        # create UDP
        udp = PureUserProperty(
            self.compiler.env,
            udp_name,
            self._bindable_to,
            self._valid_type,
            self._default_assignment,
            constr_componentwidth
        )
        self.compiler.env.property_rules.register_udp(udp, src_ref_from_antlr(ctx.ID()))


    def visitUdp_type(self, ctx: SystemRDLParser.Udp_typeContext) -> None:
        # Determine which type this property can hold
        if self._valid_type is not None:
            self.msg.fatal(
                "More than one 'type' attribute specified for user-defined property",
                src_ref_from_antlr(ctx.TYPE_kw())
            )

        token = self.visit(ctx.udp_data_type())
        valid_type = self.datatype_from_token(token)

        is_array = ctx.array_type_suffix() is not None
        if is_array:
            # arrayify
            valid_type = rdltypes.ArrayedType(valid_type) # type: ignore

        self._valid_type = valid_type


    _UDPUsage_Map = {
        SystemRDLParser.FIELD_kw    : comp.Field,
        SystemRDLParser.REG_kw      : comp.Reg,
        SystemRDLParser.REGFILE_kw  : comp.Regfile,
        SystemRDLParser.ADDRMAP_kw  : comp.Addrmap,
        SystemRDLParser.MEM_kw      : comp.Mem,
        SystemRDLParser.SIGNAL_kw   : comp.Signal,
        #SystemRDLParser.CONSTRAINT_kw   : TODO,
    }
    def visitUdp_usage(self, ctx: SystemRDLParser.Udp_usageContext) -> None:
        # Determine which components the UDP can be bound to
        if self._bindable_to is not None:
            self.msg.fatal(
                "More than one 'component' attribute specified for user-defined property",
                src_ref_from_antlr(ctx.COMPONENT_kw())
            )

        comp_types: List[Type[comp.Component]] = []
        for token_ctx in ctx.getTypedRuleContexts(SystemRDLParser.Udp_comp_typeContext):
            token = self.visit(token_ctx)
            if token.type == SystemRDLParser.ALL_kw:
                comp_types.extend(list(self._UDPUsage_Map.values()))
            else:
                comp_types.append(self._UDPUsage_Map[token.type])

        self._bindable_to = set(comp_types)


    def visitUdp_default(self, ctx: SystemRDLParser.Udp_defaultContext) -> None:
        if self._default_assignment is not None:
            self.msg.fatal(
                "More than one 'default' attribute specified for user-defined property",
                src_ref_from_antlr(ctx.DEFAULT_kw())
            )

        # defer expr evaluation until later
        self._default_assignment = ctx.expr()


    def visitUdp_constraint(self, ctx: SystemRDLParser.Udp_constraintContext) -> None:
        # There is only one type of constraint even allowed by the grammar
        # no need to explore further
        if self._constr_componentwidth is not None:
            self.msg.fatal(
                "More than one 'constraint' attribute specified for user-defined property",
                src_ref_from_antlr(ctx.CONSTRAINT_kw())
            )

        self._constr_componentwidth = True
