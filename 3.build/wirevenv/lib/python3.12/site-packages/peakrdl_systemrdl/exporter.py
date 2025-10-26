from typing import Union, TYPE_CHECKING

from systemrdl.node import AddrmapNode, RootNode, MemNode

from .rdl_generator import RDLGenerator

if TYPE_CHECKING:
    from systemrdl.messages import MessageHandler

class SystemRDLExporter:
    msg: "MessageHandler"

    def export(self, node: Union[AddrmapNode, RootNode], path: str) -> None:
        self.msg = node.env.msg

        # If it is the root node, skip to top addrmap
        if isinstance(node, RootNode):
            node = node.top

        if not isinstance(node, (AddrmapNode, MemNode)):
            raise TypeError("'node' argument expects type AddrmapNode or MemNode. Got '%s'" % type(node).__name__)

        with open(path, 'w', encoding='utf-8') as f:
            g = RDLGenerator()
            s = g.get_content(node)
            f.write(s)
