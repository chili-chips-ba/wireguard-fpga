from typing import TYPE_CHECKING
import re

from peakrdl.plugins.importer import ImporterPlugin #pylint: disable=import-error
from peakrdl.plugins.exporter import ExporterSubcommandPlugin #pylint: disable=import-error

from .exporter import IPXACTExporter, Standard
from .importer import IPXACTImporter

if TYPE_CHECKING:
    import argparse
    from systemrdl import RDLCompiler
    from systemrdl.node import AddrmapNode


class Exporter(ExporterSubcommandPlugin):
    short_desc = "Export the register model to IP-XACT"


    def add_exporter_arguments(self, arg_group: 'argparse.ArgumentParser') -> None:
        arg_group.add_argument(
            "--vendor",
            default="example.org",
            help="vendor url string. [example.org]"
        )
        arg_group.add_argument(
            "--library",
            default="mylibrary",
            help="library name string. [mylibrary]"
        )
        arg_group.add_argument(
            "--name",
            default=None,
            help="component name. Defaults to top exported component's name"
        )
        arg_group.add_argument(
            "--version",
            default="1.0",
            help="version string. [1.0]"
        )

        arg_group.add_argument(
            "--standard",
            dest="standard",
            choices=[2009, 2014],
            default=2014,
            type=int,
            help="IP-XACT standard to use. [2014]"
        )


    def do_export(self, top_node: 'AddrmapNode', options: 'argparse.Namespace') -> None:

        x = IPXACTExporter(
            standard=Standard(options.standard),
            vendor=options.vendor,
            library=options.library,
            version=options.version,
        )
        x.export(
            top_node,
            options.output,
            component_name=options.name
        )


class Importer(ImporterPlugin):
    file_extensions = ["xml"]

    def is_compatible(self, path: str) -> bool:
        # Could be any XML file.
        # See if file contains an ipxact or spirit component tag
        with open(path, "r", encoding="utf-8") as f:
            if re.search(r"<(spirit|ipxact):component\b", f.read()):
                return True
        return False # type: ignore [unreachable]

    def add_importer_arguments(self, arg_group: 'argparse.ArgumentParser') -> None:
        arg_group.add_argument(
            "--remap-state",
            metavar="STATE",
            default=None,
            help="Optional remapState string that is used to select memoryRemap regions that are tagged under a specific remap state."
        )

    def do_import(self, rdlc: 'RDLCompiler', options: 'argparse.Namespace', path: str) -> None:
        i = IPXACTImporter(rdlc)
        i.import_file(
            path,
            remap_state=options.remap_state
        )
