from typing import Any

from systemrdl.udp import UDPDefinition
from systemrdl.component import Reg
from systemrdl.rdltypes.references import RefType, PropertyReference
from systemrdl.rdltypes import NoValue
from systemrdl.node import Node, RegNode, VectorNode, SignalNode, FieldNode


class xBufferTrigger(UDPDefinition):
    valid_components = {Reg}
    valid_type = RefType

    def validate(self, node: Node, value: Any) -> None:
        # TODO: Reference shall not cross an internal/external boundary

        if value is NoValue:
            self.msg.error(
                "Double-buffer trigger property is missing a value assignment",
                self.get_src_ref(node)
            )
        elif isinstance(value, VectorNode):
            # Trigger can reference a vector, but only if it is a single-bit
            if value.width != 1:
                self.msg.error(
                    "%s '%s' references %s '%s' but its width is not 1"
                    % (
                        type(node.inst).__name__.lower(), node.inst_name,
                        type(value.inst).__name__.lower(), value.inst_name
                    ),
                    self.get_src_ref(node)
                )

            if isinstance(value, SignalNode):
                if not value.get_property('activehigh') and not value.get_property('activelow'):
                    self.msg.error(
                        "Trigger was asigned a signal, but it does not specify whether it is activehigh/activelow",
                        self.get_src_ref(node)
                    )

        elif isinstance(value, PropertyReference) and value.width is not None:
            # Trigger can reference a property, but only if it is a single-bit
            if value.width != 1:
                self.msg.error(
                    "%s '%s' references property '%s->%s' but its width is not 1"
                    % (
                        type(node.inst).__name__.lower(), node.inst_name,
                        value.node.inst_name, value.name,
                    ),
                    self.get_src_ref(node)
                )
        elif isinstance(value, RegNode):
            # Trigger can reference a register, which implies access of the
            # 'correct half' of the register is the trigger.
            # For buffered writes, it is the upper-half.
            # For buffered reads, it is the lower-half.
            pass
        else:
            # All other reference types are invalid
            self.msg.error(
                "Reference to a %s component is incompatible with the '%s' property."
                % (type(node.inst).__name__.lower(), self.name),
                self.get_src_ref(node)
            )

#-------------------------------------------------------------------------------
class BufferWrites(UDPDefinition):
    name = "buffer_writes"
    valid_components = {Reg}
    valid_type = bool

    def validate(self, node: 'Node', value: Any) -> None:
        assert isinstance(node, RegNode)
        if value:
            if not node.has_sw_writable:
                self.msg.error(
                    "'buffer_writes' is set to true, but this register does not contain any writable fields.",
                    self.get_src_ref(node)
                )

    def get_unassigned_default(self, node: 'Node') -> Any:
        return False


class WBufferTrigger(xBufferTrigger):
    name = "wbuffer_trigger"

    def get_unassigned_default(self, node: 'Node') -> Any:
        # If buffering is enabled, trigger is the register itself
        if node.get_property('buffer_writes'):
            return node
        return None

    def validate(self, node: Node, value: Any) -> None:
        super().validate(node, value)

        if isinstance(value, FieldNode):
            if value.parent == node:
                self.msg.error(
                    "Trigger for a write-buffered register cannot be a field "
                    "within the same register since the buffering makes it impossible to trigger."
                )


class BufferReads(UDPDefinition):
    name = "buffer_reads"
    valid_components = {Reg}
    valid_type = bool

    def validate(self, node: 'Node', value: Any) -> None:
        assert isinstance(node, RegNode)
        if value:
            if not node.has_sw_readable:
                self.msg.error(
                    "'buffer_reads' is set to true, but this register does not contain any readable fields.",
                    self.get_src_ref(node)
                )

    def get_unassigned_default(self, node: 'Node') -> Any:
        return False


class RBufferTrigger(xBufferTrigger):
    name = "rbuffer_trigger"

    def get_unassigned_default(self, node: 'Node') -> Any:
        # If buffering is enabled, trigger is the register itself
        if node.get_property('buffer_reads'):
            return node
        return None
