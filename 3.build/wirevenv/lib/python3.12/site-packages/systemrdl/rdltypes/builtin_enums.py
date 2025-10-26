import enum
from typing import Any

class AutoNoValueEnum(enum.Enum):
    def __new__(cls) -> 'AutoNoValueEnum':
        value = len(cls.__members__) + 1
        obj = object.__new__(cls)
        obj._value_ = value
        return obj

    def __repr__(self) -> str:
        return f"<{self.__class__.__name__}.{self.name}>"

class BuiltinEnum(AutoNoValueEnum):
    pass

#===============================================================================
class AccessType(BuiltinEnum):
    #: Not Accessible
    na = ()

    #: Readable and writable
    rw = ()

    #: Read-only
    r = ()

    #: Write-only
    w = ()

    #: Readable and writable. After a reset occurs, can only be written once.
    rw1 = ()

    #: Write-only. After a reset occurs, can only be written once.
    w1 = ()

    def __add__(self, other: Any) -> 'AccessType':
        """
        Add operator combines AccessTypes into the more permissive superset of
        the two addends.

        For example: ``r + w --> rw``


        .. versionadded:: 1.23
        """
        if not isinstance(other, AccessType):
            raise TypeError(f"unsupported addend types: {repr(self)} + {repr(other)}")

        pair = {other, self}

        # addends are the same. No change
        if len(pair) == 1:
            return self

        # rw supersedes all others
        if AccessType.rw in pair:
            return AccessType.rw

        # na is superseded by all others
        if self == AccessType.na:
            return other
        if other == AccessType.na:
            return self

        if pair == {AccessType.r, AccessType.w}:
            return AccessType.rw
        if pair == {AccessType.r, AccessType.rw1}:
            return AccessType.rw1
        if pair == {AccessType.r, AccessType.w1}:
            return AccessType.rw1
        if pair == {AccessType.w, AccessType.rw1}:
            return AccessType.rw
        if pair == {AccessType.w, AccessType.w1}:
            return AccessType.w
        if pair == {AccessType.rw1, AccessType.w1}:
            return AccessType.rw1

        # unreachable
        raise RuntimeError


class OnReadType(BuiltinEnum):
    #: Cleared on read
    rclr = ()

    #: Set on read
    rset = ()

    #: User-defined read side-effect
    ruser = ()


class OnWriteType(BuiltinEnum):
    #: Bitwise write one to set
    woset = ()

    #: Bitwise write one to clear
    woclr = ()

    #: Bitwise write one to toggle
    wot = ()

    #: Bitwise write zero to set
    wzs = ()

    #: Bitwise write zero to clear
    wzc = ()

    #: Bitwise write zero to toggle
    wzt = ()

    #: All bits are cleared on write
    wclr = ()

    #: All bits are set on write
    wset = ()

    #: Write modification is user-defined
    wuser = ()


class AddressingType(BuiltinEnum):
    #: Components are packed tightly together
    compact = ()

    #: Components are packed so each component's start address is a multiple of its size
    regalign = ()

    #: Same as regalign, except arrays are aligned to their entire size
    fullalign = ()


class PrecedenceType(BuiltinEnum):
    #: Hardware writes take precedence over software
    hw = ()

    #: Software writes take precedence over hardware
    sw = ()


class InterruptType(BuiltinEnum):
    """
    A field's interrupt type is set when using an RDL interrupt property modifier:

    .. code-block:: systemrdl

        field f {
            negedge intr;
        };

    The modifier is stored in the internal "intr type" property. (note the
    intentional space in the name)

    It can be fetched the same way as other properties:

    .. code-block:: python

        intr_type = my_field_node.get_property('intr type')


    .. note::

        The ``nonsticky`` interrupt type is intentionally omitted from this
        enumeration since it is not really a distinct interrupt type. Its use in
        SystemRDL implies an assignment of ``stickybit = false``.
    """
    #: Interrupt when asserted and maintained
    level = ()

    #: Interrupt on low-to-high transition
    posedge = ()

    #: Interrupt on high-to-low transition
    negedge = ()

    #: Interrupt on any transition
    bothedge = ()
