from typing import List, TYPE_CHECKING

from .hw_interrupts import (
    Sticky, Stickybit,
    PosedgeStickybit, NegedgeStickybit, BothedgeStickybit
)
from .hw_write import WEWrite, WELWrite

if TYPE_CHECKING:
    from systemrdl.node import FieldNode


class StickyWE(Sticky, WEWrite):
    """
    Normal multi-bit sticky with write enable
    """
    comment = "multi-bit sticky with WE"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            Sticky.is_match(self, field)
            and WEWrite.is_match(self, field)
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = Sticky.get_predicate(self, field)
        WE = WEWrite.get_predicate(self, field)
        return f"{BASE} && {WE}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return Sticky.get_assignments(self, field)

class StickyWEL(Sticky, WELWrite):
    """
    Normal multi-bit sticky with write enable low
    """
    comment = "multi-bit sticky with WEL"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            Sticky.is_match(self, field)
            and WELWrite.is_match(self, field)
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = Sticky.get_predicate(self, field)
        WEL = WELWrite.get_predicate(self, field)
        return f"{BASE} && {WEL}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return Sticky.get_assignments(self, field)

class StickybitWE(Stickybit, WEWrite):
    """
    Normal stickybiti with write enable
    """
    comment = "stickybit with WE"
    def is_match(self, field: 'FieldNode') -> bool:
        return (
            Stickybit.is_match(self, field)
            and WEWrite.is_match(self, field)
        )

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = Stickybit.get_predicate(self, field)
        WE = WEWrite.get_predicate(self, field)
        return f"{BASE} && {WE}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return Stickybit.get_assignments(self, field)

class StickybitWEL(Stickybit, WELWrite):
    """
    Normal stickybiti with write enable low
    """
    comment = "stickybit with WEL"
    def is_match(self, field: 'FieldNode') -> bool:
        return Stickybit.is_match(self, field) \
            and WELWrite.is_match(self, field)

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = Stickybit.get_predicate(self, field)
        WEL = WELWrite.get_predicate(self, field)
        return f"{BASE} && {WEL}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return Stickybit.get_assignments(self, field)

class PosedgeStickybitWE(PosedgeStickybit, WEWrite):
    """
    Positive edge stickybit with write enable
    """
    comment = "posedge stickybit with WE"
    def is_match(self, field: 'FieldNode') -> bool:
        return PosedgeStickybit.is_match(self, field) \
            and WEWrite.is_match(self, field)

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = PosedgeStickybit.get_predicate(self, field)
        WE = WEWrite.get_predicate(self, field)
        return f"{BASE} && {WE}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return PosedgeStickybit.get_assignments(self, field)

class PosedgeStickybitWEL(PosedgeStickybit, WELWrite):
    """
    Positive edge stickybit with write enable low
    """
    comment = "posedge stickybit with WEL"
    def is_match(self, field: 'FieldNode') -> bool:
        return PosedgeStickybit.is_match(self, field) \
            and WELWrite.is_match(self, field)

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = PosedgeStickybit.get_predicate(self, field)
        WEL = WELWrite.get_predicate(self, field)
        return f"{BASE} && {WEL}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return PosedgeStickybit.get_assignments(self, field)

class NegedgeStickybitWE(NegedgeStickybit, WEWrite):
    """
    Negative edge stickybit with write enable
    """
    comment = "negedge stickybit with WE"
    def is_match(self, field: 'FieldNode') -> bool:
        return NegedgeStickybit.is_match(self, field) \
            and WEWrite.is_match(self, field)

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = NegedgeStickybit.get_predicate(self, field)
        WE = WEWrite.get_predicate(self, field)
        return f"{BASE} && {WE}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return NegedgeStickybit.get_assignments(self, field)

class NegedgeStickybitWEL(NegedgeStickybit, WELWrite):
    """
    Negative edge stickybit with write enable low
    """
    comment = "negedge stickybit with WEL"
    def is_match(self, field: 'FieldNode') -> bool:
        return NegedgeStickybit.is_match(self, field) \
            and WELWrite.is_match(self, field)

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = NegedgeStickybit.get_predicate(self, field)
        WEL = WELWrite.get_predicate(self, field)
        return f"{BASE} && {WEL}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return NegedgeStickybit.get_assignments(self, field)

class BothedgeStickybitWE(BothedgeStickybit, WEWrite):
    """
    edge-sensitive stickybit with write enable
    """
    comment = "bothedge stickybit with WE"
    def is_match(self, field: 'FieldNode') -> bool:
        return BothedgeStickybit.is_match(self, field) \
            and WEWrite.is_match(self, field)

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = BothedgeStickybit.get_predicate(self, field)
        WE = WEWrite.get_predicate(self, field)
        return f"{BASE} && {WE}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return BothedgeStickybit.get_assignments(self, field)

class BothedgeStickybitWEL(BothedgeStickybit, WELWrite):
    """
    edge-sensitive stickybit with write enable low
    """
    comment = "bothedge stickybit with WEL"
    def is_match(self, field: 'FieldNode') -> bool:
        return BothedgeStickybit.is_match(self, field) \
            and WELWrite.is_match(self, field)

    def get_predicate(self, field: 'FieldNode') -> str:
        BASE = BothedgeStickybit.get_predicate(self, field)
        WEL = WELWrite.get_predicate(self, field)
        return f"{BASE} && {WEL}"

    def get_assignments(self, field: 'FieldNode') -> List[str]:
        return BothedgeStickybit.get_assignments(self, field)
