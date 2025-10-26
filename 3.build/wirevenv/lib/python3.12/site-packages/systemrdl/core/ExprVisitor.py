import re
from collections import OrderedDict

from ..parser.SystemRDLParser import SystemRDLParser
from .. import rdltypes
from .. import component as comp
from ..source_ref import src_ref_from_antlr

from .BaseVisitor import BaseVisitor
from .. import ast
from .parameter import Parameter
from .helpers import get_ID_text

class ExprVisitor(BaseVisitor):

    #---------------------------------------------------------------------------
    # Numerical Expressions
    #---------------------------------------------------------------------------
    _BinaryExpr_map = {
        SystemRDLParser.EXP     : ast.Exponent,
        SystemRDLParser.MULT    : ast.Mult,
        SystemRDLParser.DIV     : ast.Div,
        SystemRDLParser.MOD     : ast.Mod,
        SystemRDLParser.PLUS    : ast.Add,
        SystemRDLParser.MINUS   : ast.Sub,
        SystemRDLParser.LSHIFT  : ast.LShift,
        SystemRDLParser.RSHIFT  : ast.RShift,
        SystemRDLParser.LT      : ast.Lt,
        SystemRDLParser.LEQ     : ast.Leq,
        SystemRDLParser.GT      : ast.Gt,
        SystemRDLParser.GEQ     : ast.Geq,
        SystemRDLParser.EQ      : ast.Eq,
        SystemRDLParser.NEQ     : ast.Neq,
        SystemRDLParser.AND     : ast.BitwiseAnd,
        SystemRDLParser.XOR     : ast.BitwiseXor,
        SystemRDLParser.XNOR    : ast.BitwiseXnor,
        SystemRDLParser.OR      : ast.BitwiseOr,
        SystemRDLParser.BAND    : ast.BoolAnd,
        SystemRDLParser.BOR     : ast.BoolOr
    }

    _UnaryExpr_map = {
        SystemRDLParser.PLUS    : ast.UnaryPlus,
        SystemRDLParser.MINUS   : ast.UnaryMinus,
        SystemRDLParser.BNOT    : ast.BoolNot,
        SystemRDLParser.NOT     : ast.BitwiseInvert,
        SystemRDLParser.AND     : ast.AndReduce,
        SystemRDLParser.NAND    : ast.NandReduce,
        SystemRDLParser.OR      : ast.OrReduce,
        SystemRDLParser.NOR     : ast.NorReduce,
        SystemRDLParser.XOR     : ast.XorReduce,
        SystemRDLParser.XNOR    : ast.XnorReduce
    }

    # Visit a parse tree produced by SystemRDLParser#BinaryExpr.
    def visitBinaryExpr(self, ctx: SystemRDLParser.BinaryExprContext):
        l = self.visit(ctx.expr(0))
        r = self.visit(ctx.expr(1))
        expr_class = self._BinaryExpr_map[ctx.op.type]
        return expr_class(self.compiler.env, src_ref_from_antlr(ctx.op), l, r)


    # Visit a parse tree produced by SystemRDLParser#UnaryExpr.
    def visitUnaryExpr(self, ctx: SystemRDLParser.UnaryExprContext):
        n = self.visit(ctx.expr_primary())
        expr_class = self._UnaryExpr_map[ctx.op.type]
        return expr_class(self.compiler.env, src_ref_from_antlr(ctx.op), n)


    # Visit a parse tree produced by SystemRDLParser#TernaryExpr.
    def visitTernaryExpr(self, ctx: SystemRDLParser.TernaryExprContext):
        i = self.visit(ctx.expr(0))
        j = self.visit(ctx.expr(1))
        k = self.visit(ctx.expr(2))
        return ast.Conditional(self.compiler.env, src_ref_from_antlr(ctx.op), i, j, k)


    # Visit a parse tree produced by SystemRDLParser#paren_expr.
    def visitParen_expr(self, ctx: SystemRDLParser.Paren_exprContext):
        return self.visit(ctx.expr())

    #---------------------------------------------------------------------------
    # Numeric Literals
    #---------------------------------------------------------------------------
    # Visit a parse tree produced by SystemRDLParser#NumberInt.
    def visitNumberInt(self, ctx: SystemRDLParser.NumberIntContext):
        s = ctx.INT().getText()
        s = s.replace("_", "")
        return ast.IntLiteral(self.compiler.env, src_ref_from_antlr(ctx.INT()), int(s))


    # Visit a parse tree produced by SystemRDLParser#NumberHex.
    def visitNumberHex(self, ctx: SystemRDLParser.NumberHexContext):
        s = ctx.HEX_INT().getText()
        s = s.replace("_", "")
        return ast.IntLiteral(self.compiler.env, src_ref_from_antlr(ctx.HEX_INT()), int(s, 16))


    # Visit a parse tree produced by SystemRDLParser#NumberVerilog.
    def visitNumberVerilog(self, ctx: SystemRDLParser.NumberVerilogContext):
        s = ctx.VLOG_INT().getText()
        s = s.replace("_", "")
        m = re.fullmatch(r"(\d+)'(b|d|h)([\da-f]+)", s, re.IGNORECASE)
        width = int(m.group(1))
        basechar = m.group(2).lower()
        if basechar == "b":
            base = 2
        elif basechar == "d":
            base = 10
        else:
            base = 16

        val = int(m.group(3), base)

        if width < 1:
            self.msg.fatal(
                "Integer literal width must be greater than zero",
                src_ref_from_antlr(ctx.VLOG_INT())
            )

        if val.bit_length() > width:
            self.msg.fatal(
                "Value of integer literal exceeds the specified width",
                src_ref_from_antlr(ctx.VLOG_INT())
            )

        return ast.IntLiteral(self.compiler.env, src_ref_from_antlr(ctx.VLOG_INT()), val, width)


    # Visit a parse tree produced by SystemRDLParser#boolean_literal.
    def visitBoolean_literal(self, ctx: SystemRDLParser.Boolean_literalContext):
        if ctx.val.type == SystemRDLParser.TRUE_kw:
            return ast.BoolLiteral(self.compiler.env, src_ref_from_antlr(ctx.val), True)
        else:
            return ast.BoolLiteral(self.compiler.env, src_ref_from_antlr(ctx.val), False)

    #---------------------------------------------------------------------------
    # Built-in RDL Enumeration literals
    #---------------------------------------------------------------------------
    def visitAccesstype_literal(self, ctx: SystemRDLParser.Accesstype_literalContext):
        if ctx.kw.text == "wr":
            # same as rw
            value = rdltypes.AccessType.rw
        else:
            value = rdltypes.AccessType[ctx.kw.text]

        return ast.BuiltinEnumLiteral(self.compiler.env, src_ref_from_antlr(ctx.kw), value)

    def visitOnreadtype_literal(self, ctx: SystemRDLParser.Onreadtype_literalContext):
        return ast.BuiltinEnumLiteral(self.compiler.env, src_ref_from_antlr(ctx.kw), rdltypes.OnReadType[ctx.kw.text])

    def visitOnwritetype_literal(self, ctx: SystemRDLParser.Onwritetype_literalContext):
        return ast.BuiltinEnumLiteral(self.compiler.env, src_ref_from_antlr(ctx.kw), rdltypes.OnWriteType[ctx.kw.text])

    def visitAddressingtype_literal(self, ctx: SystemRDLParser.Addressingtype_literalContext):
        return ast.BuiltinEnumLiteral(self.compiler.env, src_ref_from_antlr(ctx.kw), rdltypes.AddressingType[ctx.kw.text])

    #---------------------------------------------------------------------------
    # Misc other literals
    #---------------------------------------------------------------------------
    def visitString_literal(self, ctx: SystemRDLParser.String_literalContext):
        string = ctx.STRING().getText()

        # Remove leading and trailing quotes (guaranteed to exist)
        string = string[1:-1]

        # Remove backslashes from any escaped characters
        string = re.sub(r'\\(.)', r'\1', string)

        return ast.StringLiteral(self.compiler.env, src_ref_from_antlr(ctx.STRING()), string)


    def visitEnum_literal(self, ctx: SystemRDLParser.Enum_literalContext):
        enum_type_name = get_ID_text(ctx.ID(0))
        enum_entry_name = get_ID_text(ctx.ID(1))

        # Lookup the enum type
        enum_type = self.compiler.namespace.lookup_type(enum_type_name)
        if enum_type is None:
            self.msg.fatal(
                "Enumeration type '%s' not found" % enum_type_name,
                src_ref_from_antlr(ctx.ID(0))
            )

        if not rdltypes.is_user_enum(enum_type):
            self.msg.fatal(
                "Identifier '%s' is not an enum" % enum_type_name,
                src_ref_from_antlr(ctx.ID(0))
            )

        # Get its value
        if enum_entry_name not in enum_type.members:
            self.msg.fatal(
                "'%s' is not a valid member of enum '%s'"
                % (enum_entry_name, enum_type_name),
                src_ref_from_antlr(ctx.ID(1))
            )

        return ast.EnumLiteral(self.compiler.env, src_ref_from_antlr(ctx), enum_type[enum_entry_name])


    def visitArray_literal(self, ctx: SystemRDLParser.Array_literalContext):
        elements = []
        for expr_ctx in ctx.getTypedRuleContexts(SystemRDLParser.ExprContext):
            elm_expr = self.visit(expr_ctx)
            elements.append(elm_expr)

        expr = ast.ArrayLiteral(self.compiler.env, src_ref_from_antlr(ctx), elements)
        expr.predict_type()
        return expr


    def visitStruct_literal(self, ctx: SystemRDLParser.Struct_literalContext):
        struct_type_name = get_ID_text(ctx.ID())

        # Lookup the struct type
        struct_type = self.compiler.namespace.lookup_type(struct_type_name)
        if struct_type is None:
            self.msg.fatal(
                "Struct type '%s' not found" % struct_type_name,
                src_ref_from_antlr(ctx.ID())
            )

        if not rdltypes.is_user_struct(struct_type):
            self.msg.fatal(
                "Identifier '%s' is not a struct" % struct_type_name,
                src_ref_from_antlr(ctx.ID())
            )

        if struct_type._is_abstract:
            self.msg.fatal(
                "Creating a literal from abstract struct '%s' is not allowed" % struct_type_name,
                src_ref_from_antlr(ctx.ID())
            )

        # collect member values
        values = OrderedDict()
        for kv_ctx in ctx.getTypedRuleContexts(SystemRDLParser.Struct_kvContext):
            member_name, member_expr, member_name_src_ref = self.visit(kv_ctx)

            if member_name in values:
                self.msg.error(
                    "Struct member '%s' already used in this literal" % member_name,
                    member_name_src_ref
                )
                continue

            if member_name not in struct_type._members:
                self.msg.fatal(
                    "'%s' is not a member of struct '%s'"
                    % (member_name, struct_type_name),
                    member_name_src_ref
                )

            # TODO: Need to detect if type is bit, and not perform a width cast (only do an assign cast)
            # Current implementation will truncate integers larger than 64-bits
            if struct_type._members[member_name] == int:
                member_expr = ast.Width64Cast(self.compiler.env, member_name_src_ref, member_expr)
            elif struct_type._members[member_name] == bool:
                member_expr = ast.BoolCast(self.compiler.env, member_name_src_ref, member_expr)

            values[member_name] = (member_expr, member_name_src_ref)

        missing_members = set(struct_type._members.keys()) - set(values.keys())
        undefined_members = []
        for member_name in missing_members:
            # 6.3.2.3.2-b: When defining struct member values, unassigned members
            # shall receive a default value depending on their type, when available:
            t = struct_type._members[member_name]
            if t == bool:
                values[member_name] = (ast.BoolLiteral(self.compiler.env, None, False), None)
            elif t == str:
                values[member_name] = (ast.StringLiteral(self.compiler.env, None, ""), None)
            elif t == rdltypes.AccessType:
                v = ast.BuiltinEnumLiteral(self.compiler.env, None, rdltypes.AccessType.rw)
                values[member_name] = (v, None)
            elif t == rdltypes.AddressingType:
                v = ast.BuiltinEnumLiteral(self.compiler.env, None, rdltypes.AddressingType.regalign)
                values[member_name] = (v, None)
            elif isinstance(t, rdltypes.ArrayedType):
                v = ast.ArrayLiteral(self.compiler.env, None, [])
                values[member_name] = (v, None)
            else:
                undefined_members.append(member_name)

        if undefined_members:
            # 6.3.2.3.2-c: All the members from a struct instance shall be assigned
            # a value, either explicitly or by default.
            # Undefined struct members shall raise an error
            self.msg.fatal(
                "Incomplete struct literal '%s'. The following members are undefined: %s"
                % (struct_type_name, ", ".join(undefined_members)),
                src_ref_from_antlr(ctx.ID())
            )

        expr = ast.StructLiteral(
            self.compiler.env,
            src_ref_from_antlr(ctx.ID()),
            struct_type,
            values
        )
        expr.predict_type()
        return expr


    def visitStruct_kv(self, ctx: SystemRDLParser.Struct_kvContext):
        member_name = get_ID_text(ctx.ID())
        member_name_src_ref = src_ref_from_antlr(ctx.ID())
        member_expr = self.visit(ctx.expr())
        return member_name, member_expr, member_name_src_ref

    #---------------------------------------------------------------------------
    # Aggregate Operators
    #---------------------------------------------------------------------------
    def visitConcatenate(self, ctx: SystemRDLParser.ConcatenateContext):
        elements = []
        for expr_ctx in ctx.getTypedRuleContexts(SystemRDLParser.ExprContext):
            elm_expr = self.visit(expr_ctx)
            elements.append(elm_expr)

        expr = ast.Concatenate(self.compiler.env, src_ref_from_antlr(ctx), elements)
        expr.predict_type()
        return expr


    def visitReplicate(self, ctx: SystemRDLParser.ReplicateContext):
        reps_expr = self.visit(ctx.expr())
        concat_expr = self.visit(ctx.concatenate())
        expr = ast.Replicate(self.compiler.env, src_ref_from_antlr(ctx), reps_expr, concat_expr)
        expr.predict_type()
        return expr

    #---------------------------------------------------------------------------
    # Cast
    #---------------------------------------------------------------------------
    # Visit a parse tree produced by SystemRDLParser#CastType.
    def visitCastType(self, ctx: SystemRDLParser.CastTypeContext):
        if ctx.typ.type == SystemRDLParser.LONGINT_kw:
            # Longint gets truncated to 64-bits
            return ast.Width64Cast(self.compiler.env, src_ref_from_antlr(ctx.op), self.visit(ctx.expr()))
        elif ctx.typ.type == SystemRDLParser.BIT_kw:
            # Cast to bit remains unaffected, but in self-determined context
            # Use assignment cast to isolate evaluation
            return ast.AssignmentCast(self.compiler.env, src_ref_from_antlr(ctx.op), self.visit(ctx.expr()), int)
        elif ctx.typ.type == SystemRDLParser.BOOLEAN_kw:
            return ast.BoolCast(self.compiler.env, src_ref_from_antlr(ctx.op), self.visit(ctx.expr()))
        else:
            raise RuntimeError

    # Visit a parse tree produced by SystemRDLParser#CastWidth.
    def visitCastWidth(self, ctx: SystemRDLParser.CastWidthContext):
        w = self.visit(ctx.cast_width_expr())
        return ast.WidthCast(self.compiler.env, src_ref_from_antlr(ctx.op), self.visit(ctx.expr()), w)

    #---------------------------------------------------------------------------
    # References
    #---------------------------------------------------------------------------
    def visitInstance_ref(self, ctx: SystemRDLParser.Instance_refContext) -> ast.ASTNode:

        # Get each ref element in a hierarchical chain. Each element is a tuple:
        #   (name, [index_expr, ...], SourceRefBase)
        ref_elements = []
        for ref_elem in ctx.getTypedRuleContexts(SystemRDLParser.Instance_ref_elementContext):
            ref_elements.append(self.visit(ref_elem))

        # Resolve reference of first element, since it is in the local scope
        first_name, first_array_suffixes, first_name_src_ref = ref_elements[0]
        first_elem, first_elem_parent_def = self.compiler.namespace.lookup_element(first_name)
        if first_elem is None:
            self.msg.fatal(
                "Reference to '%s' not found" % first_name,
                first_name_src_ref
            )

        if isinstance(first_elem, Parameter):
            # Reference is to a local parameter
            ref_expr: ast.ASTNode = ast.ParameterRef(
                self.compiler.env,
                first_name_src_ref,
                ref_root=first_elem_parent_def,
                param_name=first_elem.name,
            )

            # Wrap ref_expr with array/struct dereferencers as appropriate
            for array_suffix in first_array_suffixes:
                ref_expr = ast.ArrayIndex(self.compiler.env, first_name_src_ref, ref_expr, array_suffix)
            for name, array_suffixes, name_src_ref in ref_elements[1:]:
                ref_expr = ast.MemberRef(self.compiler.env, name_src_ref, ref_expr, name)
                for array_suffix in array_suffixes:
                    ref_expr = ast.ArrayIndex(self.compiler.env, name_src_ref, ref_expr, array_suffix)

        elif isinstance(first_elem, comp.Component):
            ref_expr = ast.InstRef(
                self.compiler.env,
                ref_root=first_elem_parent_def,
                ref_elements=ref_elements
            )
        else:
            raise RuntimeError

        return ref_expr

    def visitInstance_ref_element(self, ctx: SystemRDLParser.Instance_ref_elementContext):
        name_token = ctx.ID()
        name = get_ID_text(name_token)

        array_suffixes = []
        for as_ctx in ctx.getTypedRuleContexts(SystemRDLParser.Array_suffixContext):
            array_suffixes.append(self.visit(as_ctx))

        return name, array_suffixes, src_ref_from_antlr(name_token)

    def visitProp_ref(self, ctx: SystemRDLParser.Prop_refContext):
        ref_expr = self.visit(ctx.instance_ref())

        if ctx.prop_keyword() is not None:
            prop_token = self.visit(ctx.prop_keyword())
        else:
            prop_token = ctx.ID()

        if not isinstance(ref_expr, ast.InstRef):
            self.msg.fatal(
                "Illegal property reference from non-component.",
                src_ref_from_antlr(ctx.instance_ref())
            )

        prop_name = get_ID_text(prop_token)
        prop_ref_type = self.compiler.env.property_rules.lookup_prop_ref_type(prop_name)

        if prop_ref_type is None:
            if self.compiler.env.property_rules.lookup_property(prop_name):
                self.msg.fatal(
                    "'%s' can not be referenced in the righthand side of an assignment expression" % prop_name,
                    src_ref_from_antlr(prop_token)
                )
            else:
                self.msg.fatal(
                    "'%s' is not a known property" % prop_name,
                    src_ref_from_antlr(prop_token)
                )

        propref_expr = ast.PropRef(
            self.compiler.env,
            src_ref_from_antlr(prop_token),
            ref_expr,
            prop_ref_type
        )

        return propref_expr

    def visitArray_suffix(self, ctx: SystemRDLParser.Array_suffixContext):
        expr = self.visit(ctx.expr())
        expr = ast.AssignmentCast(self.compiler.env, src_ref_from_antlr(ctx.expr()), expr, int)
        expr.predict_type()
        return expr
