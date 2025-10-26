from typing import Any, Set, Type, Tuple, TYPE_CHECKING, Optional, Dict
import sys

from .. import node as m_node
from ..ast.ast_node import ASTNode
from .. import rdltypes
from ..ast.cast import AssignmentCast, is_castable
from ..core.helpers import get_all_subclasses

if TYPE_CHECKING:
    from .. import component as comp
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase

#===============================================================================
# Base property
#===============================================================================
class PropertyRule:
    # Set of components this property can be bound to
    bindable_to: Set[Type['comp.Component']] = set()

    # List of valid assignment types. In order of cast preference
    valid_types: Tuple[Any, ...] = tuple()

    # Default value if not assigned
    default: Any = None

    # Whether dynamic assignments are allowed to be made to this property
    dyn_assign_allowed: bool = True

    # Group string in which this property is mutually exclusive
    mutex_group: Optional[str] = None


    def __init__(self, env: 'RDLEnvironment'):
        self.env = env
        self._name = self.get_name_cls()


    @classmethod
    def get_name_cls(cls) -> str:
        return sys.intern(cls.__name__.replace("Prop_", ""))


    def get_name(self) -> str:
        return self._name


    def assign_value(self, comp_def: 'comp.Component', value: Any, src_ref: 'SourceRefBase') -> None:
        """
        Used by the compiler for either local or dynamic prop assignments
        This does the following:
            - Check that the property is allowed in this component
            - Check if the value being assigned is compatible
            - Assign the property, as well as any side-effects
                subclasses extend this to define prop-specific side-effects
        """

        # Check if property is allowed in this component
        if type(comp_def) not in self.bindable_to:
            self.env.msg.fatal(
                "The property '%s' is not valid for '%s' components"
                % (self.get_name(), type(comp_def).__name__.lower()),
                src_ref
            )

        # Property assignments with no rhs show up as None here
        # For built-in properties, this implies a True value
        if value is None:
            value = True

        # unpack true type of value
        # Contents of value can be:
        #   - An expression (instance of an ASTNode subclass)
        #   - Direct assignment of a type-compatible value
        if isinstance(value, ASTNode):
            # Predict expected type after value would get evaluated
            assign_type = value.predict_type()
        elif rdltypes.is_user_enum(value):
            # Value is a user enum type derived from UserEnum.
            # Mark it as such
            assign_type = rdltypes.UserEnum
        else:
            # Value is already evaluated
            if isinstance(value, list):
                # Value is a list. Construct an arrayed type
                if value:
                    # List is not empty. Get member type
                    member_type = type(value[0])
                else:
                    # List is empty. Member type is unknown
                    member_type = None
                assign_type = rdltypes.ArrayedType(member_type)
            else:
                assign_type = type(value)

        # First check if the value's type is already directly compatible
        for valid_type in self.valid_types:
            if assign_type == valid_type:
                break
        else:
            # otherwise, cast to the first compatible type
            for valid_type in self.valid_types:
                if is_castable(assign_type, valid_type):
                    if isinstance(value, ASTNode):
                        # Found a type-compatible match. (first match is best match)
                        # Wrap the expression with an explicit assignment cast
                        value = AssignmentCast(self.env, src_ref, value, valid_type)
                    break
            else:
                self.env.msg.fatal(
                    "Incompatible assignment to property '%s'" % self.get_name(),
                    src_ref
                )

        # If the property belongs to a mutex group, wipe out any of its
        # counterpart properties
        if self.mutex_group is not None:
            for prop_name in _get_mutex_properties(self.mutex_group):
                if prop_name in comp_def.properties:
                    del comp_def.properties[prop_name]

        # Store the property
        comp_def.properties[self.get_name()] = value

        if src_ref is not None:
            comp_def.property_src_ref[self.get_name()] = src_ref


    def get_default(self, node: m_node.Node) -> Any:
        # pylint: disable=unused-argument
        """
        Used when the user queries a property, and it was not explicitly set.
        Default values are not always directly known. Sometimes they depend on
        one or more other properties.
        The base behavior will simply return the static variable's value.
        Properties with more complex rules can override this to implement
        other default value derivations
        """
        return self.default


    def validate(self, node: m_node.Node, value: Any) -> None:
        """
        Used during the validate phase after elaboration.
        Performs checks against the property's value
        """


    def _validate_ref_width(self, node: m_node.VectorNode, value: Any) -> None:
        """
        Helper function to check that if value is a vector-like reference,
        that its width matches the node.
        """
        if isinstance(value, m_node.VectorNode):
            if node.width != value.width:
                self.env.msg.error(
                    "%s '%s' references %s '%s''s value but they are not the same width (%d != %d)"
                    % (
                        type(node.inst).__name__.lower(), node.inst_name,
                        type(value.inst).__name__.lower(), value.inst_name,
                        node.width, value.width
                    ),
                    self.get_src_ref(node)
                )
        elif isinstance(value, rdltypes.PropertyReference) and value.width is not None:
            if node.width != value.width:
                self.env.msg.error(
                    "%s '%s' references property '%s->%s' but they are not the same width (%d != %d)"
                    % (
                        type(node.inst).__name__.lower(), node.inst_name,
                        value.node.inst_name, value.name,
                        node.width, value.width
                    ),
                    self.get_src_ref(node)
                )


    def _validate_ref_width_is_1(self, node: m_node.Node, value: Any) -> None:
        """
        Helper function to check that if value is a vector-like reference,
        that its width is exactly 1.
        """
        if isinstance(value, m_node.VectorNode):
            if value.width != 1:
                self.env.msg.error(
                    "%s '%s' references %s '%s' but its width is not 1"
                    % (
                        type(node.inst).__name__.lower(), node.inst_name,
                        type(value.inst).__name__.lower(), value.inst_name
                    ),
                    self.get_src_ref(node)
                )
        elif isinstance(value, rdltypes.PropertyReference) and value.width is not None:
            if value.width != 1:
                self.env.msg.error(
                    "%s '%s' references property '%s->%s' but its width is not 1"
                    % (
                        type(node.inst).__name__.lower(), node.inst_name,
                        value.node.inst_name, value.name,
                    ),
                    self.get_src_ref(node)
                )


    def _validate_ref_is_present(self, node: m_node.Node, value: Any) -> None:
        """
        5.3.1-i: If a present instance includes references (e.g., signals), the
        referred objects need to also be present.
        """
        if isinstance(value, m_node.Node):
            if not value.get_property('ispresent'):
                self.env.msg.error(
                    "%s '%s' references %s '%s' but it is not present (ispresent=false)"
                    % (
                        type(node.inst).__name__.lower(), node.inst_name,
                        type(value.inst).__name__.lower(), value.inst_name
                    ),
                    self.get_src_ref(node)
                )
        elif isinstance(value, rdltypes.PropertyReference):
            if not value.node.get_property('ispresent'):
                self.env.msg.error(
                    "%s '%s' references '%s->%s' but it is not present (ispresent=false)"
                    % (
                        type(node.inst).__name__.lower(), node.inst_name,
                        value.node.inst_name, value.name
                    ),
                    self.get_src_ref(node)
                )

    def _validate_width_eq_or_smaller(self, node: m_node.VectorNode, value: Any) -> None:
        """
        Helper function to check that if value is a vector-like reference,
        that its width is equal or smaller than the node's width

        Used for 9.8.1: The increment/decrement value shall be equal to or
        smaller than the field's width.
        """
        if isinstance(value, int):
            if node.width < value.bit_length():
                self.env.msg.error(
                    "A counter's %s cannot reference a value wider than the counter itself."
                    % (self.get_name()),
                    self.get_src_ref(node)
                )
        elif isinstance(value, m_node.VectorNode):
            if node.width < value.width:
                self.env.msg.error(
                    "A counter's %s cannot reference a value wider than the counter itself."
                    % (self.get_name()),
                    self.get_src_ref(node)
                )
        elif isinstance(value, rdltypes.PropertyReference) and value.width is not None:
            if node.width < value.width:
                self.env.msg.error(
                    "A counter's %s cannot reference a value wider than the counter itself."
                    % (self.get_name()),
                    self.get_src_ref(node)
                )

    def get_src_ref(self, node: m_node.Node) -> Optional['SourceRefBase']:
        return node.property_src_ref.get(self.get_name(), node.inst_src_ref)


#===============================================================================
class PropertyRuleBoolPair(PropertyRule):
    # Property name of the equivalent opposite
    opposite_property = ""

    def get_default(self, node: m_node.Node) -> bool:
        """
        If not explicitly set, check if the opposite was set first before returning
        default
        """
        # Check for explicit assignment to avoid infinite loop via get_default()
        if self.opposite_property in node.inst.properties:
            return not node.inst.properties[self.opposite_property]
        else:
            return self.default

#===============================================================================
_MUTEX_PROP_GROUPS: Dict[str, Set[str]] = {}
def _get_mutex_properties(group_name: str) -> Set[str]:
    # initialize cache for the first time if needed
    if not _MUTEX_PROP_GROUPS:
        for prop_cls in get_all_subclasses(PropertyRule):
            if prop_cls.__name__.startswith("Prop_"):
                if prop_cls.mutex_group is not None:
                    if prop_cls.mutex_group not in _MUTEX_PROP_GROUPS:
                        _MUTEX_PROP_GROUPS[sys.intern(prop_cls.mutex_group)] = set()
                    _MUTEX_PROP_GROUPS[sys.intern(prop_cls.mutex_group)].add(prop_cls.get_name_cls())

    return _MUTEX_PROP_GROUPS[group_name]
