from typing import TYPE_CHECKING, Any, Set, Type, Tuple

from .bases import PropertyRule

from .. import rdltypes
from .. import node as m_node

if TYPE_CHECKING:
    from .. import component as comp
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..udp import UDPDefinition


class UserProperty(PropertyRule):
    """
    Base-class for user-defined properties
    """
    @property
    def name(self) -> str:
        raise NotImplementedError

    @property
    def bindable_to(self) -> 'Set[Type[comp.Component]]': # type: ignore
        raise NotImplementedError

    @property
    def valid_type(self) -> Any:
        raise NotImplementedError

    @property
    def default_assignment(self) -> Any:
        raise NotImplementedError

    @property
    def constr_componentwidth(self) -> bool:
        raise NotImplementedError

    @property
    def valid_types(self) -> Tuple[Any, ...]: # type: ignore
        if isinstance(self.valid_type, rdltypes.ArrayedType):
            return (self.valid_type,)
        if issubclass(self.valid_type, rdltypes.references.RefType):
            return self.valid_type.expanded
        else:
            return (self.valid_type,)

    def get_name(self) -> str:
        return self.name

    def assign_value(self, comp_def: 'comp.Component', value: Any, src_ref: 'SourceRefBase') -> None:
        # Property assignments with no rhs show up as None here
        # For user-defined properties, this implies the default value
        # (15.2.2)
        if value is None:
            if self.default_assignment is None:
                # No default was set, so value is undefined.
                # As per 15.2.1-c. UDP is still "bound" to the component, so give
                # it the NoValue class as a value

                # Check if property is allowed in this component
                if type(comp_def) not in self.bindable_to:
                    self.env.msg.fatal(
                        "The property '%s' is not valid for '%s' components"
                        % (self.get_name(), type(comp_def).__name__.lower()),
                        src_ref
                    )

                # Circumvent the usual assignment function to avoid some pesky validation
                comp_def.properties[self.get_name()] = rdltypes.NoValue
                if src_ref is not None:
                    comp_def.property_src_ref[self.get_name()] = src_ref

                return

            value = self.default_assignment

        super().assign_value(comp_def, value, src_ref)

    def get_default(self, node: m_node.Node) -> Any:
        # If a user-defined property is not explicitly assigned, then it
        # does not get bound with its default value
        return None

    def validate(self, node: m_node.Node, value: Any) -> None:
        if self.constr_componentwidth:
            # 15.1.1-g: If constraint is set to componentwidth, the assigned
            #   value of the property shall not have a value of 1 for any bit
            #   beyond the width of the field.

            # Spec does not specify, but assuming this check gets ignored for
            # non-vector nodes
            if isinstance(node, m_node.VectorNode) and isinstance(value, int):
                if value.bit_length() > node.width:
                    self.env.msg.error(
                        "Value (%d) of the '%s' property cannot fit within the width (%d) of component '%s'"
                        % (value, self.name, node.width, node.inst_name),
                        node.property_src_ref.get(self.name, node.inst_src_ref)
                    )

        self._validate_ref_is_present(node, value)


class PureUserProperty(UserProperty):
    """
    UDP that was defined purely within SystemRDL source
    """

    def __init__(
        self, env: 'RDLEnvironment',
        name: str,
        valid_components: 'Set[Type[comp.Component]]',
        valid_type: Any,
        default_assignment: Any,
        constr_componentwidth: bool
    ):
        super().__init__(env)

        self._name = name
        self._valid_components = valid_components
        self._valid_type = valid_type
        self._default_assignment = default_assignment
        self._constr_componentwidth = constr_componentwidth

    @property
    def name(self) -> str:
        return self._name

    @property
    def bindable_to(self) -> 'Set[Type[comp.Component]]': # type: ignore # overriding base class var as property
        return self._valid_components

    @property
    def valid_type(self) -> Any:
        return self._valid_type

    @property
    def default_assignment(self) -> Any:
        return self._default_assignment

    @property
    def constr_componentwidth(self) -> bool:
        return self._constr_componentwidth


class ExternalUserProperty(UserProperty):
    """
    UDP that was defined via rdlc.register_udp().
    This variant fetches its definition contents from an external class
    """
    def __init__(self, env: 'RDLEnvironment', definition_cls: 'Type[UDPDefinition]', soft: bool=True):
        super().__init__(env)

        self.definition = definition_cls(env)
        self.is_soft = soft

    @property
    def name(self) -> str:
        return self.definition.name

    @property
    def bindable_to(self) -> 'Set[Type[comp.Component]]': # type: ignore
        return self.definition.valid_components

    @property
    def valid_type(self) -> Any:
        return self.definition.valid_type

    @property
    def default_assignment(self) -> Any:
        return self.definition.default_assignment

    @property
    def constr_componentwidth(self) -> bool:
        return self.definition.constr_componentwidth

    def get_default(self, node: m_node.Node) -> Any:
        return self.definition.get_unassigned_default(node)

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        self.definition.validate(node, value)
