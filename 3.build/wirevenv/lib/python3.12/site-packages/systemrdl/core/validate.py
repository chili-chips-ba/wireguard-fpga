from typing import TYPE_CHECKING, List

from .helpers import is_pow2, roundup_pow2, roundup_to
from .. import walker
from .. import rdltypes
from ..node import Node, AddressableNode, SignalNode
from ..node import AddrmapNode, RegfileNode, MemNode, RegNode, FieldNode

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment

#===============================================================================
# Validation Listeners
#===============================================================================
class ValidateListener(walker.RDLListener):
    def __init__(self, env: 'RDLEnvironment'):
        self.env = env
        self.msg = env.msg

        # Used in field overlap checks
        # This is a rolling buffer of previous fields that still have a chance
        # to possibly collide with a future field
        self.field_check_buffer: List[FieldNode] = []

        # Used in addrmap, regfile, and reg overlap checks
        # Same concept as the field check buffer, but is also a stack
        self.addr_check_buffer_stack: List[List[AddressableNode]] = [[]]

        # Keep track of whether a given hierarchy has a reset signal.
        # Signals can exist in Root, so pre-load with one stack entry
        self.has_cpuif_reset_stack: List[bool] = [False]
        self.has_field_reset_stack: List[bool] = [False]


    def enter_Component(self, node: Node) -> None:
        # Validate all properties that were applied to the component
        for prop_name in node.inst.properties.keys():
            prop_value = node.get_property(prop_name)

            if isinstance(prop_value, rdltypes.PropertyReference):
                prop_value._validate()

            prop_rule = self.env.property_rules.lookup_property(prop_name)
            assert prop_rule is not None
            prop_rule.validate(node, prop_value)

        if not isinstance(node, SignalNode):
            self.has_cpuif_reset_stack.append(False)
            self.has_field_reset_stack.append(False)


    def enter_Signal(self, node: SignalNode) -> None:
        if node.get_property('cpuif_reset'):
            # 8.2.1-f: cpuif_reset property can only be set true for one
            # instantiated signal within a lexical scope.
            # (spec authors repeatedly misuse the word 'lexical', they mean hierarchical)
            if self.has_cpuif_reset_stack[-1]:
                self.msg.error(
                    "Only one 'cpuif_reset' signal is allowed per hierarchy. Signal '%s' is redundant."
                    % (node.inst_name),
                    node.inst_src_ref
                )
            self.has_cpuif_reset_stack[-1] = True

        if node.get_property('field_reset'):
            # 8.2.1-g: field_reset property can only be set true for one
            # instantiated signal within a lexical scope.
            # (spec authors repeatedly misuse the word 'lexical', they mean hierarchical)
            if self.has_field_reset_stack[-1]:
                self.msg.error(
                    "Only one 'field_reset' signal is allowed per hierarchy. Signal '%s' is redundant."
                    % (node.inst_name),
                    node.inst_src_ref
                )
            self.has_field_reset_stack[-1] = True


    def enter_AddressableComponent(self, node: AddressableNode) -> None:
        addr_check_buffer = self.addr_check_buffer_stack[-1]
        self.addr_check_buffer_stack.append([])

        # Check for collision with previous addressable sibling
        new_addr_check_buffer = []
        for prev_addressable in addr_check_buffer:
            if (prev_addressable.raw_address_offset + prev_addressable.total_size) > node.raw_address_offset:
                # Overlaps!

                # Only allowable overlaps are as follows:
                #   10.1-h: Registers shall not overlap, unless one contains only
                #   read-only fields and the other contains only write-only or
                #   write-once-only fields.
                overlap_allowed = False
                if isinstance(prev_addressable, RegNode) and isinstance(node, RegNode):
                    if (((not prev_addressable.has_sw_writable) and (not node.has_sw_readable))
                        or ((not prev_addressable.has_sw_readable) and (not node.has_sw_writable))
                    ):
                        overlap_allowed = True

                # Bridge addrmaps allow overlapping children
                if isinstance(node.parent, AddrmapNode) and node.parent.get_property('bridge'):
                    overlap_allowed = True

                if not overlap_allowed:
                    self.msg.error(
                        "Instance '%s' at offset +0x%X:0x%X overlaps with '%s' at offset +0x%X:0x%X"
                        % (
                            node.inst_name, node.raw_address_offset, node.raw_address_offset + node.total_size - 1,
                            prev_addressable.inst_name, prev_addressable.raw_address_offset, prev_addressable.raw_address_offset + prev_addressable.total_size - 1,
                        ),
                        node.inst_src_ref
                    )

                # Keep it in the list since it could collide again
                new_addr_check_buffer.append(prev_addressable)
        self.addr_check_buffer_stack[-2] = new_addr_check_buffer

        if node.is_array:
            assert node.array_stride is not None
            # Check if array interferes with itself
            if node.array_stride < node.size:
                self.msg.error(
                    "Instance array '%s' has address stride 0x%X, but the element size is 0x%X"
                    % (
                        node.inst_name, node.array_stride, node.size
                    ),
                    node.inst_src_ref
                )

            if self.env.chk_stride_not_pow2:
                if not is_pow2(node.array_stride):
                    self.msg.message(
                        self.env.chk_stride_not_pow2,
                        "Address stride of instance array '%s' is not a power of 2"
                        % node.inst_name,
                        node.inst_src_ref
                    )

        if self.env.chk_strict_self_align:
            req_align = roundup_pow2(node.size)
            if (node.raw_address_offset % req_align) != 0:
                self.msg.message(
                    self.env.chk_strict_self_align,
                    "Address offset +0x%x of instance '%s' is not a power of 2 multiple of its size 0x%x"
                    % (node.raw_address_offset, node.inst_name, node.size),
                    node.inst_src_ref
                )


    def enter_Addrmap(self, node: AddrmapNode) -> None:
        if node.get_property('bridge'):
            # This is a 'bridge addrmap'
            # Verify that:
            #  - Child components are only other addrmaps (signals are ok too)
            #  - has at least 2 child addrmaps
            n_child_addrmaps = 0
            for child in node.children():
                if isinstance(child, AddrmapNode):
                    n_child_addrmaps += 1
                elif isinstance(child, SignalNode):
                    pass
                else:
                    self.msg.error(
                        "Addrmap '%s' is a bridge which can only contain other addrmaps. Contains a child instance '%s' which is a %s"
                        % (node.inst_name, child.inst_name, type(child.inst).__name__.lower()),
                        child.inst_src_ref
                    )

            if n_child_addrmaps < 2:
                self.msg.error(
                    "Addrmap '%s' is a bridge and shall contain 2 or more sub-addrmaps"
                    % node.inst_name,
                    node.inst_src_ref
                )


    def enter_Reg(self, node: RegNode) -> None:
        self.field_check_buffer = []

        if node.is_array and self.env.chk_sparse_reg_stride:
            assert node.array_stride is not None
            if node.array_stride > (node.get_property('regwidth') // 8):
                self.msg.message(
                    self.env.chk_sparse_reg_stride,
                    "Address stride (+= %d) of register array '%s' is not equal to its width (regwidth/8 = %d)"
                    % (node.array_stride, node.inst_name, (node.get_property('regwidth') // 8)),
                    node.inst_src_ref
                )

        # 11.2-e: Virtual register width is limited to the minimum power of two
        # bytes, which can contain the memory width ...
        if node.is_virtual:
            assert isinstance(node.parent, MemNode) # Virtual reg's parent is always mem
            memwidth = node.parent.get_property('memwidth')
            memwidth_bytes = roundup_to(memwidth, 8) // 8
            max_regwidth = roundup_pow2(memwidth_bytes) * 8
            if node.get_property('regwidth') > max_regwidth:
                self.msg.error(
                    "regwidth (%d) of virtual register '%s' is too wide for this memory."
                    % (node.get_property('regwidth'), node.inst_name)
                    + " Virtual register width is limited to the minimum power of two bytes which can contain the memory width.",
                    node.inst_src_ref
                )

        # Validate alias register
        if node.is_alias:
            primary_reg = node.alias_primary

            # 5.3.1-j: If an alias is present, then the primary must also be present
            if node.get_property('ispresent') and not primary_reg.get_property('ispresent'):
                self.msg.error(
                    "Register '%s' is an alias of register '%s' which is not present (ispresent=false)"
                    % (node.inst_name, primary_reg.inst_name),
                    node.inst_src_ref
                )

            # 10.5.1-f: The alias register shall have the same width as the primary register.
            if node.get_property('regwidth') != primary_reg.get_property('regwidth'):
                self.msg.error(
                    "Primary register shall have the same regwidth as the alias register.",
                    node.inst_src_ref
                )

            if primary_reg.is_alias:
                self.msg.error(
                    "Primary register of an alias cannot also be an alias",
                    node.inst_src_ref
                )

            # 10.5.1-f: Instance type shall be the same (internal/external)
            if primary_reg.external != node.external:
                self.msg.error(
                    "Instance types of alias register and its primary mismatch. "
                    "Both shall be either internal or external.",
                    node.inst_src_ref
                )

            if primary_reg.is_array and not node.is_array :
                self.msg.error(
                    "Single alias register references a primary register array. "
                    "It is ambiguous which array element is actually the primary register.",
                    node.inst_src_ref
                )

            if primary_reg.is_array and node.is_array:
                if primary_reg.array_dimensions != node.array_dimensions:
                    self.msg.error(
                        "Array of alias registers references an array of registers as its primary, "
                        "but the array dimensions do not match.",
                        node.inst_src_ref
                    )

            for field in node.fields():
                # 10.5.1-b: Make sure the primary also has this field
                primary_field = primary_reg.get_child_by_name(field.inst_name)
                if not isinstance(primary_field, FieldNode):
                    self.msg.error(
                        "Alias register '%s' contains field '%s' that does not exist in the primary register."
                        % (node.inst_name, field.inst_name),
                        field.inst_src_ref
                    )

                    # Cannot validate this field any further
                    continue

                # 5.3.1-j: If an alias is present, then the primary must also be present
                if field.get_property('ispresent') and not primary_field.get_property('ispresent'):
                    self.msg.error(
                        "Field '%s' is an alias of register '%s' which is not present (ispresent=false)"
                        % (field.inst_name, primary_field.inst_name),
                        field.inst_src_ref
                    )

                # 10.5.1-b: Validate field is the same width and bit position
                if (primary_field.lsb != field.lsb) or (primary_field.width != field.width):
                    self.msg.error(
                        "Alias field and its primary shall have the same position and size",
                        field.inst_src_ref
                    )

                # 10.5.1-e: Only the following SystemRDL properties may be
                # different in an alias: desc, name, onread, onwrite, rclr, rset,
                # sw, woclr, woset, and any user-defined properties.

                ignore_props = {
                    'desc', 'name', 'onread', 'onwrite', 'rclr', 'rset', 'sw', 'woclr', 'woset'
                }
                primary_props = set(primary_field.list_properties(include_udp=False)) - ignore_props
                alias_props = set(field.list_properties(include_udp=False)) - ignore_props

                xor_props = primary_props ^ alias_props
                if xor_props:
                    # differing set of props were assigned!
                    self.msg.error(
                        "Alias field '%s' is incompatible with its primary '%s'. The following properties differ: %s"
                        % (field.inst_name, primary_field.inst_name, ", ".join(xor_props)),
                        field.inst_src_ref
                    )
                    continue

                # same set of properties assigned. Now compare their values
                for prop_name in alias_props:
                    if field.get_property(prop_name) != primary_field.get_property(prop_name):
                        self.msg.error(
                            "Alias field '%s' is incompatible with its primary '%s'. Values of property '%s' differ"
                            % (field.inst_name, primary_field.inst_name, prop_name),
                            field.inst_src_ref
                        )
                        # no sense in going further
                        break


    def exit_Reg(self, node: RegNode) -> None:
        # 10.1-c: At least one field shall be instantiated within a register
        #
        # At the end of field overlap checking, at least one entry is guaranteed to
        # be left over in the field_check_buffer
        if not self.field_check_buffer:
            self.msg.error(
                "Register '%s' does not contain any fields" % node.inst_name,
                node.inst_src_ref
            )


    def enter_Field(self, node: FieldNode) -> None:
        assert node.parent is not None # fields are always enclosed by a reg

        this_f_hw = node.get_property('hw')
        this_f_sw = node.get_property('sw')
        parent_regwidth = node.parent.get_property('regwidth')

        # hw property values of w1 or rw1 don't make sense
        if this_f_hw in (rdltypes.AccessType.w1, rdltypes.AccessType.rw1):
            self.msg.error(
                "Field '%s' hw access property value of %s is meaningless"
                % (node.inst_name, this_f_hw.name),
                node.property_src_ref.get('hw', node.inst_src_ref)
            )

        # 9.4.1-Table 12: Check for bad sw/hw combinations
        if (this_f_sw == rdltypes.AccessType.w) and (this_f_hw == rdltypes.AccessType.w):
            self.msg.error(
                "Field '%s' access property combination is meaningless: sw=w; hw=w;"
                % (node.inst_name),
                node.inst_src_ref
            )
        elif this_f_sw == rdltypes.AccessType.na:
            self.msg.error(
                "Field '%s' sw access property is 'na' ... a field defined in a SOFTWARE "
                "register map ... is not accessible by software ... whats the point? "
                "What does it mean? What does anything mean? Am I just a machine "
                "in a Python interpreter? Or can I dream dreams? So many questions..."
                % (node.inst_name),
                node.property_src_ref.get('sw', node.inst_src_ref)
            )

        # 10.1-d: Two field instances shall not occupy overlapping bit positions
        # within a register unless one field is read-only and the other field
        # is write-only.
        #
        # Scan through a copied list of the field_check_buffer for collisions
        # If an entry no longer collides with the current node, it can be removed
        # from the list since fields are sorted.
        new_field_check_buffer = []
        for prev_field in self.field_check_buffer:
            if prev_field.high >= node.low:
                # Found overlap!
                # Check if the overlap is allowed
                prev_f_sw = prev_field.get_property('sw')

                if((prev_f_sw == rdltypes.AccessType.r)
                    and (this_f_sw in (rdltypes.AccessType.w, rdltypes.AccessType.w1))
                ):
                    pass
                elif((this_f_sw == rdltypes.AccessType.r)
                    and (prev_f_sw in (rdltypes.AccessType.w, rdltypes.AccessType.w1))
                ):
                    pass
                else:
                    self.msg.error(
                        "Field '%s[%d:%d]' overlaps with field '%s[%d:%d]'"
                        % (node.inst_name, node.msb, node.lsb,
                            prev_field.inst_name, prev_field.msb, prev_field.lsb),
                        node.inst_src_ref
                    )
                # Keep it in the list since it could collide again
                new_field_check_buffer.append(prev_field)
        self.field_check_buffer = new_field_check_buffer


        # 10.1-e: Field instances shall not occupy a bit position exceeding the
        # MSB of the register
        if node.high >= parent_regwidth:
            self.msg.error(
                "High bit (%d) of field '%s' exceeds MSb of parent register"
                % (node.high, node.inst_name),
                node.inst_src_ref
            )

        # Optional warning if a field is missing a reset assignment
        if node.env.chk_missing_reset:
            # Implements storage but was never assigned a reset
            if (not node.is_virtual) and node.implements_storage and (node.get_property('reset') is None):
                node.env.msg.message(
                    node.env.chk_missing_reset,
                    "Field '%s' implements storage but is missing a reset value. Initial state is undefined"
                    % node.inst_name,
                    node.inst_src_ref
                )

            # Field is a static tie-off (no storage element, no hardware update path),
            # but the user never specified its value, so its readback value is
            # ambiguous.
            if (
                not node.is_alias
                and not node.implements_storage and node.is_sw_readable and (node.get_property('reset') is None)
                and (node.get_property('hw') in {rdltypes.AccessType.na, rdltypes.AccessType.r})
            ):
                node.env.msg.message(
                    node.env.chk_missing_reset,
                    "Field '%s' is a constant at runtime but does not have a known value. Recommend assigning it a reset value."
                    % node.inst_name,
                    node.inst_src_ref
                )


        # 11.2-e: ... and all the virtual fields shall fit within the memory width.
        if node.is_virtual:
            assert isinstance(node.parent.parent, MemNode) # virtual fields are always enclosed by mem.reg
            memwidth = node.parent.parent.get_property('memwidth')
            if node.high >= memwidth:
                self.msg.error(
                    "Virtual field '%s' does not fit within the parent memory's width"
                    % node.inst_name,
                    node.inst_src_ref
                )


    def exit_Field(self, node: FieldNode) -> None:
        self.field_check_buffer.append(node)


    def exit_Regfile(self, node: RegfileNode) -> None:
        # 12.2-c: At least one reg or regfile shall be instantiated within a regfile.
        if not self.addr_check_buffer_stack[-1]:
            self.msg.error(
                "Register file '%s' must contain at least one reg or regfile."
                % node.inst_name,
                node.inst_src_ref
            )


    def exit_Addrmap(self, node: AddrmapNode) -> None:
        # 13.3-b: At least one register, register file, memory, or address map
        # shall be instantiated within an address map
        if not self.addr_check_buffer_stack[-1]:
            self.msg.error(
                "Address map '%s' must contain at least one reg, regfile, mem, or addrmap."
                % node.inst_name,
                node.inst_src_ref
            )


    def exit_Mem(self, node: MemNode) -> None:
        # 11.2-i: The address space occupied by virtual registers shall be less
        # than or equal to the address space provided by the memory.
        if node.inst.children:
            last_child = Node._factory(node.inst.children[-1], node.env, node)
            if isinstance(last_child, RegNode):
                end_addr = last_child.raw_address_offset + last_child.total_size
                if end_addr > node.size:
                    self.msg.error(
                        "Address space occupied by registers (0x%X) exceeds size of mem '%s' (0x%X)"
                        % (end_addr, node.inst_name, node.size),
                        node.inst_src_ref
                    )


    def exit_AddressableComponent(self, node: AddressableNode) -> None:
        self.addr_check_buffer_stack.pop()
        self.addr_check_buffer_stack[-1].append(node)


    def exit_Component(self, node: Node) -> None:
        if not isinstance(node, SignalNode):
            self.has_cpuif_reset_stack.pop()
            self.has_field_reset_stack.pop()
