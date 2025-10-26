import os
import re
from typing import Optional

import jinja2 as jj
from systemrdl.node import RootNode, Node, RegNode, AddrmapNode, RegfileNode
from systemrdl.node import FieldNode, MemNode, AddressableNode
from systemrdl.rdltypes import AccessType, OnReadType, OnWriteType
from systemrdl.component import Root
from systemrdl import RDLWalker

from .pre_export_listener import PreExportListener

class UVMExporter:

    def __init__(self, **kwargs):
        """
        Constructor for the UVM Exporter class

        Parameters
        ----------
        user_template_dir: str
            Path to a directory where user-defined template overrides are stored.
        user_template_context: dict
            Additional context variables to load into the template namespace.
        """
        user_template_dir = kwargs.pop("user_template_dir", None)
        self.user_template_context = kwargs.pop("user_template_context", {})

        # Check for stray kwargs
        if kwargs:
            raise TypeError("got an unexpected keyword argument '%s'" % list(kwargs.keys())[0])

        if user_template_dir:
            loader = jj.ChoiceLoader([
                jj.FileSystemLoader(user_template_dir),
                jj.FileSystemLoader(os.path.join(os.path.dirname(__file__), "templates")),
                jj.PrefixLoader({
                    'user': jj.FileSystemLoader(user_template_dir),
                    'base': jj.FileSystemLoader(os.path.join(os.path.dirname(__file__), "templates"))
                }, delimiter=":")
            ])
        else:
            loader = jj.ChoiceLoader([
                jj.FileSystemLoader(os.path.join(os.path.dirname(__file__), "templates")),
                jj.PrefixLoader({
                    'base': jj.FileSystemLoader(os.path.join(os.path.dirname(__file__), "templates"))
                }, delimiter=":")
            ])

        self.jj_env = jj.Environment(
            loader=loader,
            undefined=jj.StrictUndefined
        )

        # Define variables used during export

        # Top-level node
        self.top = None

        # Dictionary of group-like nodes (addrmap, regfile) and their bus
        # widths.
        # key = node path
        # value = max accesswidth/memwidth used in node's descendants
        self.bus_width_db = {}

        # Dictionary of root-level type definitions
        # key = definition type name
        # value = representative object
        #   components, this is the original_def (which can be None in some cases)
        self.namespace_db = {}

        self.reuse_class_definitions = True


    def export(self, node: Node, path: str, **kwargs):
        """
        Perform the export!

        Parameters
        ----------
        node: systemrdl.Node
            Top-level node to export. Can be the top-level `RootNode` or any
            internal `AddrmapNode`.
        path: str
            Output file.
        export_as_package: bool
            If True (Default), UVM register model is exported as a SystemVerilog
            package. Package name is based on the output file name.

            If False, register model is exported as an includable header.
        reuse_class_definitions: bool
            If True (Default), exporter attempts to re-use class definitions
            where possible. Class names are based on the lexical scope of the
            original SystemRDL definitions.

            If False, class definitions are not reused. Class names are based on
            the instance's hierarchical path.
        use_uvm_factory: bool
            If True, class definitions and class instances are created using the
            UVM factory.

            If False (Default), UVM factory is disabled. Classes are created
            directly via new() constructors.
        """
        export_as_package = kwargs.pop("export_as_package", True)
        use_uvm_factory = kwargs.pop("use_uvm_factory", False)
        self.reuse_class_definitions = kwargs.pop("reuse_class_definitions", True)

        # Check for stray kwargs
        if kwargs:
            raise TypeError("got an unexpected keyword argument '%s'" % list(kwargs.keys())[0])

        # If it is the root node, skip to top addrmap
        if isinstance(node, RootNode):
            node = node.top
        self.top = node

        if isinstance(node, AddrmapNode) and node.get_property('bridge'):
            node.env.msg.warning(
                "UVM RAL generator does not have proper support for bridge addmaps yet. The 'bridge' property will be ignored.",
                node.inst.property_src_ref.get('bridge', node.inst.inst_src_ref)
            )

        # First, traverse the model and collect some information
        self.bus_width_db = {}
        RDLWalker().walk(self.top, PreExportListener(self))

        context = {
            'top_node': node,
            'RegNode': RegNode,
            'RegfileNode': RegfileNode,
            'AddrmapNode': AddrmapNode,
            'MemNode': MemNode,
            'AddressableNode': AddressableNode,
            'isinstance': isinstance,
            'class_needs_definition': self._class_needs_definition,
            'get_class_name': self._get_class_name,
            'get_class_friendly_name': self._get_class_friendly_name,
            'get_inst_name': self._get_inst_name,
            'get_field_access': self._get_field_access,
            'get_array_address_offset_expr': self._get_array_address_offset_expr,
            'get_endianness': self._get_endianness,
            'get_bus_width': self._get_bus_width,
            'get_mem_access': self._get_mem_access,
            'roundup_to': self._roundup_to,
            'roundup_pow2': self._roundup_pow2,
            'use_uvm_factory': use_uvm_factory,
        }

        context.update(self.user_template_context)

        if export_as_package:
            context['package_name'] = self._get_package_name(path)
            template = self.jj_env.get_template("top_pkg.sv")
        else:
            context['include_guard'] = self._get_include_guard(path)
            template = self.jj_env.get_template("top_include.svh")
        stream = template.stream(context)
        stream.dump(path)


    def _get_package_name(self, path: str) -> str:
        s = os.path.splitext(os.path.basename(path))[0]
        s = re.sub(r'[^\w]', "_", s)
        return s


    def _get_include_guard(self, path: str) -> str:
        s = os.path.basename(path)
        s = re.sub(r'[^\w]', "_", s).upper()
        return s


    def _get_class_name_new(self, node: Node) -> str:
        """
        Returns the class type name.
        Shall be unique enough to prevent type name collisions
        """
        if self.reuse_class_definitions:
            pass
        else:
            class_name = node.get_rel_path(
                self.top.parent,
                hier_separator="__", array_suffix="", empty_array_suffix=""
            )

        return class_name

    def _get_resolved_scope_path(self, node: Node, separator:str = "::") -> Optional[str]:
        """
        Returns the scope path, but with resolved type names
        Returns None if any segment in the path is unknown
        """

        if node.inst.parent_scope is None:
            # Scope information is not known
            return None

        if isinstance(node.inst.parent_scope, Root):
            # Declaration of this was in the root scope
            return node.type_name

        # Due to namespace nesting properties, it is guaranteed that the parent
        # scope definition is also going to be one of the node's ancestors.
        # Seek up and find it
        current_parent_node = node.parent

        while current_parent_node:
            if current_parent_node.inst.original_def is None:
                # Original def reference is unknown
                return None
            if current_parent_node.inst.original_def is node.inst.parent_scope:
                # Parent node's definition matches the scope we're looking for
                parent_scope_path = self._get_resolved_scope_path(current_parent_node, separator)
                if (parent_scope_path is None) or (node.type_name is None):
                    return None
                return parent_scope_path + separator + node.type_name

            current_parent_node = current_parent_node.parent

        # Failed to find the path
        return None

    def _get_class_name(self, node: Node) -> str:
        """
        Returns the class type name.
        Shall be unique enough to prevent type name collisions
        """
        if self.reuse_class_definitions:
            scope_path = self._get_resolved_scope_path(node, "__")

            if scope_path is not None:
                class_name = scope_path
            else:
                # Unable to determine a reusable type name. Fall back to hierarchical path
                class_name = node.get_rel_path(
                    self.top.parent,
                    hier_separator="__", array_suffix="", empty_array_suffix=""
                )
                # Add prefix to prevent collision when mixing namespace methods
                class_name = "xtern__" + class_name
        else:
            class_name = node.get_rel_path(
                self.top.parent,
                hier_separator="__", array_suffix="", empty_array_suffix=""
            )

        return class_name


    def _get_class_friendly_name(self, node: Node) -> str:
        """
        Returns a useful string that helps identify the class definition in
        a comment
        """
        if self.reuse_class_definitions:
            scope_path = self._get_resolved_scope_path(node)

            if scope_path is not None:
                friendly_name = scope_path
            else:
                # Unable to determine a reusable type name. Fall back to hierarchical path
                friendly_name = node.get_rel_path(self.top.parent)
        else:
            friendly_name = node.get_rel_path(self.top.parent)

        return type(node.inst).__name__ + " - " + friendly_name


    def _get_inst_name(self, node: Node) -> str:
        """
        Returns the class instance name
        """
        return node.inst_name


    def _class_needs_definition(self, node: Node) -> bool:
        """
        Checks if the class that defines this node already exists.
        If not, returns True, indicating that a definition shall be emitted.

        If returning True, then the act of calling this function also registers
        the class definition into the namespace database so that future calls
        for equivalent node types will return False
        """
        type_name = self._get_class_name(node)

        if type_name in self.namespace_db:
            obj = self.namespace_db[type_name]

            # Sanity-check for collisions
            if (obj is None) or (obj is not node.inst.original_def):
                raise RuntimeError("Namespace collision! Type-name generation is not robust enough to create unique names!")

            # This object likely represents the existing class definition
            # Ok to omit the re-definition
            return False

        # Need to emit a new definition
        # First, register it in the namespace
        self.namespace_db[type_name] = node.inst.original_def
        return True


    def _get_field_access(self, field: FieldNode) -> str:
        """
        Get field's UVM access string
        """
        sw = field.get_property("sw")
        onread = field.get_property("onread")
        onwrite = field.get_property("onwrite")

        if sw == AccessType.rw:
            if (onwrite is None) and (onread is None):
                return "RW"
            elif (onread == OnReadType.rclr) and (onwrite == OnWriteType.woset):
                return "W1SRC"
            elif (onread == OnReadType.rclr) and (onwrite == OnWriteType.wzs):
                return "W0SRC"
            elif (onread == OnReadType.rclr) and (onwrite == OnWriteType.wset):
                return "WSRC"
            elif (onread == OnReadType.rset) and (onwrite == OnWriteType.woclr):
                return "W1CRS"
            elif (onread == OnReadType.rset) and (onwrite == OnWriteType.wzc):
                return "W0CRS"
            elif (onread == OnReadType.rset) and (onwrite == OnWriteType.wclr):
                return "WCRS"
            elif onwrite == OnWriteType.woclr:
                return "W1C"
            elif onwrite == OnWriteType.woset:
                return "W1S"
            elif onwrite == OnWriteType.wot:
                return "W1T"
            elif onwrite == OnWriteType.wzc:
                return "W0C"
            elif onwrite == OnWriteType.wzs:
                return "W0S"
            elif onwrite == OnWriteType.wzt:
                return "W0T"
            elif onwrite == OnWriteType.wclr:
                return "WC"
            elif onwrite == OnWriteType.wset:
                return "WS"
            elif onread == OnReadType.rclr:
                return "WRC"
            elif onread == OnReadType.rset:
                return "WRS"
            else:
                return "RW"

        elif sw == AccessType.r:
            if onread is None:
                return "RO"
            elif onread == OnReadType.rclr:
                return "RC"
            elif onread == OnReadType.rset:
                return "RS"
            else:
                return "RO"

        elif sw == AccessType.w:
            if onwrite is None:
                return "WO"
            elif onwrite == OnWriteType.wclr:
                return "WOC"
            elif onwrite == OnWriteType.wset:
                return "WOS"
            else:
                return "WO"

        elif sw == AccessType.rw1:
            return "W1"

        elif sw == AccessType.w1:
            return "WO1"

        else: # na
            return "NOACCESS"


    def _get_mem_access(self, mem: MemNode) -> str:
        sw = mem.get_property("sw")
        if sw == AccessType.r:
            return "RO"
        else:
            return "RW"


    def _get_array_address_offset_expr(self, node: AddressableNode) -> str:
        """
        Returns an expression to calculate the address offset
        for example, a 4-dimensional array allocated as:
            [A][B][C][D] @ X += Y
        results in:
            X + i0*B*C*D*Y + i1*C*D*Y + i2*D*Y + i3*Y
        """
        s = "'h%x" % node.raw_address_offset
        if node.is_array:
            for i in range(len(node.array_dimensions)):
                m = node.array_stride
                for j in range(i+1, len(node.array_dimensions)):
                    m *= node.array_dimensions[j]
                s += " + i%d*'h%x" % (i, m)
        return s


    def _get_endianness(self, node: Node) -> str:
        amap = node.owning_addrmap
        if amap.get_property("bigendian"):
            return "UVM_BIG_ENDIAN"
        elif amap.get_property("littleendian"):
            return "UVM_LITTLE_ENDIAN"
        else:
            return "UVM_NO_ENDIAN"


    def _get_bus_width(self, node: Node) -> int:
        """
        Returns group-like node's bus width (in bytes)
        """
        width = self.bus_width_db[node.get_path()]

        # Divide by 8, rounded up
        if width % 8:
            return width // 8 + 1
        else:
            return width // 8


    def _roundup_to(self, x: int, n: int) -> int:
        """
        Round x up to the nearest n
        """
        if x % n:
            return (x//n + 1) * n
        else:
            return (x//n) * n


    def _roundup_pow2(self, x):
        return 1<<(x-1).bit_length()
