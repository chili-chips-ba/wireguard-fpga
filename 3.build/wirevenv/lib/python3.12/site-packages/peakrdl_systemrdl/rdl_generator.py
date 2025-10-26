from typing import TYPE_CHECKING, Type

from systemrdl.walker import RDLListener, RDLWalker
from systemrdl import rdltypes

from .definition_generator import DefinitionGenerator
from .stringify import stringify_rdl_value

if TYPE_CHECKING:
    from systemrdl.node import AddressableNode
    from systemrdl.node import AddrmapNode, RegfileNode, RegNode, FieldNode, Node, MemNode, SignalNode

class RDLGenerator(DefinitionGenerator, RDLListener):
    def get_content(self, node: 'Node') -> str:

        if node.type_name is not None:
            type_name = node.type_name
        else:
            type_name = node.inst_name

        self.start("addrmap", type_name)
        self.assign_properties(node)

        walker = RDLWalker(skip_not_present=False)
        walker.walk(node, self, skip_top=True)

        return self.finish()

    def assign_properties(self, node: 'Node') -> None:
        """
        - exclude 'reset' values that are integer
        """
        for prop_name in node.list_properties():
            value = node.get_property(prop_name)
            if prop_name == "reset" and isinstance(value, int):
                continue

            value_s = stringify_rdl_value(value)
            self.add_content(f"{prop_name} = {value_s};")

    def define_enum(self, enum: Type[rdltypes.UserEnum])-> None:
        self.push(f"enum {enum.type_name}", "")
        for identifier, member in enum.members.items():
            if member.rdl_name or member.rdl_desc:
                self.add_content(f"{identifier} = {member.value} {{")
                if member.rdl_name:
                    self.add_content(f"    name = {stringify_rdl_value(member.rdl_name)};")
                if member.rdl_desc:
                    self.add_content(f"    desc = {stringify_rdl_value(member.rdl_desc)};")
                self.add_content("};")
            else:
                self.add_content(f"{identifier} = {member.value};")
        self.pop()


    def get_addressable_assignment(self, node: 'AddressableNode') -> str:
        a = f" @ 0x{node.raw_address_offset:X}"
        if node.is_array:
            a += f" += 0x{node.array_stride:X}"
        return a

    def enter_Addrmap(self, node: 'AddrmapNode') -> None:
        suffix = self.get_addressable_assignment(node)
        self.push("addrmap", node.inst_name, node.array_dimensions, suffix)
        self.assign_properties(node)

    def enter_Regfile(self, node: 'RegfileNode') -> None:
        suffix = self.get_addressable_assignment(node)
        self.push("regfile", node.inst_name, node.array_dimensions, suffix, node.external)
        self.assign_properties(node)

    def enter_Mem(self, node: 'MemNode') -> None:
        suffix = self.get_addressable_assignment(node)
        self.push("mem", node.inst_name, node.array_dimensions, suffix, True)
        self.assign_properties(node)

    def enter_Reg(self, node: 'RegNode') -> None:
        suffix = self.get_addressable_assignment(node)
        self.push("reg", node.inst_name, node.array_dimensions, suffix, node.external)
        self.assign_properties(node)

    def enter_Field(self, node: 'FieldNode') -> None:
        suffix = f"[{node.msb}:{node.lsb}]"
        reset = node.get_property('reset')
        if isinstance(reset, int):
            suffix += f" = 0x{reset:X}"

        self.push("field", node.inst_name, suffix=suffix, is_external=node.external)

        encode = node.get_property('encode')
        if encode is not None:
            self.define_enum(encode)

        self.assign_properties(node)

    def enter_Signal(self, node: 'SignalNode') -> None:
        self.push("signal", node.inst_name)
        self.assign_properties(node)

    def exit_Component(self, node: 'Node') -> None:
        self.pop()
