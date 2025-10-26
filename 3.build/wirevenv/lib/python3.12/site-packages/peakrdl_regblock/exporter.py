import os
from typing import TYPE_CHECKING, Union, Any, Type, Optional, Set, List
from collections import OrderedDict

import jinja2 as jj
from systemrdl.node import AddrmapNode, RootNode

from .addr_decode import AddressDecode
from .field_logic import FieldLogic
from .dereferencer import Dereferencer
from .readback import Readback
from .identifier_filter import kw_filter as kwf
from .utils import clog2
from .scan_design import DesignScanner
from .validate_design import DesignValidator
from .cpuif import CpuifBase
from .cpuif.apb4 import APB4_Cpuif
from .hwif import Hwif
from .write_buffering import WriteBuffering
from .read_buffering import ReadBuffering
from .external_acks import ExternalWriteAckGenerator, ExternalReadAckGenerator
from .parity import ParityErrorReduceGenerator
from .sv_int import SVInt

if TYPE_CHECKING:
    from systemrdl.node import SignalNode
    from systemrdl.rdltypes import UserEnum

class RegblockExporter:
    hwif: Hwif
    cpuif: CpuifBase
    address_decode: AddressDecode
    field_logic: FieldLogic
    readback: Readback
    write_buffering: WriteBuffering
    read_buffering: ReadBuffering
    dereferencer: Dereferencer
    ds: 'DesignState'

    def __init__(self, **kwargs: Any) -> None:
        # Check for stray kwargs
        if kwargs:
            raise TypeError(f"got an unexpected keyword argument '{list(kwargs.keys())[0]}'")


        loader = jj.ChoiceLoader([
            jj.FileSystemLoader(os.path.dirname(__file__)),
            jj.PrefixLoader({
                'base': jj.FileSystemLoader(os.path.dirname(__file__)),
            }, delimiter=":")
        ])

        self.jj_env = jj.Environment(
            loader=loader,
            undefined=jj.StrictUndefined,
        )


    def export(self, node: Union[RootNode, AddrmapNode], output_dir:str, **kwargs: Any) -> None:
        """
        Parameters
        ----------
        node: AddrmapNode
            Top-level SystemRDL node to export.
        output_dir: str
            Path to the output directory where generated SystemVerilog will be written.
            Output includes two files: a module definition and package definition.
        cpuif_cls: :class:`peakrdl_regblock.cpuif.CpuifBase`
            Specify the class type that implements the CPU interface of your choice.
            Defaults to AMBA APB4.
        module_name: str
            Override the SystemVerilog module name. By default, the module name
            is the top-level node's name.
        package_name: str
            Override the SystemVerilog package name. By default, the package name
            is the top-level node's name with a "_pkg" suffix.
        reuse_hwif_typedefs: bool
            By default, the exporter will attempt to re-use hwif struct definitions for
            nodes that are equivalent. This allows for better modularity and type reuse.
            Struct type names are derived using the SystemRDL component's type
            name and declared lexical scope path.

            If this is not desireable, override this parameter to ``False`` and structs
            will be generated more naively using their hierarchical paths.
        retime_read_fanin: bool
            Set this to ``True`` to enable additional read path retiming.
            For large register blocks that operate at demanding clock rates, this
            may be necessary in order to manage large readback fan-in.

            The retiming flop stage is automatically placed in the most optimal point in the
            readback path so that logic-levels and fanin are minimized.

            Enabling this option will increase read transfer latency by 1 clock cycle.
        retime_read_response: bool
            Set this to ``True`` to enable an additional retiming flop stage between
            the readback mux and the CPU interface response logic.
            This option may be beneficial for some CPU interfaces that implement the
            response logic fully combinationally. Enabling this stage can better
            isolate timing paths in the register file from the rest of your system.

            Enabling this when using CPU interfaces that already implement the
            response path sequentially may not result in any meaningful timing improvement.

            Enabling this option will increase read transfer latency by 1 clock cycle.
        retime_external_reg: bool
            Retime outputs to external ``reg`` components.
        retime_external_regfile: bool
            Retime outputs to external ``regfile`` components.
        retime_external_mem: bool
            Retime outputs to external ``mem`` components.
        retime_external_addrmap: bool
            Retime outputs to external ``addrmap`` components.
        generate_hwif_report: bool
            If set, generates a hwif report that can help designers understand
            the contents of the ``hwif_in`` and ``hwif_out`` structures.
        address_width: int
            Override the CPU interface's address width. By default, address width
            is sized to the contents of the regblock.
        default_reset_activelow: bool
            If overriden to True, default reset is active-low instead of active-high.
        default_reset_async: bool
            If overriden to True, default reset is asynchronous instead of synchronous.
        """
        # If it is the root node, skip to top addrmap
        if isinstance(node, RootNode):
            top_node = node.top
        else:
            top_node = node

        self.ds = DesignState(top_node, kwargs)

        cpuif_cls = kwargs.pop("cpuif_cls", None) or APB4_Cpuif # type: Type[CpuifBase]
        generate_hwif_report = kwargs.pop("generate_hwif_report", False) # type: bool

        # Check for stray kwargs
        if kwargs:
            raise TypeError(f"got an unexpected keyword argument '{list(kwargs.keys())[0]}'")

        if generate_hwif_report:
            path = os.path.join(output_dir, f"{self.ds.module_name}_hwif.rpt")
            hwif_report_file = open(path, "w", encoding='utf-8') # pylint: disable=consider-using-with
        else:
            hwif_report_file = None

        # Construct exporter components
        self.cpuif = cpuif_cls(self)
        self.hwif = Hwif(self, hwif_report_file=hwif_report_file)
        self.readback = Readback(self)
        self.address_decode = AddressDecode(self)
        self.field_logic = FieldLogic(self)
        self.write_buffering = WriteBuffering(self)
        self.read_buffering = ReadBuffering(self)
        self.dereferencer = Dereferencer(self)
        ext_write_acks = ExternalWriteAckGenerator(self)
        ext_read_acks = ExternalReadAckGenerator(self)
        parity = ParityErrorReduceGenerator(self)

        # Validate that there are no unsupported constructs
        DesignValidator(self).do_validate()

        # Compute readback implementation early.
        # Readback has the capability to disable retiming if the fanin is tiny.
        # This affects the rest of the design's implementation, and must be known
        # before any other templates are rendered
        readback_implementation = self.readback.get_implementation()

        # Build Jinja template context
        context = {
            "cpuif": self.cpuif,
            "hwif": self.hwif,
            "write_buffering": self.write_buffering,
            "read_buffering": self.read_buffering,
            "get_resetsignal": self.dereferencer.get_resetsignal,
            "default_resetsignal_name": self.dereferencer.default_resetsignal_name,
            "address_decode": self.address_decode,
            "field_logic": self.field_logic,
            "readback_implementation": readback_implementation,
            "ext_write_acks": ext_write_acks,
            "ext_read_acks": ext_read_acks,
            "parity": parity,
            "get_always_ff_event": self.dereferencer.get_always_ff_event,
            "ds": self.ds,
            "kwf": kwf,
            "SVInt" : SVInt,
        }

        # Write out design
        os.makedirs(output_dir, exist_ok=True)
        package_file_path = os.path.join(output_dir, self.ds.package_name + ".sv")
        template = self.jj_env.get_template("package_tmpl.sv")
        stream = template.stream(context)
        stream.dump(package_file_path)

        module_file_path = os.path.join(output_dir, self.ds.module_name + ".sv")
        template = self.jj_env.get_template("module_tmpl.sv")
        stream = template.stream(context)
        stream.dump(module_file_path)

        if hwif_report_file:
            hwif_report_file.close()


class DesignState:
    """
    Dumping ground for all sorts of variables that are relevant to a particular
    design.
    """

    def __init__(self, top_node: AddrmapNode, kwargs: Any) -> None:
        self.top_node = top_node
        msg = top_node.env.msg

        #------------------------
        # Extract compiler args
        #------------------------
        self.reuse_hwif_typedefs = kwargs.pop("reuse_hwif_typedefs", True) # type: bool
        self.module_name = kwargs.pop("module_name", None) or kwf(self.top_node.inst_name) # type: str
        self.package_name = kwargs.pop("package_name", None) or (self.module_name + "_pkg") # type: str
        user_addr_width = kwargs.pop("address_width", None) # type: Optional[int]

        # Pipelining options
        self.retime_read_fanin = kwargs.pop("retime_read_fanin", False) # type: bool
        self.retime_read_response = kwargs.pop("retime_read_response", False) # type: bool
        self.retime_external_reg = kwargs.pop("retime_external_reg", False) # type: bool
        self.retime_external_regfile = kwargs.pop("retime_external_regfile", False) # type: bool
        self.retime_external_mem = kwargs.pop("retime_external_mem", False) # type: bool
        self.retime_external_addrmap = kwargs.pop("retime_external_addrmap", False) # type: bool

        # Default reset type
        self.default_reset_activelow = kwargs.pop("default_reset_activelow", False) # type: bool
        self.default_reset_async = kwargs.pop("default_reset_async", False) # type: bool

        #------------------------
        # Info about the design
        #------------------------
        self.cpuif_data_width = 0

        # Collections of signals that were actually referenced by the design
        self.in_hier_signal_paths = set() # type: Set[str]
        self.out_of_hier_signals = OrderedDict() # type: OrderedDict[str, SignalNode]

        self.has_writable_msb0_fields = False
        self.has_buffered_write_regs = False
        self.has_buffered_read_regs = False

        self.has_external_block = False
        self.has_external_addressable = False

        self.has_paritycheck = False

        # Track any referenced enums
        self.user_enums = [] # type: List[Type[UserEnum]]

        # Scan the design to fill in above variables
        DesignScanner(self).do_scan()

        if self.cpuif_data_width == 0:
            # Scanner did not find any registers in the design being exported,
            # so the width is not known.
            # Assume 32-bits
            msg.warning(
                "Addrmap being exported only contains external components. Unable to infer the CPUIF bus width. Assuming 32-bits.",
                self.top_node.inst.def_src_ref
            )
            self.cpuif_data_width = 32

        #------------------------
        # Min address width encloses the total size AND at least 1 useful address bit
        self.addr_width = max(clog2(self.top_node.size), clog2(self.cpuif_data_width//8) + 1)

        if user_addr_width is not None:
            if user_addr_width < self.addr_width:
                msg.fatal(f"User-specified address width shall be greater than or equal to {self.addr_width}.")
            self.addr_width = user_addr_width

    @property
    def min_read_latency(self) -> int:
        n = 0
        if self.retime_read_fanin:
            n += 1
        if self.retime_read_response:
            n += 1
        return n

    @property
    def min_write_latency(self) -> int:
        n = 0
        return n
