from typing import List, TextIO, Set, Match
import os
import re

from systemrdl.walker import RDLListener, RDLWalker
from systemrdl.node import AddrmapNode, RegNode, AddressableNode

from .design_state import DesignState
from . import utils
from .identifier_filter import kw_filter as kwf

class TestcaseGenerator:
    def __init__(self, ds: DesignState) -> None:
        self.ds = ds

    def run(self, header_path: str, top_nodes: List[AddrmapNode]) -> None:
        testcase_path = header_path + ".test.c"
        with open(testcase_path, "w", encoding='utf-8') as f:

            context = {
                "ds": self.ds,
                "header_filename": os.path.basename(header_path),
            }

            # Stream header via jinja
            template = self.ds.jj_env.get_template("test_header.c")
            template.stream(context).dump(f)
            f.write("\n\n")

            OffsetTestsGenerator(self.ds).run(f, top_nodes)

            if self.ds.generate_bitfields:
                f.write("\n")
                BitfieldTestsGenerator(self.ds).run(f, top_nodes)



class OffsetTestsGenerator(RDLListener):
    def __init__(self, ds: DesignState) -> None:
        self.ds = ds

        self.indent_level = 0

        self.root_node: AddrmapNode
        self.root_node = None

        self.root_struct_name: str
        self.root_struct_name = ""

        self.f: TextIO
        self.f = None # type: ignore

        self.overlap_pair_stack: List[List[str]]
        self.overlap_pair_stack = []

    def run(self, f: TextIO, top_nodes: List[AddrmapNode]) -> None:
        self.f = f

        f.write("static void test_offsets(void){\n")
        self.push_indent()
        for node in top_nodes:
            node.zero_lineage_index()
            self.root_node = node
            self.root_struct_name = utils.get_struct_name(self.ds, node, node)
            RDLWalker(unroll=True).walk(node, self)
        self.pop_indent()
        f.write("}\n")


    def push_indent(self) -> None:
        self.indent_level += 1


    def pop_indent(self) -> None:
        self.indent_level -= 1


    def write(self, s: str) -> None:
        if self.indent_level:
            self.f.write("    " * self.indent_level)
        self.f.write(s)


    def enter_AddressableComponent(self, node: AddressableNode) -> None:
        if isinstance(node, RegNode):
            return
        self.overlap_pair_stack.append([])


    def exit_AddressableComponent(self, node: AddressableNode) -> None:
        if isinstance(node, RegNode):
            return
        self.overlap_pair_stack.pop()


    def enter_Reg(self, node: RegNode) -> None:
        # Keep track of overlapping register pairs
        overlap_neighbor = self.ds.overlapping_reg_pairs.get(
            node.get_path(array_suffix="[]"), None
        )
        if overlap_neighbor:
            overlap_pair = [node.inst_name, overlap_neighbor]
            self.overlap_pair_stack[-1] = overlap_pair
        else:
            overlap_pair = self.overlap_pair_stack[-1]

        # If anonymous unions are not supported, then register pairs will be
        # wrapped in a nested hierarchy
        if not self.ds.std.anon_unions and node.inst_name in overlap_pair:
            member = node.parent.get_rel_path(self.root_node)
            if member:
                member += "."
            member += f"{'_'.join(overlap_pair)}.{node.get_path_segment()}"
        else:
            member = node.get_rel_path(self.root_node)

        # Sanitize keywords
        def kwrepl(m: Match) -> str:
            return kwf(m.group(0))
        member = re.sub(r"\w+", kwrepl, member)

        if self.ds.generate_bitfields:
            # Reg is defined as a bitfield union. Access entire word member
            member += ".w"

        regwidth = node.get_property('regwidth')
        node_addr = node.absolute_address - self.root_node.absolute_address
        if regwidth > 64:
            # Reg is split into an array of subwords
            n_subwords = regwidth // self.ds.wide_reg_subword_size
            stride = self.ds.wide_reg_subword_size // 8
            for i in range(n_subwords):
                addr = f"{node_addr + i * stride:#x}UL"
                self.write(f"assert(offsetof({self.root_struct_name}, {member}[{i}]) == {addr});\n")
        else:
            self.write(f"assert(offsetof({self.root_struct_name}, {member}) == {node_addr:#x}UL);\n")



class BitfieldTestsGenerator(RDLListener):
    def __init__(self, ds: DesignState) -> None:
        self.ds = ds

        self.indent_level = 0

        self.defined_namespace: Set[str]
        self.defined_namespace = set()

        self.root_node: AddrmapNode
        self.root_node = None

        self.f: TextIO
        self.f = None # type: ignore

    def run(self, f: TextIO, top_nodes: List[AddrmapNode]) -> None:
        self.f = f

        f.write("static void test_bitfields(void){\n")
        self.push_indent()
        for node in top_nodes:
            self.root_node = node
            RDLWalker().walk(node, self)
        self.pop_indent()
        f.write("}\n")


    def push_indent(self) -> None:
        self.indent_level += 1


    def pop_indent(self) -> None:
        self.indent_level -= 1


    def write(self, s: str) -> None:
        if self.indent_level:
            self.f.write("    " * self.indent_level)
        self.f.write(s)


    def enter_Reg(self, node: RegNode) -> None:
        union_name = utils.get_struct_name(self.ds, self.root_node, node)
        if union_name in self.defined_namespace:
            # Already tested. Skip
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


        prefix = utils.get_node_prefix(self.ds, self.root_node, node).upper()

        self.write("{\n")
        self.push_indent()
        self.write(f"{union_name} reg;\n")
        for grp_name, fields in zip(["f", "fr", "fw"], [f_fields, fr_fields, fw_fields]):
            for field in fields:
                field_prefix = prefix + "__" + field.inst_name.upper()
                self.write("reg.w = 0;\n")
                self.write(f"reg.{grp_name}.{kwf(field.inst_name)} = {(1 << field.width) - 1:#x};\n")
                self.write(f"assert(reg.w == {field_prefix}_bm);\n")
        self.pop_indent()
        self.write("}\n")
