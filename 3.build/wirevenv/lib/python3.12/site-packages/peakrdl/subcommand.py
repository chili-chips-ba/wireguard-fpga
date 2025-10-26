from typing import TYPE_CHECKING, Optional, List, Type, Dict, Any

from systemrdl import RDLCompiler

from .config import schema
from .config.loader import AppConfig
from . import process_input

if TYPE_CHECKING:
    import argparse

    from systemrdl.node import AddrmapNode
    from systemrdl.udp import UDPDefinition
    from .plugins.importer import ImporterPlugin

class Subcommand:
    """
    Base command line interface subcommand class
    """

    # Subcommand name
    name: str

    #: A brief one-line description of the exporter command.
    short_desc: str

    #: Longer-form description.
    #: If left as None, inherits short_desc
    long_desc: Optional[str] = None

    #: Schema for additional organization-specific configuration options
    #: specified by a 'peakrdl.toml' file loaded at startup.
    #:
    #: For more details, see :ref:`cfg_schema`
    cfg_schema: Dict[str, Any] = {}

    def __init__(self) -> None:
        #: Resolved configuration data that was extracted from the PeakRDL TOML,
        #: and validated.
        self.cfg: Dict[str, Any] = {}

    def _load_cfg(self, cfg: AppConfig) -> None:
        self.cfg = cfg.get_namespace(self.name, schema.normalize(self.cfg_schema))

    def _init_subparser(self, subgroup: 'argparse._SubParsersAction', importers: 'List[ImporterPlugin]') -> None:
        assert isinstance(self.name, str)
        assert isinstance(self.short_desc, str)
        subparser = subgroup.add_parser(
            self.name,
            help=self.short_desc,
            description=(self.long_desc or self.short_desc)
        )
        self.add_arguments(subparser, importers)
        subparser.set_defaults(subcommand=self)

        # Add dummy -f and cfg flags. Not actually used as these are already
        # expanded earlier manually
        subparser.add_argument(
            '-f',
            metavar="FILE",
            dest="argfile",
            help="Specify a file containing more command line arguments"
        )
        subparser.add_argument(
            '--peakrdl-cfg',
            metavar="CFG",
            dest="peakrdl_cfg",
            help="Specify a PeakRDL configuration TOML file"
        )


    def add_arguments(self, parser: 'argparse._ActionsContainer', importers: 'List[ImporterPlugin]') -> None:
        pass # pragma: no cover


    def main(self, importers: 'List[ImporterPlugin]', options: 'argparse.Namespace') -> None:
        raise NotImplementedError



class ExporterSubcommand(Subcommand):
    """
    Basic PeakRDL exporter subcommand.
    Most subcommands will fall under this category as they do the following:
    - Compile one or more RDL files
    - Optionally import other non-RDL sources
    - Elaborate the register model
    - Export <something>
    """

    #: Determines whether this subcommand should require the user to provide an
    #: output path. If ``True``, adds a required ``-o`` command-line argument.
    #: The result of this is available later in the ``do_export()`` function
    #: via ``options.output``.
    #:
    #: Set this to ``False`` if your exporter does not write any output files.
    generates_output_file = True

    #: List of ``systemrdl.udp.UDPDefinition`` classes that this subcommand
    #: provides. Internally, each of these definitions are registered with the
    #: compiler as soft UDPs via ``RDLCompiler.register_udp()``
    udp_definitions: List[Type["UDPDefinition"]] = []

    def add_arguments(self, parser: 'argparse._ActionsContainer', importers: 'List[ImporterPlugin]') -> None:
        compiler_arg_group = parser.add_argument_group("compilation args")
        process_input.add_rdl_compile_arguments(compiler_arg_group)
        process_input.add_elaborate_arguments(compiler_arg_group)

        process_input.add_importer_arguments(parser, importers)

        exporter_arg_group = parser.add_argument_group("exporter args")
        if self.generates_output_file:
            exporter_arg_group.add_argument(
                "-o",
                dest="output",
                required=True,
                help="Output path",
            )
        self.add_exporter_arguments(exporter_arg_group)

    def add_exporter_arguments(self, arg_group: 'argparse._ActionsContainer') -> None:
        """
        Override this function to define additional command line arguments by
        using the ``arg_group.add_argument()`` method.
        See Python's `argparse module <https://docs.python.org/3/library/argparse.html#the-add-argument-method>`_
        for more details on how to use this.

        .. note::

            Not all exporter configuration options are appropriate as command-line arguments.
            For options that will likely remain static for a given user/organization,
            consider using the PeakRDL TOML configuration mechanism via the
            ``cfg_schema`` and ``cfg`` class members.

        Parameters
        ----------
        arg_group: ``argparse.ArgumentParser``
            Add more command line arguments via this object.
        """

    def main(self, importers: 'List[ImporterPlugin]', options: 'argparse.Namespace') -> None:
        rdlc = RDLCompiler()

        for udp in self.udp_definitions:
            rdlc.register_udp(udp)

        parameters = process_input.parse_parameters(rdlc, options.parameters)

        process_input.process_input(rdlc, importers, options.input_files, options)

        root = rdlc.elaborate(
            top_def_name=options.top_def_name,
            inst_name=options.inst_name,
            parameters=parameters
        )

        # Run exporter
        self.do_export(root.top, options)


    def do_export(self, top_node: 'AddrmapNode', options: 'argparse.Namespace') -> None:
        """
        Override this function to define the implementation of your exporter.

        Parameters
        ----------
        top_node: ``systemrdl.node.AddrmapNode``
            Node representing the top of the design to be exported
        options: ``argparse.Namespace``
            Argparse namespace object containing all the command line argument values.
        """
        raise NotImplementedError
