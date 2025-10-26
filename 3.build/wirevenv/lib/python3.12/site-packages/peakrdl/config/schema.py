from typing import Any, List, Dict, Union
import datetime
import os
import re
import importlib

class SchemaException(Exception):
    """
    Raised if encounters a data extraction error.
    """

class Schema:
    def extract(self, data: Any, path: str, err_ctx: str) -> Any:
        raise NotImplementedError

RawSchema = Union[Schema, list, dict]

#-------------------------------------------------------------------------------
# Base TOML datatypes
#-------------------------------------------------------------------------------
class _SimpleType(Schema):
    TYPE: Any
    def extract(self, data: Any, path: str, err_ctx: str) -> Any:
        if not isinstance(data, self.TYPE):
            raise SchemaException(f"{err_ctx}: Expected {self.TYPE.__name__}. Got {type(data).__name__}")
        return data

class String(_SimpleType):
    """
    Matches a string.
    """
    TYPE = str

class Integer(_SimpleType):
    """
    Matches an integer.
    """
    TYPE = int

class Float(_SimpleType):
    """
    Matches a float.
    """
    TYPE = float

class Boolean(_SimpleType):
    """
    Matches a boolean.
    """
    TYPE = bool

class DateTime(_SimpleType):
    """
    Matches a date + time.
    """
    TYPE = datetime.datetime

class Date(_SimpleType):
    """
    Matches a date.
    """
    TYPE = datetime.date

class Time(_SimpleType):
    """
    Matches a time.
    """
    TYPE = datetime.time

class AnyType(Schema):
    """
    Wildcard. Matches any type.
    """
    def extract(self, data: Any, path: str, err_ctx: str) -> Any:
        return data

#-------------------------------------------------------------------------------
# Aggregate datatypes
#-------------------------------------------------------------------------------
class Array(Schema):
    """
    Matches an array of elements of the same schema
    """
    def __init__(self, raw_element_schema: RawSchema) -> None:
        super().__init__()
        self.element_schema = normalize(raw_element_schema)

    def extract(self, data: Any, path: str, err_ctx: str) -> List:
        if not isinstance(data, list):
            raise SchemaException(f"{err_ctx}: Expected array. Got {type(data).__name__}")

        array = []
        for i, e in enumerate(data):
            element = self.element_schema.extract(e, path, f"{err_ctx}[{i}]")
            array.append(element)
        return array

class FixedMapping(Schema):
    """
    Matches a fixed mapping of specified key:value pairs.

    If a key is not provided, it will be guaranteed to exist and will fall back
    to its default value.
    """
    def __init__(self, schema: Dict[str, RawSchema]) -> None:
        super().__init__()
        self.schema = {}
        for k,v in schema.items():
            self.schema[k] = normalize(v)

    def extract(self, data: Any, path: str, err_ctx: str) -> Dict[str, Any]:
        if not isinstance(data, dict):
            raise SchemaException(f"{err_ctx}: Expected mapping. Got {type(data).__name__}")

        mapping: Dict[str, Any] = {}
        for key, schema in self.schema.items():
            if key not in data:
                # Not specified. Assign default
                if isinstance(schema, Array):
                    # Arrays are empty if unspecified
                    mapping[key] = []
                elif isinstance(schema, UserMapping):
                    # User mappings have no entries
                    mapping[key] = {}
                elif isinstance(schema, FixedMapping):
                    # Fixed mappings have all keys populated with their defaults
                    mapping[key] = schema.extract({}, path, f"{err_ctx}.{key}")
                else:
                    mapping[key] = None
            else:
                mapping[key] = schema.extract(data[key], path, f"{err_ctx}.{key}")
        return mapping

class UserMapping(Schema):
    """
    Matches a user-defined mapping. Keys can be anything
    """
    def __init__(self, raw_value_schema: RawSchema) -> None:
        super().__init__()
        self.value_schema = normalize(raw_value_schema)

    def extract(self, data: Any, path: str, err_ctx: str) -> Dict[str, Any]:
        if not isinstance(data, dict):
            raise SchemaException(f"{err_ctx}: Expected mapping. Got {type(data).__name__}")

        mapping = {}
        for key, value in data.items():
            mapping[key] = self.value_schema.extract(value, path, f"{err_ctx}.{key}")
        return mapping


def normalize(raw_schema: RawSchema) -> Schema:
    """
    Convert a raw user-defined scheme into a fully resolved object tree.
    Shorthand representations of aggregate datatypes are expanded into their
    actual classes
    """
    if isinstance(raw_schema, Schema):
        # pass through. no conversion needed
        return raw_schema

    if isinstance(raw_schema, list):
        # Shorthand array. Convert to Array schema object
        if len(raw_schema) != 1:
            raise RuntimeError("Array schema can only have one element")
        return Array(raw_schema[0])

    if isinstance(raw_schema, dict):
        if "*" in raw_schema:
            # Is a user mapping
            if len(raw_schema) != 1:
                raise RuntimeError("User mapping schema shall have only one entry")
            return UserMapping(raw_schema['*'])
        else:
            # Is a fixed mapping
            return FixedMapping(raw_schema)


    raise RuntimeError(f"Invalid schema object: {repr(raw_schema)}")


#-------------------------------------------------------------------------------
# High-level elements
#-------------------------------------------------------------------------------
class Path(String):
    """
    Matches any path
    """
    def __init__(self, shall_exist: bool = True) -> None:
        super().__init__()
        self.shall_exist = shall_exist

    def extract(self, data: Any, path: str, err_ctx: str) -> Any:
        s = super().extract(data, path, err_ctx)
        s = os.path.expanduser(s)

        if not os.path.isabs(s):
            # relative path.
            # extend it to be relative to the config file
            dir_path = os.path.dirname(path)
            s = os.path.join(dir_path, s)

        s = os.path.abspath(s)
        s = os.path.normpath(s)

        if self.shall_exist and not os.path.exists(s):
            raise SchemaException(f"{err_ctx}: Path does not exist: {s}")


        return s

class FilePath(Path):
    """
    Matches a path to a file
    """
    def extract(self, data: Any, path: str, err_ctx: str) -> Any:
        s = super().extract(data, path, err_ctx)
        if self.shall_exist and not os.path.isfile(s):
            raise SchemaException(f"{err_ctx}: Path does not point to a file: {s}")
        return s

class DirectoryPath(Path):
    """
    Matches a path to a directory
    """
    def extract(self, data: Any, path: str, err_ctx: str) -> Any:
        s = super().extract(data, path, err_ctx)
        if self.shall_exist and not os.path.isdir(s):
            raise SchemaException(f"{err_ctx}: Path does not point to a directory: {s}")
        return s

class PythonObjectImport(String):
    """
    Matches a string that specifies a Python object to import.
    For example: ``"my.module.path:ObjectName"``
    """
    def extract(self, data: Any, path: str, err_ctx: str) -> Any:
        s = super().extract(data, path, err_ctx)
        m = re.fullmatch(r"(\w+(?:\.\w+)*):(\w+)", s)
        if not m:
            raise SchemaException(f"{err_ctx}: Invalid object import spec: {s}")

        module_name = m.group(1)
        object_name = m.group(2)

        try:
            module = importlib.import_module(module_name)
        except ModuleNotFoundError as e:
            raise SchemaException(f"{err_ctx}: {str(e)}") from e

        try:
            cls = getattr(module, object_name)
        except AttributeError as e:
            raise SchemaException(f"{err_ctx}: {str(e)}") from e

        return cls

class Choice(String):
    """
    Schema that matches against a specific set of allowed strings
    """
    def __init__(self, choices: List[str]) -> None:
        super().__init__()
        self.choices = choices

    def extract(self, data: Any, path: str, err_ctx: str) -> Any:
        s = super().extract(data, path, err_ctx)
        if s not in self.choices:
            raise SchemaException(f"{err_ctx}: Value '{s}' is not a valid choice. Must be one of: {','.join(self.choices)}")
        return s
