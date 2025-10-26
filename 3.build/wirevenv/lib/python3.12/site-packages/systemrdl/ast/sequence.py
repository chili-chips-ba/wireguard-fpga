from typing import TYPE_CHECKING, Optional, Type, List, Union

from .ast_node import ASTNode
from .conditional import is_castable

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

class Concatenate(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', elements: List[ASTNode]):
        super().__init__(env, src_ref)
        self.elements = elements
        self.type: Union[Type[int], Type[str]] = int

    def predict_type(self) -> Union[Type[int], Type[str]]:
        element_iter = iter(self.elements)

        # first element defines the type of the concatenation
        element_type = next(element_iter).predict_type()
        if is_castable(element_type, int):
            self.type = int
        elif is_castable(element_type, str):
            self.type = str
        else:
            self.msg.fatal(
                "Concatenation operator can only be used for integral or string types",
                self.src_ref
            )

        # All remaining elements shall be castable to the concatenation type
        for element in element_iter:
            if not is_castable(element.predict_type(), self.type):
                self.msg.fatal(
                    "Elements of a concatenation shall be the same type",
                    self.src_ref
                )
        return self.type

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        if self.type == int:
            width = 0
            for element in self.elements:
                width = width + element.get_min_eval_width(assignee_node)

            return width
        else:
            raise RuntimeError

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> Union[int, str]:
        if self.type == int:
            int_result = 0
            for element in self.elements:
                width = element.get_min_eval_width(assignee_node)
                int_result <<= width
                int_result |= int(element.get_value(assignee_node=assignee_node))
            return int_result

        elif self.type == str:
            str_result = ""
            for element in self.elements:
                str_result += element.get_value(assignee_node=assignee_node)
            return str_result

        else:
            raise RuntimeError


class Replicate(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', reps: ASTNode, concat: ASTNode):
        super().__init__(env, src_ref)
        self.reps = reps
        self.concat = concat
        self.type: Union[Type[int], Type[str]] = int

    def predict_type(self) -> Union[Type[int], Type[str]]:

        if not is_castable(self.reps.predict_type(), int):
            self.msg.fatal(
                "Replication count operand of replication expression is not a compatible numeric type",
                self.reps.src_ref
            )

        element_type = self.concat.predict_type()

        if is_castable(element_type, int):
            self.type = int
            return int
        elif is_castable(element_type, str):
            self.type = str
            return str
        else:
            # All replications contain a nested concatenation
            # Type check for invalid type is already handled there
            raise RuntimeError

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        # Evaluate number of repetitions
        reps_value = self.reps.get_value(assignee_node=assignee_node)

        if self.type == int:
            # Get width of single contents
            width = self.concat.get_min_eval_width(assignee_node)
            width *= reps_value
            return width
        else:
            raise RuntimeError

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> Union[int, str]:
        # Evaluate number of repetitions
        reps_value = self.reps.get_value(assignee_node=assignee_node)

        if self.type == int:
            width = self.concat.get_min_eval_width(assignee_node)
            val = int(self.concat.get_value(assignee_node=assignee_node))

            int_result = 0
            for _ in range(reps_value):
                int_result <<= width
                int_result |= val

            return int_result

        elif self.type == str:
            str_result = self.concat.get_value(assignee_node=assignee_node)
            str_result *= reps_value
            return str_result

        else:
            raise RuntimeError
