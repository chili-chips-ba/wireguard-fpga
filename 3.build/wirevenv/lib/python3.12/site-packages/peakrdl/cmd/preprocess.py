from typing import TYPE_CHECKING, List

from systemrdl import RDLCompiler

from ..subcommand import Subcommand
from ..process_input import parse_defines

if TYPE_CHECKING:
    import argparse
    from ..plugins.importer import ImporterPlugin

class Preprocess(Subcommand):
    name = "preprocess"
    short_desc = "Preprocess SystemRDL and write the result to a file"

    def add_arguments(self, parser: 'argparse._ActionsContainer', importers: 'List[ImporterPlugin]') -> None:
        grp = parser.add_argument_group("preprocessor args")
        grp.add_argument(
            "file",
            help="SystemRDL file to preprocess"
        )
        grp.add_argument(
            "-I",
            dest="incdirs",
            metavar="INCDIR",
            action="append",
            help='Search directory for files included with `include "filename"',
        )
        parser.add_argument(
            "-D",
            dest="defines",
            metavar="MACRO[=VALUE]",
            action="append",
            default=[],
            help="Pre-define a Verilog-style preprocessor macro"
        )
        grp.add_argument(
            "-o",
            dest="output",
            required=True,
            help="Output path",
        )

    def main(self, importers: 'List[ImporterPlugin]', options: 'argparse.Namespace') -> None:
        rdlc = RDLCompiler()
        defines = parse_defines(rdlc, options.defines)
        f_info = rdlc.preprocess_file(options.file, options.incdirs, defines=defines)
        with open(options.output, 'w', encoding='utf-8') as f:
            f.write(f_info.preprocessed_text)
