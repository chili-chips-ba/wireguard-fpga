from typing import TYPE_CHECKING, Optional, Type

from .ast_node import ASTNode
from .conditional import is_castable

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

# Logical boolean operators:
#   && ||
# Both operands are self-determined
class _BoolExpr(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', l: ASTNode, r: ASTNode):
        super().__init__(env, src_ref)
        self.l = l
        self.r = r

    def predict_type(self) -> Type[bool]:
        l_type = self.l.predict_type()
        r_type = self.r.predict_type()
        if not is_castable(l_type, bool):
            self.msg.fatal(
                "Left operand of expression is not a compatible boolean type",
                self.src_ref
            )
        if not is_castable(r_type, bool):
            self.msg.fatal(
                "Right operand of expression is not a compatible boolean type",
                self.src_ref
            )
        return bool

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        return 1

class BoolAnd(_BoolExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        l = bool(self.l.get_value(assignee_node=assignee_node))
        r = bool(self.r.get_value(assignee_node=assignee_node))
        return l and r

class BoolOr(_BoolExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        l = bool(self.l.get_value(assignee_node=assignee_node))
        r = bool(self.r.get_value(assignee_node=assignee_node))
        return l or r
