from typing import Optional, List, Union
import textwrap


class _DefinitionBase:
    def __init__(self) -> None:
        self.children = [] # type: List[Union[str, _DefinitionBase]]

    def __str__(self) -> str:
        s = '\n'.join((str(x) for x in self.children))
        return textwrap.indent(s, "    ")


class _AnonymousDefinition(_DefinitionBase):
    def __init__(self, classname: str, inst_name: str, array_dimensions: Optional[List[int]] = None, suffix: Optional[str] = None, is_external: bool = False):
        super().__init__()
        self.classname = classname
        self.inst_name = inst_name
        self.array_dimensions = array_dimensions
        self.suffix = suffix
        self.is_external = is_external

    def __str__(self) -> str:
        if self.array_dimensions:
            suffix = "[" + "][".join((str(n) for n in self.array_dimensions)) + "]"
        else:
            suffix = ""

        if self.suffix:
            suffix += self.suffix

        if self.is_external:
            ext = "external "
        else:
            ext = ""

        content = super().__str__()
        if content:
            content = "\n" + content + "\n"
        return (
            f"{self.classname} {{"
            + content
            + f"}} {ext}{self.inst_name}{suffix};"
        )


class _NamedDefinition(_DefinitionBase):
    def __init__(self, classname: str, type_name: str, inst_name: Optional[str] = None, array_dimensions: Optional[List[int]] = None, suffix: Optional[str] = None):
        super().__init__()
        self.classname = classname
        self.type_name = type_name
        self.inst_name = inst_name
        self.array_dimensions = array_dimensions
        self.suffix = suffix

    def __str__(self) -> str:
        return (
            f"{self.classname} {self.type_name} {{\n"
            + super().__str__()
            + "\n};"
        )

    @property
    def instantiation(self) -> str:
        if self.array_dimensions:
            suffix = "[" + "][".join((str(n) for n in self.array_dimensions)) + "]"
        else:
            suffix = ""

        if self.suffix:
            suffix += self.suffix

        return f"{self.type_name} {self.inst_name}{suffix};"

#-------------------------------------------------------------------------------

class DefinitionGenerator:

    def __init__(self) -> None:
        self._definition_stack = [] # type: List[_DefinitionBase]

    @property
    def current_struct(self) -> _DefinitionBase:
        return self._definition_stack[-1]


    def push(self, classname: str, inst_name: str, array_dimensions: Optional[List[int]] = None, suffix: Optional[str] = None, is_external: bool = False) -> None:
        s = _AnonymousDefinition(classname, inst_name, array_dimensions, suffix, is_external)
        self._definition_stack.append(s)


    def add_content(self, content: str) -> None:
        self.current_struct.children.append(content)


    def pop(self) -> None:
        s = self._definition_stack.pop()

        self.current_struct.children.append(s)


    def start(self, classname: str, type_name: str) -> None:
        assert not self._definition_stack
        s = _NamedDefinition(classname, type_name)
        self._definition_stack.append(s)

    def finish(self) -> str:
        s = self._definition_stack.pop()
        assert not self._definition_stack
        return str(s)
