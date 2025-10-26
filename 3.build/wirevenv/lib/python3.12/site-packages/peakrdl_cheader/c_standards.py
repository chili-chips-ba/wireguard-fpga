from typing import Dict
import enum

class CStandard(enum.Enum):

    def __init__(self, name: str, d: Dict[str, bool]) -> None:
        self.anon_unions = d.get("anon_unions", False)
        self.static_assert = d.get("static_assert", False)
        self.static_assert_needs_assert_h = d.get("static_assert_needs_assert_h", False)

        # Prevent Enum from flattening members into aliases
        self._value_ = name

    gnu23 = "gnu23", {
        "anon_unions": True,
        "static_assert": True,
    }

    gnu17 = "gnu17", {
        "anon_unions": True,
        "static_assert": True,
        "static_assert_needs_assert_h": True,
    }

    gnu11 = "gnu11", {
        "anon_unions": True,
        "static_assert": True,
        "static_assert_needs_assert_h": True,
    }

    gnu99 = "gnu99", {
        "anon_unions": False,
        "static_assert": False,
        "static_assert_needs_assert_h": False,
    }

    gnu90 = "gnu90", {
        "anon_unions": False,
        "static_assert": False,
        "static_assert_needs_assert_h": False,
    }

    gnu89 = "gnu89", {
        "anon_unions": False,
        "static_assert": False,
        "static_assert_needs_assert_h": False,
    }

    latest = gnu17 # gnu23 is still unreleased
