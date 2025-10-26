from typing import TYPE_CHECKING, List

from .bases import NextStateConditional, NextStateUnconditional

if TYPE_CHECKING:
    from systemrdl.node import FieldNode


class AlwaysWrite(NextStateUnconditional):
    """
    hw writable, without any qualifying we/wel
    """
    comment = "HW Write"
    unconditional_explanation = "A hardware-writable field without a write-enable (we/wel) will always update the field value"

    def is_match(self, field: 'FieldNode') -> bool:
        return (
            field.is_hw_writable
            and not field.get_property('we')
            and not field.get_property('wel')
        )

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        hwmask = field.get_property('hwmask')
        hwenable = field.get_property('hwenable')
        I = str(self.exp.hwif.get_input_identifier(field))
        R = self.exp.field_logic.get_storage_identifier(field)
        if hwmask is not None:
            M = self.exp.dereferencer.get_value(hwmask)
            next_val = f"{I} & ~{M} | {R} & {M}"
        elif hwenable is not None:
            E = self.exp.dereferencer.get_value(hwenable)
            next_val = f"{I} & {E} | {R} & ~{E}"
        else:
            next_val = I

        return [
            f"next_c = {next_val};",
            "load_next_c = '1;",
        ]


class _QualifiedWrite(NextStateConditional):
    def get_assignments(self, field: 'FieldNode') -> List[str]:
        hwmask = field.get_property('hwmask')
        hwenable = field.get_property('hwenable')
        I = str(self.exp.hwif.get_input_identifier(field))
        R = self.exp.field_logic.get_storage_identifier(field)
        if hwmask is not None:
            M = self.exp.dereferencer.get_value(hwmask)
            next_val = f"{I} & ~{M} | {R} & {M}"
        elif hwenable is not None:
            E = self.exp.dereferencer.get_value(hwenable)
            next_val = f"{I} & {E} | {R} & ~{E}"
        else:
            next_val = I

        return [
            f"next_c = {next_val};",
            "load_next_c = '1;",
        ]

class WEWrite(_QualifiedWrite):
    comment = "HW Write - we"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            field.is_hw_writable
            and bool(field.get_property('we'))
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        prop = field.get_property('we')
        if isinstance(prop, bool):
            identifier = self.exp.hwif.get_implied_prop_input_identifier(field, "we")
        else:
            # signal or field
            identifier = str(self.exp.dereferencer.get_value(prop))
        return identifier

class WELWrite(_QualifiedWrite):
    comment = "HW Write - wel"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            field.is_hw_writable
            and bool(field.get_property('wel'))
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        prop = field.get_property('wel')
        if isinstance(prop, bool):
            identifier = self.exp.hwif.get_implied_prop_input_identifier(field, "wel")
        else:
            # signal or field
            identifier = str(self.exp.dereferencer.get_value(prop))
        return f"!{identifier}"
