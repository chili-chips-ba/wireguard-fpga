from typing import TYPE_CHECKING, Optional, Type

from .ast_node import ASTNode
from .conditional import is_castable

from ..core.helpers import truncate_int

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

# Integer unary operators:
#   +  -  ~
# Normal expression context rules
class _UnaryIntExpr(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', n: ASTNode):
        super().__init__(env, src_ref)
        self.n = n

    def predict_type(self) -> Type[int]:
        op_type = self.n.predict_type()
        if not is_castable(op_type, int):
            self.msg.fatal(
                "Operand of expression is not a compatible numeric type",
                self.src_ref
            )
        return int

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        return self.n.get_min_eval_width(assignee_node)

class UnaryPlus(_UnaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        n = int(self.n.get_value(eval_width, assignee_node))
        return truncate_int(n, eval_width)

class UnaryMinus(_UnaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        n = int(self.n.get_value(eval_width, assignee_node))
        return truncate_int(-n, eval_width)

class BitwiseInvert(_UnaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        n = int(self.n.get_value(eval_width, assignee_node))
        return truncate_int(~n, eval_width)
