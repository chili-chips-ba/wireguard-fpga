from typing import TYPE_CHECKING, Dict, Type
import functools
import sys

from peakrdl.plugins.exporter import ExporterSubcommandPlugin
from peakrdl.config import schema
from peakrdl.plugins.entry_points import get_entry_points

from .exporter import RegblockExporter
from .cpuif import CpuifBase, apb3, apb4, axi4lite, passthrough, avalon
from .udps import ALL_UDPS

if TYPE_CHECKING:
    import argparse
    from systemrdl.node import AddrmapNode

class Exporter(ExporterSubcommandPlugin):
    short_desc = "Generate a SystemVerilog control/status register (CSR) block"

    udp_definitions = ALL_UDPS

    cfg_schema = {
        "cpuifs": {"*": schema.PythonObjectImport()},
        "default_reset": schema.Choice(["rst", "rst_n", "arst", "arst_n"]),
    }

    @functools.lru_cache()
    def get_cpuifs(self) -> Dict[str, Type[CpuifBase]]:

        # All built-in CPUIFs
        cpuifs = {
            "passthrough": passthrough.PassthroughCpuif,
            "apb3": apb3.APB3_Cpuif,
            "apb3-flat": apb3.APB3_Cpuif_flattened,
            "apb4": apb4.APB4_Cpuif,
            "apb4-flat": apb4.APB4_Cpuif_flattened,
            "axi4-lite": axi4lite.AXI4Lite_Cpuif,
            "axi4-lite-flat": axi4lite.AXI4Lite_Cpuif_flattened,
            "avalon-mm": avalon.Avalon_Cpuif,
            "avalon-mm-flat": avalon.Avalon_Cpuif_flattened,
        }

        # Load any cpuifs specified via entry points
        for ep, dist in get_entry_points("peakrdl_regblock.cpuif"):
            name = ep.name
            cpuif = ep.load()
            if name in cpuifs:
                raise RuntimeError(f"A plugin for 'peakrdl-regblock' tried to load cpuif '{name}' but it already exists")
            if not issubclass(cpuif, CpuifBase):
                raise RuntimeError(f"A plugin for 'peakrdl-regblock' tried to load cpuif '{name}' but it not a CpuifBase class")
            cpuifs[name] = cpuif

        # Load any CPUIFs via config import
        for name, cpuif in self.cfg['cpuifs'].items():
            if name in cpuifs:
                raise RuntimeError(f"A plugin for 'peakrdl-regblock' tried to load cpuif '{name}' but it already exists")
            if not issubclass(cpuif, CpuifBase):
                raise RuntimeError(f"A plugin for 'peakrdl-regblock' tried to load cpuif '{name}' but it not a CpuifBase class")
            cpuifs[name] = cpuif

        return cpuifs


    def add_exporter_arguments(self, arg_group: 'argparse._ActionsContainer') -> None:
        cpuifs = self.get_cpuifs()

        arg_group.add_argument(
            "--cpuif",
            choices=cpuifs.keys(),
            default="apb3",
            help="Select the CPU interface protocol to use [apb3]"
        )

        arg_group.add_argument(
            "--module-name",
            metavar="NAME",
            default=None,
            help="Override the SystemVerilog module name"
        )

        arg_group.add_argument(
            "--package-name",
            metavar="NAME",
            default=None,
            help="Override the SystemVerilog package name"
        )

        arg_group.add_argument(
            "--type-style",
            dest="type_style",
            choices=['lexical', 'hier'],
            default="lexical",
            help="""Choose how HWIF struct type names are generated.
            The 'lexical' style will use RDL lexical scope & type names where
            possible and attempt to re-use equivalent type definitions.
            The 'hier' style uses component's hierarchy as the struct type name. [lexical]
            """
        )

        arg_group.add_argument(
            "--hwif-report",
            action="store_true",
            default=False,
            help="Generate a HWIF report file"
        )

        arg_group.add_argument(
            "--addr-width",
            type=int,
            default=None,
            help="""Override the CPU interface's address width. By default,
            address width is sized to the contents of the regblock.
            """
        )

        arg_group.add_argument(
            "--rt-read-fanin",
            action="store_true",
            default=False,
            help="Enable additional read path retiming. Good for register blocks with large readback fan-in"
        )
        arg_group.add_argument(
            "--rt-read-response",
            action="store_true",
            default=False,
            help="Enable additional retiming stage between readback fan-in and cpu interface"
        )
        arg_group.add_argument(
            "--rt-external",
            help="Retime outputs to external components. Specify a comma-separated list of: reg,regfile,mem,addrmap,all"
        )

        arg_group.add_argument(
            "--default-reset",
            choices=["rst", "rst_n", "arst", "arst_n"],
            default=None,
            help="""Choose the default style of reset signal if not explicitly
            specified by the SystemRDL design. If unspecified, the default reset
            is active-high and synchronous [rst]"""
        )


    def do_export(self, top_node: 'AddrmapNode', options: 'argparse.Namespace') -> None:
        cpuifs = self.get_cpuifs()

        retime_external_reg = False
        retime_external_regfile = False
        retime_external_mem = False
        retime_external_addrmap = False
        if options.rt_external:
            for key in options.rt_external.split(","):
                key = key.strip().lower()
                if key == "reg":
                    retime_external_reg = True
                elif key == "regfile":
                    retime_external_regfile = True
                elif key == "mem":
                    retime_external_mem = True
                elif key == "addrmap":
                    retime_external_addrmap = True
                elif key == "all":
                    retime_external_reg = True
                    retime_external_regfile = True
                    retime_external_mem = True
                    retime_external_addrmap = True
                else:
                    print("error: invalid option for --rt-external: '%s'" % key, file=sys.stderr)

        # Get default reset. Favor command-line over cfg. Fall back to 'rst'
        default_rst = options.default_reset or self.cfg['default_reset'] or "rst"
        if default_rst == "rst":
            default_reset_activelow = False
            default_reset_async = False
        elif default_rst == "rst_n":
            default_reset_activelow = True
            default_reset_async = False
        elif default_rst == "arst":
            default_reset_activelow = False
            default_reset_async = True
        elif default_rst == "arst_n":
            default_reset_activelow = True
            default_reset_async = True
        else:
            raise RuntimeError


        x = RegblockExporter()
        x.export(
            top_node,
            options.output,
            cpuif_cls=cpuifs[options.cpuif],
            module_name=options.module_name,
            package_name=options.package_name,
            reuse_hwif_typedefs=(options.type_style == "lexical"),
            retime_read_fanin=options.rt_read_fanin,
            retime_read_response=options.rt_read_response,
            retime_external_reg=retime_external_reg,
            retime_external_regfile=retime_external_regfile,
            retime_external_mem=retime_external_mem,
            retime_external_addrmap=retime_external_addrmap,
            generate_hwif_report=options.hwif_report,
            address_width=options.addr_width,
            default_reset_activelow=default_reset_activelow,
            default_reset_async=default_reset_async,
        )
