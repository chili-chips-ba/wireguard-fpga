from typing import Type, Any, List, Dict, Optional, Iterable, TYPE_CHECKING

from antlr4 import InputStream

from . import messages
from . import warnings
from .parser import sa_systemrdl
from .core.ComponentVisitor import RootVisitor
from .core.ExprVisitor import ExprVisitor
from .properties.rulebook import PropertyRuleBook
from .properties.user_defined import ExternalUserProperty
from .core.namespace import NamespaceRegistry
from .core.elaborate import ElabExpressionsListener, PrePlacementValidateListener, LateElabListener
from .core.elaborate import StructuralPlacementListener, LateElabRevisitor
from .core.validate import ValidateListener
from . import ast
from . import component as comp
from . import walker
from .node import RootNode
from . import preprocessor

if TYPE_CHECKING:
    from .rdltypes.typing import RDLValue
    from .udp import UDPDefinition


class FileInfo:
    def __init__(self, preprocessed_text: str, included_files: Iterable[str]) -> None:
        self._pp_text = preprocessed_text
        self._incl_files = included_files

    @property
    def preprocessed_text(self) -> str:
        """
        Resolved text after Perl and Verilog preprocessing
        """
        return self._pp_text

    @property
    def included_files(self) -> Iterable[str]:
        """
        Iterable of paths that were included while preprocessing this file.
        """
        return self._incl_files


class RDLCompiler:
    def __init__(self, **kwargs: Any):
        """
        RDLCompiler constructor.

        Parameters
        ----------
        message_printer: :class:`~systemrdl.messages.MessagePrinter`
            Override the default message printer
        warning_flags: int
            Flags to enable warnings. See :ref:`messages_warnings` for more details.
        error_flags: int
            Same as ``warning_flags`` but promote them to errors instead.
        dedent_desc: bool
            Automatically remove any common indentation from multi-line
            ``desc`` properties.

            Set to True by default.
        extended_dpa_type_names: bool
            Enable extended type name generation that accounts for dynamic
            property assignments augmenting the type.

            Set to True by default.

            See :ref:`dpa_type_generation` for more details.
        perl_safe_opcodes: List[str]
            Perl preprocessor commands are executed within a
            `Perl Safe <https://perldoc.perl.org/Safe.html>`_ compartment to
            prevent malicious code execution.

            The default set of `Perl opcodes <https://perldoc.perl.org/Opcode.html#Predefined-Opcode-Tags>`_
            allowed should be sufficient for most applications, however this
            option is exposed in the rare case it is necessary to override the
            opcode list in order to make an exception.

            Default value::

                [
                    ':base_core', ':base_mem', ':base_loop', ':base_orig', ':base_math',
                    ':base_thread', ':filesys_read', ':sys_db', ':load',
                    'sort', 'tied', 'pack', 'unpack', 'reset'
                ]

        .. versionchanged:: 1.8
            Added ``dedent_desc`` option.
        .. versionchanged:: 1.9
            Added ``extended_dpa_type_names`` option.
        .. versionchanged:: 1.10
            Added ``perl_safe_opcodes`` option.
        """
        self.env = RDLEnvironment(kwargs)

        # Check for stray kwargs
        if kwargs:
            raise TypeError(f"got an unexpected keyword argument '{list(kwargs.keys())[0]}'")

        #: Reference to the compiler's :class:`~systemrdl.messages.MessageHandler` object
        #:
        #: .. warning::
        #:
        #:      This will be deprecated in a future release. See this page for more details: https://github.com/SystemRDL/systemrdl-compiler/issues/168
        self.msg = self.env.msg

        self.namespace: NamespaceRegistry = NamespaceRegistry(self.env)
        self.visitor: RootVisitor = RootVisitor(self, comp.Root())
        self.root = self.visitor.component


    def register_udp(self, definition_cls: 'Type[UDPDefinition]', soft: bool=True) -> None:
        """
        Pre-register a User Defined Property into the compiler.

        Parameters
        ----------
        definition_cls: :class:`systemrdl.udp.UDPDefinition`
            Reference to the container class that defines your new UDP.
        soft: bool
            Override to False to register the UDP as a hard definition.


        .. versionadded:: 1.25
        """
        if definition_cls.name in self.env.property_rules.rdl_properties:
            raise ValueError(f"UDP definition's name '{definition_cls.name}' conflicts with existing built-in RDL property")
        if definition_cls.name in self.env.property_rules.user_properties:
            raise ValueError(f"UDP '{definition_cls.name}' has already been defined")

        # Wrap definition with internal UDP object & register it
        udp = ExternalUserProperty(self.env, definition_cls, soft)
        self.env.property_rules.user_properties[udp.name] = udp

    def list_udps(self) -> List[str]:
        """
        List all user-defined properties encountered by the compiler.


        .. versionadded:: 1.12
        """
        udps = []
        for udp_name, udp in self.env.property_rules.user_properties.items():
            if isinstance(udp, ExternalUserProperty) and udp.is_soft:
                continue
            udps.append(udp_name)
        return udps


    def preprocess_file(self, path: str, incl_search_paths: Optional[List[str]]=None, defines: Optional[Dict[str,str]]=None) -> FileInfo:
        """
        Preprocess a single file without compiling it.

        Parameters
        ----------
        path:str
            Path to an RDL source file

        incl_search_paths: List[str]
            List of additional paths to search to resolve includes.
            If unset, defaults to an empty list.

            Relative include paths are resolved in the following order:

            1. Search each path specified in ``incl_search_paths``.
            2. Path relative to the source file performing the include.

        defines: Dict[str, str]
            Dictionary of pre-defined verilog macros where the key is the macro
            name, and the value is the macro text.

        Raises
        ------
        RDLCompileError
            If any fatal preprocessing error is encountered.

        Returns
        -------
        :class:`FileInfo`
            File info object


        .. versionadded:: 1.20
        """
        if incl_search_paths is None:
            incl_search_paths = []

        input_stream, included_files = preprocessor.preprocess_file(self.env, path, incl_search_paths, defines)

        return FileInfo(input_stream.strdata, included_files)


    def compile_file(self, path: str, incl_search_paths: Optional[List[str]]=None, defines: Optional[Dict[str,str]]=None) -> FileInfo:
        """
        Parse & compile a single file and append it to RDLCompiler's root
        namespace.

        If any exceptions (:class:`~systemrdl.RDLCompileError` or other)
        occur during compilation, then the RDLCompiler object should be discarded.

        Parameters
        ----------
        path:str
            Path to an RDL source file

        incl_search_paths: List[str]
            List of additional paths to search to resolve includes.
            If unset, defaults to an empty list.

            Relative include paths are resolved in the following order:

            1. Search each path specified in ``incl_search_paths``.
            2. Path relative to the source file performing the include.

        defines: Dict[str, str]
            Dictionary of pre-defined verilog macros where the key is the macro
            name, and the value is the macro text.

        Raises
        ------
        RDLCompileError
            If any fatal compile error is encountered.

        Returns
        -------
        :class:`FileInfo`
            File info object


        .. versionchanged:: 1.20
            Returns a :class:`FileInfo` object instead of ``None``
        """

        if incl_search_paths is None:
            incl_search_paths = []

        input_stream, included_files = preprocessor.preprocess_file(self.env, path, incl_search_paths, defines)

        # Run Antlr parser on input
        parsed_tree = sa_systemrdl.parse(
            input_stream,
            "root",
            messages.RdlSaErrorListener(self.msg)
        )

        if self.msg.had_error:
            self.msg.fatal("Parse aborted due to previous errors")

        # Traverse parse tree with RootVisitor
        self.visitor.visit(parsed_tree)

        # Reset default property assignments from namespace.
        # They should not be shared between files since that would be confusing.
        self.namespace.default_property_ns_stack = [{}]

        if self.msg.had_error:
            self.msg.fatal("Compile aborted due to previous errors")

        return FileInfo(input_stream.strdata, included_files)


    def elaborate(self, top_def_name: Optional[str]=None, inst_name: Optional[str]=None, parameters: Optional[Dict[str, 'RDLValue']]=None) -> RootNode:
        """
        Elaborates the design for the given top-level addrmap component.

        During elaboration, the following occurs:

        - An instance of the ``$root`` meta-component is created.
        - The addrmap component specified by ``top_def_name`` is instantiated as a
          child of ``$root``.
        - Expressions, parameters, and inferred address/field placements are elaborated.
        - Validation checks are performed.

        If a design contains multiple root-level addrmaps, ``elaborate()`` can be
        called multiple times in order to elaborate each individually.

        If any exceptions (:class:`~systemrdl.RDLCompileError` or other)
        occur during elaboration, then the RDLCompiler object should be discarded.

        Parameters
        ----------
        top_def_name: str
            Explicitly choose which addrmap  in the root namespace will be the
            top-level component.

            If unset, The last addrmap defined will be chosen.

        inst_name: str
            Overrides the top-component's instantiated name.
            By default, instantiated name is the same as ``top_def_name``

        parameters: dict
            Dictionary of parameter overrides for the top component instance.

        Raises
        ------
        RDLCompileError
            If any fatal elaboration error is encountered

        Returns
        -------
        :class:`~systemrdl.node.RootNode`
            Elaborated root meta-component's Node object.
        """

        if parameters is None:
            parameters = {}

        # Get top-level component definition to elaborate
        if top_def_name is not None:
            # Lookup top_def_name
            if top_def_name not in self.root.comp_defs:
                self.msg.fatal(f"Elaboration target '{top_def_name}' not found")
            top_def = self.root.comp_defs[top_def_name]

            if not isinstance(top_def, comp.Addrmap):
                self.msg.fatal(f"Elaboration target '{top_def_name}' is not an 'addrmap' component")
        else:
            # Not specified. Find the last addrmap defined
            for comp_def in reversed(self.root.comp_defs.values()):
                if isinstance(comp_def, comp.Addrmap):
                    top_def = comp_def
                    top_def_name = comp_def.type_name
                    break
            else:
                self.msg.fatal("Could not find any 'addrmap' components to elaborate")

        # Create design instance
        root_node = self._elab_create_root_inst(top_def, inst_name, top_def_name, parameters)

        # Elaborate the design
        self._elab_design(root_node)

        # Validate design
        self._elab_validate(root_node)

        if self.msg.had_error:
            self.msg.fatal("Elaborate aborted due to previous errors")

        return root_node

    def _elab_create_root_inst(self, top_def: comp.Addrmap, inst_name: Optional[str], top_def_name: Optional[str], parameters: Dict[str, 'RDLValue']) -> RootNode:
        # Create an instance of the root component
        root_inst = self.root._copy_for_inst({}, recursive=True)
        root_inst.is_instance = True
        root_inst.original_def = self.root
        root_inst.inst_name = "$root"
        root_inst.external = False # meaningless, but must not be None

        # Create a top-level instance
        top_inst = top_def._copy_for_inst({}, recursive=True)
        top_inst.is_instance = True
        top_inst.original_def = top_def
        top_inst.addr_offset = 0
        top_inst.external = True # addrmap is always implied as external
        if inst_name is not None:
            top_inst.inst_name = inst_name
        else:
            top_inst.inst_name = top_def_name

        # Override parameters as needed
        for param_name, value in parameters.items():
            # Find the parameter to override
            if param_name in top_inst.parameters_dict:
                parameter = top_inst.parameters_dict[param_name]
            else:
                self.msg.fatal(f"Elaboration top does not have a parameter '{param_name}' that is available for override")

            literal_expr = ast.ExternalLiteral(self.env, value)
            assign_expr = ast.AssignmentCast(self.env, None, literal_expr, parameter.param_type)
            try:
                # Try to predict type to test if ExternalLiteral maps to a valid RDL type
                assign_expr.predict_type()
            except ValueError:
                self.msg.fatal(f"Incorrect type for top-level parameter override of '{param_name}'")

            parameter.expr = assign_expr


        # instantiate top_inst into the root component instance
        root_inst.children.append(top_inst)

        root_node = RootNode(root_inst, self.env, None)

        return root_node

    def _elab_design(self, root_node: RootNode) -> None:
        # Resolve all expressions
        walker.RDLSimpleWalker(skip_not_present=False).walk(
            root_node,
            ElabExpressionsListener(self.msg)
        )

        # Resolve address and field placement
        late_elab_listener = LateElabListener(self.msg, self.env)
        walker.RDLSimpleWalker(skip_not_present=False).walk(
            root_node,
            PrePlacementValidateListener(self.msg),
            StructuralPlacementListener(self.msg),
            late_elab_listener
        )

        # re-visit nodes a 2nd time as-needed to complete elaboration
        LateElabRevisitor(late_elab_listener.node_needs_revisit)

    def _elab_validate(self, root_node: RootNode) -> None:
        # Only need to validate nodes that are present
        walker.RDLSimpleWalker(skip_not_present=True).walk(root_node, ValidateListener(self.env))



    def eval(self, expression: str) ->'RDLValue':
        """
        Evaluate an RDL expression string and return its compiled value.
        This function is provided as a helper to simplify overriding top-level
        parameters during elaboration.

        Parameters
        ----------
        expression: str
            This string is parsed and evaluated as a SystemRDL expression.
            Any references used in the expression are resolved using the
            current contents of the root namespace.

        Raises
        ------
        ValueError
            If any parse or evaluation error occurs.


        .. versionadded:: 1.8
        """
        # Create local message handler that suppresses the usual output
        # to stderr.
        # Instead raises ValueError on any error
        msg_printer = messages.MessageExceptionRaiser()
        msg_handler = messages.MessageHandler(msg_printer)

        input_stream = InputStream(expression)

        parsed_tree = sa_systemrdl.parse(
            input_stream,
            "eval_expr_root",
            messages.RdlSaErrorListener(msg_handler)
        )

        visitor = ExprVisitor(self)

        # override visitor to use local message handler
        visitor.msg = msg_handler

        result = visitor.visit(parsed_tree)
        result.predict_type()
        return result.get_value()


class RDLEnvironment:
    """
    Container object for misc resources that are preserved outside the lifetime
    of source compilation
    """
    def __init__(self, args_dict: Dict[str, Any]):
        # Collect args
        message_printer = args_dict.pop('message_printer', messages.MessagePrinter())
        w_flags = args_dict.pop('warning_flags', 0)
        e_flags = args_dict.pop('error_flags', 0)
        self.dedent_desc = args_dict.pop('dedent_desc', True)
        self.use_extended_type_name_gen = args_dict.pop('extended_dpa_type_names', True)
        self.perl_safe_opcodes = args_dict.pop('perl_safe_opcodes', [
            ':base_core', ':base_mem', ':base_loop', ':base_orig', ':base_math',
            ':base_thread', ':filesys_read', ':sys_db', ':load',
            'sort', 'tied', 'pack', 'unpack', 'reset'
        ])
        self.chk_missing_reset = self.chk_flag_severity(warnings.MISSING_RESET, w_flags, e_flags)
        self.chk_implicit_field_pos = self.chk_flag_severity(warnings.IMPLICIT_FIELD_POS, w_flags, e_flags)
        self.chk_implicit_addr = self.chk_flag_severity(warnings.IMPLICIT_ADDR, w_flags, e_flags)
        self.chk_stride_not_pow2 = self.chk_flag_severity(warnings.STRIDE_NOT_POW2, w_flags, e_flags)
        self.chk_strict_self_align = self.chk_flag_severity(warnings.STRICT_SELF_ALIGN, w_flags, e_flags)
        self.chk_sparse_reg_stride = self.chk_flag_severity(warnings.SPARSE_REG_STRIDE, w_flags, e_flags)

        self.msg = messages.MessageHandler(message_printer)
        self.property_rules = PropertyRuleBook(self)

    @staticmethod
    def chk_flag_severity(flag: int, w_flags: int, e_flags: int) -> messages.Severity:
        if bool(e_flags & flag):
            return messages.Severity.ERROR
        elif bool(w_flags & flag):
            return messages.Severity.WARNING
        else:
            return messages.Severity.NONE
