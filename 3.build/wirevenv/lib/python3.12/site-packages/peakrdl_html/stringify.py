from typing import Any, List

from systemrdl import rdltypes, node

def stringify_rdl_value(value: Any, owner_node: node.Node) -> str:
    """
    Convert value into its pretty-printed string.
    owner_node is provided for a reference for relative paths if needed
    """

    if type(value) == int:
        return stringify_int(value)
    elif type(value) == bool:
        return stringify_boolean(value)
    elif type(value) == str:
        return stringify_string(value)
    elif type(value) == list:
        return stringify_array(value, owner_node)
    elif isinstance(value, rdltypes.BuiltinEnum):
        return stringify_builtin_enum(value)
    elif isinstance(value, rdltypes.UserEnum):
        return stringify_user_enum_member(value)
    elif isinstance(value, rdltypes.UserStruct):
        return stringify_struct(value, owner_node)
    elif isinstance(value, node.Node):
        return stringify_component_ref(value, owner_node)
    elif isinstance(value, rdltypes.PropertyReference):
        return stringify_property_ref(value, owner_node)
    elif rdltypes.is_user_enum(value):
        return stringify_user_enum_type(value)
    else:
        # Should never get here
        raise RuntimeError


def stringify_int(value: int) -> str:
    return str(value)


def stringify_boolean(value: bool) -> str:
    return str(value).lower()


def stringify_string(value: str) -> str:
    return '"' + value + '"'


def stringify_array(value: List[Any], owner_node: node.Node) -> str:
    elements = [stringify_rdl_value(element, owner_node) for element in value]
    return '[' + ", ".join(elements) + ']'


def stringify_builtin_enum(value: rdltypes.BuiltinEnum) -> str:
    return value.name


def stringify_user_enum_member(value: rdltypes.UserEnum) -> str:
    return "%s::%s" % (type(value).type_name, value.name)


def stringify_struct(value: rdltypes.UserStruct, owner_node: node.Node) -> str:
    elements = ["%s:%s" % (k, stringify_rdl_value(v, owner_node)) for k,v in value._values.items()]
    return "%s'{%s}" % (type(value).__name__, ", ".join(elements))


def stringify_component_ref(value: node.Node, owner_node: node.Node) -> str:
    return value.get_rel_path(owner_node)


def stringify_property_ref(value: rdltypes.PropertyReference, owner_node: node.Node) -> str:
    return "%s->%s" % (value.node.get_rel_path(owner_node), value.name)


def stringify_user_enum_type(value: rdltypes.UserEnum) -> str:
    return value.__name__
