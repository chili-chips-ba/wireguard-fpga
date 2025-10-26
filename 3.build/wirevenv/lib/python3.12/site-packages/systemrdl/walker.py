from typing import Optional, Iterable
from enum import IntEnum

from .node import AddressableNode, VectorNode, FieldNode, RegNode, RegfileNode
from .node import AddrmapNode, MemNode, SignalNode
from .node import RootNode, Node


class WalkerAction(IntEnum):

    #: Continue walking the register model
    Continue = 0

    #: Walker will continue calling listener methods for this component, but
    #: will not recurse into this node's children.
    SkipDescendants = 1

    #: Stop the walker immediately. No more listener methods will be called.
    StopNow = 2


class RDLListener:
    """
    Base class for user-defined RDL traversal listeners.
    """
    def enter_Component(self, node: Node) -> Optional[WalkerAction]:
        pass

    def exit_Component(self, node: Node) -> Optional[WalkerAction]:
        pass

    def enter_AddressableComponent(self, node: AddressableNode) -> Optional[WalkerAction]:
        pass

    def exit_AddressableComponent(self, node: AddressableNode) -> Optional[WalkerAction]:
        pass

    def enter_VectorComponent(self, node: VectorNode) -> Optional[WalkerAction]:
        pass

    def exit_VectorComponent(self, node: VectorNode) -> Optional[WalkerAction]:
        pass

    def enter_Addrmap(self, node: AddrmapNode) -> Optional[WalkerAction]:
        pass

    def exit_Addrmap(self, node: AddrmapNode) -> Optional[WalkerAction]:
        pass

    def enter_Regfile(self, node: RegfileNode) -> Optional[WalkerAction]:
        pass

    def exit_Regfile(self, node: RegfileNode) -> Optional[WalkerAction]:
        pass

    def enter_Mem(self, node: MemNode) -> Optional[WalkerAction]:
        pass

    def exit_Mem(self, node: MemNode) -> Optional[WalkerAction]:
        pass

    def enter_Reg(self, node: RegNode) -> Optional[WalkerAction]:
        pass

    def exit_Reg(self, node: RegNode) -> Optional[WalkerAction]:
        pass

    def enter_Field(self, node: FieldNode) -> Optional[WalkerAction]:
        pass

    def exit_Field(self, node: FieldNode) -> Optional[WalkerAction]:
        pass

    def enter_Signal(self, node: SignalNode) -> Optional[WalkerAction]:
        pass

    def exit_Signal(self, node: SignalNode) -> Optional[WalkerAction]:
        pass

#===============================================================================
class RDLSimpleWalker:
    """
    Implements a walker instance that traverses the elaborated RDL instance tree
    Each node is visited exactly once.

    Each node is visited as follows:

    1. Run :func:`~RDLListener.enter_Component` callback
    2. Run :func:`~RDLListener.enter_AddressableComponent` or :func:`~RDLListener.enter_VectorComponent` callback
    3. Run type-specific ``enter_*()`` callback, such as :func:`~RDLListener.enter_Reg`
    4. Traverse any children
    5. Run type-specific ``exit_*()`` callback, such as :func:`~RDLListener.exit_Reg`
    6. Run :func:`~RDLListener.exit_AddressableComponent` or :func:`~RDLListener.exit_VectorComponent` callback
    7. Run :func:`~RDLListener.exit_Component` callback

    """
    def __init__(self, unroll: bool=False, skip_not_present: bool=True):
        """
        Parameters
        ----------
        unroll : bool
            If True, any nodes that are arrays are unrolled.
            When the walker arrives at an array node, it will be visited multiple
            times according to the array dimensions.

        skip_not_present : bool
            If True, walker skips nodes whose 'ispresent' property is set
            to False
        """
        self.unroll = unroll
        self.skip_not_present = skip_not_present

    def walk(self, node: Node, *listeners: RDLListener, skip_top: bool=False) -> None:
        """
        Initiates the walker to traverse the current ``node`` and its children.
        Calls the corresponding callback for each of the ``listeners`` provided in
        the order that they are listed.

        Parameters
        ----------
        node : :class:`~systemrdl.node.Node`
            Node to start traversing.
            Listener traversal includes this node.

        listeners : :class:`~RDLListener`
            One or more :class:`~RDLListener` that are invoked during
            node traversal.
            Listener callbacks are executed in the same order as provided.

        skip_top : bool
            Skip callbacks for the top node specified by ``node``
        """
        if skip_top or isinstance(node, RootNode):
            # Do not visit current node. Only visit children
            for child in node.children(unroll=self.unroll, skip_not_present=self.skip_not_present):
                self._walk(child, listeners)
        else:
            # Walk this node normally
            self._walk(node, listeners)

    def _walk(self, node: Node, listeners: Iterable[RDLListener]) -> None:
        for listener in listeners:
            self.do_enter(node, listener)

        for child in node.children(unroll=self.unroll, skip_not_present=self.skip_not_present):
            self._walk(child, listeners)

        for listener in listeners:
            self.do_exit(node, listener)

    def do_enter(self, node: Node, listener: RDLListener) -> None:
        listener.enter_Component(node)

        if isinstance(node, FieldNode):
            listener.enter_VectorComponent(node)
            listener.enter_Field(node)
        elif isinstance(node, RegNode):
            listener.enter_AddressableComponent(node)
            listener.enter_Reg(node)
        elif isinstance(node, RegfileNode):
            listener.enter_AddressableComponent(node)
            listener.enter_Regfile(node)
        elif isinstance(node, AddrmapNode):
            listener.enter_AddressableComponent(node)
            listener.enter_Addrmap(node)
        elif isinstance(node, MemNode):
            listener.enter_AddressableComponent(node)
            listener.enter_Mem(node)
        elif isinstance(node, SignalNode):
            listener.enter_VectorComponent(node)
            listener.enter_Signal(node)

    def do_exit(self, node: Node, listener: RDLListener) -> None:
        if isinstance(node, FieldNode):
            listener.exit_Field(node)
            listener.exit_VectorComponent(node)
        elif isinstance(node, RegNode):
            listener.exit_Reg(node)
            listener.exit_AddressableComponent(node)
        elif isinstance(node, RegfileNode):
            listener.exit_Regfile(node)
            listener.exit_AddressableComponent(node)
        elif isinstance(node, AddrmapNode):
            listener.exit_Addrmap(node)
            listener.exit_AddressableComponent(node)
        elif isinstance(node, MemNode):
            listener.exit_Mem(node)
            listener.exit_AddressableComponent(node)
        elif isinstance(node, SignalNode):
            listener.exit_Signal(node)
            listener.exit_VectorComponent(node)

        listener.exit_Component(node)


class RDLSteerableWalker:
    """
    Identical to :class:`~RDLSimpleWalker`, except that this walker allows
    listeners to steer the traversal of the design using "Walker Actions"

    From each callback, the listener may optionally return a :class:`WalkerAction`
    to control how the walker should continue model traversal.
    Returning ``None`` is equivalent to :attr:`WalkerAction.Continue`.

    If this feature is not necessary, it is recommended to use :class:`~RDLSimpleWalker`
    as it has less traversal overhead.
    """
    def __init__(self, unroll: bool=False, skip_not_present: bool=True):
        self.unroll = unroll
        self.skip_not_present = skip_not_present
        self.current_action = WalkerAction.Continue


    def walk(self, node: Node, *listeners: RDLListener, skip_top: bool=False) -> None:
        if skip_top or isinstance(node, RootNode):
            # Do not visit current node. Only visit children
            for child in node.children(unroll=self.unroll, skip_not_present=self.skip_not_present):
                self._walk(child, listeners)
                if self.current_action == WalkerAction.StopNow:
                    return
        else:
            # Walk this node normally
            self._walk(node, listeners)

    def _walk(self, node: Node, listeners: Iterable[RDLListener]) -> None:
        for listener in listeners:
            self.current_action = self.do_enter(node, listener)
            if self.current_action == WalkerAction.StopNow:
                return

        if self.current_action == WalkerAction.SkipDescendants:
            # skip recursion into children, then reset action
            self.current_action = WalkerAction.Continue
        else:
            for child in node.children(unroll=self.unroll, skip_not_present=self.skip_not_present):
                self._walk(child, listeners)
                if self.current_action == WalkerAction.StopNow:
                    return

        for listener in listeners:
            self.current_action = self.do_exit(node, listener)
            if self.current_action == WalkerAction.StopNow:
                return


    def do_enter(self, node: Node, listener: RDLListener) -> WalkerAction:
        action = WalkerAction.Continue
        new_action = WalkerAction.Continue

        action = listener.enter_Component(node) or WalkerAction.Continue

        if action == WalkerAction.StopNow:
            return action

        if isinstance(node, AddressableNode):
            new_action = listener.enter_AddressableComponent(node) or WalkerAction.Continue
        elif isinstance(node, VectorNode):
            new_action = listener.enter_VectorComponent(node) or WalkerAction.Continue

        action = max(new_action, action)
        if action == WalkerAction.StopNow:
            return action

        if isinstance(node, FieldNode):
            new_action = listener.enter_Field(node) or WalkerAction.Continue
        elif isinstance(node, RegNode):
            new_action = listener.enter_Reg(node) or WalkerAction.Continue
        elif isinstance(node, RegfileNode):
            new_action = listener.enter_Regfile(node) or WalkerAction.Continue
        elif isinstance(node, AddrmapNode):
            new_action = listener.enter_Addrmap(node) or WalkerAction.Continue
        elif isinstance(node, MemNode):
            new_action = listener.enter_Mem(node) or WalkerAction.Continue
        elif isinstance(node, SignalNode):
            new_action = listener.enter_Signal(node) or WalkerAction.Continue

        action = max(new_action, action)

        return action


    def do_exit(self, node: Node, listener: RDLListener) -> WalkerAction:
        action = WalkerAction.Continue
        new_action = WalkerAction.Continue

        if isinstance(node, FieldNode):
            action = listener.exit_Field(node) or WalkerAction.Continue
        elif isinstance(node, RegNode):
            action = listener.exit_Reg(node) or WalkerAction.Continue
        elif isinstance(node, RegfileNode):
            action = listener.exit_Regfile(node) or WalkerAction.Continue
        elif isinstance(node, AddrmapNode):
            action = listener.exit_Addrmap(node) or WalkerAction.Continue
        elif isinstance(node, MemNode):
            action = listener.exit_Mem(node) or WalkerAction.Continue
        elif isinstance(node, SignalNode):
            action = listener.exit_Signal(node) or WalkerAction.Continue

        if action == WalkerAction.StopNow:
            return action

        if isinstance(node, AddressableNode):
            new_action = listener.exit_AddressableComponent(node) or WalkerAction.Continue
        elif isinstance(node, VectorNode):
            new_action = listener.exit_VectorComponent(node) or WalkerAction.Continue

        action = max(new_action, action)
        if action == WalkerAction.StopNow:
            return action

        new_action = listener.exit_Component(node) or WalkerAction.Continue

        action = max(new_action, action)
        return action


#: Alias to :class:`~RDLSteerableWalker` for backwards compatibility
RDLWalker = RDLSteerableWalker
