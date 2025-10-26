from typing import TYPE_CHECKING, Union

from systemrdl.rdltypes import PrecedenceType, InterruptType

from .bases import AssignmentPrecedence, NextStateConditional
from . import sw_onread
from . import sw_onwrite
from . import sw_singlepulse
from . import hw_write
from . import hw_set_clr
from . import hw_interrupts
from . import hw_interrupts_with_write

from ..utils import get_indexed_path
from ..sv_int import SVInt

from .generators import CombinationalStructGenerator, FieldStorageStructGenerator, FieldLogicGenerator

if TYPE_CHECKING:
    from typing import Dict, List
    from systemrdl.node import AddrmapNode, FieldNode
    from ..exporter import RegblockExporter, DesignState

class FieldLogic:
    def __init__(self, exp:'RegblockExporter'):
        self.exp = exp

        self._hw_conditionals = {} # type: Dict[int, List[NextStateConditional]]
        self._sw_conditionals = {} # type: Dict[int, List[NextStateConditional]]

        self.init_conditionals()

    @property
    def ds(self) -> 'DesignState':
        return self.exp.ds

    @property
    def top_node(self) -> 'AddrmapNode':
        return self.exp.ds.top_node

    def get_storage_struct(self) -> str:
        struct_gen = FieldStorageStructGenerator(self)
        s = struct_gen.get_struct(self.top_node, "field_storage_t")

        # Only declare the storage struct if it exists
        if s is None:
            return ""

        return s + "\nfield_storage_t field_storage;"

    def get_combo_struct(self) -> str:
        struct_gen = CombinationalStructGenerator(self)
        s = struct_gen.get_struct(self.top_node, "field_combo_t")

        # Only declare the storage struct if it exists
        if s is None:
            return ""

        return s + "\nfield_combo_t field_combo;"

    def get_implementation(self) -> str:
        gen = FieldLogicGenerator(self)
        s = gen.get_content(self.top_node)
        if s is None:
            return ""
        return s

    #---------------------------------------------------------------------------
    # Field utility functions
    #---------------------------------------------------------------------------
    def get_storage_identifier(self, field: 'FieldNode') -> str:
        """
        Returns the Verilog string that represents the storage register element
        for the referenced field
        """
        assert field.implements_storage
        path = get_indexed_path(self.top_node, field)
        return f"field_storage.{path}.value"

    def get_next_q_identifier(self, field: 'FieldNode') -> str:
        """
        Returns the Verilog string that represents the storage register element
        for the delayed 'next' input value
        """
        assert field.implements_storage
        path = get_indexed_path(self.top_node, field)
        return f"field_storage.{path}.next_q"

    def get_field_combo_identifier(self, field: 'FieldNode', name: str) -> str:
        """
        Returns a Verilog string that represents a field's internal combinational
        signal.
        """
        assert field.implements_storage
        path = get_indexed_path(self.top_node, field)
        return f"field_combo.{path}.{name}"

    def get_counter_incr_strobe(self, field: 'FieldNode') -> str:
        """
        Return the Verilog string that represents the field's incr strobe signal.
        """
        prop_value = field.get_property('incr')
        if prop_value:
            return str(self.exp.dereferencer.get_value(prop_value))

        # unset by the user, points to the implied input signal
        return self.exp.hwif.get_implied_prop_input_identifier(field, "incr")

    def get_counter_incrvalue(self, field: 'FieldNode') -> Union[SVInt, str]:
        """
        Return the string that represents the field's increment value
        """
        incrvalue = field.get_property('incrvalue')
        if incrvalue is not None:
            return self.exp.dereferencer.get_value(incrvalue, field.width)
        if field.get_property('incrwidth'):
            return self.exp.hwif.get_implied_prop_input_identifier(field, "incrvalue")
        return "1'b1"

    def get_counter_incrsaturate_value(self, field: 'FieldNode') -> Union[SVInt, str]:
        prop_value = field.get_property('incrsaturate')
        if prop_value is True:
            return self.exp.dereferencer.get_value(2**field.width - 1, field.width)
        return self.exp.dereferencer.get_value(prop_value, field.width)

    def counter_incrsaturates(self, field: 'FieldNode') -> bool:
        """
        Returns True if the counter saturates
        """
        return field.get_property('incrsaturate') is not False

    def get_counter_incrthreshold_value(self, field: 'FieldNode') -> Union[SVInt, str]:
        prop_value = field.get_property('incrthreshold')
        if isinstance(prop_value, bool):
            # No explicit value set. use max
            return self.exp.dereferencer.get_value(2**field.width - 1, field.width)
        return self.exp.dereferencer.get_value(prop_value, field.width)

    def get_counter_decr_strobe(self, field: 'FieldNode') -> str:
        """
        Return the Verilog string that represents the field's incr strobe signal.
        """
        prop_value = field.get_property('decr')
        if prop_value:
            return str(self.exp.dereferencer.get_value(prop_value))

        # unset by the user, points to the implied input signal
        return self.exp.hwif.get_implied_prop_input_identifier(field, "decr")

    def get_counter_decrvalue(self, field: 'FieldNode') -> Union[SVInt, str]:
        """
        Return the string that represents the field's decrement value
        """
        decrvalue = field.get_property('decrvalue')
        if decrvalue is not None:
            return self.exp.dereferencer.get_value(decrvalue, field.width)
        if field.get_property('decrwidth'):
            return self.exp.hwif.get_implied_prop_input_identifier(field, "decrvalue")
        return "1'b1"

    def get_counter_decrsaturate_value(self, field: 'FieldNode') -> Union[SVInt, str]:
        prop_value = field.get_property('decrsaturate')
        if prop_value is True:
            return f"{field.width}'d0"
        return self.exp.dereferencer.get_value(prop_value, field.width)

    def counter_decrsaturates(self, field: 'FieldNode') -> bool:
        """
        Returns True if the counter saturates
        """
        return field.get_property('decrsaturate') is not False

    def get_counter_decrthreshold_value(self, field: 'FieldNode') -> Union[SVInt, str]:
        prop_value = field.get_property('decrthreshold')
        if isinstance(prop_value, bool):
            # No explicit value set. use min
            return f"{field.width}'d0"
        return self.exp.dereferencer.get_value(prop_value, field.width)

    def get_swacc_identifier(self, field: 'FieldNode') -> str:
        """
        Asserted when field is software accessed (read or write)
        """
        buffer_reads = field.parent.get_property('buffer_reads')
        buffer_writes = field.parent.get_property('buffer_writes')
        if buffer_reads and buffer_writes:
            rstrb = self.exp.read_buffering.get_trigger(field.parent)
            wstrb = self.exp.write_buffering.get_write_strobe(field)
            return f"{rstrb} || {wstrb}"
        elif buffer_reads and not buffer_writes:
            strb = self.exp.dereferencer.get_access_strobe(field)
            rstrb = self.exp.read_buffering.get_trigger(field.parent)
            return f"{rstrb} || ({strb} && decoded_req_is_wr)"
        elif not buffer_reads and buffer_writes:
            strb = self.exp.dereferencer.get_access_strobe(field)
            wstrb = self.exp.write_buffering.get_write_strobe(field)
            return f"{wstrb} || ({strb} && !decoded_req_is_wr)"
        else:
            strb = self.exp.dereferencer.get_access_strobe(field)
            return strb

    def get_rd_swacc_identifier(self, field: 'FieldNode') -> str:
        """
        Asserted when field is software accessed (read)
        """
        buffer_reads = field.parent.get_property('buffer_reads')
        if buffer_reads:
            rstrb = self.exp.read_buffering.get_trigger(field.parent)
            return rstrb
        else:
            strb = self.exp.dereferencer.get_access_strobe(field)
            return f"{strb} && !decoded_req_is_wr"

    def get_wr_swacc_identifier(self, field: 'FieldNode') -> str:
        """
        Asserted when field is software accessed (write)
        """
        buffer_writes = field.parent.get_property('buffer_writes')
        if buffer_writes:
            wstrb = self.exp.write_buffering.get_write_strobe(field)
            return wstrb
        else:
            strb = self.exp.dereferencer.get_access_strobe(field)
            return f"{strb} && decoded_req_is_wr"

    def get_swmod_identifier(self, field: 'FieldNode') -> str:
        """
        Asserted when field is modified by software (written or read with a
        set or clear side effect).
        """
        w_modifiable = field.is_sw_writable
        r_modifiable = field.get_property('onread') is not None
        buffer_writes = field.parent.get_property('buffer_writes')
        buffer_reads = field.parent.get_property('buffer_reads')
        accesswidth = field.parent.get_property("accesswidth")


        astrb = self.exp.dereferencer.get_access_strobe(field)

        conditions = []
        if r_modifiable:
            if buffer_reads:
                rstrb = self.exp.read_buffering.get_trigger(field.parent)
            else:
                rstrb = f"{astrb} && !decoded_req_is_wr"
            conditions.append(rstrb)

        if w_modifiable:
            if buffer_writes:
                wstrb = self.exp.write_buffering.get_write_strobe(field)
            else:
                wstrb = f"{astrb} && decoded_req_is_wr"

            # Due to 10.6.1-f, it is impossible for a field that is sw-writable to
            # be split across subwords.
            # Therefore it is ok to get the subword idx from only one of the bit offsets
            # in order to compute the biten range
            sidx = field.low // accesswidth
            biten = self.get_wr_biten(field, sidx)
            wstrb += f" && |({biten})"

            conditions.append(wstrb)

        if not conditions:
            # Not sw modifiable
            return "1'b0"
        else:
            return " || ".join(conditions)


    def get_parity_identifier(self, field: 'FieldNode') -> str:
        """
        Returns the identifier for the stored 'golden' parity value of the field
        """
        path = get_indexed_path(self.top_node, field)
        return f"field_storage.{path}.parity"

    def get_parity_error_identifier(self, field: 'FieldNode') -> str:
        """
        Returns the identifier for whether the field currently has a parity error
        """
        path = get_indexed_path(self.top_node, field)
        return f"field_combo.{path}.parity_error"

    def has_next_q(self, field: 'FieldNode') -> bool:
        """
        Some fields require a delayed version of their 'next' input signal in
        order to do edge-detection.

        Returns True if this is the case.
        """
        if field.get_property('intr type') in {
            InterruptType.posedge,
            InterruptType.negedge,
            InterruptType.bothedge
        }:
            return True

        return False

    def get_wbus_bitslice(self, field: 'FieldNode', subword_idx: int = 0) -> str:
        """
        Get the bitslice range string of the internal cpuif's data/biten bus
        that corresponds to this field
        """
        if field.parent.get_property('buffer_writes'):
            # register is buffered.
            # write buffer is the full width of the register. no need to deal with subwords
            high = field.high
            low = field.low
            if field.msb < field.lsb:
                # slice is for an msb0 field.
                # mirror it
                regwidth = field.parent.get_property('regwidth')
                low = regwidth - 1 - low
                high = regwidth - 1 - high
                low, high = high, low
        else:
            # Regular non-buffered register
            # For normal fields this ends up passing-through the field's low/high
            # values unchanged.
            # For fields within a wide register (accesswidth < regwidth), low/high
            # may be shifted down and clamped depending on which sub-word is being accessed
            accesswidth = field.parent.get_property('accesswidth')

            # Shift based on subword
            high = field.high - (subword_idx * accesswidth)
            low = field.low - (subword_idx * accesswidth)

            # clamp to accesswidth
            high = max(min(high, accesswidth), 0)
            low = max(min(low, accesswidth), 0)

            if field.msb < field.lsb:
                # slice is for an msb0 field.
                # mirror it
                bus_width = self.exp.cpuif.data_width
                low = bus_width - 1 - low
                high = bus_width - 1 - high
                low, high = high, low

        return f"[{high}:{low}]"

    def get_wr_biten(self, field: 'FieldNode', subword_idx: int=0) -> str:
        """
        Get the bit-enable slice that corresponds to this field
        """
        if field.parent.get_property('buffer_writes'):
            # Is buffered. Use value from write buffer
            # No need to check msb0 ordering. Bus is pre-swapped, and bitslice
            # accounts for it
            bslice = self.get_wbus_bitslice(field)
            wbuf_prefix = self.exp.write_buffering.get_wbuf_prefix(field)
            return wbuf_prefix + ".biten" + bslice
        else:
            # Regular non-buffered register
            bslice = self.get_wbus_bitslice(field, subword_idx)

            if field.msb < field.lsb:
                # Field gets bitswapped since it is in [low:high] orientation
                value = "decoded_wr_biten_bswap" + bslice
            else:
                value = "decoded_wr_biten" + bslice
            return value

    def get_wr_data(self, field: 'FieldNode', subword_idx: int=0) -> str:
        """
        Get the write data slice that corresponds to this field
        """
        if field.parent.get_property('buffer_writes'):
            # Is buffered. Use value from write buffer
            # No need to check msb0 ordering. Bus is pre-swapped, and bitslice
            # accounts for it
            bslice = self.get_wbus_bitslice(field)
            wbuf_prefix = self.exp.write_buffering.get_wbuf_prefix(field)
            return wbuf_prefix + ".data" + bslice
        else:
            # Regular non-buffered register
            bslice = self.get_wbus_bitslice(field, subword_idx)

            if field.msb < field.lsb:
                # Field gets bitswapped since it is in [low:high] orientation
                value = "decoded_wr_data_bswap" + bslice
            else:
                value = "decoded_wr_data" + bslice
            return value

    #---------------------------------------------------------------------------
    # Field Logic Conditionals
    #---------------------------------------------------------------------------
    def add_hw_conditional(self, conditional: NextStateConditional, precedence: AssignmentPrecedence) -> None:
        """
        Register a NextStateConditional action for hardware-triggered field updates.
        Categorizing conditionals correctly by hw/sw ensures that the RDL precedence
        property can be reliably honored.

        The ``precedence`` argument determines the conditional assignment's priority over
        other assignments of differing precedence.

        If multiple conditionals of the same precedence are registered, they are
        searched sequentially and only the first to match the given field is used.
        """
        if precedence not in self._hw_conditionals:
            self._hw_conditionals[precedence] = []
        self._hw_conditionals[precedence].append(conditional)


    def add_sw_conditional(self, conditional: NextStateConditional, precedence: AssignmentPrecedence) -> None:
        """
        Register a NextStateConditional action for software-triggered field updates.
        Categorizing conditionals correctly by hw/sw ensures that the RDL precedence
        property can be reliably honored.

        The ``precedence`` argument determines the conditional assignment's priority over
        other assignments of differing precedence.

        If multiple conditionals of the same precedence are registered, they are
        searched sequentially and only the first to match the given field is used.
        """
        if precedence not in self._sw_conditionals:
            self._sw_conditionals[precedence] = []
        self._sw_conditionals[precedence].append(conditional)


    def init_conditionals(self) -> None:
        """
        Initialize all possible conditionals here.

        Remember: The order in which conditionals are added matters within the
        same assignment precedence.
        """

        self.add_sw_conditional(sw_onread.ClearOnRead(self.exp), AssignmentPrecedence.SW_ONREAD)
        self.add_sw_conditional(sw_onread.SetOnRead(self.exp), AssignmentPrecedence.SW_ONREAD)

        self.add_sw_conditional(sw_onwrite.Write(self.exp), AssignmentPrecedence.SW_ONWRITE)
        self.add_sw_conditional(sw_onwrite.WriteSet(self.exp), AssignmentPrecedence.SW_ONWRITE)
        self.add_sw_conditional(sw_onwrite.WriteClear(self.exp), AssignmentPrecedence.SW_ONWRITE)
        self.add_sw_conditional(sw_onwrite.WriteZeroToggle(self.exp), AssignmentPrecedence.SW_ONWRITE)
        self.add_sw_conditional(sw_onwrite.WriteZeroClear(self.exp), AssignmentPrecedence.SW_ONWRITE)
        self.add_sw_conditional(sw_onwrite.WriteZeroSet(self.exp), AssignmentPrecedence.SW_ONWRITE)
        self.add_sw_conditional(sw_onwrite.WriteOneToggle(self.exp), AssignmentPrecedence.SW_ONWRITE)
        self.add_sw_conditional(sw_onwrite.WriteOneClear(self.exp), AssignmentPrecedence.SW_ONWRITE)
        self.add_sw_conditional(sw_onwrite.WriteOneSet(self.exp), AssignmentPrecedence.SW_ONWRITE)

        self.add_sw_conditional(sw_singlepulse.Singlepulse(self.exp), AssignmentPrecedence.SW_SINGLEPULSE)

        self.add_hw_conditional(hw_interrupts_with_write.PosedgeStickybitWE(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.PosedgeStickybitWEL(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.NegedgeStickybitWE(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.NegedgeStickybitWEL(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.BothedgeStickybitWE(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.BothedgeStickybitWEL(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.StickyWE(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.StickyWEL(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.StickybitWE(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts_with_write.StickybitWEL(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts.PosedgeStickybit(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts.NegedgeStickybit(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts.BothedgeStickybit(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts.Sticky(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_interrupts.Stickybit(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_write.WEWrite(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_write.WELWrite(self.exp), AssignmentPrecedence.HW_WRITE)
        self.add_hw_conditional(hw_write.AlwaysWrite(self.exp), AssignmentPrecedence.HW_WRITE)

        self.add_hw_conditional(hw_set_clr.HWClear(self.exp), AssignmentPrecedence.HWCLR)

        self.add_hw_conditional(hw_set_clr.HWSet(self.exp), AssignmentPrecedence.HWSET)


    def _get_X_conditionals(self, conditionals: 'Dict[int, List[NextStateConditional]]', field: 'FieldNode') -> 'List[NextStateConditional]':
        result = []
        precedences = sorted(conditionals.keys(), reverse=True)
        for precedence in precedences:
            for conditional in conditionals[precedence]:
                if conditional.is_match(field):
                    result.append(conditional)
                    break
        return result


    def get_conditionals(self, field: 'FieldNode') -> 'List[NextStateConditional]':
        """
        Get a list of NextStateConditional objects that apply to the given field.

        The returned list is sorted in priority order - the conditional with highest
        precedence is first in the list.
        """
        sw_precedence = field.get_property('precedence') == PrecedenceType.sw
        result = []

        if sw_precedence:
            result.extend(self._get_X_conditionals(self._sw_conditionals, field))

        result.extend(self._get_X_conditionals(self._hw_conditionals, field))

        if not sw_precedence:
            result.extend(self._get_X_conditionals(self._sw_conditionals, field))

        return result
