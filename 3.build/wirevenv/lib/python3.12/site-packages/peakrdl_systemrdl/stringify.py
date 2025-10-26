from typing import Any, List

from systemrdl import rdltypes, node

def stringify_rdl_value(value: Any) -> str:
    """
    Convert value into its RDL string.
    """

    if isinstance(value, bool):
        return stringify_boolean(value)
    elif isinstance(value, int):
        return stringify_int(value)
    elif isinstance(value, str):
        return stringify_string(value)
    elif isinstance(value, list):
        return stringify_array(value)
    elif isinstance(value, rdltypes.BuiltinEnum):
        return stringify_builtin_enum(value)
    elif isinstance(value, rdltypes.UserEnum):
        return stringify_user_enum_member(value)
    elif isinstance(value, rdltypes.UserStruct):
        return stringify_struct(value)
    elif rdltypes.is_user_enum(value):
        return stringify_user_enum_type(value)
    elif isinstance(value, (node.Node, rdltypes.PropertyReference)):
        # TODO: Throw error. not supported
        raise NotImplementedError
    else:
        # Should never get here
        raise RuntimeError


def stringify_int(value: int) -> str:
    return "0x%x" % value


def stringify_boolean(value: bool) -> str:
    return str(value).lower()


def stringify_string(value: str) -> str:
    t = str.maketrans({
        "\\" : "\\\\",
        '"': '\\"',
    })
    return '"' + value.translate(t) + '"'


def stringify_array(value: List[Any]) -> str:
    elements = [stringify_rdl_value(element) for element in value]
    return "'{" + ", ".join(elements) + '}'


def stringify_builtin_enum(value: rdltypes.BuiltinEnum) -> str:
    return value.name


def stringify_user_enum_member(value: rdltypes.UserEnum) -> str:
    return "%s::%s" % (type(value).type_name, value.name) # type: ignore


def stringify_struct(value: rdltypes.UserStruct) -> str:
    elements = ["%s:%s" % (k, stringify_rdl_value(v)) for k,v in value._values.items()]
    return "%s'{%s}" % (type(value).type_name, ", ".join(elements))


def stringify_user_enum_type(value: rdltypes.UserEnum) -> str:
    return value.type_name # type: ignore
