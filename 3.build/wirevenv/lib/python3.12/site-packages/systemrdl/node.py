import re
import itertools
from copy import deepcopy, copy
from collections import deque, OrderedDict
from typing import TYPE_CHECKING, Optional, Iterator, Any, List, Tuple, Dict
from typing import Sequence, Union, overload, TypeVar, Type

from typing_extensions import Literal

from . import component as comp
from . import rdltypes
from .core import rdlformatcode, helpers

if TYPE_CHECKING:
    from .compiler import RDLEnvironment
    from .source_ref import SourceRefBase
    from markdown import Markdown

T = TypeVar("T")

class Node:
    """
    The Node class is the base for all Node overlay classes.
    """

    def __init__(self, inst: comp.Component, env: 'RDLEnvironment', parent: Optional['Node']) -> None:
        # Generic Node constructor.
        # Do not call directly. Use factory() static method instead
        self.env = env

        #: Reference to :class:`~systemrdl.component.Component` data object.
        #:
        #: .. deprecated:: 1.30
        #:   Querying the internal ``Component`` objects is no longer recommended.
        #:
        #:   Equivalents for most concepts have been made available as direct
        #:   methods or properties of :class:`Node` objects. It is strongly
        #:   recommended to use these instead to prevent compatibility issues.
        self.inst = inst

        #: Reference to parent :class:`~Node`
        self.parent = parent

    def __repr__(self) -> str:
        return f"<{self.__class__.__qualname__} {self.get_path()} at {id(self):#x}>"


    def __deepcopy__(self, memo: Dict[int, Any]) -> 'Node':
        """
        Deepcopy the node overlay.
        Members that are not part of the overlay (component tree) are not
        deepcopied.

        .. versionadded:: 1.8
        """
        copy_by_ref = {"inst", "env"}
        cls = self.__class__
        result = cls.__new__(cls)
        memo[id(self)] = result
        for k, v in self.__dict__.items():
            if k in copy_by_ref:
                setattr(result, k, v)
            else:
                setattr(result, k, deepcopy(v, memo))
        return result

    @overload
    @staticmethod
    def _factory(inst: comp.Field, env: 'RDLEnvironment', parent: Optional['Node']) -> 'FieldNode': ...

    @overload
    @staticmethod
    def _factory(inst: comp.Reg, env: 'RDLEnvironment', parent: Optional['Node']) -> 'RegNode': ...

    @overload
    @staticmethod
    def _factory(inst: comp.Regfile, env: 'RDLEnvironment', parent: Optional['Node']) -> 'RegfileNode': ...

    @overload
    @staticmethod
    def _factory(inst: comp.Addrmap, env: 'RDLEnvironment', parent: Optional['Node']) -> 'AddrmapNode': ...

    @overload
    @staticmethod
    def _factory(inst: comp.Mem, env: 'RDLEnvironment', parent: Optional['Node']) -> 'MemNode': ...

    @overload
    @staticmethod
    def _factory(inst: comp.Signal, env: 'RDLEnvironment', parent: Optional['Node']) -> 'SignalNode': ...

    @overload
    @staticmethod
    def _factory(inst: comp.AddressableComponent, env: 'RDLEnvironment', parent: Optional['Node']) -> 'AddressableNode': ...

    @overload
    @staticmethod
    def _factory(inst: comp.Component, env: 'RDLEnvironment', parent: Optional['Node']) -> 'Node': ...

    @staticmethod
    def _factory(inst: comp.Component, env: 'RDLEnvironment', parent: Optional['Node']=None) -> 'Node':
        if isinstance(inst, comp.Field):
            return FieldNode(inst, env, parent)
        elif isinstance(inst, comp.Reg):
            return RegNode(inst, env, parent)
        elif isinstance(inst, comp.Regfile):
            return RegfileNode(inst, env, parent)
        elif isinstance(inst, comp.Addrmap):
            return AddrmapNode(inst, env, parent)
        elif isinstance(inst, comp.Mem):
            return MemNode(inst, env, parent)
        elif isinstance(inst, comp.Signal):
            return SignalNode(inst, env, parent)
        else:
            raise RuntimeError


    def unrolled(self) -> Iterator['Node']:
        """
        Returns an iterator that provides unrolled nodes for this instance

        Yields
        ------
        :class:`~Node`
            Unrolled array dimensions

        .. versionadded:: 1.20.0
        """
        if isinstance(self, AddressableNode) and self.array_dimensions: # pylint: disable=no-member
            cls = type(self)

            # Is an array. Yield a Node object for each instance
            range_list = [range(n) for n in self.array_dimensions] # pylint: disable=no-member
            for idxs in itertools.product(*range_list):
                N = cls(self.inst, self.env, self.parent)
                N.current_idx = list(idxs)
                yield N
        else:
            cls2 = type(self)
            # not an array. Nothing to unroll
            yield cls2(self.inst, self.env, self.parent)


    def children(self, unroll: bool=False, skip_not_present: bool=True) -> List['Node']:
        """
        Returns a list of all immediate children of this component.

        Parameters
        ----------
        unroll : bool
            If True, any children that are arrays are unrolled.

        skip_not_present : bool
            If True, skips children whose 'ispresent' property is set to False

        Returns
        -------
        List of :class:`Node`
            All immediate children


        .. versionchanged:: 1.29
            Returns list instead of generator
        """
        children: List[Node] = []
        for child_inst in self.inst.children:
            if skip_not_present:
                # Check if property ispresent == False
                if not child_inst.properties.get('ispresent', True):
                    # ispresent was explicitly set to False. Skip it
                    continue

            if unroll and isinstance(child_inst, comp.AddressableComponent) and child_inst.array_dimensions:
                # Unroll the array
                range_list = [range(n) for n in child_inst.array_dimensions]
                for idxs in itertools.product(*range_list):
                    N = Node._factory(child_inst, self.env, self)
                    N.current_idx = list(idxs) # pylint: disable=attribute-defined-outside-init
                    children.append(N)
            else:
                children.append(Node._factory(child_inst, self.env, self))
        return children


    def descendants(self, unroll: bool=False, skip_not_present: bool=True, in_post_order: bool=False) -> Iterator['Node']:
        """
        Returns an iterator that provides nodes for all descendants of this
        component.

        Parameters
        ----------
        unroll : bool
            If True, any children that are arrays are unrolled.

        skip_not_present : bool
            If True, skips children whose 'ispresent' property is set to False

        in_post_order : bool
            If True, descendants are walked using post-order traversal
            (children first) rather than the default pre-order traversal
            (parents first).

        Yields
        ------
        :class:`~Node`
            All descendant nodes of this component
        """
        for child in self.children(unroll, skip_not_present):
            if in_post_order:
                yield from child.descendants(unroll, skip_not_present, in_post_order)

            yield child

            if not in_post_order:
                yield from child.descendants(unroll, skip_not_present, in_post_order)


    def signals(self, skip_not_present: bool=True) -> List['SignalNode']:
        """
        Returns a list of all immediate signals of this component.

        Parameters
        ----------
        skip_not_present : bool
            If True, skips children whose 'ispresent' property is set to False

        Returns
        -------
        :class:`~SignalNode`
            All signals in this component


        .. versionchanged:: 1.29
            Returns list instead of generator
        """
        children = []
        for child in self.children(skip_not_present=skip_not_present):
            if isinstance(child, SignalNode):
                children.append(child)
            else:
                # Optimization.
                # children are sorted so signals are always first.
                # If encountered a non-signal, no reason to continue iterating
                break
        return children


    def registers(self, unroll: bool=False, skip_not_present: bool=True) -> List['RegNode']:
        """
        Returns a list of all immediate registers of this component.

        Parameters
        ----------
        unroll : bool
            If True, any children that are arrays are unrolled.

        skip_not_present : bool
            If True, skips children whose 'ispresent' property is set to False

        Returns
        -------
        :class:`~RegNode`
            All registers in this component


        .. versionchanged:: 1.29
            Returns list instead of generator
        """
        children = []
        for child in self.children(unroll, skip_not_present):
            if isinstance(child, RegNode):
                children.append(child)
        return children


    @property
    def owning_addrmap(self) -> Optional['AddrmapNode']:
        """
        Returns the enclosing addrmap that owns this node.

        If this node is already an addrmap, returns itself

        If not enclosed in an addrmap, returns None

        .. versionadded:: 1.12
        """
        if isinstance(self, AddrmapNode):
            return self
        elif isinstance(self, RootNode):
            return None
        else:
            assert self.parent is not None
            return self.parent.owning_addrmap


    def get_child_by_name(self, inst_name: str) -> Optional['Node']:
        """
        Returns an immediate child :class:`~Node` whose instance name matches ``inst_name``

        Returns ``None`` if ``inst_name`` does not match

        Parameters
        ----------
        inst_name: str
            Name of immediate child to get

        Returns
        -------
        :class:`~Node` or None
            Child Node. None if not found.
        """
        child_inst = self.inst.get_child_by_name(inst_name)
        if child_inst is None:
            return None
        return Node._factory(child_inst, self.env, self)


    def find_by_path(self, path: str) -> Optional['Node']:
        """
        Finds the descendant node that is located at the relative path
        Returns ``None`` if not found
        Raises exception if path is malformed, or array index is out of range

        Parameters
        ----------
        path: str
            Path to target relative to current node

        Returns
        -------
        :class:`~Node` or None
            Descendant Node. None if not found.

        Raises
        ------
        ValueError
            If path syntax is invalid
        IndexError
            If an array index in the path is invalid
        """
        pathparts = path.split('.')
        current_node: Optional[Node] = self
        assert current_node is not None

        for pathpart in pathparts:
            # If parent reference, jump upwards
            if pathpart == "^":
                if current_node.parent:
                    current_node = current_node.parent
                continue

            # .. otherwise continue parsing the path
            m = re.fullmatch(r'^(\w+)((?:\[(?:\d+|0[xX][\da-fA-F]+)\])*)$', pathpart)
            if not m:
                raise ValueError("Invalid path")
            inst_name, array_suffix = m.group(1, 2)
            idx_list = [int(s, 0) for s in re.findall(r'\[(\d+|0[xX][\da-fA-F]+)\]', array_suffix)]

            current_node = current_node.get_child_by_name(inst_name)
            if current_node is None:
                return None

            if idx_list:
                if not isinstance(current_node, AddressableNode):
                    raise IndexError("Index attempted on unindexable component")

                if current_node.inst.array_dimensions:
                    # is an array
                    if len(idx_list) != len(current_node.inst.array_dimensions):
                        raise IndexError("Wrong number of array dimensions")

                    current_node.current_idx = [] # pylint: disable=attribute-defined-outside-init
                    for i, idx in enumerate(idx_list):
                        if idx >= current_node.inst.array_dimensions[i]:
                            raise IndexError("Array index out of range")
                        current_node.current_idx.append(idx)
                else:
                    raise IndexError("Index attempted on non-array component")

        return current_node

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        """
        Gets the SystemRDL component property

        If a property was not explicitly set in the RDL source, its default
        value is derived. In some cases, a default value is implied according to
        other property values.

        Properties values that are a reference to a component instance are
        converted to a :class:`~Node` overlay object.

        Parameters
        ----------
        prop_name: str
            SystemRDL property name
        default:
            Override built-in default value of property.
            If the property was not explicitly set, return this value rather than
            the property's intrinsic default value.

        Raises
        ------
        LookupError
            If prop_name is invalid
        """
        ovr_default = False
        default = None
        if 'default' in kwargs:
            ovr_default = True
            default = kwargs.pop('default')

        # Check for stray kwargs
        if kwargs:
            raise TypeError(f"got an unexpected keyword argument '{list(kwargs.keys())[0]}'")

        if prop_name not in self.inst.properties:
            # Was not assigned by the user
            if ovr_default:
                # Default value is being overridden by user. Return their value
                return default

            # Otherwise, return its default value based on the property's rules
            rule = self.env.property_rules.lookup_property(prop_name, include_soft_udp=True)

            # Is it even a valid property or allowed for this component type?
            if rule is None:
                raise LookupError(f"Unknown property '{prop_name}'")
            if type(self.inst) not in rule.bindable_to:
                raise LookupError(f"Unknown property '{prop_name}'")

            # Return the default value as specified by the rulebook
            return rule.get_default(self)

        # Property WAS indeed assigned by the user
        prop_value = self.inst.properties[prop_name]

        if isinstance(prop_value, (rdltypes.BuiltinEnum, str, int)):
            # Optimization: Exit early to skip comparisons for popular simple return types
            return prop_value
        if isinstance(prop_value, rdltypes.ComponentRef):
            # If this is a hierarchical component reference, convert it to a Node reference
            return prop_value.build_node_ref(self)
        if isinstance(prop_value, rdltypes.PropertyReference):
            return prop_value.get_resolved_ref(self)
        if isinstance(prop_value, list):
            # Inspect array and resolve any references
            return rdltypes.references.resolve_node_refs_in_array(self, prop_value)
        if rdltypes.is_user_struct(type(prop_value)):
            return rdltypes.references.resolve_node_refs_in_struct(self, prop_value)

        return prop_value



    def list_properties(self, list_all: bool=False, include_native: bool=True, include_udp: bool=True) -> List[str]:
        """
        Lists properties associated with this node.
        By default, only lists properties that were explicitly set. If ``list_all`` is
        set to ``True`` then lists all valid properties of this component type

        Parameters
        ----------
        list_all: bool
            If true, lists all valid properties of this component type.
        include_native: bool
            If set to false, does not list native SystemRDL properties in the output.
        include_udp: bool
            If set to false, does not list user-defined properties in the output.


        .. versionchanged:: 1.12
            Added ``include_native`` and ``include_udp`` options.
        """

        # Importing here to avoid a circular import
        from .properties.user_defined import ExternalUserProperty # pylint: disable=import-outside-toplevel

        if list_all:
            props = []
            if include_native:
                for k, v in self.env.property_rules.rdl_properties.items():
                    if type(self.inst) in v.bindable_to:
                        props.append(k)
            if include_udp:
                for k, v in self.env.property_rules.user_properties.items():
                    if isinstance(v, ExternalUserProperty) and v.is_soft:
                        continue
                    if type(self.inst) in v.bindable_to:
                        props.append(k)
            return props
        else:
            if include_native and include_udp:
                return list(self.inst.properties.keys())
            else:
                props = []
                for prop_name in self.inst.properties.keys():
                    if include_native and prop_name in self.env.property_rules.rdl_properties:
                        props.append(prop_name)
                    if include_udp and prop_name in self.env.property_rules.user_properties:
                        props.append(prop_name)
                return props


    def get_path_segment(self, array_suffix: str="[{index:d}]", empty_array_suffix: str="[]") -> str:
        """
        Gets the hierarchical path segment for just this node. This includes the
        instance name and any array suffixes.

        Parameters
        ----------
        array_suffix: str
            Override how array suffixes are represented when the index is known
        empty_array_suffix: str
            Override how array suffixes are represented when the index is not known
        """
        # pylint: disable=unused-argument
        assert self.inst.inst_name is not None
        return self.inst.inst_name


    def get_path_segments(self, array_suffix: str="[{index:d}]", empty_array_suffix: str="[]") -> List[str]:
        """
        Gets a list of path segments that represent the hierarchical path.

        .. versionadded:: 1.8
        """
        if self.parent and not isinstance(self.parent, RootNode):
            segs = self.parent.get_path_segments(array_suffix, empty_array_suffix)
            segs.append(self.get_path_segment(array_suffix, empty_array_suffix))
        elif not isinstance(self, RootNode):
            segs = [self.get_path_segment(array_suffix, empty_array_suffix)]
        else:
            segs = []
        return segs


    def get_path(self, hier_separator: str=".", array_suffix: str="[{index:d}]", empty_array_suffix: str="[]") -> str:
        """
        Generate an absolute path string to this node

        Parameters
        ----------
        hier_separator: str
            Override the hierarchy separator
        array_suffix: str
            Override how array suffixes are represented when the index is known.

            The suffix is processed using
            `string.format() <https://docs.python.org/3/library/string.html#string.Formatter.format>`_
            with the following available kwargs:

            * ``index``: The current array index
            * ``dim``: The number of elements in the array dimension

        empty_array_suffix: str
            Override how array suffixes are represented when the index is not known.

            The suffix is processed using
            `string.format() <https://docs.python.org/3/library/string.html#string.Formatter.format>`_
            with the following available kwargs:

            * ``dim``: The number of elements in the array dimension


        .. versionchanged:: 1.17
            Added ``dim`` kwarg to suffix formatting.
        """
        segs = self.get_path_segments(array_suffix, empty_array_suffix)
        return hier_separator.join(segs)

    def get_scope_path(self, scope_separator: str="::") -> Optional[str]:
        """
        Generate a string that represents this component's declaration namespace
        scope.

        Returns ``None`` if scope is not known or not applicable.

        For example, the following SystemRDL snippet:

        .. code-block:: systemrdl

            reg my_reg_t {
                field {} x;
            };

            addrmap top {
                my_reg_t foo;
                reg my_other_reg_t {
                    field {} y;
                } bar;
                reg {
                    field {} z;
                } baz, xyz;
            };

        ... results in:

        * Field ``x`` of hierarchical path ``top.foo.x`` was declared in the
          lexical scope ``my_reg_t``
        * Field ``y`` of hierarchical path ``top.bar.y`` was declared in the
          lexical scope ``top::my_other_reg_t``
        * Both fields ``z`` of hierarchical paths ``top.baz.z`` and ``top.xyz.z``
          were declared in the same lexical scope ``top::baz``
        * Register ``foo`` was declared in the root scope which is represented
          by an empty string.

        Parameters
        ----------
        scope_separator: str
            Override the separator between namespace scopes

        .. versionadded:: 1.30
        """
        return self.inst.get_scope_path(scope_separator)


    def get_rel_path(self, ref: 'Node', uplevel: str="^", hier_separator: str=".", array_suffix: str="[{index:d}]", empty_array_suffix: str="[]") -> str:
        """
        Generate a relative path string to this node with respect to a reference node.

        A reference to a descendant node::

            foo.bar->foo.bar.baz.abcd = "baz.abcd"

        Relative path that traverses upwards::

            foo.bar.baz->foo.abc.def = "^.^.abc.def"

        Relative path to self results in an empty string::

            foo.bar.baz->foo.bar.baz = ""

        Paths between array nodes with/without indexes will result in upwards paths::

            foo.array[].baz->foo.array[0].baz = "^.^.array[0].baz"
            foo.array[0].baz->foo.array[].baz = "^.^.array[].baz"

        Parameters
        ----------
        ref: Node
            Reference starting point node
        uplevel: str
            Override the string that denotes traversing up by one parent
        hier_separator: str
            Override the hierarchy separator
        array_suffix: str
            Override how array suffixes are represented when the index is known
        empty_array_suffix: str
            Override how array suffixes are represented when the index is not known


        .. versionadded:: 1.8
        """

        # Collect path segments using default args to ensure paths can be compared
        ref_segs = deque(ref.get_path_segments())
        self_segs = deque(self.get_path_segments())

        # collect segments as-specified by the user
        self_segs_fmt = deque(self.get_path_segments(array_suffix, empty_array_suffix))

        # 1. pop off all common segments from front of both ref_segs and self_segs
        #   also pop off self_segs_fmt
        while ref_segs and self_segs and (ref_segs[0] == self_segs[0]):
            ref_segs.popleft()
            self_segs.popleft()
            self_segs_fmt.popleft()

        # 2. length of ref_segs remaining is how many uplevels needed
        self_segs_fmt.extendleft([uplevel] * len(ref_segs))

        # 3. remaining segments in self_segs_fmt is the rest of the path
        return hier_separator.join(self_segs_fmt)


    def get_html_desc(self, markdown_inst: Optional['Markdown']=None) -> Optional[str]:
        """
        Translates the node's 'desc' property into HTML.

        Any RDLFormatCode tags used are converted to HTML.
        The text is also fed through a Markdown processor.

        The additional Markdown processing allows designers the choice to use a
        more modern lightweight markup language as an alternative to SystemRDL's
        "RDLFormatCode".

        Parameters
        ----------
        markdown_inst: ``markdown.Markdown``
            Override the class instance of the Markdown processor.
            See the `Markdown module <https://python-markdown.github.io/reference/#Markdown>`_
            for more details.

        Returns
        -------
        str or None
            HTML formatted string.
            If node does not have a description, returns ``None``


        .. versionchanged:: 1.6
            Added ``markdown_inst`` option.
        """
        desc_str = self.get_property('desc')
        if desc_str is None:
            return None
        return rdlformatcode.rdlfc_to_html(desc_str, self, md=markdown_inst)


    def get_html_name(self) -> Optional[str]:
        """
        Translates the node's 'name' property into HTML.

        Any RDLFormatCode tags used are converted to HTML.

        Returns
        -------
        str or None
            HTML formatted string.
            If node does not have an explicitly set name, returns ``None``


        .. versionadded:: 1.8
        """
        name_str = self.get_property('name', default=None)
        if name_str is None:
            return None
        return rdlformatcode.rdlfc_to_html(name_str, self, is_desc=False)


    @property
    def inst_name(self) -> str:
        """
        Name of instantiated element
        """
        assert self.inst.inst_name is not None
        return self.inst.inst_name

    @property
    def type_name(self) -> Optional[str]:
        """
        Named definition identifier.
        If declaration was anonymous, inherits the first instance's name.
        The type name of parameterized components is normalized based on the
        instance's parameter values.

        Importers may leave this as ``None``

        .. versionadded:: 1.9
        """
        return self.inst.type_name

    @property
    def orig_type_name(self) -> Optional[str]:
        """
        Named definition identifier prior to type name normalization.
        If the declaration was anonymous, this reads as None.

        .. versionadded:: 1.9
        """
        if self.inst.original_def is None:
            # Component originated from an external importer
            return None
        else:
            return self.inst.original_def.type_name

    def get_global_type_name(self, separator: str = "__") -> Optional[str]:
        """
        Returns a globally scoped type name that can be used to uniquely identify this
        node's type.

        If scope or type name information is not available due to the node being imported
        from a non-RDL source, this will return None.

        .. versionadded:: 1.27.0
        """

        if (self.type_name is None) or (self.inst.parent_scope is None):
            # Scope information is not known
            return None

        if isinstance(self.inst.parent_scope, comp.Root):
            # Declaration of this was in the root scope
            return self.type_name

        # Due to namespace nesting properties, it is guaranteed that the parent
        # scope definition is also going to be one of the node's ancestors.
        # Seek up and find it
        current_parent_node = self.parent
        while current_parent_node:
            if current_parent_node.inst.original_def is None:
                # Original def reference is unknown
                return None
            if current_parent_node.inst.original_def is self.inst.parent_scope:
                # Parent node's definition matches the scope we're looking for
                parent_scope_path = current_parent_node.get_global_type_name(separator)
                if parent_scope_path is None:
                    return None
                return parent_scope_path + separator + self.type_name

            current_parent_node = current_parent_node.parent

        # Failed to find the path
        return None

    @property
    def inst_src_ref(self) -> Optional['SourceRefBase']:
        """
        :ref:`api_src_ref` for the component instantiation.

        .. versionadded:: 1.30
        """
        return self.inst.inst_src_ref

    @property
    def def_src_ref(self) -> Optional['SourceRefBase']:
        """
        :ref:`api_src_ref` for the component definition.

        .. versionadded:: 1.30
        """
        return self.inst.def_src_ref

    @property
    def property_src_ref(self) -> Dict[str, 'SourceRefBase']:
        """
        :ref:`api_src_ref` for each explicit property assignment (if available)

        .. versionadded:: 1.30
        """
        return self.inst.property_src_ref

    @property
    def parameters(self) -> 'OrderedDict[str, Any]':
        """
        Returns a dictionary of the parameters of this component, and their final
        elaborated values.

        These are stored in the order that they were defined

        .. versionadded:: 1.30
        """
        param_values_dict = OrderedDict()
        for param_name, param in self.inst.parameters_dict.items():
            param_values_dict[param_name] = param.get_value()
        return param_values_dict

    @property
    def external(self) -> bool:
        """
        True if instance type is external. False if internal.

        .. versionadded:: 1.9
        """
        # Guaranteed after elaboration
        assert self.inst.external is not None

        return self.inst.external

    @property
    def cpuif_reset(self) -> 'Optional[SignalNode]':
        """
        Returns a reference to the nearest cpuif_reset signal in the enclosing
        hierarchy.

        Is None if no cpuif_reset signal was found.

        .. versionadded:: 1.19
        """
        current_node: Optional[Node] = self
        while current_node is not None:
            for signal in current_node.signals():
                if signal.get_property('cpuif_reset'):
                    return signal
            current_node = current_node.parent

        return None


    def __eq__(self, other: object) -> bool:
        """
        Node equality checks determine whether the other node represents the
        same position in the register model's hierarchy.
        """
        if not isinstance(other, Node):
            return NotImplemented
        return self.get_path() == other.get_path()

#===============================================================================
class AddressableNode(Node):
    """
    Inherits: :class:`Node`

    Base-class for any kind of node that can have an address
    """
    parent: Union['AddressableNode', 'RootNode']
    inst: comp.AddressableComponent

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str, **kwargs: Any)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        return super().get_property(prop_name, **kwargs)

    def __init__(self, inst: comp.AddressableComponent, env: 'RDLEnvironment', parent: Optional[Node]) -> None:
        super().__init__(inst, env, parent)

        #: List of current array indexes this node is referencing where the last
        #: item in this list iterates the most frequently
        #:
        #: If None, then the current index is unknown
        self.current_idx: Optional[List[int]] = None


    def get_path_segment(self, array_suffix: str="[{index:d}]", empty_array_suffix: str="[]") -> str:
        # Extends get_path_segment() in order to append any array suffixes
        path_segment = super().get_path_segment(array_suffix, empty_array_suffix)

        if self.array_dimensions:
            if self.current_idx is None:
                # Index is not known.
                for dim in self.array_dimensions:
                    path_segment += empty_array_suffix.format(dim=dim)
                return path_segment
            else:
                # Index list is known
                for idx, dim in zip(self.current_idx, self.array_dimensions):
                    path_segment += array_suffix.format(index=idx, dim=dim)
                return path_segment
        else:
            return path_segment


    def clear_lineage_index(self) -> None:
        """
        Resets this node's, as well as all parent node array indexes to
        the 'unknown index' state.

        .. versionadded:: 1.7
        """
        if self.is_array:
            self.current_idx = None

        if isinstance(self.parent, AddressableNode):
            self.parent.clear_lineage_index()


    def zero_lineage_index(self) -> None:
        """
        Resets this node's, as well as all parent node array indexes to
        zero.

        .. versionadded:: 1.7
        """
        if self.array_dimensions:
            self.current_idx = [0] * len(self.array_dimensions)

        if isinstance(self.parent, AddressableNode):
            self.parent.zero_lineage_index()


    @property
    def raw_address_offset(self) -> int:
        """
        Raw byte address offset of the first array element node relative to
        its parent.

        If this node is not an array, then this is equivalent to
        :attr:`address_offset`

        """
        assert self.inst.addr_offset is not None
        return self.inst.addr_offset


    @property
    def address_offset(self) -> int:
        """
        Byte address offset of this node relative to its parent

        If this node is an array, its index must be known

        Raises
        ------
        ValueError
            If this property is referenced on a node whose array index is not
            fully defined
        """
        if self.array_dimensions:
            assert self.array_stride is not None
            if self.current_idx is None:
                raise ValueError("Index of array element must be known to derive address")

            # Calculate the "flattened" index of a general multidimensional array
            # For example, a component array declared as:
            #   foo[S0][S1][S2]
            # and referenced as:
            #   foo[I0][I1][I2]
            # Is flattened like this:
            #   idx = I0*S1*S2 + I1*S2 + I2
            idx = 0
            for i, current_idx in enumerate(self.current_idx):
                sz = 1
                for j in range(i + 1, len(self.array_dimensions)):
                    sz *= self.array_dimensions[j]
                idx += sz * current_idx

            offset = self.raw_address_offset + idx * self.array_stride

        else:
            offset = self.raw_address_offset

        return offset


    @property
    def raw_absolute_address(self) -> int:
        """
        Get the absolute byte address of this node excluding array stride of
        all parent.

        If this node, and all parents are not an array, then this is equivalent
        to :attr:`absolute_address`

        .. versionadded:: 1.7
        """
        if self.parent and not isinstance(self.parent, RootNode):
            return self.parent.raw_absolute_address + self.raw_address_offset
        else:
            return self.raw_address_offset


    @property
    def absolute_address(self) -> int:
        """
        Get the absolute byte address of this node.

        Indexes of all arrays in the node's lineage must be known

        Raises
        ------
        ValueError
            If this property is referenced on a node whose array lineage is not
            fully defined

        """
        if self.parent and not isinstance(self.parent, RootNode):
            return self.parent.absolute_address + self.address_offset
        else:
            return self.address_offset


    @property
    def size(self) -> int:
        """
        Determine the size (in bytes) of this node.

        If an array, returns the size of a single element
        """
        # must be overridden
        raise NotImplementedError


    @property
    def total_size(self) -> int:
        """
        Determine the size (in bytes) of this node.
        If an array, returns size of the entire array
        """
        if self.is_array:
            assert self.array_stride is not None
            # RDL spec does not explicitly clarify this, but total size for arrays
            # should include any additional trailing padding implied by the stride.
            # This makes it consistent with IP-XACT.
            # See discussion here: https://forums.accellera.org/topic/7529-interpretation-of-total-array-size-implicit-address-allocation/
            return self.array_stride * self.n_elements

        else:
            return self.size


    @property
    def is_array(self) -> bool:
        """
        Indicates that this node represents an array of instances
        """
        return self.inst.is_array


    @property
    def array_dimensions(self) -> Optional[List[int]]:
        """
        List of sizes for each array dimension.
        Last item in the list iterates the most frequently.

        If node is not an array (``is_array == False``), then this is ``None``
        """
        return self.inst.array_dimensions


    @property
    def n_elements(self) -> int:
        """
        Total number of array elements.
        If array is multidimensional, array is flattened.
        Returns 1 if not an array.

        .. versionadded:: 1.30
        """
        return self.inst.n_elements


    @property
    def array_stride(self) -> Optional[int]:
        """
        Address offset between array elements.

        If node is not an array (``is_array == False``), then this is ``None``
        """
        return self.inst.array_stride

#===============================================================================
class VectorNode(Node):
    """
    Inherits: :class:`Node`

    Base-class for any kind of node that is vector-like.
    """
    parent: Node
    inst: comp.VectorComponent

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str, **kwargs: Any)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        return super().get_property(prop_name, **kwargs)

    @property
    def width(self) -> int:
        """
        Width of vector in bits
        """
        return self.inst.width

    @property
    def msb(self) -> int:
        """
        Bit position of most significant bit
        """
        return self.inst.msb

    @property
    def lsb(self) -> int:
        """
        Bit position of least significant bit
        """
        return self.inst.lsb

    @property
    def high(self) -> int:
        """
        High index of bit range
        """
        return self.inst.high

    @property
    def low(self) -> int:
        """
        Low index of bit range
        """
        return self.inst.low


#===============================================================================
class RootNode(Node):
    """
    Inherits: :class:`Node`

    Pseudo-node that represents the root namespace of a compiled design.

    This is does not represent any actual design hierarchy. It is merely a
    convenient container for the following children:

    * Zero or more :class:`SignalNode` that are instantiated in the root namespace
    * Exactly one top-level :class:`AddrmapNode`.

    """

    #: RootNode never has a parent, so this attribute is always None
    parent: None

    inst: comp.Root

    @property
    def top(self) -> 'AddrmapNode':
        """
        Returns the top-level addrmap node
        """
        for child in self.children(skip_not_present=False):
            if not isinstance(child, AddrmapNode):
                continue
            return child
        raise RuntimeError

#===============================================================================
class SignalNode(VectorNode):
    """
    Inherits: :class:`VectorNode`

    Represents an RDL ``signal``.
    """
    parent: Node
    inst: comp.Signal

    @overload # type: ignore[override]
    def get_property(self, prop_name: Literal["signalwidth"], *, default: T)-> Union[int, T]: ...

    @overload
    def get_property(self, prop_name: Literal["signalwidth"], **kwargs: Any)-> int: ...

    @overload
    def get_property(self, prop_name: Literal["sync"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["sync"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["async"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["async"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["cpuif_reset"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["cpuif_reset"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["field_reset"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["field_reset"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["activelow"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["activelow"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["activehigh"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["activehigh"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str, **kwargs: Any)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        return super().get_property(prop_name, **kwargs)

#===============================================================================
class FieldNode(VectorNode):
    """
    Inherits: :class:`VectorNode`

    Represents an RDL ``field``
    """
    parent: 'RegNode'
    inst: comp.Field

    @overload # type: ignore[override]
    def get_property(self, prop_name: Literal["dontcompare"], *, default: T)-> Union[Union[int, bool], T]: ...

    @overload
    def get_property(self, prop_name: Literal["dontcompare"], **kwargs: Any)-> Union[int, bool]: ...

    @overload
    def get_property(self, prop_name: Literal["donttest"], *, default: T)-> Union[Union[int, bool], T]: ...

    @overload
    def get_property(self, prop_name: Literal["donttest"], **kwargs: Any)-> Union[int, bool]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_slice"], *, default: T)-> Union[Optional[List[str]], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_slice"], **kwargs: Any)-> Optional[List[str]]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate_slice"], *, default: T)-> Union[Optional[List[str]], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate_slice"], **kwargs: Any)-> Optional[List[str]]: ...

    @overload
    def get_property(self, prop_name: Literal["hw"], *, default: T)-> Union['rdltypes.AccessType', T]: ...

    @overload
    def get_property(self, prop_name: Literal["hw"], **kwargs: Any)-> 'rdltypes.AccessType': ...

    @overload
    def get_property(self, prop_name: Literal["sw"], *, default: T)-> Union['rdltypes.AccessType', T]: ...

    @overload
    def get_property(self, prop_name: Literal["sw"], **kwargs: Any)-> 'rdltypes.AccessType': ...

    @overload
    def get_property(self, prop_name: Literal["next"], *, default: T)-> Union[Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["next"], **kwargs: Any)-> Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["reset"], *, default: T)-> Union[Optional[Union[int, 'FieldNode', SignalNode, 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["reset"], **kwargs: Any)-> Optional[Union[int, 'FieldNode', SignalNode, 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["resetsignal"], *, default: T)-> Union[Optional[SignalNode], T]: ...

    @overload
    def get_property(self, prop_name: Literal["resetsignal"], **kwargs: Any)-> Optional[SignalNode]: ...

    @overload
    def get_property(self, prop_name: Literal["rclr"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["rclr"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["rset"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["rset"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["onread"], *, default: T)-> Union[Optional['rdltypes.OnReadType'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["onread"], **kwargs: Any)-> Optional['rdltypes.OnReadType']: ...

    @overload
    def get_property(self, prop_name: Literal["woclr"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["woclr"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["woset"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["woset"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["onwrite"], *, default: T)-> Union[Optional['rdltypes.OnWriteType'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["onwrite"], **kwargs: Any)-> Optional['rdltypes.OnWriteType']: ...

    @overload
    def get_property(self, prop_name: Literal["swwe"], *, default: T)-> Union[Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["swwe"], **kwargs: Any)-> Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["swwel"], *, default: T)-> Union[Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["swwel"], **kwargs: Any)-> Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["swmod"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["swmod"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["swacc"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["swacc"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["singlepulse"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["singlepulse"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["we"], *, default: T)-> Union[Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["we"], **kwargs: Any)-> Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["wel"], *, default: T)-> Union[Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["wel"], **kwargs: Any)-> Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["anded"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["anded"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["ored"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ored"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["xored"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["xored"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["fieldwidth"], *, default: T)-> Union[int, T]: ...

    @overload
    def get_property(self, prop_name: Literal["fieldwidth"], **kwargs: Any)-> int: ...

    @overload
    def get_property(self, prop_name: Literal["hwclr"], *, default: T)-> Union[Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hwclr"], **kwargs: Any)-> Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["hwset"], *, default: T)-> Union[Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hwset"], **kwargs: Any)-> Union[bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["hwenable"], *, default: T)-> Union[Optional[Union[SignalNode, 'FieldNode', 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hwenable"], **kwargs: Any)-> Optional[Union[SignalNode, 'FieldNode', 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["hwmask"], *, default: T)-> Union[Optional[Union[SignalNode, 'FieldNode', 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hwmask"], **kwargs: Any)-> Optional[Union[SignalNode, 'FieldNode', 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["counter"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["counter"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["threshold"], *, default: T)-> Union[Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["threshold"], **kwargs: Any)-> Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["incrthreshold"], *, default: T)-> Union[Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["incrthreshold"], **kwargs: Any)-> Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["saturate"], *, default: T)-> Union[Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["saturate"], **kwargs: Any)-> Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["incrsaturate"], *, default: T)-> Union[Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["incrsaturate"], **kwargs: Any)-> Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["overflow"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["overflow"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["underflow"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["underflow"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["incr"], *, default: T)-> Union[Optional[Union[SignalNode, 'FieldNode', 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["incr"], **kwargs: Any)-> Optional[Union[SignalNode, 'FieldNode', 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["incrvalue"], *, default: T)-> Union[Optional[Union[int, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["incrvalue"], **kwargs: Any)-> Optional[Union[int, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["incrwidth"], *, default: T)-> Union[Optional[int], T]: ...

    @overload
    def get_property(self, prop_name: Literal["incrwidth"], **kwargs: Any)-> Optional[int]: ...

    @overload
    def get_property(self, prop_name: Literal["decrvalue"], *, default: T)-> Union[Optional[Union[int, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["decrvalue"], **kwargs: Any)-> Optional[Union[int, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["decr"], *, default: T)-> Union[Optional[Union[SignalNode, 'FieldNode', 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["decr"], **kwargs: Any)-> Optional[Union[SignalNode, 'FieldNode', 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["decrwidth"], *, default: T)-> Union[Optional[int], T]: ...

    @overload
    def get_property(self, prop_name: Literal["decrwidth"], **kwargs: Any)-> Optional[int]: ...

    @overload
    def get_property(self, prop_name: Literal["decrsaturate"], *, default: T)-> Union[Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["decrsaturate"], **kwargs: Any)-> Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["decrthreshold"], *, default: T)-> Union[Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["decrthreshold"], **kwargs: Any)-> Union[int, bool, SignalNode, 'FieldNode', 'rdltypes.PropertyReference']: ...

    @overload
    def get_property(self, prop_name: Literal["intr"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["intr"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["intr type"], *, default: T)-> Union[Optional['rdltypes.InterruptType'], T]: ...

    @overload
    def get_property(self, prop_name: Literal["intr type"], **kwargs: Any)-> Optional['rdltypes.InterruptType']: ...

    @overload
    def get_property(self, prop_name: Literal["enable"], *, default: T)-> Union[Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["enable"], **kwargs: Any)-> Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["mask"], *, default: T)-> Union[Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["mask"], **kwargs: Any)-> Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["haltenable"], *, default: T)-> Union[Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["haltenable"], **kwargs: Any)-> Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["haltmask"], *, default: T)-> Union[Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["haltmask"], **kwargs: Any)-> Optional[Union['FieldNode', SignalNode, 'rdltypes.PropertyReference']]: ...

    @overload
    def get_property(self, prop_name: Literal["sticky"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["sticky"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["stickybit"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["stickybit"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["encode"], *, default: T)-> Union[Optional[Type['rdltypes.UserEnum']], T]: ...

    @overload
    def get_property(self, prop_name: Literal["encode"], **kwargs: Any)-> Optional[Type['rdltypes.UserEnum']]: ...

    @overload
    def get_property(self, prop_name: Literal["precedence"], *, default: T)-> Union['rdltypes.PrecedenceType', T]: ...

    @overload
    def get_property(self, prop_name: Literal["precedence"], **kwargs: Any)-> 'rdltypes.PrecedenceType': ...

    @overload
    def get_property(self, prop_name: Literal["paritycheck"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["paritycheck"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str, **kwargs: Any)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        return super().get_property(prop_name, **kwargs)

    def get_global_type_name(self, separator: str = "__") -> Optional[str]:
        name = super().get_global_type_name(separator)
        if name is None:
            return None

        # Fields may reuse the same type, but end up instantiating different widths
        # Uniquify the type name further if the field width was overridden when instantiating
        if self.inst.original_def is None:
            suffix = ""
        elif self.inst.original_def.type_name is None:
            # is an anonymous definition. No extra suffix needed
            suffix =  ""
        elif "fieldwidth" in self.list_properties():
            # fieldwidth was explicitly set.
            # This type name is already sufficiently distinct
            suffix =  ""
        elif self.width == 1:
            # field width is the default. Skip suffix
            suffix =  ""
        else:
            suffix = f"_w{self.width}"

        return name + suffix

    @property
    def is_virtual(self) -> bool:
        """
        Determines if this node represents a virtual field (child of a virtual register)
        """
        return self.parent.is_virtual

    @property
    def is_volatile(self) -> bool:
        """
        True if combination of field access properties result in a field that
        should be interpreted as volatile.
        (Any hardware-writable field is inherently volatile)
        """

        hw = self.get_property('hw')
        return (
            (hw in (rdltypes.AccessType.rw, rdltypes.AccessType.rw1,
                    rdltypes.AccessType.w, rdltypes.AccessType.w1))
            or self.get_property('counter')
            or bool(self.get_property('hwset'))
            or bool(self.get_property('hwclr'))
        )

    @property
    def is_sw_writable(self) -> bool:
        """
        Field is writable by software
        """
        sw = self.get_property('sw')

        return sw in (rdltypes.AccessType.rw, rdltypes.AccessType.rw1,
                        rdltypes.AccessType.w, rdltypes.AccessType.w1)

    @property
    def is_sw_readable(self) -> bool:
        """
        Field is readable by software
        """
        sw = self.get_property('sw')

        return sw in (rdltypes.AccessType.rw, rdltypes.AccessType.rw1,
                        rdltypes.AccessType.r)

    @property
    def is_hw_writable(self) -> bool:
        """
        Field is writable by hardware
        """
        hw = self.get_property('hw')

        return hw in (rdltypes.AccessType.rw, rdltypes.AccessType.rw1,
                        rdltypes.AccessType.w, rdltypes.AccessType.w1)

    @property
    def is_hw_readable(self) -> bool:
        """
        Field is readable by hardware
        """
        hw = self.get_property('hw')

        return hw in (rdltypes.AccessType.rw, rdltypes.AccessType.rw1,
                        rdltypes.AccessType.r)

    @property
    def implements_storage(self) -> bool:
        """
        True if combination of field access properties imply that the field
        implements a storage element.


        .. versionchanged:: 1.22
            Counter, interrupt, stickybit, and sticky fields always implement
            storage, regardless of sw/hw access.

        .. versionchanged:: 1.23
            Alias fields never implement storage.
            A primary field may inherit a storage element depending on the access
            modes of aliases that augment access to it.

        .. versionchanged:: 1.30
            All variants of software-writable access now imply a storage element.

            All hardware-writable fields that are qualified by ``we`` or ``wel`` imply storage.
        """
        if self.is_alias:
            # A field that is an alias never implements storage.
            # Storage element, if any, resides in the alias's primary.
            return False

        sw = self.get_property('sw')
        hw = self.get_property('hw')
        onread = self.get_property('onread')

        # Aliases of a primary may have additive access modes that imply
        # that the primary actually implements storage.
        # accumulate access modes
        for alias_field in self.aliases():
            sw += alias_field.get_property('sw')
            onread = onread or alias_field.get_property('onread')

        # 9.4.1, Table 12
        if self.is_sw_writable:
            # Software can write, implying a storage element
            # Intentionally including sw=w;hw=na case as this is useful for internal references.
            return True
        if hw == rdltypes.AccessType.rw:
            # Hardware can read and write, implying a storage element
            return True


        if onread is not None:
            # 9.6.1-c: Onread side-effects imply storage regardless of whether
            # or not the field is writable by sw
            return True


        if self.is_hw_writable and (self.get_property('we') or self.get_property('wel')):
            # Any write-enable implies a storage element
            return True

        if self.get_property('hwset') or self.get_property('hwclr'):
            # Not in spec, but these imply that a storage element exists
            return True

        if self.get_property('counter'):
            # All counters implicitly implement storage
            return True

        if self.get_property('intr'):
            # All interrupt fields implicitly implement storage
            return True

        if self.get_property('stickybit') or self.get_property('sticky'):
            # All sticky fields implicitly implement storage
            return True

        return False

    @property
    def is_up_counter(self) -> bool:
        """
        Denotes whether this field is a counter and the property assignments imply
        it has up-counting functionality.

        .. versionadded:: 1.21
        """
        if not self.get_property('counter'):
            # Not a counter!
            return False

        for prop_name in self.list_properties():
            if (
                prop_name.startswith("incr")
                or (prop_name == "overflow")
                or (prop_name == "saturate")
                or (prop_name == "threshold")
            ):
                return True

        # No up-counter properties were set
        if self.is_down_counter:
            # Is explicitly a down-counter, so not an up-counter
            return False

        # No up/down properties were set. Assume up-counter
        return True


    @property
    def is_down_counter(self) -> bool:
        """
        Denotes whether this field is a counter and the property assignments imply
        it has down-counting functionality.

        .. versionadded:: 1.21
        """
        if not self.get_property('counter'):
            # Not a counter!
            return False

        for prop_name in self.list_properties():
            if prop_name.startswith("decr") or (prop_name == "underflow"):
                return True

        return False


    @property
    def is_alias(self) -> bool:
        """
        Indicates whether this field is an alias
        (is contained inside an alias register)


        .. versionadded:: 1.23
        """
        return self.parent.is_alias


    @property
    def alias_primary(self) -> 'FieldNode':
        """
        Returns the FieldNode that is associated with this alias's primary register.

        Raises ValueError if this field is not an alias


        .. versionadded:: 1.23
        """
        if not self.is_alias:
            raise ValueError("Field is not an alias")

        primary_reg = self.parent.alias_primary
        primary_field = primary_reg.get_child_by_name(self.inst_name)
        assert isinstance(primary_field, FieldNode)
        return primary_field


    @property
    def has_aliases(self) -> bool:
        """
        Returns True if this field has aliases


        .. versionadded:: 1.23
        """
        for _ in self.aliases():
            return True
        return False


    def aliases(self, skip_not_present: bool = True) -> List['FieldNode']:
        """
        Returns a list of all the fields that are aliases of this primary field.

        Parameters
        ----------
        skip_not_present : bool
            If True, skips aliases whose 'ispresent' property is set to False


        .. versionadded:: 1.23

        .. versionchanged:: 1.29
            Returns list instead of generator
        """
        fields = []
        for alias_reg in self.parent.aliases(skip_not_present=skip_not_present):
            alias_field = alias_reg.get_child_by_name(self.inst_name)

            if not isinstance(alias_field, FieldNode):
                # not found in this alias
                continue

            if skip_not_present and not alias_field.get_property('ispresent'):
                continue

            fields.append(alias_field)
        return fields


#===============================================================================
class RegNode(AddressableNode):
    """
    Inherits: :class:`AddressableNode`

    Represents an RDL ``reg``
    """
    parent: Union['AddrmapNode', 'RegNode', 'MemNode']
    inst: comp.Reg

    @overload # type: ignore[override]
    def get_property(self, prop_name: Literal["dontcompare"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["dontcompare"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["donttest"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["donttest"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["errextbus"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["errextbus"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["regwidth"], *, default: T)-> Union[int, T]: ...

    @overload
    def get_property(self, prop_name: Literal["regwidth"], **kwargs: Any)-> int: ...

    @overload
    def get_property(self, prop_name: Literal["accesswidth"], *, default: T)-> Union[int, T]: ...

    @overload
    def get_property(self, prop_name: Literal["accesswidth"], **kwargs: Any)-> int: ...

    @overload
    def get_property(self, prop_name: Literal["shared"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["shared"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str, **kwargs: Any)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        return super().get_property(prop_name, **kwargs)

    @overload
    def fields(self, skip_not_present: bool = True, include_gaps: Literal[False] = False) -> Sequence['FieldNode']: ...

    @overload
    def fields(self, skip_not_present: bool, include_gaps: Literal[True]) -> Sequence[Union['FieldNode', Tuple[int, int]]]: ...

    @overload
    def fields(self, skip_not_present: bool = True, *, include_gaps: Literal[True]) -> Sequence[Union['FieldNode', Tuple[int, int]]]: ...

    @overload
    def fields(self, skip_not_present: bool = True, include_gaps: bool = False) -> Sequence[Union['FieldNode', Tuple[int, int]]]: ...

    def fields(self, skip_not_present: bool = True, include_gaps: bool = False) -> Sequence[Union['FieldNode', Tuple[int, int]]]:
        """
        Returns a list of all fields of this register.

        Parameters
        ----------
        skip_not_present: bool
            If True, skips children whose 'ispresent' property is set to False
        include_gaps: bool
            If True, returned list also includes information about gaps between
            fields. Gaps are represented as tuples in the form of: ``(high, low)``

        Returns
        -------
        :class:`~FieldNode`
            All fields in this component


        .. versionchanged:: 1.29
            Returns list instead of generator.

            Added ``include_gaps`` argument
        """
        if include_gaps:
            fields_with_gaps: List[Union['FieldNode', Tuple[int, int]]]
            fields_with_gaps = []
            current_bit = 0
            for child in self.children(skip_not_present=skip_not_present):
                if not isinstance(child, FieldNode):
                    continue
                if current_bit != child.low:
                    # Add gap before this field
                    fields_with_gaps.append((child.low - 1, current_bit))
                fields_with_gaps.append(child)
                current_bit = child.high + 1
            regwidth = self.get_property('regwidth')
            if current_bit != regwidth:
                # Add gap at end of register
                fields_with_gaps.append((regwidth - 1, current_bit))
            return fields_with_gaps
        else:
            fields = []
            for child in self.children(skip_not_present=skip_not_present):
                if isinstance(child, FieldNode):
                    fields.append(child)
            return fields


    @property
    def size(self) -> int:
        return self.get_property('regwidth') // 8

    @property
    def is_msb0_order(self) -> bool:
        """
        If true, fields are arranged in msb0 order.

        .. versionadded:: 1.30
        """
        return self.inst.is_msb0_order

    @property
    def is_virtual(self) -> bool:
        """
        True if this node represents a virtual register.
        (child of a mem component)
        """
        # since mem components can only contain reg instances, a reg can only be
        # virtual if its direct parent is of type mem
        return isinstance(self.parent, MemNode)

    @property
    def has_sw_writable(self) -> bool:
        """
        Register contains one or more present fields writable by software
        """
        for field in self.fields():
            if field.is_sw_writable:
                return True
        return False

    @property
    def has_sw_readable(self) -> bool:
        """
        Register contains one or more present fields readable by software
        """
        for field in self.fields():
            if field.is_sw_readable:
                return True
        return False

    @property
    def has_hw_writable(self) -> bool:
        """
        Register contains one or more present fields writable by hardware
        """
        for field in self.fields():
            if field.is_hw_writable:
                return True
        return False

    @property
    def has_hw_readable(self) -> bool:
        """
        Register contains one or more present fields readable by hardware
        """
        for field in self.fields():
            if field.is_hw_readable:
                return True
        return False

    @property
    def is_interrupt_reg(self) -> bool:
        """
        Register contains one or more interrupt fields and therefore produces an
        interrupt output signal.


        .. versionadded:: 1.22
        """
        for field in self.fields():
            if field.get_property('intr'):
                return True
        return False

    @property
    def is_halt_reg(self) -> bool:
        """
        Register contains one or more interrupt fields that use ``haltenable``
        or ``haltmask`` and therefore produces a halt output signal.


        .. versionadded:: 1.22
        """
        for field in self.fields():
            if field.get_property('haltenable') or field.get_property('haltmask'):
                return True
        return False


    @property
    def is_alias(self) -> bool:
        """
        Indicates whether this register is an alias.


        .. versionadded:: 1.23
        """
        return self.inst.is_alias


    @property
    def alias_primary(self) -> 'RegNode':
        """
        Returns the RegNode of this alias's primary register.

        Raises ValueError if this register is not an alias


        .. versionadded:: 1.23
        """
        if not self.is_alias:
            raise ValueError("Register is not an alias")

        assert self.inst.alias_primary_inst is not None
        assert self.inst.alias_primary_inst.inst_name is not None

        # Limitations in grammar make it so that an alias primary can only be
        # referenced by a single ID token. This means the primary cannot be a
        # hierarchical path, or anything else fancy. This implicitly guarantees
        # that the alias primary is a sibling in the hierarchy.
        # Simply look up the sibling by-name.
        name = self.inst.alias_primary_inst.inst_name
        primary_reg = self.parent.get_child_by_name(name)
        assert isinstance(primary_reg, RegNode)

        if self.is_array and primary_reg.is_array:
            # Both are arrays.
            # Mirror the current index onto the primary that is returned
            primary_reg.current_idx = copy(self.current_idx)

        return primary_reg


    @property
    def has_aliases(self) -> bool:
        """
        Returns True if this register has aliases


        .. versionadded:: 1.23
        """
        return bool(self.inst._alias_names)


    def aliases(self, skip_not_present: bool = True) -> List['RegNode']:
        """
        Returns a listof all the registers that are aliases of this primary register

        Parameters
        ----------
        skip_not_present : bool
            If True, skips aliases whose 'ispresent' property is set to False


        .. versionadded:: 1.23

        .. versionchanged:: 1.29
            Returns list instead of generator
        """
        regs = []
        for reg_name in self.inst._alias_names:
            alias_reg = self.parent.get_child_by_name(reg_name)
            assert isinstance(alias_reg, RegNode)

            if skip_not_present and not alias_reg.get_property('ispresent'):
                continue

            if self.is_array and alias_reg.is_array:
                # Both are arrays.
                # Mirror the current index onto the alias that is returned
                alias_reg.current_idx = copy(self.current_idx)

            regs.append(alias_reg)
        return regs




#===============================================================================
class RegfileNode(AddressableNode):
    """
    Inherits: :class:`AddressableNode`

    Represents an RDL ``regfile``
    """
    parent: Union['AddrmapNode', 'RegfileNode']
    inst: comp.Regfile

    @overload # type: ignore[override]
    def get_property(self, prop_name: Literal["dontcompare"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["dontcompare"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["donttest"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["donttest"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["errextbus"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["errextbus"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["alignment"], *, default: T)-> Union[Optional[int], T]: ...

    @overload
    def get_property(self, prop_name: Literal["alignment"], **kwargs: Any)-> Optional[int]: ...

    @overload
    def get_property(self, prop_name: Literal["sharedextbus"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["sharedextbus"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str, **kwargs: Any)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        return super().get_property(prop_name, **kwargs)

    @property
    def size(self) -> int:
        return get_group_node_size(self)

#===============================================================================
class AddrmapNode(AddressableNode):
    """
    Inherits: :class:`AddressableNode`

    Represents an RDL ``addrmap``
    """
    parent: Union['AddrmapNode', RootNode]
    inst: comp.Addrmap

    @overload # type: ignore[override]
    def get_property(self, prop_name: Literal["dontcompare"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["dontcompare"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["donttest"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["donttest"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["errextbus"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["errextbus"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["alignment"], *, default: T)-> Union[Optional[int], T]: ...

    @overload
    def get_property(self, prop_name: Literal["alignment"], **kwargs: Any)-> Optional[int]: ...

    @overload
    def get_property(self, prop_name: Literal["sharedextbus"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["sharedextbus"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["bigendian"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["bigendian"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["littleendian"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["littleendian"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["addressing"], *, default: T)-> Union[rdltypes.AddressingType, T]: ...

    @overload
    def get_property(self, prop_name: Literal["addressing"], **kwargs: Any)-> rdltypes.AddressingType: ...

    @overload
    def get_property(self, prop_name: Literal["rsvdset"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["rsvdset"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["rsvdsetX"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["rsvdsetX"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["msb0"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["msb0"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["lsb0"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["lsb0"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["bridge"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["bridge"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str, **kwargs: Any)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        return super().get_property(prop_name, **kwargs)

    @property
    def size(self) -> int:
        return get_group_node_size(self)

#===============================================================================
class MemNode(AddressableNode):
    """
    Inherits: :class:`AddressableNode`

    Represents an RDL ``mem``
    """
    parent: AddrmapNode
    inst: comp.Mem

    @overload # type: ignore[override]
    def get_property(self, prop_name: Literal["hdl_path_slice"], *, default: T)-> Union[Optional[List[str]], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_slice"], **kwargs: Any)-> Optional[List[str]]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate_slice"], *, default: T)-> Union[Optional[List[str]], T]: ...

    @overload
    def get_property(self, prop_name: Literal["hdl_path_gate_slice"], **kwargs: Any)-> Optional[List[str]]: ...

    @overload
    def get_property(self, prop_name: Literal["sw"], *, default: T)-> Union[rdltypes.AccessType, T]: ...

    @overload
    def get_property(self, prop_name: Literal["sw"], **kwargs: Any)-> rdltypes.AccessType: ...

    @overload
    def get_property(self, prop_name: Literal["mementries"], *, default: T)-> Union[int, T]: ...

    @overload
    def get_property(self, prop_name: Literal["mementries"], **kwargs: Any)-> int: ...

    @overload
    def get_property(self, prop_name: Literal["memwidth"], *, default: T)-> Union[int, T]: ...

    @overload
    def get_property(self, prop_name: Literal["memwidth"], **kwargs: Any)-> int: ...

    @overload
    def get_property(self, prop_name: Literal["name"], *, default: T)-> Union[str, T]: ...

    @overload
    def get_property(self, prop_name: Literal["name"], **kwargs: Any)-> str: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], *, default: T)-> Union[Optional[str], T]: ...

    @overload
    def get_property(self, prop_name: Literal["desc"], **kwargs: Any)-> Optional[str]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], *, default: T)-> Union[bool, T]: ...

    @overload
    def get_property(self, prop_name: Literal["ispresent"], **kwargs: Any)-> bool: ...

    @overload
    def get_property(self, prop_name: str, *, default: T)-> Union[Any, T]: ...

    @overload
    def get_property(self, prop_name: str, **kwargs: Any)-> Any: ...

    def get_property(self, prop_name: str, **kwargs: Any)-> Any:
        return super().get_property(prop_name, **kwargs)

    @property
    def size(self) -> int:
        memwidth = max(self.get_property('memwidth'), 8)
        entry_size = helpers.roundup_pow2(memwidth) // 8
        num_entries = self.get_property('mementries')
        return entry_size * num_entries

    @property
    def is_sw_writable(self) -> bool:
        """
        Memory is writable by software

        .. versionadded:: 1.21
        """
        sw = self.get_property('sw')

        return sw in (rdltypes.AccessType.rw, rdltypes.AccessType.rw1,
                        rdltypes.AccessType.w, rdltypes.AccessType.w1)

    @property
    def is_sw_readable(self) -> bool:
        """
        Memory is readable by software

        .. versionadded:: 1.21
        """
        sw = self.get_property('sw')

        return sw in (rdltypes.AccessType.rw, rdltypes.AccessType.rw1,
                        rdltypes.AccessType.r)

#===============================================================================
def get_group_node_size(node: Union[AddrmapNode, RegfileNode]) -> int:
    """
    Shared getter for AddrmapNode and RegfileNode's "size" property
    """
    # addrmap/regfile is guaranteed to have an addressable child.
    if not node.inst.children:
        return 0
    assert isinstance(node.inst.children[-1], comp.AddressableComponent)

    # Current node's size is based on last child
    last_child_node = Node._factory(node.inst.children[-1], node.env, node)
    assert isinstance(last_child_node, AddressableNode)
    return last_child_node.raw_address_offset + last_child_node.total_size
