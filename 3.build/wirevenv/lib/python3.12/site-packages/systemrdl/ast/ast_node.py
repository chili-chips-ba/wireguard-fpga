from typing import TYPE_CHECKING, Optional, Any


if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..source_ref import SourceRefBase
    from ..rdltypes.typing import PreElabRDLType
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

class ASTNode:
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef'):
        self.env = env
        self.msg = env.msg

        # Source Ref to use for error context
        self.src_ref = src_ref

    def predict_type(self) -> 'PreElabRDLType':
        """
        Returns the expected type of the result of the expression
        This function shall call any child expression's predict_type()
        even if the child type is not relevant to the resulting type.
        Raises exception if input types are not compatible.
        """
        raise NotImplementedError

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        """
        Returns the expressions resulting integer width based on the
        self-determined expression bit-width rules
        (SystemVerilog LRM: IEEE Std 1800-2012, Table 11-21)
        """
        raise RuntimeError

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> Any:
        """
        Compute the value of the result of the expression

        Since predict_type() was already called, safe to assume that types are
        compatible.

        The eval_width parameter controls the integer width resolution context
        - If eval_width is irrelevant:
            For example, comparison operator, integer literal, non-integer expression)
            OK to ignore eval_width.
            Otherwise...
        - If eval_width is None:
            This expression node is the start of a new self-determined context.
            Query the relevant operands to determine the context's eval_width
        - If eval_width is set to a value:
            Parent expression is propagating the eval_width

        The assignee_node arg is required in order to resolve any parameter
        references within the AST. In situations where the AST is guaranteed to
        not contain any parameter references, it is OK to omit this.
        """
        raise NotImplementedError
