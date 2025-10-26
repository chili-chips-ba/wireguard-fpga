from typing import TYPE_CHECKING, Optional, List, Union

from systemrdl.walker import RDLListener, RDLWalker, WalkerAction
from systemrdl.rdltypes import PropertyReference
from systemrdl.node import Node, RegNode, FieldNode, SignalNode, AddressableNode
from systemrdl.node import RegfileNode, AddrmapNode

from .utils import roundup_pow2, is_pow2

from .utils import ref_is_internal

if TYPE_CHECKING:
    from .exporter import RegblockExporter

class DesignValidator(RDLListener):
    """
    Performs additional rule-checks on the design that check for limitations
    imposed by this exporter.
    """
    def __init__(self, exp:'RegblockExporter') -> None:
        self.exp = exp
        self.ds = exp.ds
        self.msg = self.top_node.env.msg

        self._contains_external_block_stack = [] # type: List[bool]
        self.contains_external_block = False

    @property
    def top_node(self) -> 'AddrmapNode':
        return self.exp.ds.top_node

    def do_validate(self) -> None:
        RDLWalker().walk(self.top_node, self)
        if self.msg.had_error:
            self.msg.fatal(
                "Unable to export due to previous errors"
            )

    def enter_Component(self, node: 'Node') -> Optional[WalkerAction]:
        if node.external and (node != self.top_node):
            # Do not inspect external components. None of my business
            return WalkerAction.SkipDescendants

        # Check if any property references reach across the internal/external boundary
        for prop_name in node.list_properties():
            value = node.get_property(prop_name)
            if isinstance(value, (PropertyReference, Node)):
                if not ref_is_internal(self.top_node, value):
                    if isinstance(value, PropertyReference):
                        src_ref = value.src_ref
                    else:
                        src_ref = node.inst.property_src_ref.get(prop_name, node.inst.inst_src_ref)
                    self.msg.error(
                        "Property is assigned a reference that points to a component not internal to the regblock being exported.",
                        src_ref
                    )
        return None

    def enter_Signal(self, node: 'SignalNode') -> None:
        # If encountering a CPUIF reset that is nested within the register model,
        # warn that it will be ignored.
        # Only cpuif resets in the top-level node or above will be honored
        if node.get_property('cpuif_reset') and (node.parent != self.top_node):
            self.msg.warning(
                "Only cpuif_reset signals that are instantiated in the top-level "
                "addrmap or above will be honored. Any cpuif_reset signals nested "
                "within children of the addrmap being exported will be ignored.",
                node.inst.inst_src_ref
            )

    def enter_AddressableComponent(self, node: 'AddressableNode') -> None:
        # All registers must be aligned to the internal data bus width
        alignment = self.exp.cpuif.data_width_bytes
        if (node.raw_address_offset % alignment) != 0:
            self.msg.error(
                "Unaligned registers are not supported. Address offset of "
                f"instance '{node.inst_name}' must be a multiple of {alignment}",
                node.inst.inst_src_ref
            )
        if node.is_array and (node.array_stride % alignment) != 0: # type: ignore # is_array implies stride is not none
            self.msg.error(
                "Unaligned registers are not supported. Address stride of "
                f"instance array '{node.inst_name}' must be a multiple of {alignment}",
                node.inst.inst_src_ref
            )

        if not isinstance(node, RegNode):
            # Entering a block-like node
            if node == self.top_node:
                # Ignore top addrmap's external property when entering
                self._contains_external_block_stack.append(False)
            else:
                self._contains_external_block_stack.append(node.external)

    def enter_Regfile(self, node: RegfileNode) -> None:
        self._check_sharedextbus(node)

    def enter_Addrmap(self, node: AddrmapNode) -> None:
        self._check_sharedextbus(node)

    def _check_sharedextbus(self, node: Union[RegfileNode, AddrmapNode]) -> None:
        if node.get_property('sharedextbus'):
            self.msg.error(
                "This exporter does not support enabling the 'sharedextbus' property yet.",
                node.inst.property_src_ref.get('sharedextbus', node.inst.inst_src_ref)
            )

    def enter_Reg(self, node: 'RegNode') -> None:
        # accesswidth of wide registers must be consistent within the register block
        accesswidth = node.get_property('accesswidth')
        regwidth = node.get_property('regwidth')

        if accesswidth < regwidth:
            # register is 'wide'
            if accesswidth != self.exp.cpuif.data_width:
                self.msg.error(
                    f"Multi-word registers that have an accesswidth ({accesswidth}) "
                    "that are inconsistent with this regblock's CPU bus width "
                    f"({self.exp.cpuif.data_width}) are not supported.",
                    node.inst.inst_src_ref
                )


    def enter_Field(self, node: 'FieldNode') -> None:
        parent_accesswidth = node.parent.get_property('accesswidth')
        parent_regwidth = node.parent.get_property('regwidth')
        if (
            (parent_accesswidth < parent_regwidth)
            and (node.lsb // parent_accesswidth) != (node.msb // parent_accesswidth)
        ):
            # field spans multiple sub-words

            if node.is_sw_writable and not node.parent.get_property('buffer_writes'):
                # ... and is writable without the protection of double-buffering
                # Enforce 10.6.1-f
                self.msg.error(
                    f"Software-writable field '{node.inst_name}' shall not span"
                    " multiple software-accessible subwords. Consider enabling"
                    " write double-buffering.\n"
                    "For more details, see: https://peakrdl-regblock.readthedocs.io/en/latest/udps/write_buffering.html",
                    node.inst.inst_src_ref
                )

            if node.get_property('onread') is not None and not node.parent.get_property('buffer_reads'):
                # ... is modified by an onread action without the atomicity of read buffering
                # Enforce 10.6.1-f
                self.msg.error(
                    f"The field '{node.inst_name}' spans multiple software-accessible"
                    " subwords and is modified on-read, making it impossible to"
                    " access its value correctly. Consider enabling read"
                    " double-buffering. \n"
                    "For more details, see: https://peakrdl-regblock.readthedocs.io/en/latest/udps/read_buffering.html",
                    node.inst.inst_src_ref
                )

        # Check for unsynthesizable reset
        reset = node.get_property("reset")
        if not (reset is None or isinstance(reset, int)):
            # Has reset that is not a constant value
            resetsignal = node.get_property("resetsignal")
            if resetsignal:
                is_async_reset = resetsignal.get_property("async")
            else:
                is_async_reset = self.ds.default_reset_async

            if is_async_reset:
                self.msg.error(
                    "A field that uses an asynchronous reset cannot use a dynamic reset value. This is not synthesizable.",
                    node.inst.inst_src_ref
                )


    def exit_AddressableComponent(self, node: AddressableNode) -> None:
        if not isinstance(node, RegNode):
            # Exiting block-like node
            contains_external_block = self._contains_external_block_stack.pop()

            if self._contains_external_block_stack:
                # Still in the design. Update stack
                self._contains_external_block_stack[-1] |= contains_external_block
            else:
                # Exiting top addrmap. Resolve final answer
                self.contains_external_block = contains_external_block

            if contains_external_block:
                # Check that addressing follows strict alignment rules to allow
                # for simplified address bit-pruning
                if node.external:
                    err_suffix = "is external"
                else:
                    err_suffix = "contains an external addrmap/regfile/mem"

                req_align = roundup_pow2(node.size)
                if (node.raw_address_offset % req_align) != 0:
                    self.msg.error(
                        f"Address offset +0x{node.raw_address_offset:x} of instance '{node.inst_name}' is not a power of 2 multiple of its size 0x{node.size:x}. "
                        f"This is required by the regblock exporter if a component {err_suffix}.",
                        node.inst.inst_src_ref
                    )
                if node.is_array:
                    assert node.array_stride is not None
                    if not is_pow2(node.array_stride):
                        self.msg.error(
                            f"Address stride of instance array '{node.inst_name}' is not a power of 2"
                            f"This is required by the regblock exporter if a component {err_suffix}.",
                            node.inst.inst_src_ref
                        )
