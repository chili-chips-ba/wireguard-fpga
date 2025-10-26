from typing import Any, TYPE_CHECKING, Optional

if TYPE_CHECKING:
    from .typing import PreElabRDLType

class ArrayedType():
    """
    Placeholder class to describe array types

    Once elaborated, arrays are converted to Python lists
    In the meantime, this placeholder is used to communicate expected type
    information during compilation type checking.

    If element_type is None, then the array being represented is empty, and
    therefore its element type is indeterminate
    """
    def __init__(self, element_type: Optional['PreElabRDLType']):
        self.element_type = element_type

    def __eq__(self, other: Any) -> bool:
        if isinstance(other, ArrayedType):
            return self.element_type == other.element_type
        else:
            return NotImplemented
