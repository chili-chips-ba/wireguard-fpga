from typing import TextIO, Set, Optional, List
import os
import re

from systemrdl.walker import RDLListener, RDLWalker, WalkerAction
from systemrdl.node import AddrmapNode, AddressableNode, RegNode, FieldNode, Node, MemNode

from .design_state import DesignState
from .identifier_filter import kw_filter as kwf
from . import utils

class HeaderGenerator(RDLListener):
    def __init__(self, ds: DesignState) -> None:
        self.ds = ds

        self.defined_namespace: Set[str]
        self.defined_namespace = set()
        self.indent_level = 0

        self.root_node: AddrmapNode
        self.root_node = None

        self.f: TextIO
        self.f = None # type: ignore

    def run(self, path: str, top_nodes: List[AddrmapNode]) -> None:
        with open(path, "w", encoding='utf-8') as f:
            self.f = f

            context = {
                "ds": self.ds,
                "header_guard_def": re.sub(r"[^\w]", "_", os.path.basename(path)).upper(),
                "top_nodes": top_nodes,
                "get_struct_name": utils.get_struct_name,
            }

            # Stream header via jinja
            template = self.ds.jj_env.get_template("header.h")
            template.stream(context).dump(f)
            f.write("\n")

            # Generate definitions
            for node in top_nodes:
                self.root_node = node
                RDLWalker().walk(node, self)

            # Write direct instance definitions
            if self.ds.instantiate:
                f.write("\n// Instances\n")
                for node in top_nodes:
                    addr = node.raw_absolute_address + self.ds.inst_offset
                    type_name = utils.get_struct_name(self.ds, node, node)
                    if node.is_array:
                        if len(node.array_dimensions) > 1:
                            node.env.msg.fatal(
                                f"C header generator does not support instance defines for multi-dimensional arrays: {node.inst_name}{node.array_dimensions}",
                                node.inst.inst_src_ref
                            )
                        f.write(f"#define {node.inst_name} ((volatile {type_name} *){addr:#x}UL)\n")
                    else:
                        f.write(f"#define {node.inst_name} (*(volatile {type_name} *){addr:#x}UL)\n")

            # Stream footer via jinja
            template = self.ds.jj_env.get_template("footer.h")
            template.stream(context).dump(f)

            # Ensure newline before EOF
            f.write("\n")

    def push_indent(self) -> None:
        self.indent_level += 1

    def pop_indent(self) -> None:
        self.indent_level -= 1

    def write(self, s: str) -> None:
        if self.indent_level:
            self.f.write("    " * self.indent_level)
        self.f.write(s)


    def get_node_prefix(self, node: AddressableNode) -> str:
        return utils.get_node_prefix(self.ds, self.root_node, node)

    def get_struct_name(self, node: AddressableNode) -> str:
        return utils.get_struct_name(self.ds, self.root_node, node)

    def get_friendly_name(self, node: Node) -> str:
        return utils.get_friendly_name(self.ds, self.root_node, node)

    def write_bitfields(self, grp_name: str, regwidth: int, fields: List[FieldNode]) -> None:
        if not fields:
            return

        if regwidth > 64:
            # TODO: add support for this
            self.root_node.env.msg.fatal(
                "C header bit-fields for registers wider than 64-bits is not supported yet",
                fields[0].parent.inst.inst_src_ref
            )

        self.write("struct __attribute__ ((__packed__)) {\n")
        self.push_indent()

        if self.ds.bitfield_order_ltoh:
            # Bits are packed in struct LSb --> MSb
            current_offset = 0
            for field in fields:
                if field.low > current_offset:
                    self.write(f"uint{regwidth}_t :{field.low - current_offset:d};\n")
                    current_offset = field.low
                self.write(f"uint{regwidth}_t {kwf(field.inst_name)} :{field.width:d};\n")
                current_offset += field.width

            if current_offset < regwidth:
                self.write(f"uint{regwidth}_t :{regwidth - current_offset:d};\n")
        else:
            # Bits are packed in struct MSb --> LSb
            current_offset = regwidth - 1
            for field in reversed(fields):
                if field.high < current_offset:
                    self.write(f"uint{regwidth}_t :{current_offset - field.high:d};\n")
                    current_offset = field.high
                self.write(f"uint{regwidth}_t {kwf(field.inst_name)} :{field.width:d};\n")
                current_offset -= field.width

            if current_offset > -1:
                self.write(f"uint{regwidth}_t :{current_offset + 1:d};\n")

        self.pop_indent()
        self.write(f"}} {grp_name};\n")

    def enter_Reg(self, node: RegNode) -> Optional[WalkerAction]:
        prefix = self.get_node_prefix(node).upper()

        if prefix in self.defined_namespace:
            return WalkerAction.SkipDescendants
        self.defined_namespace.add(prefix)

        self.write(f"\n// {self.get_friendly_name(node)}\n")

        for field in node.fields():
            field_prefix = prefix + "__" + field.inst_name.upper()

            bm = ((1 << field.width) - 1) << field.low
            self.write(f"#define {field_prefix}_bm {bm:#x}\n")
            self.write(f"#define {field_prefix}_bp {field.low:d}\n")
            self.write(f"#define {field_prefix}_bw {field.width:d}\n")

            reset = field.get_property('reset')
            if isinstance(reset, int):
                self.write(f"#define {field_prefix}_reset {reset:#x}\n")

        # No need to traverse fields
        return WalkerAction.SkipDescendants


    def exit_Reg(self, node: RegNode) -> None:
        if not self.ds.generate_bitfields:
            return

        union_name = self.get_struct_name(node)
        if union_name in self.defined_namespace:
            # Already defined. Skip
            return
        self.defined_namespace.add(union_name)

        # Sort fields into their respective categories
        overlapping_fields = self.ds.overlapping_fields.get(node.get_path(), [])
        fr_fields = []
        fw_fields = []
        f_fields = []
        for field in node.fields():
            if field.inst_name in overlapping_fields:
                # Is an overlapping field.
                # Guaranteed to be either read-only or write-only
                if field.is_sw_readable:
                    fr_fields.append(field)
                else:
                    fw_fields.append(field)
            else:
                f_fields.append(field)

        # Generate a union+struct for the register
        self.write("typedef union {\n")
        self.push_indent()

        regwidth = node.get_property('regwidth')

        # Write bitfield struct members
        self.write_bitfields("f", regwidth, f_fields)
        self.write_bitfields("fr", regwidth, fr_fields)
        self.write_bitfields("fw", regwidth, fw_fields)

        # Write word member
        if regwidth > 64:
            # Cannot use stdint types
            # Build the wide register as an array of smaller stdint types
            n_subwords = regwidth // self.ds.wide_reg_subword_size
            self.write(f"uint{self.ds.wide_reg_subword_size}_t w[{n_subwords}];\n")
        else:
            self.write(f"uint{regwidth}_t w;\n")

        self.pop_indent()
        self.write(f"}} {union_name};\n")


    def exit_AddressableComponent(self, node: AddressableNode) -> None:
        if isinstance(node, (RegNode, MemNode)):
            # Registers and Mem handled elsewhere
            return

        self.write_block(node)

    def exit_Mem(self, node: MemNode) -> None:

        for _ in node.registers():
            has_vregs = True
            break
        else:
            has_vregs = False


        if has_vregs:
            # Contains virtual registers.
            # Write out as if it is a regular block
            self.write_block(node)
            return

        # otherwise, write out an array of words of memwidth
        struct_name = self.get_struct_name(node)
        if struct_name in self.defined_namespace:
            # Already defined. Skip
            return
        self.defined_namespace.add(struct_name)

        self.write(f"\n// {self.get_friendly_name(node)}\n")

        self.write("typedef struct __attribute__ ((__packed__)) {\n")
        self.push_indent()

        width = utils.roundup_pow2(node.get_property("memwidth"))
        if width > 64:
            n_subwords = width // self.ds.wide_reg_subword_size
            self.write(f"uint{self.ds.wide_reg_subword_size}_t mem[{node.get_property('mementries')}][{n_subwords}];\n")
        else:
            self.write(f"uint{width}_t mem[{node.get_property('mementries')}];\n")

        self.pop_indent()
        self.write(f"}} {struct_name};\n")

    def write_block(self, node: AddressableNode) -> None:
        struct_name = self.get_struct_name(node)
        if struct_name in self.defined_namespace:
            # Already defined. Skip
            return
        self.defined_namespace.add(struct_name)

        self.write(f"\n// {self.get_friendly_name(node)}\n")

        self.write("typedef struct __attribute__ ((__packed__)) {\n")
        self.push_indent()

        current_offset = 0
        skipme = set()
        for child in node.children():
            if not isinstance(child, AddressableNode):
                continue

            # Skip any child regs that were already emitted due to overlap union
            if child.inst_name in skipme:
                continue

            # Insert byte padding before next child
            padding = child.raw_address_offset - current_offset
            if padding:
                self.write_byte_padding(current_offset, padding)
                current_offset += padding

            if isinstance(child, RegNode):
                # Check if register is overlapping first
                partner_reg_name = self.ds.overlapping_reg_pairs.get(child.get_path(), None)
                if partner_reg_name:
                    # Two registers occupy the same space
                    self.write("union {\n")
                    self.push_indent()
                    self.write_reg_struct_member(child)
                    self.write_reg_struct_member(node.get_child_by_name(partner_reg_name))
                    self.pop_indent()
                    if self.ds.std.anon_unions:
                        self.write("};\n")
                    else:
                        self.write(f"}} {child.inst_name}_{partner_reg_name};\n")
                    skipme.add(partner_reg_name)
                else:
                    self.write_reg_struct_member(child)
            else:
                self.write_group_struct_member(child)

            current_offset += child.total_size

        # Write end padding as needed
        if node.is_array:
            padding = node.array_stride - current_offset
        else:
            padding = node.size - current_offset
        if padding:
            self.write_byte_padding(current_offset, padding)

        self.pop_indent()
        self.write(f"}} {struct_name};\n")


    def write_byte_padding(self, start_offset: int, size: int) -> None:
        self.write(f"uint8_t RESERVED_{start_offset:x}_{start_offset + size - 1:x}[{size:#x}];\n")


    def write_reg_struct_member(self, node: RegNode) -> None:
        if node.is_array:
            array_suffix = str(node.array_dimensions)
        else:
            array_suffix = ""

        if self.ds.generate_bitfields:
            struct_name = self.get_struct_name(node)
            self.write(f"{struct_name} {kwf(node.inst_name)}{array_suffix};\n")
        else:
            regwidth = node.get_property('regwidth')
            if regwidth > 64:
                # Cannot use stdint types
                # Build the wide register as an array of smaller stdint types
                n_subwords = regwidth // self.ds.wide_reg_subword_size
                self.write(f"uint{self.ds.wide_reg_subword_size}_t {kwf(node.inst_name)}{array_suffix}[{n_subwords}];\n")
            else:
                self.write(f"uint{regwidth}_t {kwf(node.inst_name)}{array_suffix};\n")


    def write_group_struct_member(self, node: AddressableNode) -> None:
        if node.is_array:
            array_suffix = str(node.array_dimensions)
        else:
            array_suffix = ""

        struct_name = self.get_struct_name(node)
        self.write(f"{struct_name} {kwf(node.inst_name)}{array_suffix};\n")
