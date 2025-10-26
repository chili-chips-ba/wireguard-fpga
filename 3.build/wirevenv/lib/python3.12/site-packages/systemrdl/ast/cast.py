from typing import TYPE_CHECKING, Optional, Type, Any

from .ast_node import ASTNode

from ..core.helpers import truncate_int
from .. import rdltypes
from .. import component as comp

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..rdltypes.typing import PreElabRDLType
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

#-------------------------------------------------------------------------------
# Width cast operator
# the cast type informs the parser what width to cast to
# The cast width determines the result's width
# Also influences the min eval width of the value expression
class WidthCast(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', v: ASTNode, w_expr: ASTNode):
        super().__init__(env, src_ref)

        self.v = v
        self.w_expr = w_expr

    def predict_type(self) -> Type[int]:
        if not is_castable(self.w_expr.predict_type(), int):
            self.msg.fatal(
                "Width operand of cast expression is not a compatible numeric type",
                self.w_expr.src_ref
            )
        if not is_castable(self.v.predict_type(), int):
            self.msg.fatal(
                "Value operand of cast expression cannot be cast to an integer",
                self.v.src_ref
            )

        return int

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        cast_width = int(self.w_expr.get_value(assignee_node=assignee_node))
        return cast_width


    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        # Truncate to cast width instead of eval width
        cast_width = int(self.w_expr.get_value(assignee_node=assignee_node))
        if cast_width == 0:
            self.msg.fatal(
                "Cannot cast to width of zero",
                self.src_ref
            )

        eval_width = max(cast_width, self.v.get_min_eval_width(assignee_node))
        n = int(self.v.get_value(eval_width, assignee_node))

        return truncate_int(n, cast_width)

class Width64Cast(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', v: ASTNode):
        super().__init__(env, src_ref)

        self.v = v

    def predict_type(self) -> Type[int]:
        if not is_castable(self.v.predict_type(), int):
            self.msg.fatal(
                "Value operand of cast expression cannot be cast to an integer",
                self.v.src_ref
            )

        return int

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        return 64


    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        eval_width = max(64, self.v.get_min_eval_width(assignee_node))
        n = int(self.v.get_value(eval_width, assignee_node))

        return truncate_int(n, 64)

#-------------------------------------------------------------------------------
# Boolean cast operator

class BoolCast(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', n: ASTNode):
        super().__init__(env, src_ref)
        self.n = n

    def predict_type(self) -> Type[bool]:
        if not is_castable(self.n.predict_type(), bool):
            self.msg.fatal(
                "Value operand of cast expression cannot be cast to a boolean",
                self.src_ref
            )
        return bool

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        return 1

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        n = int(self.n.get_value(assignee_node=assignee_node))
        return n != 0

#-------------------------------------------------------------------------------
# Assignment cast
# This is a wrapper expression that normalizes the expression result
# to the expected data type
# This wrapper forces the operand to be evaluated in a self-determined context
# The cast type has no effect on expression evaluation
# During post-compile:
#   Checks that the expression result is of a compatible type
#
# When getting value:
#   Ensures that the expression result gets converted to the resulting type
class AssignmentCast(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', v: ASTNode, dest_type: 'PreElabRDLType'):
        super().__init__(env, src_ref)

        self.v = v
        self.dest_type = dest_type

    def predict_type(self) -> 'PreElabRDLType':
        op_type = self.v.predict_type()

        if not is_castable(op_type, self.dest_type):
            self.msg.fatal(
                "Result of expression is not compatible with the expected type",
                self.src_ref
            )

        return self.dest_type

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        return self.v.get_min_eval_width(assignee_node)

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> Any:
        v = self.v.get_value(assignee_node=assignee_node)

        if self.dest_type == bool:
            return bool(v)
        elif self.dest_type == int:
            return int(v)
        else:
            return v


#===============================================================================

def is_castable(src: Any, dst: Any) -> bool:
    """
    Check if src type can be cast to dst type
    """
    if ((src in [int, bool]) or rdltypes.is_user_enum(src)) and (dst in [int, bool]):
        # Pure numeric or enum can be cast to a numeric
        return True
    elif isinstance(src, rdltypes.ArrayedType) and isinstance(dst, rdltypes.ArrayedType):
        # Check that array element types also match
        if src.element_type is None:
            # indeterminate array type. Is castable
            return True
        return is_castable(src.element_type, dst.element_type)
    elif rdltypes.is_user_struct(dst):
        # Structs can be assigned their derived counterparts - aka their subclasses
        return issubclass(src, dst)
    elif dst == rdltypes.PropertyReference:
        return issubclass(src, rdltypes.PropertyReference)
    elif dst == rdltypes.references.RefType:
        # Any reference
        if issubclass(src, comp.Component):
            return True
        return issubclass(src, rdltypes.PropertyReference)
    elif src == dst:
        return True
    else:
        return False
