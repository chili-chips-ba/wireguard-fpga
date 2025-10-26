from typing import TYPE_CHECKING

from peakrdl.plugins.exporter import ExporterSubcommandPlugin
from peakrdl.config import schema

from .exporter import HTMLExporter

if TYPE_CHECKING:
    import argparse
    from systemrdl.node import AddrmapNode


class Exporter(ExporterSubcommandPlugin):
    short_desc = "Generate HTML documentation"
    long_desc = "Generate dynamic HTML documentation pages"

    cfg_schema = {
        "user_template_dir": schema.DirectoryPath(),
        "user_static_dir": schema.DirectoryPath(),
        "extra_doc_properties": [schema.String()],
        "generate_source_links": schema.Boolean(),
    }


    def add_exporter_arguments(self, arg_group: 'argparse.ArgumentParser') -> None:
        arg_group.add_argument(
            "--title",
            dest="title",
            default=None,
            help="Override title text"
        )

        arg_group.add_argument(
            "--home-url",
            dest="home_url",
            metavar="URL",
            default=None,
            help="If a URL is specified, adds a home button to return to a parent home page"
        )

        arg_group.add_argument(
            "--show-signals",
            dest="show_signals",
            default=False,
            action="store_true",
            help="Show signal components in generated doc pages"
        )


    def do_export(self, top_node: 'AddrmapNode', options: 'argparse.Namespace') -> None:
        generate_source_links = self.cfg['generate_source_links']
        if generate_source_links is None:
            generate_source_links = True

        html = HTMLExporter(
            show_signals=options.show_signals,
            user_template_dir=self.cfg['user_template_dir'],
            user_static_dir=self.cfg['user_static_dir'],
            extra_doc_properties=self.cfg['extra_doc_properties'],
            generate_source_links=generate_source_links,
        )
        html.export(
            top_node,
            options.output,
            title=options.title,
            home_url=options.home_url,
        )
