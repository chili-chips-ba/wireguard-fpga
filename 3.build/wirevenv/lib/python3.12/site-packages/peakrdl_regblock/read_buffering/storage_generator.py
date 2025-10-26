from systemrdl.node import FieldNode, RegNode

from ..struct_generator import RDLStructGenerator

class RBufStorageStructGenerator(RDLStructGenerator):

    def enter_Field(self, node: FieldNode) -> None:
        # suppress parent class's field behavior
        pass

    def enter_Reg(self, node: RegNode) -> None:
        super().enter_Reg(node)

        if not node.get_property('buffer_reads'):
            return

        regwidth = node.get_property('regwidth')
        self.add_member("data", regwidth)
