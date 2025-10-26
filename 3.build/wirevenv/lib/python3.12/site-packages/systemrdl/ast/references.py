from typing import TYPE_CHECKING, Optional, Any, List, Tuple, Type

from .. import rdltypes
from .. import component as comp

from .ast_node import ASTNode
from .conditional import is_castable

if TYPE_CHECKING:
    from ..compiler import RDLEnvironment
    from ..core.parameter import Parameter
    from ..source_ref import SourceRefBase
    from ..rdltypes.typing import PreElabRDLType
    from ..node import Node

    OptionalSourceRef = Optional[SourceRefBase]

class ParameterRef(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', ref_root: comp.Component, param_name: str):
        super().__init__(env, src_ref)

        # Handle to the component definition that owns the parameter
        # This is the original_def, and NOT the actual instance
        # When deepcopying, this is copied by reference in order to preserve
        # the original def object
        self.ref_root = ref_root

        self.param_name = param_name

    def predict_type(self) -> 'PreElabRDLType':
        return self.ref_root.parameters_dict[self.param_name].param_type

    def _lookup_inst_parameter(self, assignee_node: Optional['Node']) -> 'Parameter':
        assert assignee_node is not None

        # Traverse up from assignee until ref_root is reached
        current_node = assignee_node
        while True:
            if current_node.inst.original_def is self.ref_root:
                break
            if current_node.parent is None:
                raise RuntimeError("Upwards traverse to ref_root failed")
            current_node = current_node.parent

        return current_node.inst.parameters_dict[self.param_name]

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        param = self._lookup_inst_parameter(assignee_node)
        if param.expr is None:
            self.msg.fatal(
                "Value for parameter '%s' was never assigned" % self.param_name,
                self.src_ref
            )
        return param.expr.get_min_eval_width(assignee_node)

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> Any:
        param = self._lookup_inst_parameter(assignee_node)
        if param.expr is None:
            self.msg.fatal(
                "Value for parameter '%s' was never assigned" % self.param_name,
                self.src_ref
            )
        return param.expr.get_value(eval_width, assignee_node)


class ArrayIndex(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', array: ASTNode, index: ASTNode):
        super().__init__(env, src_ref)
        self.array = array
        self.index = index

    def predict_type(self) -> 'PreElabRDLType':
        if not is_castable(self.index.predict_type(), int):
            self.msg.fatal(
                "Array index is not a compatible numeric type",
                self.index.src_ref
            )

        array_type = self.array.predict_type()
        if not isinstance(array_type, rdltypes.ArrayedType):
            self.msg.fatal(
                "Cannot index non-array type",
                self.array.src_ref
            )
        if array_type.element_type is None:
            # Array type is not known, therefore it must be an emptyy array.
            self.msg.fatal(
                "Array is empty. Cannot index",
                self.array.src_ref
            )

        return array_type.element_type

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        # TODO: Need to actually reach in and get eval width of array element
        return 64

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> Any:
        index = self.index.get_value(assignee_node=assignee_node)
        array = self.array.get_value(assignee_node=assignee_node)
        if index >= len(array):
            self.msg.fatal(
                "Array index '%d' is out of range" % index,
                self.src_ref
            )
        return array[index]


class MemberRef(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', struct: ASTNode, member_name: str):
        super().__init__(env, src_ref)
        self.struct = struct
        self.member_name = member_name

    def predict_type(self): # type: ignore
        struct_type = self.struct.predict_type()

        if not rdltypes.is_user_struct(struct_type):
            self.msg.fatal(
                "Cannot reference member of non-struct type",
                self.struct.src_ref
            )

        if self.member_name not in struct_type._members:
            self.msg.fatal(
                "'%s' is not a valid member of struct type '%s'"
                % (self.member_name, struct_type.__name__),
                self.src_ref
            )

        return struct_type._members[self.member_name]

    def get_min_eval_width(self, assignee_node: Optional['Node']) -> int:
        # TODO: Need to actually reach in and get eval width of struct member
        return 64

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> Any:
        struct = self.struct.get_value(assignee_node=assignee_node)
        return struct._values[self.member_name]


RefElementsType = List[
    Tuple[str, List[ASTNode], 'OptionalSourceRef']
]
class InstRef(ASTNode):
    def __init__(self, env: 'RDLEnvironment', ref_root: comp.Component, ref_elements: RefElementsType):
        super().__init__(env, None) # single src_ref doesn't make sense for InstRef

        # Handle to the component definition where ref_elements is relative to
        # This is the original_def, and NOT the actual instance
        # When deepcopying, this is copied by reference in order to preserve
        # the original def object
        self.ref_root = ref_root

        # List of hierarchical reference element tuples that make up the path
        # to the reference.
        # Path is relative to ref_inst
        # Each tuple in the list represents a segment of the path:
        # [
        #   ( str , [ <Index ASTNode> , ... ] , SourceRefBase),
        #   ( str , [ <Index ASTNode> , ... ] , SourceRefBase)
        # ]
        self.ref_elements = ref_elements

    def predict_type(self) -> Type[comp.Component]:
        """
        Traverse the ref_elements path and determine the component type being
        referenced.
        Also do some checks on the array indexes
        """
        current_comp: Optional[comp.Component] = self.ref_root
        assert current_comp is not None
        for name, array_suffixes, name_src_ref in self.ref_elements:

            # find instance
            current_comp = current_comp.get_child_by_name(name)
            if current_comp is None:
                # Not found!
                self.msg.fatal(
                    "Could not resolve hierarchical reference to '%s'" % name,
                    name_src_ref
                )

            # Do type-check in array suffixes
            for array_suffix in array_suffixes:
                array_suffix.predict_type()

            # Check array suffixes
            if (isinstance(current_comp, comp.AddressableComponent)) and current_comp.array_dimensions:
                # is an array
                if len(array_suffixes) != len(current_comp.array_dimensions):
                    self.msg.fatal(
                        "Incompatible number of index dimensions after '%s'. Expected %d, found %d."
                        % (name, len(current_comp.array_dimensions), len(array_suffixes)),
                        name_src_ref
                    )
            elif array_suffixes:
                # Has array suffixes. Check if compatible with referenced component
                self.msg.fatal(
                    "Unable to index non-array component '%s'" % name,
                    name_src_ref
                )

        return type(current_comp)

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> rdltypes.ComponentRef:
        """
        Build a resolved ComponentRef container that describes the relative path
        """

        resolved_ref_elements = []

        for name, array_suffixes, name_src_ref in self.ref_elements:
            idx_list = [suffix.get_value(assignee_node=assignee_node) for suffix in array_suffixes]
            resolved_ref_elements.append((name, idx_list, name_src_ref))

        # Create container
        cref = rdltypes.ComponentRef(self.ref_root, resolved_ref_elements)

        return cref


class PropRef(ASTNode):
    def __init__(self, env: 'RDLEnvironment', src_ref: 'OptionalSourceRef', inst_ref: ASTNode, prop_ref_type: Type[rdltypes.PropertyReference]):
        super().__init__(env, src_ref)
        # InstRef to the component whose property is being referenced
        self.inst_ref = inst_ref

        # PropertyReference class
        self.prop_ref_type = prop_ref_type

    def predict_type(self) -> Type[rdltypes.PropertyReference]:
        """
        Predict the type of the inst_ref, and make sure the property being
        referenced is allowed
        """
        inst_type = self.inst_ref.predict_type()

        if self.prop_ref_type.allowed_inst_type != inst_type:
            self.msg.fatal(
                "'%s' is not a valid property of instance" % self.prop_ref_type.get_name(),
                self.src_ref
            )

        return self.prop_ref_type

    def get_value(self, eval_width: Optional[int]=None, assignee_node: Optional['Node']=None) -> rdltypes.PropertyReference:
        cref = self.inst_ref.get_value(assignee_node=assignee_node)
        return self.prop_ref_type(self.src_ref, self.env, cref)
