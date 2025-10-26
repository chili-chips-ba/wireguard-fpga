from typing import TYPE_CHECKING, List

from .bases import NextStateUnconditional

if TYPE_CHECKING:
    from systemrdl.node import FieldNode

class Singlepulse(NextStateUnconditional):
    comment = "singlepulse clears back to 0"
    unconditional_explanation = "The 'singlepulse' property unconditionally clears a field when not written"

    def is_match(self, field: 'FieldNode') -> bool:
        return field.get_property('singlepulse')

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return [
            "next_c = '0;",
            "load_next_c = '1;",
        ]
