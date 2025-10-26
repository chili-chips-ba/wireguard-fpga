from typing import TYPE_CHECKING, Optional, List, Type

from systemrdl.node import FieldNode, RegNode, AddrmapNode, MemNode
from systemrdl.walker import WalkerAction

from ..struct_generator import RDLFlatStructGenerator
from ..identifier_filter import kw_filter as kwf
from ..sv_int import SVInt
from ..utils import clog2

if TYPE_CHECKING:
    from systemrdl.node import Node, SignalNode, AddressableNode, RegfileNode
    from . import Hwif
    from systemrdl.rdltypes import UserEnum

class HWIFStructGenerator(RDLFlatStructGenerator):
    def __init__(self, hwif: 'Hwif', hwif_name: str) -> None:
        super().__init__()
        self.hwif = hwif
        self.top_node = hwif.top_node

        self.hwif_report_stack = [hwif_name]

    def push_struct(self, type_name: str, inst_name: str, array_dimensions: Optional[List[int]] = None, packed: bool = False) -> None: # type: ignore
        super().push_struct(type_name, inst_name, array_dimensions, packed)

        if array_dimensions:
            array_suffix = "".join([f"[0:{dim-1}]" for dim in array_dimensions])
            segment = inst_name + array_suffix
        else:
            segment = inst_name
        self.hwif_report_stack.append(segment)

    def pop_struct(self) -> None:
        super().pop_struct()
        self.hwif_report_stack.pop()

    def add_member(self, name: str, width: int = 1, *, lsb: int = 0, signed: bool = False) -> None: # type: ignore # pylint: disable=arguments-differ
        super().add_member(name, width, lsb=lsb, signed=signed)

        if width > 1 or lsb != 0:
            suffix = f"[{lsb+width-1}:{lsb}]"
        else:
            suffix = ""

        path = ".".join(self.hwif_report_stack)
        if self.hwif.hwif_report_file:
            self.hwif.hwif_report_file.write(f"{path}.{name}{suffix}\n")

#-------------------------------------------------------------------------------

class InputStructGenerator_Hier(HWIFStructGenerator):
    def __init__(self, hwif: 'Hwif') -> None:
        super().__init__(hwif, "hwif_in")

    def get_typdef_name(self, node:'Node', suffix: str = "") -> str:
        base = node.get_rel_path(
            self.top_node.parent,
            hier_separator="__",
            array_suffix="x",
            empty_array_suffix="x"
        )
        return f'{base}{suffix}__in_t'

    def enter_Signal(self, node: 'SignalNode') -> None:
        # only emit the signal if design scanner detected it is actually being used
        path = node.get_path()
        if path in self.hwif.ds.in_hier_signal_paths:
            self.add_member(kwf(node.inst_name), node.width)

    def _add_external_block_members(self, node: 'AddressableNode') -> None:
        self.add_member("rd_ack")
        self.add_member("rd_data", self.hwif.ds.cpuif_data_width)
        self.add_member("wr_ack")

    def enter_Addrmap(self, node: 'AddrmapNode') -> Optional[WalkerAction]:
        super().enter_Addrmap(node)
        assert node.external
        self._add_external_block_members(node)
        return WalkerAction.SkipDescendants

    def enter_Regfile(self, node: 'RegfileNode') -> Optional[WalkerAction]:
        super().enter_Regfile(node)
        if node.external:
            self._add_external_block_members(node)
            return WalkerAction.SkipDescendants
        return WalkerAction.Continue

    def enter_Mem(self, node: 'MemNode') -> Optional[WalkerAction]:
        super().enter_Mem(node)
        assert node.external
        self._add_external_block_members(node)
        return WalkerAction.SkipDescendants

    def enter_Reg(self, node: 'RegNode') -> Optional[WalkerAction]:
        super().enter_Reg(node)
        if node.external:
            width = min(self.hwif.ds.cpuif_data_width, node.get_property('regwidth'))
            n_subwords = node.get_property("regwidth") // node.get_property("accesswidth")
            if node.has_sw_readable:
                self.add_member("rd_ack")
                self.add_external_reg_rd_data(node, width, n_subwords)
            if node.has_sw_writable:
                self.add_member("wr_ack")
            return WalkerAction.SkipDescendants

        return WalkerAction.Continue

    def add_external_reg_rd_data(self, node: 'RegNode', width: int, n_subwords: int) -> None:
        if n_subwords == 1:
            # External reg is 1 sub-word. Add a packed struct to represent it
            type_name = self.get_typdef_name(node, "__fields")
            self.push_struct(type_name, "rd_data", packed=True)
            current_bit = width - 1
            for field in reversed(list(node.fields())):
                if not field.is_sw_readable:
                    continue
                if field.high < current_bit:
                    # Add padding
                    self.add_member(
                        f"_reserved_{current_bit}_{field.high + 1}",
                        current_bit - field.high
                    )
                self.add_member(
                    kwf(field.inst_name),
                    field.width
                )
                current_bit = field.low - 1

            # Add end padding if needed
            if current_bit != -1:
                self.add_member(
                    f"_reserved_{current_bit}_0",
                    current_bit + 1
                )
            self.pop_struct()
        else:
            # Multiple sub-words. Cannot generate a struct
            self.add_member("rd_data", width)

    def enter_Field(self, node: 'FieldNode') -> None:
        type_name = self.get_typdef_name(node)
        self.push_struct(type_name, kwf(node.inst_name))

        # Provide input to field's next value if it is writable by hw, and it
        # was not overridden by the 'next' property
        if node.is_hw_writable and node.get_property('next') is None:
            # Get the field's LSB index (can be nonzero for fixed-point values)
            fracwidth = node.get_property("fracwidth")
            lsb = 0 if fracwidth is None else -fracwidth

            # get the signedness of the field
            signed = node.get_property("is_signed")

            self.add_member("next", node.width, lsb=lsb, signed=signed)

        # Generate implied inputs
        for prop_name in ["we", "wel", "swwe", "swwel", "hwclr", "hwset"]:
            # if property is boolean and true, implies a corresponding input signal on the hwif
            if node.get_property(prop_name) is True:
                self.add_member(prop_name)

        # Generate any implied counter inputs
        if node.is_up_counter:
            if not node.get_property('incr'):
                # User did not provide their own incr component reference.
                # Imply an input
                self.add_member('incr')

            width = node.get_property('incrwidth')
            if width:
                # Implies a corresponding incrvalue input
                self.add_member('incrvalue', width)

        if node.is_down_counter:
            if not node.get_property('decr'):
                # User did not provide their own decr component reference.
                # Imply an input
                self.add_member('decr')

            width = node.get_property('decrwidth')
            if width:
                # Implies a corresponding decrvalue input
                self.add_member('decrvalue', width)

    def exit_Field(self, node: 'FieldNode') -> None:
        self.pop_struct()


class OutputStructGenerator_Hier(HWIFStructGenerator):
    def __init__(self, hwif: 'Hwif') -> None:
        super().__init__(hwif, "hwif_out")

    def get_typdef_name(self, node:'Node', suffix: str = "") -> str:
        base = node.get_rel_path(
            self.top_node.parent,
            hier_separator="__",
            array_suffix="x",
            empty_array_suffix="x"
        )
        return f'{base}{suffix}__out_t'

    def _add_external_block_members(self, node: 'AddressableNode') -> None:
        self.add_member("req")
        self.add_member("addr", clog2(node.size))
        self.add_member("req_is_wr")
        self.add_member("wr_data", self.hwif.ds.cpuif_data_width)
        self.add_member("wr_biten", self.hwif.ds.cpuif_data_width)

    def enter_Addrmap(self, node: 'AddrmapNode') -> Optional[WalkerAction]:
        super().enter_Addrmap(node)
        assert node.external
        self._add_external_block_members(node)
        return WalkerAction.SkipDescendants

    def enter_Regfile(self, node: 'RegfileNode') -> Optional[WalkerAction]:
        super().enter_Regfile(node)
        if node.external:
            self._add_external_block_members(node)
            return WalkerAction.SkipDescendants
        return WalkerAction.Continue

    def enter_Mem(self, node: 'MemNode') -> Optional[WalkerAction]:
        super().enter_Mem(node)
        assert node.external
        self._add_external_block_members(node)
        return WalkerAction.SkipDescendants

    def enter_Reg(self, node: 'RegNode') -> Optional[WalkerAction]:
        super().enter_Reg(node)
        if node.external:
            width = min(self.hwif.ds.cpuif_data_width, node.get_property('regwidth'))
            n_subwords = node.get_property("regwidth") // node.get_property("accesswidth")
            self.add_member("req", n_subwords)
            self.add_member("req_is_wr")
            if node.has_sw_writable:
                self.add_external_reg_wr_data("wr_data", node, width, n_subwords)
                self.add_external_reg_wr_data("wr_biten", node, width, n_subwords)
            return WalkerAction.SkipDescendants

        return WalkerAction.Continue

    def add_external_reg_wr_data(self, name: str, node: 'RegNode', width: int, n_subwords: int) -> None:
        if n_subwords == 1:
            # External reg is 1 sub-word. Add a packed struct to represent it
            type_name = self.get_typdef_name(node, "__fields")
            self.push_struct(type_name, name, packed=True)
            current_bit = width - 1
            for field in reversed(list(node.fields())):
                if not field.is_sw_writable:
                    continue
                if field.high < current_bit:
                    # Add padding
                    self.add_member(
                        f"_reserved_{current_bit}_{field.high + 1}",
                        current_bit - field.high
                    )
                self.add_member(
                    kwf(field.inst_name),
                    field.width
                )
                current_bit = field.low - 1

            # Add end padding if needed
            if current_bit != -1:
                self.add_member(
                    f"_reserved_{current_bit}_0",
                    current_bit + 1
                )
            self.pop_struct()
        else:
            # Multiple sub-words. Cannot generate a struct
            self.add_member(name, width)

    def enter_Field(self, node: 'FieldNode') -> None:
        type_name = self.get_typdef_name(node)
        self.push_struct(type_name, kwf(node.inst_name))

        # Expose field's value if it is readable by hw
        if node.is_hw_readable:
            # Get the node's LSB index (can be nonzero for fixed-point values)
            fracwidth = node.get_property("fracwidth")
            lsb = 0 if fracwidth is None else -fracwidth

            # get the signedness of the field
            signed = node.get_property("is_signed")

            self.add_member("value", node.width, lsb=lsb, signed=signed)

        # Generate output bit signals enabled via property
        for prop_name in ["anded", "ored", "xored", "swmod", "swacc", "overflow", "underflow", "rd_swacc", "wr_swacc"]:
            if node.get_property(prop_name):
                self.add_member(prop_name)

        if node.get_property('incrthreshold') is not False: # (explicitly not False. Not 0)
            self.add_member('incrthreshold')
        if node.get_property('decrthreshold') is not False: # (explicitly not False. Not 0)
            self.add_member('decrthreshold')

    def exit_Field(self, node: 'FieldNode') -> None:
        self.pop_struct()

    def exit_Reg(self, node: 'RegNode') -> None:
        if node.is_interrupt_reg:
            self.add_member('intr')
            if node.is_halt_reg:
                self.add_member('halt')
        super().exit_Reg(node)

#-------------------------------------------------------------------------------
class InputStructGenerator_TypeScope(InputStructGenerator_Hier):
    def get_typdef_name(self, node:'Node', suffix: str = "") -> str:
        scope_path = node.get_global_type_name("__")
        if scope_path is None:
            # Unable to determine a reusable type name. Fall back to hierarchical path
            # Add prefix to prevent collision when mixing namespace methods
            scope_path = "xtern__" + super().get_typdef_name(node)

        if node.external:
            # Node generates alternate external signals
            extra_suffix = "__external"
        else:
            extra_suffix = ""

        return f'{scope_path}{extra_suffix}{suffix}__in_t'

class OutputStructGenerator_TypeScope(OutputStructGenerator_Hier):
    def get_typdef_name(self, node:'Node', suffix: str = "") -> str:
        scope_path = node.get_global_type_name("__")
        if scope_path is None:
            # Unable to determine a reusable type name. Fall back to hierarchical path
            # Add prefix to prevent collision when mixing namespace methods
            scope_path = "xtern__" + super().get_typdef_name(node)

        if node.external:
            # Node generates alternate external signals
            extra_suffix = "__external"
        else:
            extra_suffix = ""

        return f'{scope_path}{extra_suffix}{suffix}__out_t'

#-------------------------------------------------------------------------------
class EnumGenerator:
    """
    Generator for user-defined enum definitions
    """

    def get_enums(self, user_enums: List[Type['UserEnum']]) -> Optional[str]:
        if not user_enums:
            return None

        lines = []
        for user_enum in user_enums:
            lines.append(self._enum_typedef(user_enum))

        return '\n\n'.join(lines)

    @staticmethod
    def _get_prefix(user_enum: Type['UserEnum']) -> str:
        scope = user_enum.get_scope_path("__")
        if scope:
            return f"{scope}__{user_enum.type_name}"
        else:
            return user_enum.type_name

    def _enum_typedef(self, user_enum: Type['UserEnum']) -> str:
        prefix = self._get_prefix(user_enum)

        lines = []
        max_value = 1
        for enum_member in user_enum:
            lines.append(f"    {prefix}__{enum_member.name} = {SVInt(enum_member.value)}")
            max_value = max(max_value, enum_member.value)

        if max_value.bit_length() == 1:
            datatype = "logic"
        else:
            datatype = f"logic [{max_value.bit_length() - 1}:0]"

        return (
            f"typedef enum {datatype} {{\n"
            + ",\n".join(lines)
            + f"\n}} {prefix}_e;"
        )
