from typing import TYPE_CHECKING, List

from systemrdl.node import RegNode, AddressableNode
from systemrdl.walker import WalkerAction

from ..forloop_generator import RDLForLoopGenerator, LoopBody

from ..utils import do_bitswap, do_slice

if TYPE_CHECKING:
    from ..exporter import RegblockExporter

class ReadbackLoopBody(LoopBody):
    def __init__(self, dim: int, iterator: str, i_type: str) -> None:
        super().__init__(dim, iterator, i_type)
        self.n_regs = 0

    def __str__(self) -> str:
        # replace $i#sz token when stringifying
        s = super().__str__()
        token = f"${self.iterator}sz"
        s = s.replace(token, str(self.n_regs))
        return s

class ReadbackAssignmentGenerator(RDLForLoopGenerator):
    i_type = "genvar"
    loop_body_cls = ReadbackLoopBody

    def __init__(self, exp:'RegblockExporter') -> None:
        super().__init__()
        self.exp = exp

        # The readback array collects all possible readback values into a flat
        # array. The array width is equal to the CPUIF bus width. Each entry in
        # the array represents an aligned read access.
        self.current_offset = 0
        self.start_offset_stack = [] # type: List[int]
        self.dim_stack = [] # type: List[int]

    @property
    def current_offset_str(self) -> str:
        """
        Derive a string that represents the current offset being assigned.
        This consists of:
        - The current integer offset
        - multiplied index of any enclosing loop

        The integer offset from "current_offset" is static and is monotonically
        incremented as more register assignments are processed.

        The component of the offset from loops is added by multiplying the current
        loop index by the loop size.
        Since the loop's size is not known at this time, it is emitted as a
        placeholder token like: $i0sz, $i1sz, $i2sz, etc
        These tokens can be replaced once the loop body has been completed and the
        size of its contents is known.
        """
        offset_parts = []
        for i in range(self._loop_level):
            offset_parts.append(f"i{i} * $i{i}sz")
        offset_parts.append(str(self.current_offset))
        return " + ".join(offset_parts)

    def push_loop(self, dim: int) -> None:
        super().push_loop(dim)
        self.start_offset_stack.append(self.current_offset)
        self.dim_stack.append(dim)

    def pop_loop(self) -> None:
        start_offset = self.start_offset_stack.pop()
        dim = self.dim_stack.pop()

        # Number of registers enclosed in this loop
        n_regs = self.current_offset - start_offset
        self.current_loop.n_regs = n_regs # type: ignore

        super().pop_loop()

        # Advance current scope's offset to account for loop's contents
        self.current_offset = start_offset + n_regs * dim


    def enter_AddressableComponent(self, node: 'AddressableNode') -> WalkerAction:
        super().enter_AddressableComponent(node)

        if node.external and not isinstance(node, RegNode):
            # External block
            strb = self.exp.hwif.get_external_rd_ack(node)
            data = self.exp.hwif.get_external_rd_data(node)
            self.add_content(f"assign readback_array[{self.current_offset_str}] = {strb} ? {data} : '0;")
            self.current_offset += 1
            return WalkerAction.SkipDescendants

        return WalkerAction.Continue

    def enter_Reg(self, node: RegNode) -> WalkerAction:
        if not node.has_sw_readable:
            return WalkerAction.SkipDescendants

        if node.external:
            self.process_external_reg(node)
            return WalkerAction.SkipDescendants

        accesswidth = node.get_property('accesswidth')
        regwidth = node.get_property('regwidth')
        rbuf = node.get_property('buffer_reads')
        if rbuf:
            trigger = node.get_property('rbuffer_trigger')
            is_own_trigger = (isinstance(trigger, RegNode) and trigger == node)
            if is_own_trigger:
                if accesswidth < regwidth:
                    self.process_buffered_reg_with_bypass(node, regwidth, accesswidth)
                else:
                    # bypass cancels out. Behaves like a normal reg
                    self.process_reg(node)
            else:
                self.process_buffered_reg(node, regwidth, accesswidth)
        elif accesswidth < regwidth:
            self.process_wide_reg(node, accesswidth)
        else:
            self.process_reg(node)

        return WalkerAction.SkipDescendants

    def process_external_reg(self, node: RegNode) -> None:
        strb = self.exp.hwif.get_external_rd_ack(node)
        data = self.exp.hwif.get_external_rd_data(node)
        regwidth = node.get_property('regwidth')
        if regwidth < self.exp.cpuif.data_width:
            self.add_content(f"assign readback_array[{self.current_offset_str}][{self.exp.cpuif.data_width-1}:{regwidth}] = '0;")
            self.add_content(f"assign readback_array[{self.current_offset_str}][{regwidth-1}:0] = {strb} ? {data} : '0;")
        else:
            self.add_content(f"assign readback_array[{self.current_offset_str}] = {strb} ? {data} : '0;")

        self.current_offset += 1

    def process_reg(self, node: RegNode) -> None:
        current_bit = 0
        rd_strb = f"({self.exp.dereferencer.get_access_strobe(node)} && !decoded_req_is_wr)"
        # Fields are sorted by ascending low bit
        for field in node.fields():
            if not field.is_sw_readable:
                continue

            # insert reserved assignment before this field if needed
            if field.low != current_bit:
                self.add_content(f"assign readback_array[{self.current_offset_str}][{field.low-1}:{current_bit}] = '0;")

            value = self.exp.dereferencer.get_value(field)
            if field.msb < field.lsb:
                # Field gets bitswapped since it is in [low:high] orientation
                value = do_bitswap(value)

            self.add_content(f"assign readback_array[{self.current_offset_str}][{field.high}:{field.low}] = {rd_strb} ? {value} : '0;")

            current_bit = field.high + 1

        # Insert final reserved assignment if needed
        bus_width = self.exp.cpuif.data_width
        if current_bit < bus_width:
            self.add_content(f"assign readback_array[{self.current_offset_str}][{bus_width-1}:{current_bit}] = '0;")

        self.current_offset += 1


    def process_buffered_reg(self, node: RegNode, regwidth: int, accesswidth: int) -> None:
        rbuf = self.exp.read_buffering.get_rbuf_data(node)

        if accesswidth < regwidth:
            # Is wide reg
            n_subwords = regwidth // accesswidth
            astrb = self.exp.dereferencer.get_access_strobe(node, reduce_substrobes=False)
            for i in range(n_subwords):
                rd_strb = f"({astrb}[{i}] && !decoded_req_is_wr)"
                bslice = f"[{(i + 1) * accesswidth - 1}:{i*accesswidth}]"
                self.add_content(f"assign readback_array[{self.current_offset_str}] = {rd_strb} ? {rbuf}{bslice} : '0;")
                self.current_offset += 1

        else:
            # Is regular reg
            rd_strb = f"({self.exp.dereferencer.get_access_strobe(node)} && !decoded_req_is_wr)"
            self.add_content(f"assign readback_array[{self.current_offset_str}][{regwidth-1}:0] = {rd_strb} ? {rbuf} : '0;")

            bus_width = self.exp.cpuif.data_width
            if regwidth < bus_width:
                self.add_content(f"assign readback_array[{self.current_offset_str}][{bus_width-1}:{regwidth}] = '0;")

            self.current_offset += 1


    def process_buffered_reg_with_bypass(self, node: RegNode, regwidth: int, accesswidth: int) -> None:
        """
        Special case for a buffered register when the register is its own trigger.
        First sub-word shall bypass the read buffer and assign directly.
        Subsequent subwords assign from the buffer.
        Caller guarantees this is a wide reg
        """
        astrb = self.exp.dereferencer.get_access_strobe(node, reduce_substrobes=False)

        # Generate assignments for first sub-word
        bidx = 0
        rd_strb = f"({astrb}[0] && !decoded_req_is_wr)"
        for field in node.fields():
            if not field.is_sw_readable:
                continue

            if field.low >= accesswidth:
                # field is not in this subword.
                break

            if bidx < field.low:
                # insert padding before
                self.add_content(f"assign readback_array[{self.current_offset_str}][{field.low - 1}:{bidx}] = '0;")

            if field.high >= accesswidth:
                # field gets truncated
                r_low = field.low
                r_high = accesswidth - 1
                f_low = 0
                f_high = accesswidth - 1 - field.low

                if field.msb < field.lsb:
                    # Field gets bitswapped since it is in [low:high] orientation
                    # Mirror the low/high indexes
                    f_low = field.width - 1 - f_low
                    f_high = field.width - 1 - f_high
                    f_low, f_high = f_high, f_low
                    value = do_bitswap(do_slice(self.exp.dereferencer.get_value(field), f_high, f_low))
                else:
                    value = do_slice(self.exp.dereferencer.get_value(field), f_high, f_low)

                self.add_content(f"assign readback_array[{self.current_offset_str}][{r_high}:{r_low}] = {rd_strb} ? {value} : '0;")
                bidx = accesswidth
            else:
                # field fits in subword
                value = self.exp.dereferencer.get_value(field)
                if field.msb < field.lsb:
                    # Field gets bitswapped since it is in [low:high] orientation
                    value = do_bitswap(value)
                self.add_content(f"assign readback_array[{self.current_offset_str}][{field.high}:{field.low}] = {rd_strb} ? {value} : '0;")
                bidx = field.high + 1

        # pad up remainder of subword
        if bidx < accesswidth:
            self.add_content(f"assign readback_array[{self.current_offset_str}][{accesswidth-1}:{bidx}] = '0;")
        self.current_offset += 1

        # Assign remainder of subwords from read buffer
        n_subwords = regwidth // accesswidth
        rbuf = self.exp.read_buffering.get_rbuf_data(node)
        for i in range(1, n_subwords):
            rd_strb = f"({astrb}[{i}] && !decoded_req_is_wr)"
            bslice = f"[{(i + 1) * accesswidth - 1}:{i*accesswidth}]"
            self.add_content(f"assign readback_array[{self.current_offset_str}] = {rd_strb} ? {rbuf}{bslice} : '0;")
            self.current_offset += 1

    def process_wide_reg(self, node: RegNode, accesswidth: int) -> None:
        bus_width = self.exp.cpuif.data_width

        subword_idx = 0
        current_bit = 0 # Bit-offset within the wide register
        access_strb = self.exp.dereferencer.get_access_strobe(node, reduce_substrobes=False)
        # Fields are sorted by ascending low bit
        for field in node.fields():
            if not field.is_sw_readable:
                continue

            # insert zero assignment before this field if needed
            if field.low >= accesswidth*(subword_idx+1):
                # field does not start in this subword
                if current_bit > accesswidth * subword_idx:
                    # current subword had content. Assign remainder
                    low = current_bit % accesswidth
                    high = bus_width - 1
                    self.add_content(f"assign readback_array[{self.current_offset_str}][{high}:{low}] = '0;")
                    self.current_offset += 1

                # Advance to subword that contains the start of the field
                subword_idx = field.low // accesswidth
                current_bit = accesswidth * subword_idx

            if current_bit != field.low:
                # assign zero up to start of this field
                low = current_bit % accesswidth
                high = (field.low % accesswidth) - 1
                self.add_content(f"assign readback_array[{self.current_offset_str}][{high}:{low}] = '0;")
                current_bit = field.low


            # Assign field
            # loop until the entire field's assignments have been generated
            field_pos = field.low
            while current_bit <= field.high:
                # Assign the field
                rd_strb = f"({access_strb}[{subword_idx}] && !decoded_req_is_wr)"
                if (field_pos == field.low) and (field.high < accesswidth*(subword_idx+1)):
                    # entire field fits into this subword
                    low = field.low - accesswidth * subword_idx
                    high = field.high - accesswidth * subword_idx

                    value = self.exp.dereferencer.get_value(field)
                    if field.msb < field.lsb:
                        # Field gets bitswapped since it is in [low:high] orientation
                        value = do_bitswap(value)

                    self.add_content(f"assign readback_array[{self.current_offset_str}][{high}:{low}] = {rd_strb} ? {value} : '0;")

                    current_bit = field.high + 1

                    if current_bit == accesswidth*(subword_idx+1):
                        # Field ends at the subword boundary
                        subword_idx += 1
                        self.current_offset += 1
                elif field.high >= accesswidth*(subword_idx+1):
                    # only a subset of the field can fit into this subword
                    # high end gets truncated

                    # assignment slice
                    r_low = field_pos - accesswidth * subword_idx
                    r_high = accesswidth - 1

                    # field slice
                    f_low = field_pos - field.low
                    f_high = accesswidth * (subword_idx + 1) - 1 - field.low

                    if field.msb < field.lsb:
                        # Field gets bitswapped since it is in [low:high] orientation
                        # Mirror the low/high indexes
                        f_low = field.width - 1 - f_low
                        f_high = field.width - 1 - f_high
                        f_low, f_high = f_high, f_low

                        value = do_bitswap(do_slice(self.exp.dereferencer.get_value(field), f_high, f_low))
                    else:
                        value = do_slice(self.exp.dereferencer.get_value(field), f_high, f_low)

                    self.add_content(f"assign readback_array[{self.current_offset_str}][{r_high}:{r_low}] = {rd_strb} ? {value} : '0;")

                    # advance to the next subword
                    subword_idx += 1
                    current_bit = accesswidth * subword_idx
                    field_pos = current_bit
                    self.current_offset += 1
                else:
                    # only a subset of the field can fit into this subword
                    # finish field

                    # assignment slice
                    r_low = field_pos - accesswidth * subword_idx
                    r_high = field.high - accesswidth * subword_idx

                    # field slice
                    f_low = field_pos - field.low
                    f_high = field.high - field.low

                    if field.msb < field.lsb:
                        # Field gets bitswapped since it is in [low:high] orientation
                        # Mirror the low/high indexes
                        f_low = field.width - 1 - f_low
                        f_high = field.width - 1 - f_high
                        f_low, f_high = f_high, f_low

                        value = do_bitswap(do_slice(self.exp.dereferencer.get_value(field), f_high, f_low))
                    else:
                        value = do_slice(self.exp.dereferencer.get_value(field), f_high, f_low)

                    self.add_content(f"assign readback_array[{self.current_offset_str}][{r_high}:{r_low}] = {rd_strb} ? {value} : '0;")

                    current_bit = field.high + 1
                    if current_bit == accesswidth*(subword_idx+1):
                        # Field ends at the subword boundary
                        subword_idx += 1
                        self.current_offset += 1

        # insert zero assignment after the last field if needed
        if current_bit > accesswidth * subword_idx:
            # current subword had content. Assign remainder
            low = current_bit % accesswidth
            high = bus_width - 1
            self.add_content(f"assign readback_array[{self.current_offset_str}][{high}:{low}] = '0;")
            self.current_offset += 1
