from typing import TYPE_CHECKING, Optional, Type

from .ast_node import ASTNode
from .conditional import is_castable

from ..core.helpers import truncate_int

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

# Reduction operators:
#   &  ~&  |  ~|  ^  ^~  !
# Result is always 1 bit int
# Creates a new evaluation context
class _ReductionExpr(ASTNode):
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
        return 1

class AndReduce(_ReductionExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        eval_width = self.n.get_min_eval_width(assignee_node)
        n = int(self.n.get_value(eval_width, assignee_node))
        n = truncate_int(~n, eval_width)
        return int(n == 0)

class NandReduce(_ReductionExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        eval_width = self.n.get_min_eval_width(assignee_node)
        n = int(self.n.get_value(eval_width, assignee_node))
        n = truncate_int(~n, eval_width)
        return int(n != 0)

class OrReduce(_ReductionExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        n = int(self.n.get_value(assignee_node=assignee_node))
        return int(n != 0)

class NorReduce(_ReductionExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        n = int(self.n.get_value(assignee_node=assignee_node))
        return int(n == 0)

class XorReduce(_ReductionExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        n = int(self.n.get_value(assignee_node=assignee_node))
        v = 0
        while n:
            if n & 1:
                v ^= 1
            n >>= 1
        return v

class XnorReduce(_ReductionExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        n = int(self.n.get_value(assignee_node=assignee_node))
        v = 1
        while n:
            if n & 1:
                v ^= 1
            n >>= 1
        return v

class BoolNot(_ReductionExpr):
    def predict_type(self) -> Type[bool]:
        super().predict_type()
        return bool

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> bool:
        n = int(self.n.get_value(assignee_node=assignee_node))
        return not n
