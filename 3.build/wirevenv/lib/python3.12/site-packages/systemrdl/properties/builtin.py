from typing import TYPE_CHECKING, Any, Optional, Union

from .bases import PropertyRule, PropertyRuleBoolPair

from .. import component as comp
from .. import node as m_node
from ..ast.cast import AssignmentCast
from ..ast.ast_node import ASTNode
from .. import rdltypes

if TYPE_CHECKING:
    from ..source_ref import SourceRefBase
    from ..compiler import RDLEnvironment

#===============================================================================
# General Properties
#===============================================================================
class Prop_name(PropertyRule):
    """
    Specifies a more descriptive name
    (5.2.1)
    """
    bindable_to = {comp.Addrmap, comp.Field, comp.Mem, comp.Reg, comp.Regfile, comp.Signal}
    valid_types = (str,)
    default = ""
    dyn_assign_allowed = True
    mutex_group = None

    def get_default(self, node: m_node.Node) -> str:
        """
        If name is undefined, it is presumed to be the instance name.
        (5.2.1.1)
        """
        return node.inst_name


class Prop_desc(PropertyRule):
    """
    Describes the component's purpose.
    (5.2.1)
    """
    bindable_to = {comp.Addrmap, comp.Field, comp.Mem, comp.Reg, comp.Regfile, comp.Signal}
    valid_types = (str,)
    default = None
    dyn_assign_allowed = True
    mutex_group = None


class Prop_dontcompare(PropertyRule):
    """
    Indicates the components read data shall be discarded and not compared
    against expected results.
    (5.2.2)
    """
    bindable_to = {comp.Addrmap, comp.Reg, comp.Regfile, comp.Field}
    valid_types = (int, bool,)
    default = False
    dyn_assign_allowed = True

    def assign_value(self, comp_def: comp.Component, value: Any, src_ref: 'SourceRefBase') -> None:
        super().assign_value(comp_def, value, src_ref)

        # int type only makes sense if assigned to a field (since it is a bitmask)
        # If assigned to any other components, exclusively cast it to a boolean
        if not isinstance(comp_def, comp.Field):
            value = comp_def.properties[self.get_name()]
            if isinstance(value, ASTNode):
                # was not an implicit True assignment
                value = AssignmentCast(self.env, src_ref, value, bool)
                comp_def.properties[self.get_name()] = value

    def validate(self, node: m_node.Node, value: Any) -> None:
        donttest = node.get_property('donttest')

        if isinstance(node, m_node.FieldNode):
            # 5.2.2.1-a: If value is a bit mask, the mask shall have the same width
            # as the field
            if not isinstance(value, bool) and isinstance(value, int):
                if value.bit_length() > node.width:
                    self.env.msg.error(
                        "Bit mask (%d) of property 'dontcompare' exceeds width (%d) of field '%s'"
                        % (value, node.width, node.inst_name),
                        self.get_src_ref(node)
                    )

            # Normalize values to masks
            if isinstance(value, bool):
                if value:
                    value = (1 << node.width) - 1
                else:
                    value = 0
            if isinstance(donttest, bool):
                if donttest:
                    donttest = (1 << node.width) - 1
                else:
                    donttest = 0

            # 5.2.2.1-c.2: dontcompare/donttest cannot have one true and the
            # other non-zero
            # 5.2.2.1-c.3: the bitwise AND of dontcompare/donttest  masks
            # shall be zero (0) for a particular component
            # (i.e., donttest & dontcompare = 0)
            if value & donttest:
                self.env.msg.error(
                    "A field's bit cannot have both 'dontcompare' and 'donttest' properties enabled",
                    node.inst_src_ref
                )

        else:
            # A boolean may end up cast as an int. Normalize 0 or 1 to boolean
            if not isinstance(value, bool) and isinstance(value, int) and value in (0, 1):
                value = bool(value)

            # 5.2.2.1-b: can also be applied to reg, regfile, and addrmap
            # components, but only as a boolean
            if not isinstance(value, bool):
                self.env.msg.error(
                    "Property 'dontcompare' expects a boolean for non-field types. Got an integer in '%s'"
                    % (node.inst_name),
                    node.inst_src_ref
                )

            # 5.2.2.1-c.1: dontcompare/donttest cannot both be set to true
            if donttest and value:
                self.env.msg.error(
                    "Properties dontcompare/donttest cannot both be set to true in '%s'"
                    % (node.inst_name),
                    node.inst_src_ref
                )


class Prop_donttest(PropertyRule):
    """
    Indicates the component is not included in structural testing.
    (5.2.2)
    """
    bindable_to = {comp.Addrmap, comp.Reg, comp.Regfile, comp.Field}
    valid_types = (int, bool,)
    default = False
    dyn_assign_allowed = True

    def assign_value(self, comp_def: comp.Component, value: Any, src_ref: 'SourceRefBase') -> None:
        super().assign_value(comp_def, value, src_ref)

        # int type only makes sense if assigned to a field (since it is a bitmask)
        # If assigned to any other components, exclusively cast it to a boolean
        if not isinstance(comp_def, comp.Field):
            value = comp_def.properties[self.get_name()]
            if isinstance(value, ASTNode):
                # was not an implicit True assignment
                value = AssignmentCast(self.env, src_ref, value, bool)
                comp_def.properties[self.get_name()] = value

    def validate(self, node: m_node.Node, value: Any) -> None:
        if isinstance(node, m_node.FieldNode):
            # 5.2.2.1-a: If value is a bit mask, the mask shall have the same width
            # as the field
            if not isinstance(value, bool) and isinstance(value, int):
                if value >= (1 << node.width):
                    self.env.msg.error(
                        "Bit mask (%d) of property 'donttest' exceeds width (%d) of field '%s'"
                        % (value, node.width, node.inst_name),
                        self.get_src_ref(node)
                    )
        else:
            # A boolean may end up cast as an int. Normalize 0 or 1 to boolean
            if not isinstance(value, bool) and isinstance(value, int) and value in (0, 1):
                value = bool(value)

            # 5.2.2.1-b: can also be applied to reg, regfile, and addrmap
            # components, but only as a boolean
            if not isinstance(value, bool):
                self.env.msg.error(
                    "Property 'donttest' expects a boolean for non-field types. Got an integer in '%s'"
                    % (node.inst_name),
                    self.get_src_ref(node)
                )


class Prop_ispresent(PropertyRule):
    """
    Setting ispresent to false causes the given component instance to be removed
    from the final specification.
    (5.3)
    """
    bindable_to = {comp.Addrmap, comp.Field, comp.Mem, comp.Reg, comp.Regfile, comp.Signal}
    valid_types = (bool,)
    default = True
    dyn_assign_allowed = True


class Prop_errextbus(PropertyRule):
    bindable_to = {comp.Addrmap, comp.Reg, comp.Regfile}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = False

    def validate(self, node: m_node.Node, value: Any) -> None:
        # 10.6.1-h: errextbus is only valid for external registers
        if (node.external is False) and (value is True):
            self.env.msg.error(
                "The 'errextbus' property is set to 'true', but instance '%s' is not external"
                % (node.inst_name),
                node.inst_src_ref
            )


class Prop_hdl_path(PropertyRule):
    bindable_to = {comp.Addrmap, comp.Reg, comp.Regfile}
    valid_types = (str,)
    default = None
    dyn_assign_allowed = True


class Prop_hdl_path_gate(PropertyRule):
    bindable_to = {comp.Addrmap, comp.Reg, comp.Regfile}
    valid_types = (str,)
    default = None
    dyn_assign_allowed = True


class Prop_hdl_path_gate_slice(PropertyRule):
    bindable_to = {comp.Field, comp.Mem}
    valid_types = (rdltypes.ArrayedType(str),)
    default = None
    dyn_assign_allowed = True


class Prop_hdl_path_slice(PropertyRule):
    bindable_to = {comp.Field, comp.Mem}
    valid_types = (rdltypes.ArrayedType(str),)
    default = None
    dyn_assign_allowed = True


#===============================================================================
# Signal Properties
#===============================================================================

class Prop_signalwidth(PropertyRule):
    """
    Width of the signal.
    (8.2)
    """
    bindable_to = {comp.Signal}
    valid_types = (int,)
    default = None
    dyn_assign_allowed = False

    def get_default(self, node: m_node.Node) -> Optional[int]:
        """
        If not explicitly set, inherits the instantiation's width
        """
        assert isinstance(node, m_node.SignalNode)
        return node.width


class Prop_sync(PropertyRuleBoolPair):
    """
    Signal is synchronous to the clock of the component.
    (8.2)
    """
    bindable_to = {comp.Signal}
    valid_types = (bool,)
    default = True
    dyn_assign_allowed = True
    mutex_group = "N"

    opposite_property = "async"


class Prop_async(PropertyRuleBoolPair):
    """
    Signal is asynchronous to the clock of the component.
    (8.2)
    """
    bindable_to = {comp.Signal}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "N"

    opposite_property = "sync"


class Prop_cpuif_reset(PropertyRule):
    """
    Default signal to use for resetting the software interface logic. If
    cpuif_reset is not defined, this reverts to the default reset signal. This
    parameter only controls the CPU interface of a generated slave.
    (8.2)
    """
    bindable_to = {comp.Signal}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        if value is True:
            if not node.get_property('activehigh') and not node.get_property('activelow'):
                self.env.msg.error(
                    "Signal '%s' sets the 'cpuif_reset' property but does not specify whether it is activehigh/activelow"
                    % (node.inst_name),
                    self.get_src_ref(node)
                )



class Prop_field_reset(PropertyRule):
    """
    Default signal to use for resetting field implementations. If field_reset
    is not defined, this reverts to the default reset signal.
    (8.2)
    """
    bindable_to = {comp.Signal}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        if value is True:
            if not node.get_property('activehigh') and not node.get_property('activelow'):
                self.env.msg.error(
                    "Signal '%s' sets the 'field_reset' property but does not specify whether it is activehigh/activelow"
                    % (node.inst_name),
                    self.get_src_ref(node)
                )


class Prop_activelow(PropertyRule):
    """
    Signal is active low (state of 0 means ON).
    (8.2)
    """
    bindable_to = {comp.Signal}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "A"


class Prop_activehigh(PropertyRule):
    """
    Signal is active high (state of 1 means ON).
    (8.2)
    """
    bindable_to = {comp.Signal}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "A"

#===============================================================================
# Field Properties
#===============================================================================

#-------------------------------------------------------------------------------
# Field access Properties
#-------------------------------------------------------------------------------
class Prop_hw(PropertyRule):
    """
    Design's ability to sample/update a field.
    (9.4)
    """
    bindable_to = {comp.Field}
    valid_types = (rdltypes.AccessType,)
    default = rdltypes.AccessType.rw
    dyn_assign_allowed = False


class Prop_sw(PropertyRule):
    """
    Programmer's ability to read/write a field.
    (9.4)
    """
    bindable_to = {comp.Field, comp.Mem}
    valid_types = (rdltypes.AccessType,)
    default = rdltypes.AccessType.rw
    dyn_assign_allowed = True

#-------------------------------------------------------------------------------
# Hardware Signal Properties
#-------------------------------------------------------------------------------
class Prop_next(PropertyRule):
    """
    The next value of the field; the D-input for flip-flops.
    (9.5)
    """
    bindable_to = {comp.Field}
    valid_types = (comp.Field, comp.Signal, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)

        # 9.5.1-e: next cannot be self-referencing
        if isinstance(value, rdltypes.PropertyReference):
            ref_node = value.node
        else:
            ref_node = value

        if node.get_path() == ref_node.get_path():
            self.env.msg.error(
                "Field '%s' cannot reference itself in next property"
                % (node.inst_name),
                self.get_src_ref(node)
            )

        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)

        # Field shall be hardware writable
        # Example in 17.2.8 makes a passing comment that suggests this is a requirement.
        if not node.is_hw_writable:
            self.env.msg.error(
                "Use of the 'next' property requires the field to be hardware-writable.",
                self.get_src_ref(node)
            )


class Prop_reset(PropertyRule):
    """
    The reset value for the field when resetsignal is asserted.
    (9.5)
    """
    bindable_to = {comp.Field}
    valid_types = (int, comp.Field, comp.Signal, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        if isinstance(value, int):
            # 9.5.1-c: The reset value cannot be larger than can fit in the field
            if value.bit_length() > node.width:
                self.env.msg.error(
                    "The reset value (%d) of field '%s' cannot fit within its width (%d)"
                    % (value, node.inst_name, node.width),
                    self.get_src_ref(node)
                )
        elif isinstance(value, m_node.FieldNode):
            # 9.5.1-e: reset cannot be self-referencing
            if node.get_path() == value.get_path():
                self.env.msg.error(
                    "Field '%s' cannot reference itself in reset property"
                    % (node.inst_name),
                    self.get_src_ref(node)
                )
        elif isinstance(value, (m_node.SignalNode, rdltypes.PropertyReference)):
            pass
        else:
            raise RuntimeError

        # Check width
        # 9.5.1-d: When reset is a reference, it shall reference another
        # field of the same size.
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)


class Prop_resetsignal(PropertyRule):
    """
    Reference to the signal used to reset the field
    (9.5)
    """
    bindable_to = {comp.Field}
    valid_types = (comp.Signal,)
    default = None
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(value, m_node.SignalNode)
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)

        if not value.get_property('activehigh') and not value.get_property('activelow'):
            self.env.msg.error(
                "Signal '%s' referenced in 'resetsignal' does not specify whether it is activehigh/activelow"
                % (value.inst_name),
                self.get_src_ref(node)
            )

    def get_default(self, node: m_node.Node) -> Optional[m_node.SignalNode]:
        """
        If no field reset signal was explicitly assigned, search for signals in
        the enclosing hierarchy with field_reset=True
        """
        current_node: Optional[m_node.Node] = node
        while current_node is not None:
            for signal in current_node.signals():
                if signal.get_property('field_reset'):
                    return signal
            current_node = current_node.parent

        return None

#-------------------------------------------------------------------------------
# Software access properties
#-------------------------------------------------------------------------------

class Prop_rclr(PropertyRule):
    """
    Clear on read (field = 0).
    (9.6)6
    """
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "P"

    def get_default(self, node: m_node.Node) -> bool:
        """
        If not explicitly set, check if onread sets the equivalent
        """
        # Check for explicit assignment to avoid infinite loop via get_default()
        if node.inst.properties.get("onread", None) == rdltypes.OnReadType.rclr:
            return True
        else:
            return self.default

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        if value is True and not node.is_sw_readable:
            self.env.msg.error(
                "Field '%s' sets the 'rclr' property but does not have software read access"
                % (node.inst_name),
                self.get_src_ref(node)
            )


class Prop_rset(PropertyRule):
    """
    Set on read (field = all 1's).
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "P"

    def get_default(self, node: m_node.Node) -> bool:
        """
        If not explicitly set, check if onread sets the equivalent
        """
        # Check for explicit assignment to avoid infinite loop via get_default()
        if node.inst.properties.get("onread", None) == rdltypes.OnReadType.rset:
            return True
        else:
            return self.default

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        if value is True and not node.is_sw_readable:
            self.env.msg.error(
                "Field '%s' sets the 'rset' property but does not have software read access"
                % (node.inst_name),
                self.get_src_ref(node)
            )


class Prop_onread(PropertyRule):
    """
    Read side-effect.
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (rdltypes.OnReadType,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "P"

    def get_default(self, node: m_node.Node) -> Optional[rdltypes.OnReadType]:
        """
        If not explicitly set, check if rset or rclr imply the value
        """
        # Check for explicit assignment to avoid infinite loop via get_default()
        if node.inst.properties.get("rset", False):
            return rdltypes.OnReadType.rset
        elif node.inst.properties.get("rclr", False):
            return rdltypes.OnReadType.rclr
        else:
            return self.default

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        # 9.6.1-i A field with an onread property shall have software read access
        if (value is not None) and not node.is_sw_readable:
            self.env.msg.error(
                "Field '%s' has an 'onread' property but does not have software read access"
                % (node.inst_name),
                self.get_src_ref(node)
            )

        # 9.6.1-j A field with an onread value of ruser shall be external
        if (node.external is False) and (value == rdltypes.OnReadType.ruser):
            self.env.msg.error(
                "The 'onread' property is set to 'ruser', but instance '%s' is not external"
                % (node.inst_name),
                node.inst_src_ref
            )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class Prop_woclr(PropertyRule):
    """
    Write one to clear (field = field & ~write_data).
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "B"

    def get_default(self, node: m_node.Node) -> bool:
        """
        If not explicitly set, check if onwrite sets the equivalent
        """
        # Check for explicit assignment to avoid infinite loop via get_default()
        if node.inst.properties.get("onwrite", None) == rdltypes.OnWriteType.woclr:
            return True
        else:
            return self.default

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        if value is True and not node.is_sw_writable:
            self.env.msg.error(
                "Field '%s' sets the 'woclr' property but does not have software write access"
                % (node.inst_name),
                self.get_src_ref(node)
            )


class Prop_woset(PropertyRule):
    """
    Write one to set (field = field | write_data).
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "B"

    def get_default(self, node: m_node.Node) -> bool:
        """
        If not explicitly set, check if onwrite sets the equivalent
        """
        # Check for explicit assignment to avoid infinite loop via get_default()
        if node.inst.properties.get("onwrite", None) == rdltypes.OnWriteType.woset:
            return True
        else:
            return self.default

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        if value is True and not node.is_sw_writable:
            self.env.msg.error(
                "Field '%s' sets the 'woset' property but does not have software write access"
                % (node.inst_name),
                self.get_src_ref(node)
            )


class Prop_onwrite(PropertyRule):
    """
    Write side-effect
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (rdltypes.OnWriteType,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "B"

    def get_default(self, node: m_node.Node) -> Optional[rdltypes.OnWriteType]:
        """
        If not explicitly set, check if woset or woclr imply the value
        """
        # Check for explicit assignment to avoid infinite loop via get_default()
        if node.inst.properties.get("woset", False):
            return rdltypes.OnWriteType.woset
        elif node.inst.properties.get("woclr", False):
            return rdltypes.OnWriteType.woclr
        else:
            return self.default

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        # 9.6.1-l A field with an onwrite property shall have software write access.
        if (value is not None) and not node.is_sw_writable:
            self.env.msg.error(
                "Field '%s' has an 'onwrite' property but does not have software write access"
                % (node.inst_name),
                self.get_src_ref(node)
            )

        # 9.6.1-m A field with an onwrite value of wuser shall be external
        if (node.external is False) and (value == rdltypes.OnWriteType.wuser):
            self.env.msg.error(
                "The 'onwrite' property is set to 'wuser', but instance '%s' is not external"
                % (node.inst_name),
                node.inst_src_ref
            )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
def _validate_swwe_writable(env: "RDLEnvironment", node: m_node.Node, prop_name: str, prop_value: Union[bool, rdltypes.ComponentRef]) -> None:
    # swwe and swwel properties enable a hardware signal that allows the
    # writability of a field to change at runtime.
    # If either property is used, then the field is implicitly considered
    # writable at some point.
    # If the field's 'sw' property conflicts with this, emit an error to
    # the user.
    this_f_sw = node.get_property('sw')

    if isinstance(prop_value, m_node.Node):
        shall_be_writable = True
    elif prop_value is True:
        shall_be_writable = True
    else:
        shall_be_writable = False

    if shall_be_writable:
        if this_f_sw == rdltypes.AccessType.r:
            env.msg.error(
                "Field's software access is 'sw=r' but property '%s' implies it can be written in some situations during runtime."
                % prop_name,
                node.property_src_ref.get(prop_name, node.inst_src_ref)
            )
        elif this_f_sw == rdltypes.AccessType.na:
            env.msg.error(
                "Field's software access is 'sw=na' but property '%s' implies it can be written in some situations during runtime."
                % prop_name,
                node.property_src_ref.get(prop_name, node.inst_src_ref)
            )


class Prop_swwe(PropertyRule):
    """
    Override software-writeability of this field.
    Field is writable if signal/field/value is True
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "R"

    def validate(self, node: m_node.Node, value: Any) -> None:
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)
        _validate_swwe_writable(self.env, node, "swwe", value)


class Prop_swwel(PropertyRule):
    """
    Override software-writeability of this field.
    Field is writable if signal/field/value is False
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "R"

    def validate(self, node: m_node.Node, value: Any) -> None:
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)
        _validate_swwe_writable(self.env, node, "swwel", value)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class Prop_swmod(PropertyRule):
    """
    Indicates a generated output signal shall notify hardware when this field is
    modified by software
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True


class Prop_swacc(PropertyRule):
    """
    Indicates a generated output signal shall notify hardware when this field is
    accessed by software
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True


class Prop_singlepulse(PropertyRule):
    """
    Field asserts for one cycle when written 1 and then clears back to 0
    on the next cycle
    If set, field shall be instantiated with a width of 1 and the reset value
    shall be specified as 0
    (9.6)
    """
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        # 9.6.1-g: singlepulse fields shall be instantiated with a width of 1
        # and the reset value shall be specified as 0
        if value:
            if node.width != 1:
                self.env.msg.error(
                    "Field '%s' marked as 'singlepulse' shall have width of 1"
                    % (node.inst_name),
                    self.get_src_ref(node)
                )

            if node.get_property('reset') != 0:
                self.env.msg.error(
                    "Field '%s' marked as 'singlepulse' shall have a reset value of 0"
                    % (node.inst_name),
                    self.get_src_ref(node)
                )

            if not node.is_sw_writable:
                self.env.msg.error(
                    "Field '%s' marked as 'singlepulse' shall be writable by software"
                    % (node.inst_name),
                    self.get_src_ref(node)
                )

            # singlepulse does not make sense alongside any onwrite properties
            # that conflict with singlepulse semantics
            onwrite = node.get_property('onwrite')
            if onwrite is not None:
                illegal_onwrite = {
                    rdltypes.OnWriteType.woclr,
                    rdltypes.OnWriteType.wclr,
                }
                if onwrite in illegal_onwrite:
                    self.env.msg.error(
                        "Field '%s' marked as 'singlepulse' has conflicting 'onwrite' value of '%s'"
                        % (node.inst_name, onwrite.name),
                        self.get_src_ref(node)
                    )

#-------------------------------------------------------------------------------
# Hardware access properties
#-------------------------------------------------------------------------------

class Prop_we(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "C"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)

        if isinstance(value, (m_node.FieldNode, rdltypes.PropertyReference)):
            uses_we = True
        else:
            # value is boolean
            uses_we = value

        if uses_we and (node.get_property('hw') not in (rdltypes.AccessType.rw, rdltypes.AccessType.w)):
            self.env.msg.error(
                "Field '%s' sets property 'we', but the field's 'hw' property indicates is not writable by hardware"
                % (node.inst_name),
                self.get_src_ref(node)
            )

        if uses_we and not node.implements_storage and not node.is_alias:
            self.env.msg.error(
                "Use of 'we' property on field '%s' that does not implement storage does not make sense"
                % (node.inst_name),
                self.get_src_ref(node)
            )


class Prop_wel(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "C"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)

        if isinstance(value, (m_node.FieldNode, rdltypes.PropertyReference)):
            uses_we = True
        else:
            # value is boolean
            uses_we = value

        if uses_we and (node.get_property('hw') not in (rdltypes.AccessType.rw, rdltypes.AccessType.w)):
            self.env.msg.error(
                "Field '%s' sets property 'wel', but the field's 'hw' property indicates is not writable by hardware"
                % (node.inst_name),
                self.get_src_ref(node)
            )

        if uses_we and not node.implements_storage and not node.is_alias:
            self.env.msg.error(
                "Use of 'wel' property on field '%s' that does not implement storage does not make sense"
                % (node.inst_name),
                self.get_src_ref(node)
            )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class Prop_anded(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True


class Prop_ored(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True


class Prop_xored(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class Prop_fieldwidth(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (int,)
    default = None
    dyn_assign_allowed = False

    def get_default(self, node: m_node.Node) -> Optional[int]:
        """
        If not explicitly set, inherits the instantiation's width
        """
        assert isinstance(node, m_node.FieldNode)
        return node.width

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class Prop_hwclr(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)


class Prop_hwset(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class Prop_hwenable(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (comp.Field, comp.Signal, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "D"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)


class Prop_hwmask(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (comp.Field, comp.Signal, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "D"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)


#-------------------------------------------------------------------------------
# Counter field properties
#-------------------------------------------------------------------------------

class Prop_counter(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "E"


class CounterProperty(PropertyRule):
    def validate(self, node: m_node.Node, value: Any) -> None:
        # If using this property, validate that the field was marked as a counter
        if not node.get_property('counter'):
            self.env.msg.error(
                "Field '%s' uses property '%s' which is reserved for counter fields, but the field is not marked as a counter"
                % (node.inst_name, self.get_name()),
                self.get_src_ref(node)
            )


class Prop_threshold(CounterProperty):
    """
    alias of incrthreshold.
    """
    bindable_to = {comp.Field}
    valid_types = (int, bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "incrthreshold alias"

    def assign_value(self, comp_def: comp.Component, value: Any, src_ref: 'SourceRefBase') -> None:
        """
        Set both alias and actual value
        """
        super().assign_value(comp_def, value, src_ref)
        comp_def.properties['incrthreshold'] = comp_def.properties['threshold']

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)


class Prop_saturate(CounterProperty):
    """
    alias of incrsaturate.
    """
    bindable_to = {comp.Field}
    valid_types = (int, bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "incrsaturate alias"

    def assign_value(self, comp_def: comp.Component, value: Any, src_ref: 'SourceRefBase') -> None:
        """
        Set both alias and actual value
        """
        super().assign_value(comp_def, value, src_ref)
        comp_def.properties['incrsaturate'] = comp_def.properties['saturate']

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)


class Prop_incrthreshold(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (int, bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "incrthreshold alias"

    def assign_value(self, comp_def: comp.Component, value: Any, src_ref: 'SourceRefBase') -> None:
        """
        Set both alias and actual value
        """
        super().assign_value(comp_def, value, src_ref)
        comp_def.properties['threshold'] = comp_def.properties['incrthreshold']

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)


class Prop_incrsaturate(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (int, bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "incrsaturate alias"

    def assign_value(self, comp_def: comp.Component, value: Any, src_ref: 'SourceRefBase') -> None:
        """
        Set both alias and actual value
        """
        super().assign_value(comp_def, value, src_ref)
        comp_def.properties['saturate'] = comp_def.properties['incrsaturate']

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)


class Prop_overflow(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)

        if node.get_property('incrsaturate') is not False:
            self.env.msg.error(
                "Use of 'overflow' property is meaningless. Counter sets the "
                "'incrsaturate' property which makes it unable to overflow",
                self.get_src_ref(node)
            )


class Prop_underflow(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)

        if node.get_property('decrsaturate') is not False:
            self.env.msg.error(
                "Use of 'underflow' property is meaningless. Counter sets the "
                "'decrsaturate' property which makes it unable to underflow",
                self.get_src_ref(node)
            )


class Prop_incr(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)


class Prop_incrvalue(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (int, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "F"

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_width_eq_or_smaller(node, value)
        self._validate_ref_is_present(node, value)

    def get_default(self, node: m_node.Node) -> Any:
        assert isinstance(node, m_node.FieldNode)

        if node.is_up_counter and node.get_property('incrwidth') is None:
            # Is counter, but no alternatives to increment value were specified.
            return 1

        return None


class Prop_incrwidth(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (int,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "F"

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)

        if not 1 <= value <= node.width:
            self.env.msg.error(
                "A counter's 'incrwidth' must be between 1 and the counter's width (%d)"
                % node.width,
                self.get_src_ref(node)
            )


class Prop_decrvalue(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (int, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "G"

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_width_eq_or_smaller(node, value)
        self._validate_ref_is_present(node, value)

    def get_default(self, node: m_node.Node) -> Any:
        assert isinstance(node, m_node.FieldNode)
        if node.is_down_counter and node.get_property('decrwidth') is None:
            # Is counter, but no alternatives to decrement value were specified.
            return 1

        return None


class Prop_decr(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width_is_1(node, value)
        self._validate_ref_is_present(node, value)


class Prop_decrwidth(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (int,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "G"

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)

        if not 1 <= value <= node.width:
            self.env.msg.error(
                "A counter's 'decrwidth' must be between 1 and the counter's width (%d)"
                % node.width,
                self.get_src_ref(node)
            )


class Prop_decrsaturate(CounterProperty):
    bindable_to = {comp.Field}
    valid_types = (int, bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)


class Prop_decrthreshold(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (int, bool, comp.Signal, comp.Field, rdltypes.PropertyReference,)
    default = False
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        super().validate(node, value)
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)

#-------------------------------------------------------------------------------
# Field access interrupt properties
#-------------------------------------------------------------------------------

class Prop_intr(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "E"


class Prop_intr_type(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (rdltypes.InterruptType,)
    default = None
    dyn_assign_allowed = True

    @classmethod
    def get_name_cls(cls) -> str:
        # Interrupt modifier type is a "special" hidden property
        # Intentionally override the property name to something that is impossible
        # to define in RDL and collide with: contains a space!
        return "intr type"

    def get_default(self, node: m_node.Node) -> Any:
        if node.get_property('intr'):
            # If unspecified, interrupt fields are level-sensitive by default
            return rdltypes.InterruptType.level
        return None


class Prop_enable(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (comp.Field, comp.Signal, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "J"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)

        if not node.get_property('intr'):
            self.env.msg.error(
                "The 'enable' property can only be used on interrupt fields.",
                self.get_src_ref(node)
            )


class Prop_mask(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (comp.Field, comp.Signal, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "J"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)

        if not node.get_property('intr'):
            self.env.msg.error(
                "The 'mask' property can only be used on interrupt fields.",
                self.get_src_ref(node)
            )


class Prop_haltenable(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (comp.Field, comp.Signal, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "K"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)

        if not node.get_property('intr'):
            self.env.msg.error(
                "The 'haltenable' property can only be used on interrupt fields.",
                self.get_src_ref(node)
            )


class Prop_haltmask(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (comp.Field, comp.Signal, rdltypes.PropertyReference,)
    default = None
    dyn_assign_allowed = True
    mutex_group = "K"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        self._validate_ref_width(node, value)
        self._validate_ref_is_present(node, value)

        if not node.get_property('intr'):
            self.env.msg.error(
                "The 'haltmask' property can only be used on interrupt fields.",
                self.get_src_ref(node)
            )


class Prop_sticky(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "I"

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        if value is True:
            # 'sticky' property doesnt quite make sense for edge-senstive interrupts
            intr_type = node.get_property('intr type')
            if intr_type in {
                rdltypes.InterruptType.posedge,
                rdltypes.InterruptType.negedge,
                rdltypes.InterruptType.bothedge,
            }:
                self.env.msg.error(
                    "Whole-field stickiness only makes sense in level-senstive interrupts, "
                    "but this field is defined as '%s intr'. "
                    "Did you mean to use the 'stickybit' property instead of 'sticky'?"
                    % intr_type.name,
                    self.get_src_ref(node)
                )

            # Use of we/wel qualifier conflicts with sticky property
            if node.get_property('we'):
                self.env.msg.error(
                    "Use of a hardware write-enable on field '%s' does not make "
                    "sense because it is defined as 'sticky'. Sticky fields already "
                    "implicitly control their hardware write-enable behavior based on the input value."
                    % (node.inst_name),
                    node.property_src_ref.get('we', node.inst_src_ref)
                )
            if node.get_property('wel'):
                self.env.msg.error(
                    "Use of a hardware write-enable on field '%s' does not make "
                    "sense because it is defined as 'sticky'. Sticky fields already "
                    "implicitly control their hardware write-enable behavior based on the input value."
                    % (node.inst_name),
                    node.property_src_ref.get('wel', node.inst_src_ref)
                )

            if not node.is_hw_writable:
                self.env.msg.error(
                    "Sticky fields shall be hardware-writable",
                    self.get_src_ref(node)
                )


class Prop_stickybit(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = True
    mutex_group = "I"

    def get_default(self, node: m_node.Node) -> bool:
        """
        Unless specified otherwise, intr fields are implicitly stickybit
        """
        if node.get_property('intr'):
            # Field is an interrupt
            if node.get_property('sticky'):
                # ... and it was defined as multibit sticky. Not stickybit
                return False
            else:
                # By default, implies stickybit
                return True
        else:
            return False

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        if value is True:
            # Use of we/wel qualifier conflicts with stickybit property
            if node.get_property('we'):
                self.env.msg.error(
                    "Use of a hardware write-enable on field '%s' does not make "
                    "sense because it is defined as 'stickybit'. Stickybit fields already "
                    "implicitly control their hardware write-enable behavior based on the input value."
                    % (node.inst_name),
                    node.property_src_ref.get('we', node.inst_src_ref)
                )
            if node.get_property('wel'):
                self.env.msg.error(
                    "Use of a hardware write-enable on field '%s' does not make "
                    "sense because it is defined as 'stickybit'. Stickybit fields already "
                    "implicitly control their hardware write-enable behavior based on the input value."
                    % (node.inst_name),
                    node.property_src_ref.get('wel', node.inst_src_ref)
                )

            if not node.is_hw_writable:
                self.env.msg.error(
                    "Stickybit fields shall be hardware-writable",
                    self.get_src_ref(node)
                )


#-------------------------------------------------------------------------------
# Misc properties
#-------------------------------------------------------------------------------
class Prop_encode(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (rdltypes.UserEnum,)
    default = None
    dyn_assign_allowed = True

    def validate(self, node: m_node.Node, value: Any) -> None:
        assert isinstance(node, m_node.FieldNode)
        # 9.10.1-b: The enumeration's values shall fit inside the field width.
        enum_max = max(map(int, value))
        if enum_max >= (1 << node.width):
            self.env.msg.error(
                "Field '%s' is not wide enough to encode as enum '%s'"
                % (node.inst_name, value.__name__),
                self.get_src_ref(node)
            )


class Prop_precedence(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (rdltypes.PrecedenceType,)
    default = rdltypes.PrecedenceType.sw
    dyn_assign_allowed = True


class Prop_paritycheck(PropertyRule):
    bindable_to = {comp.Field}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = False
    mutex_group = None

#===============================================================================
# Reg Properties
#===============================================================================

class Prop_regwidth(PropertyRule):
    """
    The bit-width of the register (power of two).
    """
    bindable_to = {comp.Reg}
    valid_types = (int,)
    default = 32
    dyn_assign_allowed = False


class Prop_accesswidth(PropertyRule):
    """
    The minimum software access width (power of two) operation that may be
    performed on the register.
    """
    bindable_to = {comp.Reg}
    valid_types = (int,)
    default = None
    dyn_assign_allowed = True

    def get_default(self, node: m_node.Node) -> int:
        """
        10.6.1.d: The default value of the accesswidth property shall be
        identical to the width of the register.
        """
        return node.get_property('regwidth')

    def validate(self, node: m_node.Node, value: Any) -> None:
        # 10.6.1-c: The value of the accesswidth property shall not exceed the
        # value of the regwidth property
        if value > node.get_property('regwidth'):
            self.env.msg.error(
                "Register '%s' has accesswidth of %d which exceeds its regwidth of %d"
                % (node.inst_name, value, node.get_property('regwidth')),
                self.get_src_ref(node)
            )


class Prop_shared(PropertyRule):
    bindable_to = {comp.Reg}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = False

#===============================================================================
# Mem Properties
#===============================================================================

class Prop_mementries(PropertyRule):
    bindable_to = {comp.Mem}
    valid_types = (int,)
    default = 1
    dyn_assign_allowed = False


class Prop_memwidth(PropertyRule):
    bindable_to = {comp.Mem}
    valid_types = (int,)
    default = 32
    dyn_assign_allowed = False

#===============================================================================
# Register file properties
#===============================================================================

class Prop_alignment(PropertyRule):
    bindable_to = {comp.Addrmap, comp.Regfile}
    valid_types = (int,)
    default = None
    dyn_assign_allowed = False

    # RDL spec claims that if unspecified, the default alignment is based on
    # the registers width.
    # If that is taken at face-value, then it would directly conflict with the
    # 'compact' addressing rules in the situation where accesswidth < regwidth
    # Since the equivalent alignment is already handled by the addressing mode
    # rules, the alignment property's default is intentionally left as None
    # in order to distinguish it as unspecified by the user.


class Prop_sharedextbus(PropertyRule):
    bindable_to = {comp.Addrmap, comp.Regfile}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = False

#===============================================================================
# Address map properties
#===============================================================================

class Prop_bigendian(PropertyRuleBoolPair):
    bindable_to = {comp.Addrmap}
    valid_types = (bool,)
    default = False # Default both to false unless one is explicitly set
    dyn_assign_allowed = True
    mutex_group = "L"

    opposite_property = "littleendian"


class Prop_littleendian(PropertyRuleBoolPair):
    bindable_to = {comp.Addrmap}
    valid_types = (bool,)
    default = False # Default both to false unless one is explicitly set
    dyn_assign_allowed = True
    mutex_group = "L"

    opposite_property = "bigendian"


class Prop_addressing(PropertyRule):
    bindable_to = {comp.Addrmap}
    valid_types = (rdltypes.AddressingType,)
    default = rdltypes.AddressingType.regalign
    dyn_assign_allowed = False


class Prop_rsvdset(PropertyRule):
    """
    If true, the read value of all fields not explicitly defined is set to 1
    otherwise, it is set to 0.
    """
    bindable_to = {comp.Addrmap}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = False
    mutex_group = "Q"


class Prop_rsvdsetX(PropertyRule):
    bindable_to = {comp.Addrmap}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = False
    mutex_group = "Q"


class Prop_msb0(PropertyRuleBoolPair):
    bindable_to = {comp.Addrmap}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = False
    mutex_group = "M"

    opposite_property = "lsb0"


class Prop_lsb0(PropertyRuleBoolPair):
    bindable_to = {comp.Addrmap}
    valid_types = (bool,)
    default = True
    dyn_assign_allowed = False
    mutex_group = "M"

    opposite_property = "msb0"

#-------------------------------------------------------------------------------
class Prop_bridge(PropertyRule):
    bindable_to = {comp.Addrmap}
    valid_types = (bool,)
    default = False
    dyn_assign_allowed = False

    def validate(self, node: m_node.Node, value: Any) -> None:
        # 13.5: Bridge can only be applied to the root address map
        if value:
            # is bridge
            if (node.parent is not None) and not isinstance(node.parent, m_node.RootNode):
                self.env.msg.error(
                    "The 'bridge' property can only be applied to the root address map.",
                    self.get_src_ref(node)
                )
