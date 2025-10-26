from typing import TYPE_CHECKING, Union

from systemrdl.node import AddrmapNode, RegNode, SignalNode

from .storage_generator import RBufStorageStructGenerator
from .implementation_generator import RBufLogicGenerator
from ..utils import get_indexed_path
from ..sv_int import SVInt

if TYPE_CHECKING:
    from ..exporter import RegblockExporter


class ReadBuffering:
    def __init__(self, exp:'RegblockExporter'):
        self.exp = exp

    @property
    def top_node(self) -> 'AddrmapNode':
        return self.exp.ds.top_node

    def get_storage_struct(self) -> str:
        struct_gen = RBufStorageStructGenerator()
        s = struct_gen.get_struct(self.top_node, "rbuf_storage_t")
        assert s is not None
        return s + "\nrbuf_storage_t rbuf_storage;"

    def get_implementation(self) -> str:
        gen = RBufLogicGenerator(self)
        s = gen.get_content(self.top_node)
        assert s is not None
        return s

    def get_trigger(self, node: RegNode) -> str:
        trigger = node.get_property('rbuffer_trigger')

        if isinstance(trigger, RegNode):
            # Trigger is a register.
            # trigger when lowermost address of the register is written
            regwidth = trigger.get_property('regwidth')
            accesswidth = trigger.get_property('accesswidth')
            strb_prefix = self.exp.dereferencer.get_access_strobe(trigger, reduce_substrobes=False)

            if accesswidth < regwidth:
                return f"{strb_prefix}[0] && !decoded_req_is_wr"
            else:
                return f"{strb_prefix} && !decoded_req_is_wr"
        elif isinstance(trigger, SignalNode):
            s = self.exp.dereferencer.get_value(trigger)
            if trigger.get_property('activehigh'):
                return str(s)
            else:
                return f"~{s}"
        else:
            # Trigger is a field or propref bit
            return str(self.exp.dereferencer.get_value(trigger))

    def get_rbuf_data(self, node: RegNode) -> str:
        return "rbuf_storage." + get_indexed_path(self.top_node, node) + ".data"
