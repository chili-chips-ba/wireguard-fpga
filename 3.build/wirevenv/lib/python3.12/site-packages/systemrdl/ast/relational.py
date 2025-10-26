from typing import TYPE_CHECKING, Type, Optional, Any, Tuple

from .ast_node import ASTNode
from .conditional import is_castable

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

#-------------------------------------------------------------------------------
# Relational operators:
#   == != < > <= >=
# Result is always 1 bit bool
# Creates a new evaluation context
# Child operands are evaluated in the same width context, sized to the max
# of either op.
class _RelationalExpr(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', l: ASTNode, r: ASTNode):
        super().__init__(env, src_ref)
        self.l = l
        self.r = r
        self.is_numeric: bool = False

    def predict_type(self) -> Type[bool]:
        l_type = self.l.predict_type()
        r_type = self.r.predict_type()

        # Type of L and R operands shall be compatible
        if is_castable(l_type, int) and is_castable(r_type, int):
            self.is_numeric = True
        elif l_type == r_type:
            # Same types. Inherently compatible
            self.is_numeric = False
        else:
            # Incompatible
            self.msg.fatal(
                "Left and right operands of expression are not compatible types",
                self.src_ref
            )
        return bool

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        return 1

    def get_ops(self, assignee_node: Optional['Node']=None) -> Tuple[Any, Any]:

        if self.is_numeric:
            # New width context. Determine eval_width here
            eval_width = max(
                self.l.get_min_eval_width(assignee_node),
                self.r.get_min_eval_width(assignee_node)
            )

            l = int(self.l.get_value(eval_width, assignee_node))
            r = int(self.r.get_value(eval_width, assignee_node))
        elif not self.is_numeric:
            l = self.l.get_value(assignee_node=assignee_node)
            r = self.r.get_value(assignee_node=assignee_node)
        else:
            raise RuntimeError

        return l, r

class _NumericRelationalExpr(_RelationalExpr):

    def predict_type(self) -> Type[bool]:
        l_type = self.l.predict_type()
        r_type = self.r.predict_type()

        # Type of L and R operands shall be integral types
        self.is_numeric = True
        if not is_castable(l_type, int):
            self.msg.fatal(
                "Left operand of expression is not a compatible numeric type",
                self.src_ref
            )
        if not is_castable(r_type, int):
            self.msg.fatal(
                "Right operand of expression is not a compatible numeric type",
                self.src_ref
            )
        return bool



class Eq(_RelationalExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        l, r = self.get_ops(assignee_node)
        return l == r

class Neq(_RelationalExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        l, r = self.get_ops(assignee_node)
        return l != r

class Lt(_NumericRelationalExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        l, r = self.get_ops(assignee_node)
        return l < r

class Gt(_NumericRelationalExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        l, r = self.get_ops(assignee_node)
        return l > r

class Leq(_NumericRelationalExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        l, r = self.get_ops(assignee_node)
        return l <= r

class Geq(_NumericRelationalExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        l, r = self.get_ops(assignee_node)
        return l >= r
