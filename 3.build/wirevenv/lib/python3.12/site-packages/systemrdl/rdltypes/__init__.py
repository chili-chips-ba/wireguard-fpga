
from typing import Any, Optional, TYPE_CHECKING

from .builtin_enums import BuiltinEnum, AccessType, OnReadType, OnWriteType
from .builtin_enums import AddressingType, PrecedenceType, InterruptType

from .user_enum import UserEnumMemberContainer, UserEnum, is_user_enum

from .user_struct import UserStruct, is_user_struct

from .array import ArrayedType

from .references import ComponentRef, PropertyReference, RefType

if TYPE_CHECKING:
    from .typing import PreElabRDLType

#-------------------------------------------------------------------------------
def get_rdltype(value: Any) -> 'PreElabRDLType':
    """
    Given a value, return the type identifier object used within the RDL compiler
    If not a supported type, raises ValueError
    """

    if isinstance(value, (int, bool, str)):
        # Pass canonical types as-is
        return type(value)
    elif is_user_enum(type(value)):
        return type(value)
    elif is_user_struct(type(value)):
        return type(value)
    elif isinstance(value, BuiltinEnum):
        return type(value)
    elif isinstance(value, list):
        # Create ArrayedType representation
        # Determine element type and make sure it is uniform
        array_el_type: Optional[PreElabRDLType] = None

        for el in value:
            el_type = get_rdltype(el)
            if (array_el_type is not None) and (el_type != array_el_type):
                raise ValueError("Array literal is not of uniform type")
            array_el_type = el_type
        return ArrayedType(array_el_type)
    else:
        raise ValueError("Could not map to RDL type")


class NoValue:
    """
    Non-value token used for UDPs that were bound to a component, but not
    actually assigned a value.
    (15.2.1-c)
    """
