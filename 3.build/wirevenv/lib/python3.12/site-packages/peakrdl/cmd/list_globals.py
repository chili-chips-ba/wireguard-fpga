from typing import TYPE_CHECKING, List

from systemrdl import RDLCompiler
from systemrdl.component import Addrmap

from ..subcommand import Subcommand
from .. import process_input

if TYPE_CHECKING:
    import argparse
    from ..plugins.importer import ImporterPlugin

class ListGlobals(Subcommand):
    name = "globals"
    short_desc = "list all globally accessible types that can be elaborated as top"

    def add_arguments(self, parser: 'argparse._ActionsContainer', importers: 'List[ImporterPlugin]') -> None:
        compiler_arg_group = parser.add_argument_group("compilation args")
        process_input.add_rdl_compile_arguments(compiler_arg_group)

        process_input.add_importer_arguments(parser, importers)

    def main(self, importers: 'List[ImporterPlugin]', options: 'argparse.Namespace') -> None:
        rdlc = RDLCompiler()
        process_input.process_input(rdlc, importers, options.input_files, options)

        for name, comp_def in rdlc.root.comp_defs.items():
            if isinstance(comp_def, Addrmap):
                print(name)
