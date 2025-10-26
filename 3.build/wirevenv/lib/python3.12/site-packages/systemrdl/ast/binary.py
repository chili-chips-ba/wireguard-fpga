from typing import TYPE_CHECKING, Optional, Type

from .ast_node import ASTNode
from .conditional import is_castable

from ..core.helpers import truncate_int

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

# Integer binary operators:
#   +  -  *  /  %  &  |  ^  ^~  ~^
# Normal expression context rules
class _BinaryIntExpr(ASTNode):
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
        return(max(
            self.l.get_min_eval_width(assignee_node),
            self.r.get_min_eval_width(assignee_node)
        ))

class Add(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))
        return truncate_int(l + r, eval_width)

class Sub(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))
        return truncate_int(l - r, eval_width)

class Mult(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))
        return truncate_int(l * r, eval_width)

class Div(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))

        if r == 0:
            self.msg.fatal(
                "Division by zero",
                self.src_ref
            )
        return truncate_int(l // r, eval_width)

class Mod(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))

        if r == 0:
            self.msg.fatal(
                "Modulo by zero",
                self.src_ref
            )
        return truncate_int(l % r, eval_width)

class BitwiseAnd(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))
        return truncate_int(l & r, eval_width)

class BitwiseOr(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))
        return truncate_int(l | r, eval_width)

class BitwiseXor(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))
        return truncate_int(l ^ r, eval_width)

class BitwiseXnor(_BinaryIntExpr):
    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> int:
        if eval_width is None:
            eval_width = self.get_min_eval_width(assignee_node)
        l = int(self.l.get_value(eval_width, assignee_node))
        r = int(self.r.get_value(eval_width, assignee_node))
        return truncate_int(l ^~ r, eval_width)
