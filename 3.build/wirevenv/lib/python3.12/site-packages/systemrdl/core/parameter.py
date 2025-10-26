from typing import TYPE_CHECKING, Optional, Any

from .value_normalization import normalize

if TYPE_CHECKING:
    from .. import rdltypes
    from ..ast import ASTNode
    from ..node import Node

class Parameter:
    def __init__(self, param_type: 'rdltypes.PreElabRDLType', name: str, default_expr: Optional['ASTNode']=None):
        self.name = name
        self.param_type = param_type

        self.expr = default_expr

        self._cached_value: Any = None


    def get_value(self, assignee_node: Optional['Node'] = None) -> Any:
        """
        Evaluate self.expr to get the parameter's value

        HACK:
        assignee_node is normally ALWAYS required. However by the time a design
        is elaborated, the parameter will have been evaluated and the cached
        value available. This lets end-users avoid providing an assignee node if
        querying the value via Node.inst.parameters[...].get_value()
        Making the argument optional is a workaround for https://github.com/SystemRDL/PeakRDL-regblock/issues/162
        Once <Parameter> truly gets hidden from the public API (No more user
        access to Node.inst...), clean this up and make assignee_node not optional
        """
        if self._cached_value is not None:
            return self._cached_value

        if self.expr is None:
            # No expression was assigned
            return None

        assert assignee_node is not None
        self._cached_value = self.expr.get_value(assignee_node=assignee_node)
        return self._cached_value


    def get_normalized_parameter(self, assignee_node: 'Node') -> str:
        """
        Converts the parameter to the normalized type name segment as defined in
        SystemRDL 2.0 Section 5.1.1.4-c

        Returns the whole parameter string:
            <parameter name> + "_" + <normalized value>
        """
        return self.name + "_" + normalize(self.get_value(assignee_node))

    def __copy__(self) -> 'Parameter':
        cls = self.__class__
        result = cls.__new__(cls)

        result.name = self.name
        result.param_type = self.param_type
        result.expr = self.expr
        result._cached_value = None

        return result
