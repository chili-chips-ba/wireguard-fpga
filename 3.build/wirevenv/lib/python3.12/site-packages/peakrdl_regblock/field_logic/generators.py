from typing import TYPE_CHECKING, List, Optional

from collections import OrderedDict

from systemrdl.walker import WalkerAction
from systemrdl.node import RegNode, RegfileNode, MemNode, AddrmapNode

from ..struct_generator import RDLStructGenerator
from ..forloop_generator import RDLForLoopGenerator
from ..utils import get_indexed_path, clog2
from ..identifier_filter import kw_filter as kwf
from .bases import NextStateUnconditional

if TYPE_CHECKING:
    from . import FieldLogic
    from systemrdl.node import FieldNode, AddressableNode
    from .bases import SVLogic

class CombinationalStructGenerator(RDLStructGenerator):

    def __init__(self, field_logic: 'FieldLogic'):
        super().__init__()
        self.field_logic = field_logic

    def enter_AddressableComponent(self, node: 'AddressableNode') -> Optional[WalkerAction]:
        super().enter_AddressableComponent(node)

        if node.external:
            return WalkerAction.SkipDescendants
        return WalkerAction.Continue

    def enter_Field(self, node: 'FieldNode') -> None:
        # If a field doesn't implement storage, it is not relevant here
        if not node.implements_storage:
            return

        # collect any extra combo signals that this field requires
        extra_combo_signals = OrderedDict() # type: OrderedDict[str, SVLogic]
        for conditional in self.field_logic.get_conditionals(node):
            for signal in conditional.get_extra_combo_signals(node):
                if signal.name in extra_combo_signals:
                    # Assert that subsequent declarations of the same signal
                    # are identical
                    assert signal == extra_combo_signals[signal.name]
                else:
                    extra_combo_signals[signal.name] = signal

        self.push_struct(kwf(node.inst_name))
        self.add_member("next", node.width)
        self.add_member("load_next")
        for signal in extra_combo_signals.values():
            self.add_member(signal.name, signal.width)
        if node.is_up_counter:
            self.add_up_counter_members(node)
        if node.is_down_counter:
            self.add_down_counter_members(node)
        if node.get_property('paritycheck'):
            self.add_member("parity_error")
        self.pop_struct()

    def add_up_counter_members(self, node: 'FieldNode') -> None:
        self.add_member('incrthreshold')
        if self.field_logic.counter_incrsaturates(node):
            self.add_member('incrsaturate')
        else:
            self.add_member('overflow')

    def add_down_counter_members(self, node: 'FieldNode') -> None:
        self.add_member('decrthreshold')
        if self.field_logic.counter_decrsaturates(node):
            self.add_member('decrsaturate')
        else:
            self.add_member('underflow')


class FieldStorageStructGenerator(RDLStructGenerator):

    def __init__(self, field_logic: 'FieldLogic') -> None:
        super().__init__()
        self.field_logic = field_logic

    def enter_AddressableComponent(self, node: 'AddressableNode') -> Optional[WalkerAction]:
        super().enter_AddressableComponent(node)

        if node.external:
            return WalkerAction.SkipDescendants
        return WalkerAction.Continue

    def enter_Field(self, node: 'FieldNode') -> None:
        self.push_struct(kwf(node.inst_name))

        if node.implements_storage:
            self.add_member("value", node.width)
            if node.get_property('paritycheck'):
                self.add_member("parity")

        if self.field_logic.has_next_q(node):
            self.add_member("next_q", node.width)

        self.pop_struct()


class FieldLogicGenerator(RDLForLoopGenerator):
    i_type = "genvar"
    def __init__(self, field_logic: 'FieldLogic') -> None:
        super().__init__()
        self.field_logic = field_logic
        self.exp = field_logic.exp
        self.ds = self.exp.ds
        self.field_storage_template = self.exp.jj_env.get_template(
            "field_logic/templates/field_storage.sv"
        )
        self.external_reg_template = self.exp.jj_env.get_template(
            "field_logic/templates/external_reg.sv"
        )
        self.external_block_template = self.exp.jj_env.get_template(
            "field_logic/templates/external_block.sv"
        )
        self.intr_fields = [] # type: List[FieldNode]
        self.halt_fields = [] # type: List[FieldNode]
        self.msg = self.ds.top_node.env.msg


    def enter_AddressableComponent(self, node: 'AddressableNode') -> Optional[WalkerAction]:
        super().enter_AddressableComponent(node)

        if node.external and not isinstance(node, RegNode):
            # Is an external block
            self.assign_external_block_outputs(node)

            # Do not recurse
            return WalkerAction.SkipDescendants

        return WalkerAction.Continue

    def enter_Reg(self, node: 'RegNode') -> Optional[WalkerAction]:
        self.intr_fields = []
        self.halt_fields = []

        if node.external:
            self.assign_external_reg_outputs(node)
            # Do not recurse to fields
            return WalkerAction.SkipDescendants

        return WalkerAction.Continue


    def enter_Field(self, node: 'FieldNode') -> None:
        if node.implements_storage:
            self.generate_field_storage(node)

        self.assign_field_outputs(node)

        if node.get_property('intr'):
            self.intr_fields.append(node)
            if node.get_property('haltenable') or node.get_property('haltmask'):
                self.halt_fields.append(node)


    def exit_Reg(self, node: 'RegNode') -> None:
        # Assign register's intr output
        if self.intr_fields:
            strs = []
            for field in self.intr_fields:
                enable = field.get_property('enable')
                mask = field.get_property('mask')
                F = self.exp.dereferencer.get_value(field)
                if enable:
                    E = self.exp.dereferencer.get_value(enable)
                    s = f"|({F} & {E})"
                elif mask:
                    M = self.exp.dereferencer.get_value(mask)
                    s = f"|({F} & ~{M})"
                else:
                    s = f"|{F}"
                strs.append(s)

            self.add_content(
                f"assign {self.exp.hwif.get_implied_prop_output_identifier(node, 'intr')} ="
            )
            self.add_content(
                "    "
                + "\n    || ".join(strs)
                + ";"
            )

        # Assign register's halt output
        if self.halt_fields:
            strs = []
            for field in self.halt_fields:
                enable = field.get_property('haltenable')
                mask = field.get_property('haltmask')
                F = self.exp.dereferencer.get_value(field)
                if enable:
                    E = self.exp.dereferencer.get_value(enable)
                    s = f"|({F} & {E})"
                elif mask:
                    M = self.exp.dereferencer.get_value(mask)
                    s = f"|({F} & ~{M})"
                else:
                    s = f"|{F}"
                strs.append(s)

            self.add_content(
                f"assign {self.exp.hwif.get_implied_prop_output_identifier(node, 'halt')} ="
            )
            self.add_content(
                "    "
                + "\n    || ".join(strs)
                + ";"
            )


    def generate_field_storage(self, node: 'FieldNode') -> None:
        conditionals = self.field_logic.get_conditionals(node)
        extra_combo_signals = OrderedDict()
        unconditional: Optional[NextStateUnconditional] = None
        new_conditionals = []
        for conditional in conditionals:
            for signal in conditional.get_extra_combo_signals(node):
                extra_combo_signals[signal.name] = signal

            if isinstance(conditional, NextStateUnconditional):
                if unconditional is not None:
                    # Too inconvenient to validate this early. Easier to validate here in-place generically
                    self.msg.fatal(
                        "Field has multiple conflicting properties that unconditionally set its state:\n"
                        f"  * {conditional.unconditional_explanation}\n"
                        f"  * {unconditional.unconditional_explanation}",
                        node.inst.inst_src_ref
                    )
                unconditional = conditional
            else:
                new_conditionals.append(conditional)
        conditionals = new_conditionals

        resetsignal = node.get_property('resetsignal')

        reset_value = node.get_property('reset')
        if reset_value is not None:
            reset_value_str = self.exp.dereferencer.get_value(reset_value, node.width)
        else:
            # 5.9.1-g: If no reset value given, the field is not reset, even if it has a resetsignal.
            reset_value_str = None
            resetsignal = None

        context = {
            'node': node,
            'reset': reset_value_str,
            'field_logic': self.field_logic,
            'extra_combo_signals': extra_combo_signals,
            'conditionals': conditionals,
            'unconditional': unconditional,
            'resetsignal': resetsignal,
            'get_always_ff_event': self.exp.dereferencer.get_always_ff_event,
            'get_value': self.exp.dereferencer.get_value,
            'get_resetsignal': self.exp.dereferencer.get_resetsignal,
            'get_input_identifier': self.exp.hwif.get_input_identifier,
            'ds': self.ds,
        }
        self.add_content(self.field_storage_template.render(context))


    def assign_field_outputs(self, node: 'FieldNode') -> None:
        # Field value output
        if self.exp.hwif.has_value_output(node):
            output_identifier = self.exp.hwif.get_output_identifier(node)
            value = self.exp.dereferencer.get_value(node)
            self.add_content(
                f"assign {output_identifier} = {value};"
            )

        # Inferred logical reduction outputs
        if node.get_property('anded'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "anded")
            value = self.exp.dereferencer.get_field_propref_value(node, "anded")
            self.add_content(
                f"assign {output_identifier} = {value};"
            )
        if node.get_property('ored'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "ored")
            value = self.exp.dereferencer.get_field_propref_value(node, "ored")
            self.add_content(
                f"assign {output_identifier} = {value};"
            )
        if node.get_property('xored'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "xored")
            value = self.exp.dereferencer.get_field_propref_value(node, "xored")
            self.add_content(
                f"assign {output_identifier} = {value};"
            )

        # Software access strobes
        if node.get_property('swmod'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "swmod")
            value = self.field_logic.get_swmod_identifier(node)
            self.add_content(
                f"assign {output_identifier} = {value};"
            )
        if node.get_property('swacc'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "swacc")
            value = self.field_logic.get_swacc_identifier(node)
            self.add_content(
                f"assign {output_identifier} = {value};"
            )
        if node.get_property('rd_swacc'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "rd_swacc")
            value = self.field_logic.get_rd_swacc_identifier(node)
            self.add_content(
                f"assign {output_identifier} = {value};"
            )
        if node.get_property('wr_swacc'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "wr_swacc")
            value = self.field_logic.get_wr_swacc_identifier(node)
            self.add_content(
                f"assign {output_identifier} = {value};"
            )

        # Counter thresholds
        if node.get_property('incrthreshold') is not False: # (explicitly not False. Not 0)
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "incrthreshold")
            value = self.field_logic.get_field_combo_identifier(node, 'incrthreshold')
            self.add_content(
                f"assign {output_identifier} = {value};"
            )
        if node.get_property('decrthreshold') is not False: # (explicitly not False. Not 0)
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "decrthreshold")
            value = self.field_logic.get_field_combo_identifier(node, 'decrthreshold')
            self.add_content(
                f"assign {output_identifier} = {value};"
            )

        # Counter events
        if node.get_property('overflow'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "overflow")
            value = self.field_logic.get_field_combo_identifier(node, 'overflow')
            self.add_content(
                f"assign {output_identifier} = {value};"
            )
        if node.get_property('underflow'):
            output_identifier = self.exp.hwif.get_implied_prop_output_identifier(node, "underflow")
            value = self.field_logic.get_field_combo_identifier(node, 'underflow')
            self.add_content(
                f"assign {output_identifier} = {value};"
            )


    def assign_external_reg_outputs(self, node: 'RegNode') -> None:
        prefix = "hwif_out." + get_indexed_path(self.exp.ds.top_node, node)
        strb = self.exp.dereferencer.get_access_strobe(node)

        width = min(self.exp.cpuif.data_width, node.get_property('regwidth'))
        if width != self.exp.cpuif.data_width:
            bslice = f"[{width - 1}:0]"
        else:
            bslice = ""

        context = {
            "has_sw_writable": node.has_sw_writable,
            "has_sw_readable": node.has_sw_readable,
            "prefix": prefix,
            "strb": strb,
            "bslice": bslice,
            "retime": self.ds.retime_external_reg,
            'get_always_ff_event': self.exp.dereferencer.get_always_ff_event,
            "get_resetsignal": self.exp.dereferencer.get_resetsignal,
            "resetsignal": self.exp.ds.top_node.cpuif_reset,
        }
        self.add_content(self.external_reg_template.render(context))

    def assign_external_block_outputs(self, node: 'AddressableNode') -> None:
        prefix = "hwif_out." + get_indexed_path(self.exp.ds.top_node, node)
        strb = self.exp.dereferencer.get_external_block_access_strobe(node)
        addr_width = clog2(node.size)

        retime = False
        if isinstance(node, RegfileNode):
            retime = self.ds.retime_external_regfile
        elif isinstance(node, MemNode):
            retime = self.ds.retime_external_mem
        elif isinstance(node, AddrmapNode):
            retime = self.ds.retime_external_addrmap

        context = {
            "prefix": prefix,
            "strb": strb,
            "addr_width": addr_width,
            "retime": retime,
            'get_always_ff_event': self.exp.dereferencer.get_always_ff_event,
            "get_resetsignal": self.exp.dereferencer.get_resetsignal,
            "resetsignal": self.exp.ds.top_node.cpuif_reset,
        }
        self.add_content(self.external_block_template.render(context))
