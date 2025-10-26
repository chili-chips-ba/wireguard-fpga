import hashlib
from typing import TYPE_CHECKING, List, Optional, cast

from ..ast import ASTNode
from .helpers import is_pow2, roundup_pow2, roundup_to, dedent_text
from .value_normalization import normalize, RefInParameterError

from .. import component as comp
from .. import walker
from .. import rdltypes
from ..node import AddressableNode, RootNode, VectorNode, FieldNode, RegNode, RegfileNode
from ..node import AddrmapNode, MemNode, SignalNode, Node

if TYPE_CHECKING:
    from ..messages import MessageHandler
    from ..compiler import RDLEnvironment

#===============================================================================
# Elaboration Listeners
#===============================================================================

class ElabExpressionsListener(walker.RDLListener):
    """
    Elaborates all expressions
    - Component parameters
    - Instance array suffixes
    - Vector dimensions
    - Instance address allocators
    - Property assignments

    Also elaborates parameterized component type names
    """

    def __init__(self, msg_handler: 'MessageHandler'):
        self.msg = msg_handler


    def enter_Component(self, node: Node) -> None:
        # Evaluate component properties
        for prop_name, prop_value in node.inst.properties.items():
            if isinstance(prop_value, ASTNode):
                v = prop_value.get_value(assignee_node=node)
                if prop_name == "desc" and node.env.dedent_desc:
                    v = dedent_text(v)
                node.inst.properties[prop_name] = v


    def enter_AddressableComponent(self, node: AddressableNode) -> None:
        # Cast to pre-elaborated variant to satisfy type hinting
        node.inst = cast(comp.AddressableComponent_PreExprElab, node.inst)

        # Evaluate instance object expressions
        if isinstance(node.inst.addr_offset, ASTNode):
            node.inst.addr_offset = node.inst.addr_offset.get_value(assignee_node=node)

        if isinstance(node.inst.addr_align, ASTNode):
            node.inst.addr_align = node.inst.addr_align.get_value(assignee_node=node)
            if node.inst.addr_align == 0:
                self.msg.fatal(
                    "Alignment allocator '%=' must be greater than zero",
                    node.inst.inst_src_ref
                )

        if node.inst.array_dimensions:
            for i, dim in enumerate(node.inst.array_dimensions):
                if isinstance(dim, ASTNode):
                    node.inst.array_dimensions[i] = dim.get_value(assignee_node=node)
                    if node.inst.array_dimensions[i] == 0:
                        self.msg.fatal(
                            "Array dimension must be greater than zero",
                            node.inst.inst_src_ref
                        )

        if isinstance(node.inst.array_stride, ASTNode):
            node.inst.array_stride = node.inst.array_stride.get_value(assignee_node=node)
            if node.inst.array_stride == 0:
                self.msg.fatal(
                    "Array stride allocator '+=' must be greater than zero",
                    node.inst.inst_src_ref
                )


    def enter_VectorComponent(self, node: VectorNode) -> None:
        # Cast to pre-elaborated variant to satisfy type hinting
        node.inst = cast(comp.VectorComponent_PreExprElab, node.inst)

        # Evaluate instance object expressions
        if isinstance(node.inst.width, ASTNode):
            node.inst.width = node.inst.width.get_value(assignee_node=node)
            if node.inst.width == 0:
                self.msg.fatal(
                    "Vector width must be greater than zero",
                    node.inst.inst_src_ref
                )

        if isinstance(node.inst.msb, ASTNode):
            node.inst.msb = node.inst.msb.get_value(assignee_node=node)

        if isinstance(node.inst.lsb, ASTNode):
            node.inst.lsb = node.inst.lsb.get_value(assignee_node=node)




#-------------------------------------------------------------------------------
class PrePlacementValidateListener(walker.RDLListener):
    """
    Performs value checks of some properties prior to StructuralPlacementListener
    """
    def __init__(self, msg_handler: 'MessageHandler'):
        self.msg = msg_handler


    def enter_Addrmap(self, node: AddrmapNode) -> None:
        self.check_alignment(node)


    def enter_Regfile(self, node: RegfileNode) -> None:
        self.check_alignment(node)


    def check_alignment(self, node: AddressableNode) -> None:
        if 'alignment' in node.inst.properties:
            n = node.inst.properties['alignment']
            if n <= 0:
                self.msg.fatal(
                    "'alignment' property must be greater than zero",
                    node.inst.property_src_ref.get('alignment', node.inst.def_src_ref)
                )
            # 12.3.1-a, 13.4.1-b: All alignment values shall be a power of two (1, 2, 4, etc.)
            if not is_pow2(n):
                self.msg.fatal(
                    "'alignment' property must be a power of 2",
                    node.inst.property_src_ref.get('alignment', node.inst.def_src_ref)
                )


    def enter_Reg(self, node: RegNode) -> None:
        # 10.6.1-a: All registers shall have a regwidth = 2 N , where N >=3.
        if 'regwidth' in node.inst.properties:
            n = node.inst.properties['regwidth']
            if n < 8:
                self.msg.fatal(
                    "'regwidth' property must be at least 8",
                    node.inst.property_src_ref.get('regwidth', node.inst.def_src_ref)
                )
            if not is_pow2(n):
                self.msg.fatal(
                    "'regwidth' property must be a power of 2",
                    node.inst.property_src_ref.get('regwidth', node.inst.def_src_ref)
                )

        # 10.6.1-b: All registers shall have a accesswidth = 2 N , where N >=3.
        if 'accesswidth' in node.inst.properties:
            n = node.inst.properties['accesswidth']
            if n < 8:
                self.msg.fatal(
                    "'accesswidth' property must be at least 8",
                    node.inst.property_src_ref.get('accesswidth', node.inst.def_src_ref)
                )
            if not is_pow2(n):
                self.msg.fatal(
                    "'accesswidth' property must be a power of 2",
                    node.inst.property_src_ref.get('accesswidth', node.inst.def_src_ref)
                )


    def enter_Field(self, node: FieldNode) -> None:
        if 'fieldwidth' in node.inst.properties:
            n = node.inst.properties['fieldwidth']
            if n <= 0:
                self.msg.fatal(
                    "'fieldwidth' property must be greater than zero",
                    node.inst.property_src_ref.get('fieldwidth', node.inst.def_src_ref)
                )


    def enter_Signal(self, node: SignalNode) -> None:
        if 'signalwidth' in node.inst.properties:
            n = node.inst.properties['signalwidth']
            if n <= 0:
                self.msg.fatal(
                    "'signalwidth' property must be greater than zero",
                    node.inst.property_src_ref.get('signalwidth', node.inst.def_src_ref)
                )


    def enter_Mem(self, node: MemNode) -> None:
        # 11.3.1-a: mementries shall be greater than 0.
        if 'mementries' in node.inst.properties:
            n = node.inst.properties['mementries']
            if n <= 0:
                self.msg.fatal(
                    "'mementries' property must be greater than zero",
                    node.inst.property_src_ref.get('mementries', node.inst.def_src_ref)
                )

        # 11.3.1-a: memwidth shall be greater than 0.
        if 'memwidth' in node.inst.properties:
            n = node.inst.properties['memwidth']
            if n <= 0:
                self.msg.fatal(
                    "'memwidth' property must be greater than zero",
                    node.inst.property_src_ref.get('memwidth', node.inst.def_src_ref)
                )

#-------------------------------------------------------------------------------
class StructuralPlacementListener(walker.RDLListener):
    """
    Resolves inferred locations of structural components
    - Field width and offset
    - Component addresses
    - Signals.
    """

    def __init__(self, msg_handler: 'MessageHandler'):
        self.msg = msg_handler
        self.msb0_mode_stack: List[bool] = []
        self.addressing_mode_stack: List[rdltypes.AddressingType] = []
        self.alignment_stack: List[Optional[int]] = []
        self.max_vreg_width = 0


    def enter_Addrmap(self, node: AddrmapNode) -> None:
        self.msb0_mode_stack.append(node.get_property('msb0'))
        self.addressing_mode_stack.append(node.get_property('addressing'))
        self.alignment_stack.append(node.get_property('alignment'))


    def enter_Regfile(self, node: RegfileNode) -> None:
        # Regfile can override the current alignment, but does not block
        # the propagation of a parent's setting if left undefined
        alignment = node.get_property('alignment')
        if alignment is None:
            # not set. Propagate from parent
            alignment = self.alignment_stack[-1]
        self.alignment_stack.append(alignment)


    def enter_Mem(self, node: MemNode) -> None:
        self.max_vreg_width = 0


    def exit_Mem(self, node: MemNode) -> None:
        # 11.3.1-d: memwidth defaults to regwidth
        # ... I assume that means if there are vregs inside a mem, then
        # memwidth inherits the max virtual reg regwidth?
        if 'memwidth' not in node.inst.properties:
            if self.max_vreg_width == 0:
                self.msg.error(
                    "Width of memory component is unknown. Either assign 'memwidth', or instantiate a virtual register to define the memory's width.",
                    node.inst.def_src_ref
                )
            node.inst.properties['memwidth'] = self.max_vreg_width

        self.resolve_addresses(node)


    def exit_Field(self, node: FieldNode) -> None:
        # Cast to pre-elaborated variant to satisfy type hinting
        node.inst = cast(comp.Field_PreStructuralElab, node.inst)

        # Resolve field width
        if node.inst.width is None:
            fieldwidth = node.get_property('fieldwidth', default=None)

            if (node.inst.lsb is not None) and (node.inst.msb is not None):
                width = abs(node.inst.msb - node.inst.lsb) + 1

                node.inst.width = width
            elif fieldwidth is not None:
                node.inst.width = fieldwidth
            else:
                node.inst.width = 1

        # Test field width again
        fieldwidth = node.get_property('fieldwidth')
        if fieldwidth != node.inst.width:
            self.msg.fatal(
                "Width of field instance (%d) must match field's 'fieldwidth' property (%d)"
                % (node.inst.width, fieldwidth),
                node.inst.inst_src_ref
            )


    def exit_Signal(self, node: SignalNode) -> None:
        # Cast to pre-elaborated variant to satisfy type hinting
        node.inst = cast(comp.Signal_PreStructuralElab, node.inst)

        # Resolve signal width
        if node.inst.width is None:
            signalwidth = node.get_property('signalwidth', default=None)

            if signalwidth is not None:
                node.inst.width = signalwidth
            else:
                node.inst.width = 1

        # Signals do not allow lsb/msb notation. Fill in values
        node.inst.lsb = 0
        node.inst.msb = node.inst.width - 1
        node.inst.low = 0
        node.inst.high = node.inst.width - 1

        # Test field width again
        signalwidth = node.get_property('signalwidth')
        if signalwidth != node.inst.width:
            self.msg.fatal(
                "Width of signal instance (%d) must match signal's 'signalwidth' property (%d)"
                % (node.inst.width, signalwidth),
                node.inst.inst_src_ref
            )


    def exit_Reg(self, node: RegNode) -> None:
        regwidth = node.get_property('regwidth')

        self.max_vreg_width = max(regwidth, self.max_vreg_width)

        # Resolve field positions.
        # First determine if there is an implied lsb/msb mode
        implied_lsb_inst = None
        implied_msb_inst = None
        for inst in node.inst.children:
            if not isinstance(inst, comp.Field):
                continue

            # Cast to pre-elaborated variant to satisfy type hinting
            inst = cast(comp.Field_PreStructuralElab, inst)

            if (inst.lsb is None) or (inst.msb is None):
                continue

            if inst.msb > inst.lsb:
                # bit ordering is [high:low]. Implies lsb mode
                implied_lsb_inst = inst
            elif inst.msb < inst.lsb:
                # bit ordering is [low:high]. Implies msb mode
                implied_msb_inst = inst

        # 10.7.1-a: Both the [low:high] and [high:low] bit specification forms
        #   shall not be used together in the same register.
        if (implied_lsb_inst is not None) and (implied_msb_inst is not None):
            # register uses both [high:low] and [low:high] ordering!
            self.msg.fatal(
                "Both the [low:high] (field '%s') and [high:low] (field '%s') bit specification forms shall not be used together in the same register."
                % (implied_msb_inst.inst_name, implied_lsb_inst.inst_name),
                node.inst.def_src_ref
            )

        # Any implied lsb/msb modes override the property set by a parent
        if implied_msb_inst is not None:
            node.inst.is_msb0_order = True
        elif implied_lsb_inst is not None:
            node.inst.is_msb0_order = False
        else:
            node.inst.is_msb0_order = self.msb0_mode_stack[-1]

        # Assign field positions
        # Children are iterated in order of declaration
        prev_inst: Optional[comp.Field] = None
        for inst in node.inst.children:
            if not isinstance(inst, comp.Field):
                continue

            # Cast to pre-elaborated variant to satisfy type hinting
            inst = cast(comp.Field_PreStructuralElab, inst)

            assert inst.width is not None # Width was resolved in field visit

            if (inst.lsb is None) or (inst.msb is None):
                # Offset is not known

                if node.env.chk_implicit_field_pos:
                    node.env.msg.message(
                        node.env.chk_implicit_field_pos,
                        "Bit offset for field '%s' is not explicit" % inst.inst_name,
                        inst.inst_src_ref
                    )

                if node.inst.is_msb0_order:
                    # In msb0 mode. Pack from top first
                    # lsb == high
                    # msb == low
                    if prev_inst is None:
                        inst.lsb = regwidth - 1
                    else:
                        inst.lsb = prev_inst.msb - 1
                    assert inst.lsb is not None

                    inst.msb = inst.lsb - inst.width + 1
                    assert inst.msb is not None

                    if inst.msb < 0:
                        node.env.msg.fatal(
                            "Field '%s' of width %d infers bit range [%d:%d] which extends below bit 0"
                            % (inst.inst_name, inst.width, inst.msb, inst.lsb),
                            inst.inst_src_ref
                        )
                else:
                    # In lsb0 mode. Pack from bit 0 first
                    # lsb == low
                    # msb == high
                    if prev_inst is None:
                        inst.lsb = 0
                    else:
                        inst.lsb = prev_inst.msb + 1
                    assert inst.lsb is not None

                    inst.msb = inst.lsb + inst.width - 1
                    assert inst.msb is not None
            inst.high = max(inst.msb, inst.lsb)
            inst.low = min(inst.msb, inst.lsb)
            prev_inst = inst

        # Sort fields by low-bit.
        # Non-field child components are sorted to be first (signals)
        def get_field_sort_key(inst: comp.Component) -> int:
            if not isinstance(inst, comp.Field):
                return -1
            else:
                return inst.low
        node.inst.children.sort(key=get_field_sort_key)


    def exit_Regfile(self, node: RegfileNode) -> None:
        self.resolve_addresses(node)

        self.alignment_stack.pop()


    def exit_Addrmap(self, node: AddrmapNode) -> None:
        is_bridge = node.get_property('bridge')
        self.resolve_addresses(node, is_bridge)

        self.msb0_mode_stack.pop()
        self.addressing_mode_stack.pop()
        self.alignment_stack.pop()


    def exit_AddressableComponent(self, node: AddressableNode) -> None:
        # Resolve array stride if needed
        if node.inst.is_array and (node.inst.array_stride is None):
            node.inst.array_stride = node.size

            if node.env.chk_implicit_addr:
                node.env.msg.message(
                    node.env.chk_implicit_addr,
                    "Array stride of component '%s' is not explicitly set" % node.inst.inst_name,
                    node.inst.inst_src_ref
                )


    def resolve_addresses(self, node: AddressableNode, is_bridge: bool = False) -> None:
        """
        Resolve addresses of children of Addrmap and Regfile components
        """

        # Get alignment based on 'alignment' property
        # This remains constant for all children
        prop_alignment = self.alignment_stack[-1]
        if prop_alignment is None:
            # was not specified. Does not contribute to alignment
            prop_alignment = 1

        prev_node = None
        for child_node in node.children(skip_not_present=False):
            if not isinstance(child_node, AddressableNode):
                continue

            if child_node.inst.addr_offset is not None:
                # Address is already known. Do not need to infer
                # Still, check that it honors the requested alignment
                if (child_node.raw_address_offset % prop_alignment) != 0:
                    self.msg.error(
                        "Address offset +0x%x of component '%s' must be aligned on a 0x%x byte boundary"
                        % (child_node.raw_address_offset, child_node.inst_name, prop_alignment),
                        child_node.inst.inst_src_ref
                    )
                prev_node = child_node
                continue

            if node.env.chk_implicit_addr:
                node.env.msg.message(
                    node.env.chk_implicit_addr,
                    "Address offset of component '%s' is not explicitly set" % child_node.inst.inst_name,
                    child_node.inst.inst_src_ref
                )

            # Get alignment specified by '%=' allocator, if any
            alloc_alignment = child_node.inst.addr_align
            if alloc_alignment is None:
                # was not specified. Does not contribute to alignment
                alloc_alignment = 1

            # Calculate alignment based on current addressing mode
            if self.addressing_mode_stack[-1] == rdltypes.AddressingType.compact:
                if isinstance(child_node, RegNode):
                    # Regs are aligned based on their accesswidth
                    mode_alignment = child_node.get_property('accesswidth') // 8
                else:
                    # Spec does not specify for other components
                    # Assuming absolutely compact packing
                    mode_alignment = 1

            elif self.addressing_mode_stack[-1] == rdltypes.AddressingType.regalign:
                # Components are aligned to a multiple of their size
                # Spec vaguely suggests that alignment is also a power of 2
                mode_alignment = child_node.size
                mode_alignment = roundup_pow2(mode_alignment)

            elif self.addressing_mode_stack[-1] == rdltypes.AddressingType.fullalign:
                # Same as regalign except for arrays
                # Arrays are aligned to their total size
                # Both are rounded to power of 2
                mode_alignment = child_node.total_size
                mode_alignment = roundup_pow2(mode_alignment)

            else:
                raise RuntimeError

            # Calculate resulting address offset
            alignment = max(prop_alignment, alloc_alignment, mode_alignment)
            if (prev_node is None) or is_bridge:
                next_offset = 0
            else:
                next_offset = prev_node.raw_address_offset + prev_node.total_size

            # round next_offset up to alignment
            child_node.inst.addr_offset = roundup_to(next_offset, alignment)

            prev_node = child_node

        # Sort children by address offset
        # Non-addressable child components are sorted to be first (signals)
        def get_child_sort_key(inst: comp.Component) -> int:
            if not isinstance(inst, comp.AddressableComponent):
                return -1
            else:
                assert inst.addr_offset is not None
                return inst.addr_offset
        node.inst.children.sort(key=get_child_sort_key)

#-------------------------------------------------------------------------------
class LateElabListener(walker.RDLListener):
    """
    Elaboration listener for misc late-stage things
    """
    def __init__(self, msg_handler: 'MessageHandler', env: 'RDLEnvironment'):
        self.msg = msg_handler
        self.env = env
        self.coerce_external_to: Optional[bool] = None
        self.coerce_end_regfile: Optional[Node] = None

        self.node_needs_revisit: List[Node] = []


    def enter_Component(self, node: Node) -> None:
        # if parent is not present, children inherit it too
        if node.parent is not None and not isinstance(node.parent, RootNode):
            if not node.parent.get_property('ispresent'):
                node.inst.properties['ispresent'] = False


    def enter_Field(self, node: FieldNode) -> None:
        # Inherits internal/external of parent reg
        assert node.parent is not None
        node.inst.external = node.parent.inst.external

    def enter_Signal(self, node: SignalNode) -> None:
        # External is meaningless for signals. Always False
        node.inst.external = False

    def enter_Regfile(self, node: RegfileNode) -> None:
        if self.coerce_external_to is not None:
            # Is nested inside another regfile that is coercing to a particular inst type
            node.inst.external = self.coerce_external_to
        elif node.inst.external is not None:
            # First regfile to specify inst type. Coerce all children to the same type
            # as per 12.2-f
            self.coerce_external_to = node.inst.external
            self.coerce_end_regfile = node
        else:
            # Regfile did not specify internal/external
            # Set to default of internal
            node.inst.external = False


    def enter_Reg(self, node: RegNode) -> None:
        if self.coerce_external_to is not None:
            # Is nested inside regfile that is coercing to a particular inst type
            node.inst.external = self.coerce_external_to
        elif node.inst.external is None:
            if node.inst.is_alias:
                # inherit internal/external instance type from alias primary
                assert node.inst.alias_primary_inst is not None
                if node.inst.alias_primary_inst.external is not None:
                    node.inst.external = node.inst.alias_primary_inst.external
                else:
                    # Elaborate did not resolve the primary reg yet and it is still unspecified.
                    # re-visit this reg later
                    self.node_needs_revisit.append(node)
            else:
                node.inst.external = False

        # Register aliases with their primary register
        if node.inst.is_alias:
            assert node.inst.alias_primary_inst is not None
            node.inst.alias_primary_inst._alias_names.append(node.inst_name)


    def exit_Regfile(self, node: RegfileNode) -> None:
        if node is self.coerce_end_regfile:
            # Exiting inst type coercion
            self.coerce_external_to = None
            self.coerce_end_regfile = None


    def exit_Component(self, node: Node) -> None:
        # Generate elaborated type name
        # (only if it exists. Some importers will not assign a type name)
        if node.inst.type_name is not None:
            extra_type_name_segments = []

            # Augment based on parameter overrides as per 5.1.1.4
            if node.inst.original_def is not None:
                for param_name, inst_parameter in node.inst.parameters_dict.items():
                    orig_param_value = node.inst.original_def.parameters_dict[param_name].get_value(node)
                    new_param_value = inst_parameter.get_value(node)
                    if new_param_value != orig_param_value:
                        try:
                            segment = inst_parameter.get_normalized_parameter(node)
                            extra_type_name_segments.append(segment)
                        except RefInParameterError:
                            self.msg.error(
                                "Parameter '%s' contains a reference. SystemRDL does not allow component references inside parameter values."
                                % inst_parameter.name,
                                node.inst.inst_src_ref
                            )

            # Further augment type name as per extended type generation from DPAs
            if self.env.use_extended_type_name_gen:
                # assignments made 'through' the component
                for child_name in sorted(node.inst._dyn_assigned_children):
                    child = node.inst.get_child_by_name(child_name)
                    assert child is not None
                    assert child.inst_name is not None

                    # <child_name>_<hash of child type name>
                    if child.type_name is not None:
                        norm_name = hashlib.new('md5', child.type_name.encode('utf-8'), usedforsecurity=False).hexdigest()[:8]
                    else:
                        # an external importer did not assign a type name.
                        # Use the inst name instead
                        norm_name = hashlib.new('md5', child.inst_name.encode('utf-8'), usedforsecurity=False).hexdigest()[:8]
                    extra_type_name_segments.append(child_name + "_" + norm_name)

                # this component's DPAs
                for prop_name in sorted(node.inst._dyn_assigned_props):
                    # <prop_name>_<norm prop value>
                    norm_name = normalize(node.get_property(prop_name), owner_node=node)
                    extra_type_name_segments.append(prop_name + "_" + norm_name)

            if extra_type_name_segments:
                node.inst.type_name += "_" + "_".join(extra_type_name_segments)


#-------------------------------------------------------------------------------
class LateElabRevisitor:
    """
    In rare situations, some nodes need to be re-visited one last time in order
    to complete elaboration.

    Rather than re-traversing the entire register model, these are set aside and are
    re-visited here.
    """

    def __init__(self, revisit_nodes: List[Node]) -> None:
        for node in revisit_nodes:
            if isinstance(node, RegNode):
                self.revisit_reg(node)
            else:
                raise RuntimeError

    def revisit_reg(self, node: RegNode) -> None:

        # Resolve alias register's instance type if it was not possible to do so earlier.
        # By now, its primary would have been resolved.
        if node.inst.external is None:
            if node.inst.is_alias:
                assert node.inst.alias_primary_inst is not None
                if node.inst.alias_primary_inst.external is not None:
                    node.inst.external = node.inst.alias_primary_inst.external
                else:
                    raise RuntimeError
