
from systemrdl import RDLListener

class PreExportListener(RDLListener):
    def __init__(self, exporter):
        self.exporter = exporter

        # Max width in bits
        self.max_width_stack = []

    def enter_Addrmap(self, node):
        self.enter_group(node)

    def exit_Addrmap(self, node):
        self.exit_group(node)

    def enter_Regfile(self, node):
        self.enter_group(node)

    def exit_Regfile(self, node):
        self.exit_group(node)

    def enter_Reg(self, node):
        # Update max width in stack
        self.max_width_stack[-1] = max(node.get_property("accesswidth"), self.max_width_stack[-1])

    def enter_Mem(self, node):
        # Update max width in stack
        self.max_width_stack[-1] = max(node.get_property("memwidth"), self.max_width_stack[-1])


    def enter_group(self, node): # pylint: disable=unused-argument
        self.max_width_stack.append(0)

    def exit_group(self, node):
        max_width = self.max_width_stack.pop()

        # Register this node in the bus_width_db
        self.exporter.bus_width_db[node.get_path()] = max_width

        # Propagate max width to parent
        if self.max_width_stack:
            self.max_width_stack[-1] = max(max_width, self.max_width_stack[-1])
