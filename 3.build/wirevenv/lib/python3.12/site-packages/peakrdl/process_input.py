from typing import TYPE_CHECKING, List, Dict, Any, Sequence
import re
import os

from systemrdl.messages import FileSourceRef

if TYPE_CHECKING:
    import argparse
    from systemrdl import RDLCompiler
    from .importer import Importer


def add_rdl_compile_arguments(parser: 'argparse._ActionsContainer') -> None:
    parser.add_argument(
        "input_files",
        metavar="FILE",
        nargs="+",
        help="One or more input files"
    )
    parser.add_argument(
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


def add_importer_arguments(parser: 'argparse._ActionsContainer', importers: 'Sequence[Importer]') -> None:
    for importer in importers:
        importer_arg_group = parser.add_argument_group(f"{importer.name} importer args")
        importer.add_importer_arguments(importer_arg_group)


def add_elaborate_arguments(parser: 'argparse._ActionsContainer') -> None:
    parser.add_argument(
        "-t", "--top",
        dest="top_def_name",
        metavar="TOP",
        default=None,
        help="Explicitly choose which addrmap  in the root namespace will be the "
                "top-level component. If unset, The last addrmap defined will be chosen"
    )
    parser.add_argument(
        "--rename",
        dest="inst_name",
        default=None,
        help="Overrides the top-component's instantiated name. By default, the "
                "instantiated name is the same as the component's type name"
    )
    parser.add_argument(
        "-P",
        dest="parameters",
        metavar="PARAMETER=VALUE",
        action="append",
        default=[],
        help='Specify value for a top-level SystemRDL parameter',
    )


def parse_parameters(rdlc: 'RDLCompiler', parameter_options: List[str]) -> Dict[str, Any]:
    parameters = {}
    for raw_param in parameter_options:
        m = re.fullmatch(r"(\w+)=(.+)", raw_param)
        if not m:
            rdlc.msg.fatal(f"Invalid parameter argument: {raw_param}")
            raise ValueError

        p_name = m.group(1)
        try:
            p_value = rdlc.eval(m.group(2))
        except ValueError:
            rdlc.msg.fatal(f"Unable to parse value '{m.group(2)}' for parameter '{p_name}'")
        parameters[p_name] = p_value

    return parameters

def parse_defines(rdlc: 'RDLCompiler', define_options: List[str]) -> Dict[str, str]:
    defines = {}
    for raw_def in define_options:
        m = re.fullmatch(r"(\w+)(?:=(.+))?", raw_def)
        if not m:
            rdlc.msg.fatal(f"Invalid define argument: {raw_def}")
            raise ValueError

        k = m.group(1)
        v = m.group(2) or ""
        defines[k] = v
    return defines


def process_input(rdlc: 'RDLCompiler', importers: 'Sequence[Importer]', input_files: List[str], options: 'argparse.Namespace') -> None:
    defines = parse_defines(rdlc, options.defines)
    for file in input_files:
        load_file(rdlc, importers, file, defines, options.incdirs, options)


def load_file(
        rdlc: 'RDLCompiler',
        importers: 'Sequence[Importer]',
        path: str,
        defines: Dict[str, str],
        incdirs: List[str],
        options: 'argparse.Namespace'
    ) -> None:
    """
    Careful! This is a secret API!
    sphinx-peakrdl calls this.
    """

    if not os.path.exists(path):
        rdlc.msg.fatal(f"Input file does not exist: {path}")

    ext = os.path.splitext(path)[1].strip(".")
    if ext == "rdl":
        # Is SystemRDL file
        rdlc.compile_file(
            path,
            incl_search_paths=incdirs,
            defines=defines,
        )
    else:
        # Is foreign input file.

        # Search which importer to use by extension first
        importer_candidates: List["Importer"] = []
        for imp in importers:
            if ext in imp.file_extensions:
                importer_candidates.append(imp)

        # Do 2nd pass if needed
        if len(importer_candidates) == 1:
            importer = importer_candidates[0]
        elif len(importer_candidates) > 1:
            # ambiguous which importer to use
            # Do 2nd pass compatibility check
            for importer_candidate in importer_candidates:
                if importer_candidate.is_compatible(path):
                    importer = importer_candidate
                    break
            else:
                importer = None
        else:
            importer = None

        if not importer:
            rdlc.msg.fatal(
                "Unknown file type. Could not find any importers capable of reading this file.",
                FileSourceRef(path)
            )
            raise ValueError

        importer.do_import(rdlc, options, path)
