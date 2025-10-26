from typing import Tuple, List, Optional, Type, TYPE_CHECKING, Any
import copy

from ..node import Node, AddressableNode
from .. import component as comp
from .user_struct import UserStruct, is_user_struct

if TYPE_CHECKING:
    from ..source_ref import SourceRefBase
    from ..compiler import RDLEnvironment


RefElement = Tuple[str, List[int], Optional['SourceRefBase']]

class ComponentRef:
    """
    Container for hierarchical component instance references.
    This is used internally to store information about the reference
    When a user requests the reference value, it is resolved into a Node object
    """

    def __init__(self, ref_root: 'comp.Component', ref_elements: List[RefElement]) -> None:
        # Handle to the component definition where ref_elements is relative to
        # This is the original_def, and NOT the actual instance
        self.ref_root = ref_root

        # List of hierarchical reference element tuples that make up the path
        # to the reference.
        # Path is relative to the instance of ref_root
        # Each tuple in the list represents a segment of the path:
        # [
        #   ( <ID string> , [ <Index int> , ... ], SourceRefBase ),
        # ]
        self.ref_elements = ref_elements

    def build_node_ref(self, assignee_node: Node) -> Node:
        """
        Resolves the component reference into a Node object
        """
        current_node = assignee_node
        # Traverse up from assignee until ref_root is reached
        while True:
            if current_node.inst.original_def is self.ref_root:
                break
            if current_node.parent is None:
                raise RuntimeError("Upwards traverse to ref_root failed")
            current_node = current_node.parent

        for inst_name, idx_list, name_src_ref in self.ref_elements:
            # find instance
            node = current_node.get_child_by_name(inst_name)
            assert node is not None # Guaranteed to be found
            current_node = node

            # Check if indexes are valid
            if idx_list:
                # Reference contains one or more suffixes
                # Validation during compilation would have already enforced that
                # references are sane.

                # Safe to expect this to be an AddressableNode
                assert isinstance(current_node, AddressableNode)

                # If idx_list is not empty, guaranteed to be an array node
                assert current_node.array_dimensions is not None

                for i, idx in enumerate(idx_list):
                    if idx >= current_node.array_dimensions[i]:
                        current_node.env.msg.fatal(
                            "Array index out of range. Expected 0-%d, got %d."
                            % (current_node.array_dimensions[i]-1, idx),
                            name_src_ref
                        )

                # Assign indexes if appropriate
                if current_node.is_array:
                    current_node.current_idx = idx_list

        return current_node


class PropertyReference:
    """
    Base class for all property references used in RHS of an expression.

    The PropertyReference object represents the expression's reference target.
    Details of the reference can be determined using its ``node`` and ``name``
    variables.

    For example, the following property assignment:

    .. code-block:: systemrdl

        reg {
            ...
            fieldX->next = fieldY->intr;
        } my_reg;

    ... can be queried as follows:

    .. code-block:: python

        fieldX = my_reg.get_child_by_name("fieldX")
        fieldY = my_reg.get_child_by_name("fieldY")

        next_prop = fieldX.get_property('next')
        print(next_prop.node == fieldY) # prints: True
        print(next_prop.name) # prints: "intr"

    """
    allowed_inst_type: Type[comp.Component]

    def __init__(self, src_ref: Optional['SourceRefBase'], env: 'RDLEnvironment', comp_ref: ComponentRef) -> None:
        self.env = env
        self.src_ref = src_ref
        self._comp_ref = comp_ref

        #: Node object that represents the component instance from which the
        #: property is being referenced.
        self.node: Node

        self._name = self.get_name()

    def __repr__(self) -> str:
        return f"<{self.__class__.__qualname__} {self.node.get_path()}->{self.name} at {id(self):#x}>"

    def __eq__(self, other: object) -> bool:
        """
        Property reference equality checks determine whether the other object
        represents the same reference (node represents the same position in the
        register model's hierarchy and the property referenced is the same)
        """
        if not isinstance(other, PropertyReference):
            return NotImplemented
        if self.name != other.name:
            return False
        return self.node.get_path() == other.node.get_path()

    @property
    def name(self) -> str:
        """
        Name of the property being referenced
        """
        return self._name

    @classmethod
    def get_name(cls) -> str:
        return cls.__name__.replace("PropRef_", "")

    def _resolve_node(self, assignee_node: Node) -> None:
        self.node = self._comp_ref.build_node_ref(assignee_node)

    def get_resolved_ref(self, assignee_node: Node) -> 'PropertyReference':
        # Return a copy of this PropertyReference, but with a resolved
        # node reference.
        # Copying is essential to prevent quirk found in bug #164
        new_prop_ref = copy.copy(self)
        new_prop_ref._resolve_node(assignee_node)
        return new_prop_ref

    def _validate(self) -> None:
        pass

    @property
    def width(self) -> Optional[int]:
        """
        Get the equivalent width of the property reference.

        Returns None if reference doesn't have a specifically defined width

        .. versionadded:: 1.21
        """
        raise NotImplementedError


class RefType:
    """
    This class it not a true RDL type, but rather an object that represents
    all possible RHS references that can be made. This represents all possible
    component references, as well as RHS property references.

    This is used primarily when pre-registering a UDP that has the generic
    'ref' datatype.

    .. versionadded:: 1.25
    """

    expanded = (
        comp.Field,
        comp.Signal,
        comp.Reg,
        comp.Regfile,
        comp.Addrmap,
        comp.Mem,
        PropertyReference,
        # TODO: eventually add constraint references
    )


def resolve_node_refs_in_array(assignee_node: Node, array: List[Any]) -> List[Any]:
    """
    Recursively converts any ComponentRef within the array to proper Node objects
    """
    new_array = []
    changed = False
    for value in array:
        if isinstance(value, ComponentRef):
            value = value.build_node_ref(assignee_node)
            changed = True
        elif isinstance(value, PropertyReference):
            value = value.get_resolved_ref(assignee_node)
            changed = True
        elif is_user_struct(type(value)):
            new_value = resolve_node_refs_in_struct(assignee_node, value)
            if new_value is not value:
                changed = True
            value = new_value
        new_array.append(value)

    if changed:
        return new_array
    return array

def resolve_node_refs_in_struct(assignee_node: Node, struct: UserStruct) -> UserStruct:
    """
    Recursively converts any ComponentRef within the array to proper Node objects
    """
    new_values = {}
    changed = False
    for member_name, value in struct.members.items():
        if isinstance(value, ComponentRef):
            value = value.build_node_ref(assignee_node)
            changed = True
        elif isinstance(value, PropertyReference):
            value = value.get_resolved_ref(assignee_node)
            changed = True
        elif is_user_struct(type(value)):
            new_svalue = resolve_node_refs_in_struct(assignee_node, value)
            if new_svalue is not value:
                changed = True
            value = new_svalue
        elif isinstance(value, list):
            new_avalue = resolve_node_refs_in_array(assignee_node, value)
            if new_avalue is not value:
                changed = True
            value = new_avalue
        new_values[member_name] = value

    if changed:
        cls = type(struct)
        new_struct = cls(new_values)
        return new_struct
    return struct
