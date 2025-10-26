from typing import TYPE_CHECKING, List
import enum

from ..utils import get_indexed_path

if TYPE_CHECKING:
    from systemrdl.node import FieldNode

    from ..exporter import RegblockExporter

class AssignmentPrecedence(enum.IntEnum):
    """
    Enumeration of standard assignment precedence groups.
    Each value represents the precedence of a single conditional assignment
    category that determines a field's next state.

    Higher value denotes higher precedence

    Important: If inserting custom intermediate assignment rules, do not rely on the absolute
    value of the enumeration. Insert your rules relative to an existing precedence:
        FieldBuilder.add_hw_conditional(MyConditional, HW_WE + 1)
    """

    # Software access assignment groups
    SW_ONREAD = 5000
    SW_ONWRITE = 4000
    SW_SINGLEPULSE = 3000

    # Hardware access assignment groups
    HW_WRITE = 3000
    HWSET = 2000
    HWCLR  = 1000
    COUNTER_INCR_DECR = 0




class SVLogic:
    """
    Represents a SystemVerilog logic signal
    """
    def __init__(self, name: str, width: int, default_assignment: str) -> None:
        self.name = name
        self.width = width
        self.default_assignment = default_assignment

    def __eq__(self, o: object) -> bool:
        if not isinstance(o, SVLogic):
            return False

        return (
            o.name == self.name
            and o.width == self.width
            and o.default_assignment == self.default_assignment
        )


class NextStateConditional:
    """
    Describes a single conditional action that determines the next state of a field
    Provides information to generate the following content:
        if(<conditional>) begin
            <assignments>
        end
    """

    # Optional comment to emit next to the conditional
    comment = ""

    def __init__(self, exp:'RegblockExporter'):
        self.exp = exp

    def is_match(self, field: 'FieldNode') -> bool:
        """
        Returns True if this conditional is relevant to the field. If so,
        it instructs the FieldBuilder that Verilog for this conditional shall
        be emitted
        """
        raise NotImplementedError

    def get_field_path(self, field:'FieldNode') -> str:
        return get_indexed_path(self.exp.ds.top_node, field)

    def get_predicate(self, field: 'FieldNode') -> str:
        """
        Returns the rendered conditional text
        """
        raise NotImplementedError


    def get_assignments(self, field: 'FieldNode') -> List[str]:
        """
        Returns a list of rendered assignment strings
        This will basically always be two:
            <field>.next = <next value>
            <field>.load_next = '1;
        """
        raise NotImplementedError

    def get_extra_combo_signals(self, field: 'FieldNode') -> List[SVLogic]:
        """
        Return any additional combinational signals that this conditional
        will assign if present.
        """
        return []

class NextStateUnconditional(NextStateConditional):
    """
    Use this class if predicate can never evaluate to false.
    This will be generated as an 'else' clause, or a direct assignment
    """

    # Explanation text for use in error message about conflicts
    unconditional_explanation = ""
