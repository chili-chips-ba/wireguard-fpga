from collections import OrderedDict
from typing import TYPE_CHECKING

from ..parser.SystemRDLParser import SystemRDLParser

from .BaseVisitor import BaseVisitor
from .helpers import get_ID_text, KW_TO_COMPONENT_MAP

from .. import component as comp
from ..source_ref import src_ref_from_antlr
from .. import rdltypes

if TYPE_CHECKING:
    from ..compiler import RDLCompiler

class StructVisitor(BaseVisitor):

    def __init__(self, compiler: 'RDLCompiler', parent_component: 'comp.Component') -> None:
        super().__init__(compiler)
        self.parent_component = parent_component

    def visitStruct_def(self, ctx: SystemRDLParser.Struct_defContext):
        self.compiler.namespace.enter_scope()

        is_abstract = ctx.ABSTRACT_kw() is not None
        struct_name = get_ID_text(ctx.name)

        if ctx.base is not None:
            # Get the base struct type
            base_name = get_ID_text(ctx.base)
            base_type = self.compiler.namespace.lookup_type(base_name)
            if base_type is None:
                self.msg.fatal(
                    "Type '%s' is not defined" % base_name,
                    src_ref_from_antlr(ctx.base)
                )
            if not rdltypes.is_user_struct(base_type):
                self.msg.fatal(
                    "Base type '%s' is not a struct" % base_name,
                    src_ref_from_antlr(ctx.base)
                )
        else:
            base_type = rdltypes.UserStruct


        # Collect struct member elements
        members = OrderedDict()
        for struct_elem_ctx in ctx.getTypedRuleContexts(SystemRDLParser.Struct_elemContext):
            member_type, member_name, member_src_ref = self.visit(struct_elem_ctx)

            if member_name in members:
                self.msg.error(
                    "Struct member '%s' has already been defined" % member_name,
                    member_src_ref
                )
                continue

            if member_name in base_type._members:
                self.msg.error(
                    "Struct member '%s' has already been defined in base struct '%s'"
                    % (member_name, base_type.__name__),
                    member_src_ref
                )
                continue

            members[member_name] = member_type


        # Create Struct type
        struct_type = base_type.define_new(struct_name, members, is_abstract, self.parent_component)

        self.compiler.namespace.exit_scope()
        return struct_type, struct_name, src_ref_from_antlr(ctx.name)


    def visitStruct_elem(self, ctx: SystemRDLParser.Struct_elemContext):

        member_name = get_ID_text(ctx.ID())
        member_src_ref = src_ref_from_antlr(ctx.ID())

        member_type = self.visit(ctx.struct_type())

        if ctx.array_type_suffix() is not None:
            member_type = rdltypes.ArrayedType(member_type)

        return member_type, member_name, member_src_ref


    def visitStruct_type(self, ctx: SystemRDLParser.Struct_typeContext):
        if ctx.data_type() is not None:
            data_type_token = self.visit(ctx.data_type())
            member_type = self.datatype_from_token(data_type_token)
        elif ctx.component_type() is not None:
            type_token = self.visit(ctx.component_type())
            member_type = KW_TO_COMPONENT_MAP[type_token.type]
        else:
            raise RuntimeError

        return member_type
