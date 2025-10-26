from typing import Any, Dict, List
import os

import jinja2 as jj
from systemrdl.node import AddrmapNode

from .c_standards import CStandard

class DesignState:
    def __init__(self, top_node: AddrmapNode, kwargs: Any) -> None:
        loader = jj.FileSystemLoader(os.path.join(os.path.dirname(__file__), "templates"))
        self.jj_env = jj.Environment(
            loader=loader,
            undefined=jj.StrictUndefined
        )

        self.top_node = top_node

        #------------------------
        # Info about the design
        #------------------------
        # Each reg that has overlapping fields generates an entry:
        #   reg_path : list of field names involved in overlap
        self.overlapping_fields = {} # type: Dict[str, List[str]]

        # Pairs of overlapping registers
        #   first_reg_path : partner_register_name
        self.overlapping_reg_pairs = {} # type: Dict[str, str]

        #------------------------
        # Extract compiler args
        #------------------------
        self.std: CStandard
        self.std = kwargs.pop("std", CStandard.latest)
        assert isinstance(self.std, CStandard)

        self.reuse_typedefs: bool
        self.reuse_typedefs = kwargs.pop("reuse_typedefs", True)

        # Enable generation of bit-field structs for registers
        self.generate_bitfields: bool
        self.generate_bitfields = kwargs.pop("generate_bitfields", False)

        # Bitfield order is implementation defined
        self.bitfield_order_ltoh: bool
        self.bitfield_order_ltoh = kwargs.pop("bitfield_order_ltoh", True)

        # If a register is wider than 64-bits, it cannot be represented by a stdint
        # type. Therefore it must be represented by an array of subwords
        self.wide_reg_subword_size: int
        self.wide_reg_subword_size = kwargs.pop("wide_reg_subword_size", 32)
        assert self.wide_reg_subword_size in {8, 16, 32, 64}

        self.explode_top: bool
        self.explode_top = kwargs.pop("explode_top", False)

        self.instantiate: bool
        self.instantiate = kwargs.pop("instantiate", False)

        self.inst_offset: int
        self.inst_offset = kwargs.pop("inst_offset", 0)

        self.testcase: bool
        self.testcase = kwargs.pop("testcase", False)
