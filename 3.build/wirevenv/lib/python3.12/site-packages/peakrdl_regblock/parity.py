from typing import TYPE_CHECKING

from systemrdl.walker import WalkerAction


from .forloop_generator import RDLForLoopGenerator

if TYPE_CHECKING:
    from .exporter import RegblockExporter
    from systemrdl.node import FieldNode, AddressableNode


class ParityErrorReduceGenerator(RDLForLoopGenerator):
    def __init__(self, exp: 'RegblockExporter') -> None:
        super().__init__()
        self.exp = exp

    def get_implementation(self) -> str:
        content = self.get_content(self.exp.ds.top_node)
        if content is None:
            return ""
        return content

    def enter_AddressableComponent(self, node: 'AddressableNode') -> WalkerAction:
        super().enter_AddressableComponent(node)
        if node.external:
            return WalkerAction.SkipDescendants
        return WalkerAction.Continue

    def enter_Field(self, node: 'FieldNode') -> None:
        if node.get_property('paritycheck') and node.implements_storage:
            self.add_content(
                f"err |= {self.exp.field_logic.get_parity_error_identifier(node)};"
            )
