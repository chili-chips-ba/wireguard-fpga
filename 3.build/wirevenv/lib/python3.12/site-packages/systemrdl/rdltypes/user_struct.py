from typing import Optional, Dict, Any, Type, TYPE_CHECKING
from collections import OrderedDict
import inspect
import copyreg

from .. import component as comp

if TYPE_CHECKING:
    from .typing import PreElabRDLType

UserStructMembers = Dict[str, 'PreElabRDLType']


class UserStructMeta(type):
    """
    Declare a metaclass for UserStruct so that it can be uniquely identified
    during dynamic type pickling
    """
    _members: UserStructMembers = OrderedDict()
    _is_abstract: bool = True
    _parent_scope: Optional[comp.Component] = None

    def define_new(
        cls,
        name: str,
        members: UserStructMembers,
        is_abstract: bool=False,
        _parent_scope: Optional[comp.Component]=None
    ) -> Type['UserStruct']:
        """
        Define a new struct type derived from the current type.

        Parameters
        ----------
        name: str
            Name of the struct type
        members: {member_name : type}
            Dictionary of struct member types.
        is_abstract: bool
            If set, marks the struct as abstract.
        """

        # Extend the base struct's members
        m = OrderedDict(cls._members)
        # Make sure derivation does not have any overlapping keys with its parent
        if set(m.keys()) & set(members.keys()):
            raise ValueError("'members' contains keys that overlap with parent")
        m.update(members)

        # Create the new class
        classdict = {
            '_members' : m,
            '_is_abstract': is_abstract,
            '_parent_scope': _parent_scope,
        }
        metaclass = cls.__class__
        return metaclass(name, (cls,), classdict) # type: ignore

    @property
    def type_name(cls) -> str:
        # (docstring is in rst)
        return cls.__name__


class UserStruct(metaclass=UserStructMeta):
    """
    All user-defined struct types are extended from this class and can be
    identified using ``issubclass(obj, UserStruct)``. Once assigned a value,
    the class is constructed and is identified using ``isinstance(obj, UserStruct)``.

    Values of struct members are accessed as read-only object attributes.

    For example, the following RDL struct literal:

    .. code-block:: systemrdl

        struct my_struct {
            longint foo;
            longint bar;
        };
        ...
        my_struct_prop = my_struct'{foo:42, bar:123};

    ... can be queried in Python as follows:

    .. code-block:: python

        prop = node.get_property('my_struct_prop')

        foo = prop.foo
        bar = getattr(prop, "bar")

    Or UserStruct members names can be accessed as a mapping:

    .. code-block:: python

        for member_name, value in prop.members.items():
            ...
    """

    def __init__(self, values: Dict[str, Any]) -> None:
        """
        Create an instance of the struct

        values is a dictionary of {member_name : value}
        """
        if self._is_abstract:
            raise TypeError("Cannot create instance of an abstract struct type")

        # Make sure values dict matches the members allowed
        if set(values.keys()) != set(self._members.keys()):
            raise ValueError("Cannot map 'values' to this struct")

        self._values = values


    def __getattr__(self, name: str) -> Any:
        if name == "__setstate__":
            raise AttributeError(name)
        if name == "type_name":
            # getattr interferes with class property mechanism
            return type(self).type_name
        if name in self._values:
            return self._values[name]
        else:
            raise AttributeError("'%s' object has no attribute '%s'" % (self.type_name, name))


    @property
    def members(self) -> Dict[str, Any]:
        """
        Get a dictionary of struct members


        .. versionadded:: 1.24
        """
        return self._values

    @classmethod
    def get_parent_scope(cls) -> Optional[comp.Component]:
        """
        Returns reference to parent component that contains this type definition.
        """
        return getattr(cls, "_parent_scope", None)

    @classmethod
    def get_scope_path(cls, scope_separator: str="::") -> str:
        """
        Generate a string that represents this enum's declaration namespace
        scope.

        Parameters
        ----------
        scope_separator: str
            Override the separator between namespace scopes
        """
        parent_scope = cls.get_parent_scope()
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

    def __repr__(self) -> str:
        return "<struct '%s' %s at 0x%x>" % (
            self.__class__.__qualname__,
            "(%s)" % ", ".join(self._members.keys()),
            id(self)
        )


# Tell pickle how to reduce dynamically generated UserStruct classes
def _reduce_user_struct(c: Type[UserStruct]) -> Any:
    if c is UserStruct:
        # Reached base class. Return string so pickle can look up the actual object
        return 'UserStruct'

    assert len(c.__bases__) == 1 # Only supporting single-inheritance
    base_cls: Type[UserStruct] = c.__bases__[0]

    # remove members that exist in base class
    unique_members = c._members.copy()
    for k in base_cls._members.keys():
        del unique_members[k]

    args = (c.type_name, unique_members, c._is_abstract, c._parent_scope)
    return (base_cls.define_new, args)
copyreg.pickle(UserStructMeta, _reduce_user_struct) # type: ignore

# Utility functions
# TODO: Once py3.7 is dropped, annotate this with TypeIs[Type[UserStruct]]
def is_user_struct(t: Any) -> bool:
    """
    Test if type ``t`` is a :class:`~UserStruct`
    """
    return inspect.isclass(t) and issubclass(t, UserStruct)
