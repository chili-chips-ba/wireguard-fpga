from typing import TYPE_CHECKING, Union

from systemrdl.node import AddrmapNode, RegNode, FieldNode, SignalNode

from .storage_generator import WBufStorageStructGenerator
from .implementation_generator import WBufLogicGenerator
from ..utils import get_indexed_path
from ..sv_int import SVInt

if TYPE_CHECKING:
    from ..exporter import RegblockExporter


class WriteBuffering:
    def __init__(self, exp:'RegblockExporter'):
        self.exp = exp

    @property
    def top_node(self) -> 'AddrmapNode':
        return self.exp.ds.top_node


    def get_storage_struct(self) -> str:
        struct_gen = WBufStorageStructGenerator(self)
        s = struct_gen.get_struct(self.top_node, "wbuf_storage_t")
        assert s is not None
        return s + "\nwbuf_storage_t wbuf_storage;"


    def get_implementation(self) -> str:
        gen = WBufLogicGenerator(self)
        s = gen.get_content(self.top_node)
        assert s is not None
        return s

    def get_wbuf_prefix(self, node: Union[RegNode, FieldNode]) -> str:
        if isinstance(node, FieldNode):
            node = node.parent
        wbuf_prefix = "wbuf_storage." + get_indexed_path(self.top_node, node)
        return wbuf_prefix

    def get_write_strobe(self, node: Union[RegNode, FieldNode]) -> str:
        prefix = self.get_wbuf_prefix(node)
        return f"{prefix}.pending && {self.get_trigger(node)}"

    def get_raw_trigger(self, node: 'RegNode') -> Union[SVInt, str]:
        trigger = node.get_property('wbuffer_trigger')

        if isinstance(trigger, RegNode):
            # Trigger is a register.
            # trigger when uppermost address of the register is written
            regwidth = trigger.get_property('regwidth')
            accesswidth = trigger.get_property('accesswidth')
            strb_prefix = self.exp.dereferencer.get_access_strobe(trigger, reduce_substrobes=False)

            if accesswidth < regwidth:
                n_subwords = regwidth // accesswidth
                return f"{strb_prefix}[{n_subwords-1}] && decoded_req_is_wr"
            else:
                return f"{strb_prefix} && decoded_req_is_wr"
        elif isinstance(trigger, SignalNode):
            s = self.exp.dereferencer.get_value(trigger)
            if trigger.get_property('activehigh'):
                return s
            else:
                return f"~{s}"
        else:
            # Trigger is a field or propref bit
            return self.exp.dereferencer.get_value(trigger)

    def get_trigger(self, node: Union[RegNode, FieldNode]) -> Union[SVInt, str]:
        if isinstance(node, FieldNode):
            node = node.parent
        trigger = node.get_property('wbuffer_trigger')

        if isinstance(trigger, RegNode) and trigger == node:
            # register is its own trigger
            # use the delayed trigger signal
            return self.get_wbuf_prefix(node) + ".trigger_q"
        else:
            return self.get_raw_trigger(node)
