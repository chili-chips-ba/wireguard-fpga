from typing import Any, Union

from systemrdl.node import RootNode, AddrmapNode, MemNode, RegfileNode

from .design_state import DesignState
from .design_scanner import DesignScanner
from .header_generator import HeaderGenerator
from .testcase_generator import TestcaseGenerator

class CHeaderExporter:
    def export(self, node: Union[RootNode, AddrmapNode], path: str, **kwargs: Any) -> None:
        """
        Parameters
        ----------
        node: AddrmapNode
            Top-level SystemRDL node to export.
        path: str
            Output header file path
        std: CStandard
            Select which GNU C standard to conform to
        reuse_typedefs: bool
            By default, the exporter will attempt to re-use typedefs for
            nodes that are equivalent. This allows for better modularity and type reuse.
            Struct type names are derived using the SystemRDL component's type
            name and declared lexical scope path.

            If this is not desireable, override this parameter to ``False`` and structs
            will be generated more naively using their hierarchical paths.
        generate_bitfields: bool
            If set, registers are exported as nested union/structs to provide structured
            access to individual bitfields.
        bitfield_order_ltoh: bool
            The packing order of C struct bitfields is implementation defined.
            If True, packing will assume low-to-high bit-packing order.
        wide_reg_subword_size: int
            C's <stdint.h> types only extend up to 64-bit types.
            If a register is encountered that is larger than this, the generated
            header will represent it using an array of smaller sub-words.
            Set the desired sub-word size.
            Shall be 8, 16, 32 or 64.
        explode_top: bool
            If set, the top-level hiearchy is skipped. Instead, definitions for
            all the direct children are generated.

            Note that only block-like definitons are generated.
            i.e: children that are registers are skipped.
        instantiate: bool
            If set, header will also include a macro that instantiates each top-level
            block at a defined hardware address, allowing for direct access.
        inst_offset: int
            Apply an additional address offset to instance definitions.
        testcase: bool
            Generate a testcase C file
        """
        # If it is the root node, skip to top addrmap
        if isinstance(node, RootNode):
            top_node = node.top
        else:
            top_node = node

        ds = DesignState(top_node, kwargs)

        # Check for stray kwargs
        if kwargs:
            raise TypeError(f"got an unexpected keyword argument '{list(kwargs.keys())[0]}'")

        # Validate and collect info for export
        DesignScanner(ds).run()

        top_nodes = []
        if ds.explode_top:
            for child in top_node.children():
                if isinstance(child, (AddrmapNode, MemNode, RegfileNode)):
                    top_nodes.append(child)
        else:
            top_nodes.append(top_node)

        # Write output
        HeaderGenerator(ds).run(path, top_nodes)
        if ds.testcase:
            TestcaseGenerator(ds).run(path, top_nodes)
