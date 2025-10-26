from typing import TYPE_CHECKING, Dict, Optional, Type

from .bases import PropertyRule
from .user_defined import UserProperty, ExternalUserProperty

from .. import rdltypes
from ..core.helpers import get_all_subclasses
from ..ast.ast_node import ASTNode

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase

class PropertyRuleBook:
    def __init__(self, env: 'RDLEnvironment'):
        self.env = env

        # Auto-discover all properties defined below and load into dict
        self.rdl_properties: Dict[str, PropertyRule] = {}
        for prop in get_all_subclasses(PropertyRule):
            if prop.__name__.startswith("Prop_"):
                prop_inst = prop(self.env)
                self.rdl_properties[prop_inst.get_name()] = prop(self.env)

        self.user_properties: Dict[str, UserProperty] = {}

        self.rdl_prop_refs: Dict[str, Type[rdltypes.PropertyReference]] = {}
        for prop_ref in get_all_subclasses(rdltypes.PropertyReference):
            if prop_ref.__name__.startswith("PropRef_"):
                prop_name = prop_ref.get_name()
                self.rdl_prop_refs[prop_name] = prop_ref

    def lookup_property(self, prop_name: str, include_soft_udp: bool=False) -> Optional[PropertyRule]:
        if prop_name in self.rdl_properties:
            return self.rdl_properties[prop_name]
        elif prop_name in self.user_properties:
            udp = self.user_properties[prop_name]
            if isinstance(udp, ExternalUserProperty) and udp.is_soft and not include_soft_udp:
                # Soft UDPs do not officially exist until they are explicitly defined
                return None
            return udp
        else:
            return None

    def lookup_prop_ref_type(self, prop_ref_name: str) -> Optional[Type[rdltypes.PropertyReference]]:
        return self.rdl_prop_refs.get(prop_ref_name, None)

    def register_udp(self, udp: UserProperty, src_ref: Optional['SourceRefBase']) -> None:
        if udp.name in self.user_properties:

            existing_udp = self.user_properties[udp.name]
            if isinstance(existing_udp, ExternalUserProperty) and existing_udp.is_soft:
                # Existing UDP is soft. Check if incoming UDP is equivalent
                if existing_udp.bindable_to != udp.bindable_to:
                    self.env.msg.error(
                        "The property definition for the feature extension '%s' uses a different 'components' definition from what this tool expects." % udp.name,
                        src_ref
                    )
                if existing_udp.valid_type != udp.valid_type:
                    self.env.msg.error(
                        "The property definition for the feature extension '%s' uses a different 'type' definition from what this tool expects." % udp.name,
                        src_ref
                    )

                if isinstance(udp.default_assignment, ASTNode):
                    udp_default_assign_value = udp.default_assignment.get_value()
                else:
                    udp_default_assign_value = udp.default_assignment
                if existing_udp.default_assignment != udp_default_assign_value:
                    self.env.msg.error(
                        "The property definition for the feature extension '%s' uses a different 'default' definition from what this tool expects." % udp.name,
                        src_ref
                    )
                if existing_udp.constr_componentwidth != udp.constr_componentwidth:
                    self.env.msg.fatal(
                        "The property definition for the feature extension '%s' uses a different 'constraint' definition from what this tool expects." % udp.name,
                        src_ref
                    )

                # Now that the soft UDP has been explicitly defined by the user,
                # unmark it as soft
                existing_udp.is_soft = False
                return
            self.env.msg.fatal(
                "Multiple declarations of user-defined property '%s'"
                % udp.name,
                src_ref
            )

        if udp.name in self.rdl_properties:
            self.env.msg.fatal(
                "User-defined property '%s' cannot be the same name as a built-in SystemRDL property"
                % udp.name,
                src_ref
            )

        self.user_properties[udp.name] = udp
