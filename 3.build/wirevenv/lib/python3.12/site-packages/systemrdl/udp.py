from typing import TYPE_CHECKING, Any, Set, Type, Optional
import re

from . import component as comp

if TYPE_CHECKING:
    from .compiler import RDLEnvironment
    from .node import Node
    from .messages import MessageHandler
    from .source_ref import SourceRefBase

class UDPDefinition:
    """
    UDP definition descriptor class.
    """

    #: User-defined property name
    name: str = ""

    #: Set of :class:`~systemrdl.component.Component` types the UDP can be bound to.
    #: By default, the UDP can be bound to all components.
    valid_components: Set[Type[comp.Component]] = {
        comp.Field,
        comp.Reg,
        comp.Regfile,
        comp.Addrmap,
        comp.Mem,
        comp.Signal,
        # TODO: constraint,
    }

    #: Data type of the assignment value that this UDP will enforce.
    #: If this is a reference, either specify the specific component type class
    #: (eg. :class:`~systemrdl.component.Field`), or the generic representation
    #: of all references: :class:`~systemrdl.rdltypes.references.RefType`
    valid_type: Any = None

    #: Specifies the value assigned if a value is not specified when the UDP is bound to a component.
    #: Value must be compatible with ``valid_type``
    default_assignment: Any = None

    #: If set to True, enables a validation check that enforces that the
    #: assigned value of the property shall not have a value of 1 for any
    #: bit beyond the width of the field.
    #: This can only be used if ``valid_type`` is ``int``
    constr_componentwidth: bool = False

    def __init__(self, env: 'RDLEnvironment') -> None:
        self.env = env

        # validate a few things
        if not re.fullmatch(r"[a-z_]\w*", self.name, re.IGNORECASE):
            raise ValueError(f"Invalid UDP name '{self.name}'")
        if not isinstance(self.valid_components, set):
            raise TypeError(f"UDP {self.name}'s 'valid_components' property shall be a set")
        if self.valid_type is None:
            raise ValueError(f"UDP {self.name}'s 'valid_type' property was not defined")
        if self.constr_componentwidth and self.valid_type != int:
            raise ValueError("'constr_componentwidth' can only be true if UDP is of integer type")

    @property
    def msg(self) -> 'MessageHandler':
        """
        Reference to the compiler's message handler.
        Use this to emit error messages from within :meth:`validate()`.
        """
        return self.env.msg

    def get_src_ref(self, node: 'Node') -> Optional['SourceRefBase']:
        """
        Get the src_ref object for this property assignment.

        This function is useful when emitting error messages from within :meth:`validate()`.
        """
        return node.property_src_ref.get(self.name, node.inst_src_ref)

    def validate(self, node: 'Node', value: Any) -> None:
        """
        Optional user-defined validation function.

        This function is called after design elaboration on every assignment
        of the user defined property. This provides a mechanism to further
        validate the value assigned to your user-defined property.

        If the user-assigned value fails your validation test, be sure to flag
        it as an error as follows:

        .. code-block:: python

            self.msg.error("My error message", self.get_src_ref(node))
        """

    def get_unassigned_default(self, node: 'Node') -> Any:
        # pylint: disable=unused-argument
        """
        According to the SystemRDL spec, if a user-defined property is not explicitly
        assigned, then it does not get bound with any implied default value.

        For convenience to developers, this callback allows you to specify an implied
        default value if the UDP was never explicitly assigned.
        This only affects the behavior of :meth:`Node.get_property()` and does not
        change the semantics of how SystemRDL is interpreted during compilation.
        """

        # If a user-defined property is not explicitly assigned, then it
        # does not get bound with its default value
        return None
