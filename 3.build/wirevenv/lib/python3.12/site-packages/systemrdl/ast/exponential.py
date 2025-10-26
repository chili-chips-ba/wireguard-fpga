from typing import TYPE_CHECKING, Optional, Type

from .ast_node import ASTNode
from .conditional import is_castable

from ..core.helpers import truncate_int

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

# Exponent & shift operators:
#   **  <<  >>
# Righthand operand is self-determined
class _ExpShiftExpr(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', l: ASTNode, r: ASTNode):
        super().__init__(env, src_ref)
        self.l = l
        self.r = r

    def predict_type(self) -> Type[int]:
        l_type = self.l.predict_type()
        r_type = self.r.predict_type()
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
        return int

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        # Righthand op has no influence in evaluation context
        return self.l.get_min_eval_width(assignee_node)

class Exponent(_ExpShiftExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.l.get_min_eval_width(assignee_node)
        # Right operand is self-determined
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(assignee_node=assignee_node))
        return truncate_int(int(l ** r), eval_width)

class LShift(_ExpShiftExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.l.get_min_eval_width(assignee_node)
        # Right operand is self-determined
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(assignee_node=assignee_node))
        return truncate_int(l << r, eval_width)

class RShift(_ExpShiftExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.l.get_min_eval_width(assignee_node)
        # Right operand is self-determined
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(assignee_node=assignee_node))
        return truncate_int(l >> r, eval_width)
