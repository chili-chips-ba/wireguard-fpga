from typing import Any

from systemrdl.component import Field
from systemrdl.node import Node, FieldNode
from systemrdl.udp import UDPDefinition


class _FixedpointWidth(UDPDefinition):
    valid_components = {Field}
    valid_type = int

    def validate(self, node: "Node", value: Any) -> None:
        assert isinstance(node, FieldNode)

        intwidth = node.get_property("intwidth")
        fracwidth = node.get_property("fracwidth")
        assert intwidth is not None
        assert fracwidth is not None
        prop_ref = node.inst.property_src_ref.get(self.name)

        # incompatible with "counter" fields
        if node.get_property("counter"):
            self.msg.error(
                "Fixed-point representations are not supported for counter fields.",
                prop_ref
            )

        # incompatible with "encode" fields
        if node.get_property("encode") is not None:
            self.msg.error(
                "Fixed-point representations are not supported for fields encoded as an enum.",
                prop_ref
            )

        # ensure node width = fracwidth + intwidth
        if intwidth + fracwidth != node.width:
            self.msg.error(
                f"Number of integer bits ({intwidth}) plus number of fractional bits ({fracwidth})"
                f" must be equal to the width of the component ({node.width}).",
                prop_ref
            )


class IntWidth(_FixedpointWidth):
    name = "intwidth"

    def get_unassigned_default(self, node: "Node") -> Any:
        """
        If 'fracwidth' is defined, 'intwidth' is inferred from the node width.
        """
        assert isinstance(node, FieldNode)
        fracwidth = node.get_property("fracwidth", default=None)
        if fracwidth is not None:
            return node.width - fracwidth
        else:
            # not a fixed-point number
            return None


class FracWidth(_FixedpointWidth):
    name = "fracwidth"

    def get_unassigned_default(self, node: "Node") -> Any:
        """
        If 'intwidth' is defined, 'fracwidth' is inferred from the node width.
        """
        assert isinstance(node, FieldNode)
        intwidth = node.get_property("intwidth", default=None)
        if intwidth is not None:
            return node.width - intwidth
        else:
            # not a fixed-point number
            return None
