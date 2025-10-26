from typing import TYPE_CHECKING, List

from systemrdl.rdltypes import InterruptType

from .bases import NextStateConditional

if TYPE_CHECKING:
    from systemrdl.node import FieldNode


class Sticky(NextStateConditional):
    """
    Normal multi-bit sticky
    """
    comment = "multi-bit sticky"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            field.is_hw_writable
            and field.get_property('sticky')
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        I = self.exp.hwif.get_input_identifier(field)
        R = self.exp.field_logic.get_storage_identifier(field)
        return f"({R} == '0) && ({I} != '0)"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        I = self.exp.hwif.get_input_identifier(field)
        return [
            f"next_c = {I};",
            "load_next_c = '1;",
        ]


class Stickybit(NextStateConditional):
    """
    Normal stickybit
    """
    comment = "stickybit"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            field.is_hw_writable
            and field.get_property('stickybit')
            and field.get_property('intr type') in {None, InterruptType.level}
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        F = self.exp.hwif.get_input_identifier(field)
        if field.width == 1:
            return str(F)
        else:
            return f"{F} != '0"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        if field.width == 1:
            return [
                "next_c = '1;",
                "load_next_c = '1;",
            ]
        else:
            I = self.exp.hwif.get_input_identifier(field)
            R = self.exp.field_logic.get_storage_identifier(field)
            return [
                f"next_c = {R} | {I};",
                "load_next_c = '1;",
            ]

class PosedgeStickybit(NextStateConditional):
    """
    Positive edge stickybit
    """
    comment = "posedge stickybit"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            field.is_hw_writable
            and field.get_property('stickybit')
            and field.get_property('intr type') == InterruptType.posedge
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        I = self.exp.hwif.get_input_identifier(field)
        Iq = self.exp.field_logic.get_next_q_identifier(field)
        return f"(~{Iq} & {I}) != '0"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        if field.width == 1:
            return [
                "next_c = '1;",
                "load_next_c = '1;",
            ]
        else:
            I = self.exp.hwif.get_input_identifier(field)
            Iq = self.exp.field_logic.get_next_q_identifier(field)
            R = self.exp.field_logic.get_storage_identifier(field)
            return [
                f"next_c = {R} | (~{Iq} & {I});",
                "load_next_c = '1;",
            ]

class NegedgeStickybit(NextStateConditional):
    """
    Negative edge stickybit
    """
    comment = "negedge stickybit"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            field.is_hw_writable
            and field.get_property('stickybit')
            and field.get_property('intr type') == InterruptType.negedge
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        I = self.exp.hwif.get_input_identifier(field)
        Iq = self.exp.field_logic.get_next_q_identifier(field)
        return f"({Iq} & ~{I}) != '0"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        if field.width == 1:
            return [
                "next_c = '1;",
                "load_next_c = '1;",
            ]
        else:
            I = self.exp.hwif.get_input_identifier(field)
            Iq = self.exp.field_logic.get_next_q_identifier(field)
            R = self.exp.field_logic.get_storage_identifier(field)
            return [
                f"next_c = {R} | ({Iq} & ~{I});",
                "load_next_c = '1;",
            ]

class BothedgeStickybit(NextStateConditional):
    """
    edge-sensitive stickybit
    """
    comment = "bothedge stickybit"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            field.is_hw_writable
            and field.get_property('stickybit')
            and field.get_property('intr type') == InterruptType.bothedge
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        I = self.exp.hwif.get_input_identifier(field)
        Iq = self.exp.field_logic.get_next_q_identifier(field)
        return f"{Iq} != {I}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        if field.width == 1:
            return [
                "next_c = '1;",
                "load_next_c = '1;",
            ]
        else:
            I = self.exp.hwif.get_input_identifier(field)
            Iq = self.exp.field_logic.get_next_q_identifier(field)
            R = self.exp.field_logic.get_storage_identifier(field)
            return [
                f"next_c = {R} | ({Iq} ^ {I});",
                "load_next_c = '1;",
            ]
