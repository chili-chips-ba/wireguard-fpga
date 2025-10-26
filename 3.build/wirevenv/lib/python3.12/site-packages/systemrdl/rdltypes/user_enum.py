from typing import Optional, Dict, Any, TYPE_CHECKING, List, Type, Generator
from collections import OrderedDict
import inspect
import copyreg

from ..core import rdlformatcode
from .. import component as comp

if TYPE_CHECKING:
    from markdown import Markdown


class UserEnumMemberContainer:
    """
    Container class used only when defining a new UserEnum.
    This shall only be used by importers.


    .. versionadded:: 1.24
    """
    def __init__(self, name: str, value: int, rdl_name: Optional[str] = None, rdl_desc: Optional[str] = None) -> None:
        self.name = name
        self.value = value
        self.rdl_name = rdl_name
        self.rdl_desc = rdl_desc

    def __hash__(self) -> int:
        return hash((self.name, self.value, self.rdl_name, self.rdl_desc))

class UserEnumMeta(type):
    """
    Metaclass for UserEnum
    """

    _member_map: Dict[str, 'UserEnum'] = {}
    _parent_scope: Optional[comp.Component] = None

    def __bool__(cls) -> bool:
        # classes/types should always be True.
        return True

    def __contains__(cls, obj: Any) -> bool:
        if not isinstance(obj, UserEnum):
            raise TypeError(
                f"unsupported operand type(s) for 'in': '{type(obj).__qualname__}' and '{cls.__class__.__qualname__}'"
            )
        return isinstance(obj, cls) and obj._name in cls._member_map

    def __getitem__(cls, name: str) -> 'UserEnum':
        return cls._member_map[name]

    def __iter__(cls) -> 'Generator[UserEnum, None, None]':
        return (member for member in cls._member_map.values())

    def __len__(cls) -> int:
        return len(cls._member_map)

    def __repr__(cls) -> str:
        return f"<UserEnum {cls.__name__}>"

    def __reversed__(cls) -> 'Generator[UserEnum, None, None]':
        """
        Returns members in reverse definition order.
        """
        return (member for member in reversed(cls._member_map.values()))

    @property
    def __members__(cls) -> Dict[str, 'UserEnum']:
        return cls._member_map

    @property
    def members(cls) -> Dict[str, 'UserEnum']:
        """
        Returns a mapping of member name->value.
        """
        return cls._member_map

    @property
    def type_name(cls) -> str:
        # (docstring is in rst)
        return cls.__name__


    def define_new(cls, name: str, members: List[UserEnumMemberContainer], _parent_scope: Optional[comp.Component]=None) -> Type['UserEnum']:
        """
        Define a new UserEnum class

        Parameters
        ----------
        name: str
            Name of the enum type
        members: UserEnumMemberContainer
            List of enum members


        .. versionadded:: 1.24
        """

        # Validate all member names and values are unique
        names = [m.name for m in members]
        values = [m.value for m in members]
        if len(names) != len(set(names)):
            raise ValueError("All members of an enum shall have unique names")
        if len(values) != len(set(values)):
            raise ValueError("All members of an enum shall have unique values")

        # Create the new class
        classdict: Dict[str, Any] = {
            '_member_map': OrderedDict(),
            '_parent_scope': _parent_scope,
        }
        metaclass = cls.__class__
        newcls = metaclass(name, (cls,), classdict)

        # populate enum members, which are each instances of the new class
        for m in members:
            enum_member = newcls(
                m.name, m.value, m.rdl_name, m.rdl_desc
            )
            newcls._member_map[m.name] = enum_member

        return newcls # type: ignore

    def get_parent_scope(cls) -> Optional[comp.Component]:
        """
        Returns reference to parent component that contains this type definition.
        """
        return cls._parent_scope

    def get_scope_path(cls, scope_separator: str="::") -> str:
        """
        Generate a string that represents this enum's declaration namespace
        scope.

        Parameters
        ----------
        scope_separator: str
            Override the separator between namespace scopes
        """
        parent_scope = cls.get_parent_scope() # pylint: disable=no-value-for-parameter
        if parent_scope is None:
            # Importer likely never set the scope
            return ""
        elif isinstance(parent_scope, comp.Root):
            # Declaration was in root scope
            return ""
        else:
            # Get parent definition's scope path
            parent_path = parent_scope.get_scope_path(scope_separator)

            # If parent scope exists, then its scope name is also guaranteed to
            # exist
            assert parent_scope._scope_name is not None

            # Extend it with its scope name
            if parent_path:
                return(
                    parent_path
                    + scope_separator
                    + parent_scope._scope_name
                )
            else:
                return parent_scope._scope_name

class UserEnum(metaclass=UserEnumMeta):
    """
    All user-defined enum types are extended from this class and can be
    identified using ``issubclass(obj, UserEnum)``. Enum members are instances
    of this class and can be identified using ``isinstance(obj, UserEnum)``.
    """

    def __init__(self, name: str, value: int, rdl_name: Optional[str], rdl_desc: Optional[str]) -> None:
        self._name = name
        self._value = value
        self._rdl_name = rdl_name
        self._rdl_desc = rdl_desc

    def __repr__(self) -> str:
        return "<%s.%s: %r>" % (
            self.__class__.__name__, self._name, self._value
        )

    def __str__(self) -> str:
        return "%s.%s" % (
            self.__class__.__name__, self._name
        )

    def __int__(self) -> int:
        return self.value

    def __bool__(self) -> bool:
        return bool(self.value)

    def __deepcopy__(self, memo: Dict[int, Any]) -> 'UserEnum':
        # Do not deepcopy enumerations
        return self

    @property
    def name(self) -> str:
        return self._name

    @property
    def value(self) -> int:
        return self._value

    @property
    def rdl_name(self) -> Optional[str]:
        """
        Enum entry's ``name`` property
        """
        return self._rdl_name

    @property
    def rdl_desc(self) -> Optional[str]:
        """
        Enum entry's ``desc`` property
        """
        return self._rdl_desc

    def get_html_desc(self, markdown_inst: Optional['Markdown']=None) -> Optional[str]:
        """
        Translates the enum's 'desc' property into HTML.

        Any RDLFormatCode tags used are converted to HTML.
        The text is also fed through a Markdown processor.

        The additional Markdown processing allows designers the choice to use a
        more modern lightweight markup language as an alternative to SystemRDL's
        "RDLFormatCode".

        Parameters
        ----------
        markdown_inst: ``markdown.Markdown``
            Override the class instance of the Markdown processor.
            See the `Markdown module <https://python-markdown.github.io/reference/#Markdown>`_
            for more details.

        Returns
        -------
        str or None
            HTML formatted string.
            If enum entry does not have a description, returns ``None``


        .. versionchanged:: 1.6
            Added ``markdown_inst`` option.
        """
        desc_str = self._rdl_desc
        if desc_str is None:
            return None
        return rdlformatcode.rdlfc_to_html(desc_str, md=markdown_inst)

    def get_html_name(self) -> Optional[str]:
        """
        Translates the enum's 'name' property into HTML.

        Any RDLFormatCode tags used are converted to HTML.

        Returns
        -------
        str or None
            HTML formatted string.
            If enum entry does not have an explicitly set name, returns ``None``


        .. versionadded:: 1.8
        """
        name_str = self._rdl_name
        if name_str is None:
            return None
        return rdlformatcode.rdlfc_to_html(name_str, is_desc=False)


# Tell pickle how to reduce dynamically generated UserEnum classes
def _reduce_user_enum(c: Type[UserEnum]) -> Any:
    if c is UserEnum:
        # Reached base class. Return string so pickle can look up the actual object
        return 'UserEnum'

    assert len(c.__bases__) == 1 # Only supporting single-inheritance
    base_cls: Type[UserEnum] = c.__bases__[0]

    # decompose members back into factory containers
    members = []
    for member in c.members.values():
        m = UserEnumMemberContainer(
            member._name, member._value, member._rdl_name, member._rdl_desc
        )
        members.append(m)

    args = (c.type_name, members, c._parent_scope)
    return (base_cls.define_new, args)
copyreg.pickle(UserEnumMeta, _reduce_user_enum) # type: ignore

# TODO: Once py3.7 is dropped, annotate this with TypeIs[Type[UserEnum]]
def is_user_enum(t: Any) -> bool:
    """
    Test if type ``t`` is a :class:`~UserEnum`

    .. note:: Returns false if ``t`` is referencing a UserEnum value member
    """
    return inspect.isclass(t) and issubclass(t, UserEnum)
