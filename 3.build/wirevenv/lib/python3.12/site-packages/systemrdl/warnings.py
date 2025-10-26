
#: Check if a field that implements storage, or is a runtime constant, is
#: missing its reset value.
MISSING_RESET = 1<<0

#: Check if a field's bit offset is not explicitly specified.
#:
#: Some organizations may want to enforce explicit assignment of bit offsets to
#: avoid unexpected field packing.
IMPLICIT_FIELD_POS = 1<<1

#: Check if a component's address offset is not explicitly assigned.
#:
#: Some organizations may want to enforce explicit assignment of addresses to
#: avoid unintended address map changes.
IMPLICIT_ADDR = 1<<2

#: Check if an instance array's address stride is not a power of two.
STRIDE_NOT_POW2 = 1<<3

#: Enforce that all addressable components are aligned based on their size.
#: Alignment is determined by the component's size rounded up to the next power
#: of two.
#:
#: Strict self-alignment may be desireable since it can simplify address decode
#: logic for hierarchical designs.
#:
#: This rule is a superset of ``STRIDE_NOT_POW2``.
STRICT_SELF_ALIGN = 1<<4

#: Check if an array of registers uses a stride that is not equal to the
#: register's width.
#:
#: Many export formats are unable to natively represent register arrays that are
#: not tightly packed. (IP-XACT, UVM Virtual registers, C arrays, etc..)
SPARSE_REG_STRIDE = 1<<5

#-------------------------------------------------------------------------------
#: Enable all warnings.
ALL = (
    MISSING_RESET
    | IMPLICIT_FIELD_POS
    | IMPLICIT_ADDR
    | STRIDE_NOT_POW2
    | STRICT_SELF_ALIGN
    | SPARSE_REG_STRIDE
)
