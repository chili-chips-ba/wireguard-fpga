from typing import Type, Union, TYPE_CHECKING

if TYPE_CHECKING:
    from .builtin_enums import BuiltinEnum
    from .user_enum import UserEnum
    from .references import PropertyReference, RefType
    from .user_struct import UserStruct
    from .array import ArrayedType
    from ..node import Node
    from .. import component as comp

# RDL Types the user will encounter via the public API
RDLValue = Union[
    int, bool, str, list,
    'BuiltinEnum', 'UserEnum', 'UserStruct', Type['UserEnum'],
    'Node', 'PropertyReference'
]

# RDL Types used internally prior to elaboration
PreElabRDLValue = Union[
    int, bool, str,
    'BuiltinEnum', 'UserEnum', 'UserStruct',
    'PropertyReference', 'comp.Component', 'RefType'
]

PreElabRDLType = Union[Type[PreElabRDLValue], 'ArrayedType']
