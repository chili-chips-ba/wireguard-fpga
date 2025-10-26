from typing import Optional, Any, List, TYPE_CHECKING
import re

from .compiler import RDLCompiler
from .source_ref import FileSourceRef, SourceRefBase
from . import component as comp

if TYPE_CHECKING:
    from typing import TypeVar, Type
    ComponentClass = TypeVar('ComponentClass', bound=comp.Component)
    AddressableComponentClass = TypeVar('AddressableComponentClass', bound=comp.AddressableComponent)

class RDLImporter:
    def __init__(self, compiler: RDLCompiler):
        """
        Base class for external parsers to import data into the register model

        Parameters
        ----------
        compiler: :class:`RDLCompiler`
            Reference to compiler instance where the import is being performed.
        """

        #: Reference to the current compiler instance
        self.compiler = compiler

        #: Reference to the compiler message handler
        #:
        #: .. warning::
        #:
        #:      This will be deprecated in a future release. See this page for more details: https://github.com/SystemRDL/systemrdl-compiler/issues/168
        self.msg = compiler.env.msg

        #: Source reference used by default when not specified in importer
        #: model construction methods
        #: By default, this simply points to the file currently being imported,
        #: without any line offset information
        self.default_src_ref: SourceRefBase

    def import_file(self, path: str) -> None:
        """
        Importer entry point.

        Extend this function to read the file and perform the import.
        Be sure to call ``super().import_file(path)``

        Parameters
        ----------
        path: str
            Path to file
        """
        self.default_src_ref = FileSourceRef(path)

    # ------------------------ create_xxx_definition() -------------------------
    def _create_definition(self, cls: "Type[ComponentClass]", type_name: Optional[str] = None, src_ref: Optional[SourceRefBase] = None) -> "ComponentClass":
        if (type_name is not None) and not re.fullmatch(r"[a-zA-Z_]\w*", type_name):
            raise ValueError(f"Type name has invalid characters: '{type_name}'")
        C = cls()
        C.type_name = type_name
        C.def_src_ref = src_ref or self.default_src_ref
        return C

    def create_field_definition(self, type_name: Optional[str] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Field:
        """
        Parameters
        ----------
        type_name: str
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Field`
            Component definition
        """
        return self._create_definition(comp.Field, type_name, src_ref)

    def create_reg_definition(self, type_name: Optional[str] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Reg:
        """
        Parameters
        ----------
        type_name: str
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Reg`
            Component definition
        """
        return self._create_definition(comp.Reg, type_name, src_ref)

    def create_regfile_definition(self, type_name: Optional[str] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Regfile:
        """
        Parameters
        ----------
        type_name: str
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Regfile`
            Component definition
        """
        return self._create_definition(comp.Regfile, type_name, src_ref)

    def create_addrmap_definition(self, type_name: Optional[str] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Addrmap:
        """
        Parameters
        ----------
        type_name: str
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Addrmap`
            Component definition
        """
        return self._create_definition(comp.Addrmap, type_name, src_ref)

    def create_mem_definition(self, type_name: Optional[str] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Mem:
        """
        Parameters
        ----------
        type_name: str
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Mem`
            Component definition
        """
        C = self._create_definition(comp.Mem, type_name, src_ref)
        C.external = True
        return C


    # --------------------------- instantiate_xxx() ----------------------------
    def _instantiate(self, comp_def: "ComponentClass", inst_name: str, src_ref: Optional[SourceRefBase] = None) -> "ComponentClass":
        if comp_def.is_instance:
            raise ValueError("Component is already instantiated")
        if not re.fullmatch(r"[a-zA-Z_]\w*", inst_name):
            raise ValueError(f"Instance name has invalid characters: '{inst_name}'")

        if comp_def.type_name is None:
            # anonymous definition. No need to copy since it can only be used once
            comp_inst = comp_def
        else:
            # named definition. Copy so that the definition can be re-used
            comp_inst = comp_def._copy_for_inst({})
            comp_inst.original_def = comp_def

        comp_inst.is_instance = True
        comp_inst.inst_name = inst_name
        comp_inst.inst_src_ref = src_ref or self.default_src_ref
        return comp_inst

    def instantiate_field(self, comp_def: comp.Field, inst_name: str, bit_offset: int, bit_width: int, src_ref: Optional[SourceRefBase] = None) -> comp.Field:
        """
        Parameters
        ----------
        comp_def: :class:`comp.Field`
        inst_name: str
        bit_offset: int
        bit_width: int
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Field`
            Component instance
        """
        assert isinstance(comp_def, comp.Field)
        comp_inst = self._instantiate(comp_def, inst_name, src_ref)
        comp_inst.low = bit_offset
        comp_inst.high = bit_offset + bit_width - 1
        comp_inst.lsb = comp_inst.low
        comp_inst.msb = comp_inst.high
        comp_inst.width = bit_width
        return comp_inst

    def _instantiate_addressable(self, comp_def: "AddressableComponentClass", inst_name: str, addr_offset: int, array_dimensions: Optional[List[int]] = None, array_stride: Optional[int] = None, src_ref: Optional[SourceRefBase] = None) -> "AddressableComponentClass":

        comp_inst = self._instantiate(comp_def, inst_name, src_ref)
        comp_inst.addr_offset = addr_offset
        if array_dimensions:
            comp_inst.is_array = True
            comp_inst.array_dimensions = array_dimensions
            comp_inst.array_stride = array_stride
        return comp_inst

    def instantiate_reg(self, comp_def: comp.Reg, inst_name: str, addr_offset: int, array_dimensions: Optional[List[int]] = None, array_stride: Optional[int] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Reg:
        """
        Parameters
        ----------
        comp_def: :class:`comp.Reg`
        inst_name: str
        addr_offset: int
        array_dimensions: int
        array_stride: int
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Field`
            Component instance
        """
        assert isinstance(comp_def, comp.Reg)
        return self._instantiate_addressable(comp_def, inst_name, addr_offset, array_dimensions, array_stride, src_ref)

    def instantiate_regfile(self, comp_def: comp.Regfile, inst_name: str, addr_offset: int, array_dimensions: Optional[List[int]] = None, array_stride: Optional[int] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Regfile:
        """
        Parameters
        ----------
        comp_def: :class:`comp.Regfile`
        inst_name: str
        addr_offset: int
        array_dimensions: int
        array_stride: int
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Field`
            Component instance
        """
        assert isinstance(comp_def, comp.Regfile)
        return self._instantiate_addressable(comp_def, inst_name, addr_offset, array_dimensions, array_stride, src_ref)

    def instantiate_addrmap(self, comp_def: comp.Addrmap, inst_name: str, addr_offset: int, array_dimensions: Optional[List[int]] = None, array_stride: Optional[int] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Addrmap:
        """
        Parameters
        ----------
        comp_def: :class:`comp.Addrmap`
        inst_name: str
        addr_offset: int
        array_dimensions: int
        array_stride: int
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Field`
            Component instance
        """
        assert isinstance(comp_def, comp.Addrmap)
        return self._instantiate_addressable(comp_def, inst_name, addr_offset, array_dimensions, array_stride, src_ref)

    def instantiate_mem(self, comp_def: comp.Mem, inst_name: str, addr_offset: int, array_dimensions: Optional[List[int]] = None, array_stride: Optional[int] = None, src_ref: Optional[SourceRefBase] = None) -> comp.Mem:
        """
        Parameters
        ----------
        comp_def: :class:`comp.Mem`
        inst_name: str
        addr_offset: int
        array_dimensions: int
        array_stride: int
        src_ref: :class:`~SourceRefBase`

        Returns
        -------
        :class:`~comp.Field`
            Component instance
        """
        assert isinstance(comp_def, comp.Mem)
        return self._instantiate_addressable(comp_def, inst_name, addr_offset, array_dimensions, array_stride, src_ref)

    #---------------------------------------------------------------------------
    def add_child(self, parent: comp.Component, child: comp.Component) -> None:
        """
        Add a child component instance to an existing parent definition or instance

        .. versionadded:: 1.16
        """
        bad = True
        if isinstance(parent, comp.Addrmap):
            if isinstance(child, comp.AddressableComponent):
                bad = False
        elif isinstance(parent, comp.Regfile):
            if isinstance(child, (comp.Regfile, comp.Reg)):
                bad = False
        elif isinstance(parent, comp.Mem):
            if isinstance(child, comp.Reg):
                bad = False
        elif isinstance(parent, comp.Reg):
            if isinstance(child, comp.Field):
                bad = False
        if bad:
            raise TypeError(f"Parent {repr(parent)} cannot be assigned child {repr(child)}")

        if not child.is_instance:
            raise ValueError("Child must be an instance if adding to a parent")

        parent.children.append(child)

    def assign_property(self, component: comp.Component, prop_name: str, value: Any, src_ref: Optional[SourceRefBase] = None) -> None:
        """
        Assign a property to a component.

        Parameters
        ----------
        prop_name: str
            Name of the SystemRDL property
        value:
            Value to assign
        src_ref: :class:`~SourceRefBase`
            Optionally provide a more detailed source reference object associated
            with this assignment
        """

        rule = self.compiler.env.property_rules.lookup_property(prop_name)
        if rule is None:
            raise ValueError(f"Unrecognized property '{prop_name}'")
        if isinstance(value, comp.Component):
            # Warn user that this is not how references work
            raise TypeError("Invalid assignment type")
        src_ref = src_ref or self.default_src_ref
        rule.assign_value(component, value, src_ref)

    def register_root_component(self, definition: comp.Component) -> None:
        """
        Register a component definition with the root namespace so that it is
        visible to other compiled files.

        Parameters
        ----------
        definition: :class:`comp.Component`
            Component definition to register

        """
        if definition.type_name is None:
            raise ValueError("Component must have a type_name")

        if definition.is_instance:
            raise ValueError("Component cannot already be instantiated")

        if len(self.compiler.namespace.type_ns_stack) != 1:
            raise RuntimeError("Namespace was not properly reset to root scope")

        # Register with namespace
        self.compiler.namespace.register_type(
            definition.type_name,
            definition,
            definition.def_src_ref
        )

        # Add to root component definition list
        self.compiler.root.comp_defs[definition.type_name] = definition

    def lookup_root_component(self, type_name: str) -> Optional[comp.Component]:
        """
        Lookup a component definition from the root namespace. If the type name
        is not defined, returns ``None``
        """
        return self.compiler.root.comp_defs.get(type_name, None)
