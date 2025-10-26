from typing import Optional

from .. import rdltypes
from .. import component as comp
from .. import node as m_node

class PropertyValueReference(rdltypes.PropertyReference):
    """
    Directly references the value that was assigned to said property.
    """
    def _validate(self) -> None:
        # validate that this prop is set in the target (is not None)
        target_value = self.node.get_property(self.name)
        if target_value is None:
            self.env.msg.error(
                "Assignment references the value of property '%s', but its value was never set for instance '%s'"
                % (self.name, self.node.inst_name),
                self.src_ref
            )

        # Property value references could theoretically create a circular loop
        # validate that circular references do not exist
        ref_value = target_value
        while isinstance(ref_value, PropertyValueReference):
            if ref_value == self:
                # Looped back to a property that points to self.
                # Each reference in the chain will also emit its own error
                self.env.msg.error(
                    "Assignment creates a circular reference",
                    self.src_ref
                )
                break
            ref_value = ref_value.node.get_property(ref_value.name)


class PropertyValueReferenceFieldwidth(PropertyValueReference):
    """
    Similar to PropertyValueReference, but is limited to fields and tracks
    the field's width
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        assert isinstance(self.node, m_node.FieldNode)
        return self.node.width


class RealOrInferredVectorReference(PropertyValueReference):
    """
    References the vector that was directly assign to the property, or inferred
    by setting the property to True
    """
    complementary_prop: Optional[str] = None
    def _validate(self) -> None:
        super()._validate()
        # validate that this property is enabled in the target (is not False)
        # If complementary_prop is defined, check the partner property too before failing
        target_value = self.node.get_property(self.name)
        if target_value is False and self.complementary_prop is not None:
            # try its complement
            target_value = self.node.get_property(self.complementary_prop)
        if target_value is False:
            self.env.msg.error(
                "Assignment references property '%s', but the signal it represents was never defined or enabled for instance '%s'"
                % (self.name, self.node.inst_name),
                self.src_ref
            )

#-------------------------------------------------------------------------------
# Reductions
#-------------------------------------------------------------------------------
class ReductionPropRef(rdltypes.PropertyReference):
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_anded(ReductionPropRef):
    pass

class PropRef_ored(ReductionPropRef):
    pass

class PropRef_xored(ReductionPropRef):
    pass

#-------------------------------------------------------------------------------
# Counter
#-------------------------------------------------------------------------------
class CounterPropRef(rdltypes.PropertyReference):
    def _validate(self) -> None:
        if not self.node.get_property('counter'):
            self.env.msg.error(
                "Reference to property '%s' is illegal because '%s' is not a counter"
                % (self.name, self.node.inst_name),
                self.src_ref
            )

class CounterThresholdPropRef(CounterPropRef):
    def _validate(self) -> None:
        super()._validate()
        # validate that the counter actually sets a threshold
        target_value = self.node.get_property(self.name)
        if target_value is False:
            self.env.msg.error(
                "Reference to property '%s' is illegal because the target field does not define any thresholds"
                % self.name,
                self.src_ref
            )

class PropRef_incr(CounterPropRef):
    """
    References the increment event signal
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_incrsaturate(CounterPropRef):
    """
    referencing the counter's saturate output, which is a single bit value
    indicating whether the saturation has occurred
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_saturate(PropRef_incrsaturate):
    """
    alias of incrsaturate.
    """

class PropRef_incrthreshold(CounterThresholdPropRef):
    """
    Referencing the counter’s threshold output, which is a single bit value
    indicating whether the threshold has been crossed
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_threshold(PropRef_incrthreshold):
    """
    alias of incrthreshold
    """

class PropRef_incrvalue(PropertyValueReference):
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        # Does not correspond to the field's width.
        # not always knowable
        return None

class PropRef_decr(CounterPropRef):
    """
    References the decrement event signal
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_decrsaturate(CounterPropRef):
    """
    referencing the counter’s saturate output, which is a single bit value
    indicating whether the saturation has occurred
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_decrthreshold(CounterThresholdPropRef):
    """
    Referencing the counter’s threshold output, which is a single bit value
    indicating whether the threshold has been crossed
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_decrvalue(PropertyValueReference):
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        # Does not correspond to the field's width.
        # not always knowable
        return None

class PropRef_overflow(CounterPropRef):
    """
    asserted when counter overflows or wraps
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

    def _validate(self) -> None:
        super()._validate()

        if self.node.get_property('incrsaturate') is not False:
            self.env.msg.error(
                "Reference to property '%s' is illegal because the target field will never overflow"
                % self.name,
                self.src_ref
            )


class PropRef_underflow(CounterPropRef):
    """
    asserted when counter underflows or wraps.
    """
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

    def _validate(self) -> None:
        super()._validate()

        if self.node.get_property('decrsaturate') is not False:
            self.env.msg.error(
                "Reference to property '%s' is illegal because the target field will never underflow"
                % self.name,
                self.src_ref
            )

#-------------------------------------------------------------------------------
# Access
#-------------------------------------------------------------------------------
class PropRef_swacc(rdltypes.PropertyReference):
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_swmod(rdltypes.PropertyReference):
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_swwe(RealOrInferredVectorReference):
    allowed_inst_type = comp.Field
    complementary_prop = "swwel"

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_swwel(RealOrInferredVectorReference):
    allowed_inst_type = comp.Field
    complementary_prop = "swwe"

    @property
    def width(self) -> Optional[int]:
        return 1

#-------------------------------------------------------------------------------
# HW Signals
#-------------------------------------------------------------------------------
class PropRef_we(RealOrInferredVectorReference):
    allowed_inst_type = comp.Field
    complementary_prop = "wel"

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_wel(RealOrInferredVectorReference):
    allowed_inst_type = comp.Field
    complementary_prop = "we"

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_hwset(RealOrInferredVectorReference):
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_hwclr(RealOrInferredVectorReference):
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1

#-------------------------------------------------------------------------------
# Interrupts
#-------------------------------------------------------------------------------
class PropRef_intr(rdltypes.PropertyReference):
    """
    Represents the inclusive OR of all the interrupt bits in a register after
    any field enable and/or field mask logic has been applied.
    """
    allowed_inst_type = comp.Reg
    node: m_node.RegNode

    def _validate(self) -> None:
        # validate reg contains at least one field that is intr
        for field in self.node.fields():
            if field.get_property('intr'):
                break
        else:
            self.env.msg.error(
                "'intr' property reference is illegal because target register does not contain any interrupt fields",
                self.src_ref
            )

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_halt(rdltypes.PropertyReference):
    """
    Represents the inclusive OR of all the interrupt bits in a register after
    any field haltenable and/or field haltmask logic has been applied.
    """
    allowed_inst_type = comp.Reg
    node: m_node.RegNode

    def _validate(self) -> None:
        # 10.8.1-c: shall only be present if haltmask or haltenable is
        # specified on at least one field in the register.
        for field in self.node.fields():
            if field.get_property('haltenable') or field.get_property('haltmask'):
                break
        else:
            self.env.msg.error(
                "'halt' property reference is illegal because target register does not contain any fields with 'haltenable' or 'haltmask' set.",
                self.src_ref
            )

    @property
    def width(self) -> Optional[int]:
        return 1

class PropRef_haltenable(PropertyValueReferenceFieldwidth):
    pass

class PropRef_haltmask(PropertyValueReferenceFieldwidth):
    pass

class PropRef_enable(PropertyValueReferenceFieldwidth):
    pass

class PropRef_mask(PropertyValueReferenceFieldwidth):
    pass

#-------------------------------------------------------------------------------
class PropRef_hwenable(PropertyValueReferenceFieldwidth):
    pass

class PropRef_hwmask(PropertyValueReferenceFieldwidth):
    pass

class PropRef_next(PropertyValueReferenceFieldwidth):
    pass

class PropRef_reset(PropertyValueReferenceFieldwidth):
    pass

class PropRef_resetsignal(PropertyValueReference):
    allowed_inst_type = comp.Field

    @property
    def width(self) -> Optional[int]:
        return 1
