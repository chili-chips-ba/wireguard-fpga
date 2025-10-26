# Generated from SystemRDL.g4 by ANTLR 4.13.2
from antlr4 import *
if "." in __name__:
    from .SystemRDLParser import SystemRDLParser
else:
    from SystemRDLParser import SystemRDLParser

# This class defines a complete generic visitor for a parse tree produced by SystemRDLParser.

class SystemRDLVisitor(ParseTreeVisitor):

    # Visit a parse tree produced by SystemRDLParser#root.
    def visitRoot(self, ctx:SystemRDLParser.RootContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#eval_expr_root.
    def visitEval_expr_root(self, ctx:SystemRDLParser.Eval_expr_rootContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#root_elem.
    def visitRoot_elem(self, ctx:SystemRDLParser.Root_elemContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_def.
    def visitComponent_def(self, ctx:SystemRDLParser.Component_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#explicit_component_inst.
    def visitExplicit_component_inst(self, ctx:SystemRDLParser.Explicit_component_instContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_inst_alias.
    def visitComponent_inst_alias(self, ctx:SystemRDLParser.Component_inst_aliasContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_named_def.
    def visitComponent_named_def(self, ctx:SystemRDLParser.Component_named_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_anon_def.
    def visitComponent_anon_def(self, ctx:SystemRDLParser.Component_anon_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_body.
    def visitComponent_body(self, ctx:SystemRDLParser.Component_bodyContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_body_elem.
    def visitComponent_body_elem(self, ctx:SystemRDLParser.Component_body_elemContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_insts.
    def visitComponent_insts(self, ctx:SystemRDLParser.Component_instsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_inst.
    def visitComponent_inst(self, ctx:SystemRDLParser.Component_instContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#field_inst_reset.
    def visitField_inst_reset(self, ctx:SystemRDLParser.Field_inst_resetContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#inst_addr_fixed.
    def visitInst_addr_fixed(self, ctx:SystemRDLParser.Inst_addr_fixedContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#inst_addr_stride.
    def visitInst_addr_stride(self, ctx:SystemRDLParser.Inst_addr_strideContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#inst_addr_align.
    def visitInst_addr_align(self, ctx:SystemRDLParser.Inst_addr_alignContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_inst_type.
    def visitComponent_inst_type(self, ctx:SystemRDLParser.Component_inst_typeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_type.
    def visitComponent_type(self, ctx:SystemRDLParser.Component_typeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#component_type_primary.
    def visitComponent_type_primary(self, ctx:SystemRDLParser.Component_type_primaryContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#param_def.
    def visitParam_def(self, ctx:SystemRDLParser.Param_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#param_def_elem.
    def visitParam_def_elem(self, ctx:SystemRDLParser.Param_def_elemContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#param_inst.
    def visitParam_inst(self, ctx:SystemRDLParser.Param_instContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#param_assignment.
    def visitParam_assignment(self, ctx:SystemRDLParser.Param_assignmentContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#BinaryExpr.
    def visitBinaryExpr(self, ctx:SystemRDLParser.BinaryExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#UnaryExpr.
    def visitUnaryExpr(self, ctx:SystemRDLParser.UnaryExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#NOP.
    def visitNOP(self, ctx:SystemRDLParser.NOPContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#TernaryExpr.
    def visitTernaryExpr(self, ctx:SystemRDLParser.TernaryExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#expr_primary.
    def visitExpr_primary(self, ctx:SystemRDLParser.Expr_primaryContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#concatenate.
    def visitConcatenate(self, ctx:SystemRDLParser.ConcatenateContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#replicate.
    def visitReplicate(self, ctx:SystemRDLParser.ReplicateContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#paren_expr.
    def visitParen_expr(self, ctx:SystemRDLParser.Paren_exprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#CastType.
    def visitCastType(self, ctx:SystemRDLParser.CastTypeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#CastWidth.
    def visitCastWidth(self, ctx:SystemRDLParser.CastWidthContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#cast_width_expr.
    def visitCast_width_expr(self, ctx:SystemRDLParser.Cast_width_exprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#range_suffix.
    def visitRange_suffix(self, ctx:SystemRDLParser.Range_suffixContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#array_suffix.
    def visitArray_suffix(self, ctx:SystemRDLParser.Array_suffixContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#array_type_suffix.
    def visitArray_type_suffix(self, ctx:SystemRDLParser.Array_type_suffixContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#data_type.
    def visitData_type(self, ctx:SystemRDLParser.Data_typeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#basic_data_type.
    def visitBasic_data_type(self, ctx:SystemRDLParser.Basic_data_typeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#literal.
    def visitLiteral(self, ctx:SystemRDLParser.LiteralContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#NumberInt.
    def visitNumberInt(self, ctx:SystemRDLParser.NumberIntContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#NumberHex.
    def visitNumberHex(self, ctx:SystemRDLParser.NumberHexContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#NumberVerilog.
    def visitNumberVerilog(self, ctx:SystemRDLParser.NumberVerilogContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#string_literal.
    def visitString_literal(self, ctx:SystemRDLParser.String_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#boolean_literal.
    def visitBoolean_literal(self, ctx:SystemRDLParser.Boolean_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#array_literal.
    def visitArray_literal(self, ctx:SystemRDLParser.Array_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#struct_literal.
    def visitStruct_literal(self, ctx:SystemRDLParser.Struct_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#struct_kv.
    def visitStruct_kv(self, ctx:SystemRDLParser.Struct_kvContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#enum_literal.
    def visitEnum_literal(self, ctx:SystemRDLParser.Enum_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#accesstype_literal.
    def visitAccesstype_literal(self, ctx:SystemRDLParser.Accesstype_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#onreadtype_literal.
    def visitOnreadtype_literal(self, ctx:SystemRDLParser.Onreadtype_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#onwritetype_literal.
    def visitOnwritetype_literal(self, ctx:SystemRDLParser.Onwritetype_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#addressingtype_literal.
    def visitAddressingtype_literal(self, ctx:SystemRDLParser.Addressingtype_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#precedencetype_literal.
    def visitPrecedencetype_literal(self, ctx:SystemRDLParser.Precedencetype_literalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#instance_ref.
    def visitInstance_ref(self, ctx:SystemRDLParser.Instance_refContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#instance_ref_element.
    def visitInstance_ref_element(self, ctx:SystemRDLParser.Instance_ref_elementContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#prop_ref.
    def visitProp_ref(self, ctx:SystemRDLParser.Prop_refContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#local_property_assignment.
    def visitLocal_property_assignment(self, ctx:SystemRDLParser.Local_property_assignmentContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#dynamic_property_assignment.
    def visitDynamic_property_assignment(self, ctx:SystemRDLParser.Dynamic_property_assignmentContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#normal_prop_assign.
    def visitNormal_prop_assign(self, ctx:SystemRDLParser.Normal_prop_assignContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#encode_prop_assign.
    def visitEncode_prop_assign(self, ctx:SystemRDLParser.Encode_prop_assignContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#prop_mod_assign.
    def visitProp_mod_assign(self, ctx:SystemRDLParser.Prop_mod_assignContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#prop_assignment_rhs.
    def visitProp_assignment_rhs(self, ctx:SystemRDLParser.Prop_assignment_rhsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#prop_keyword.
    def visitProp_keyword(self, ctx:SystemRDLParser.Prop_keywordContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#prop_mod.
    def visitProp_mod(self, ctx:SystemRDLParser.Prop_modContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#udp_def.
    def visitUdp_def(self, ctx:SystemRDLParser.Udp_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#udp_attr.
    def visitUdp_attr(self, ctx:SystemRDLParser.Udp_attrContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#udp_type.
    def visitUdp_type(self, ctx:SystemRDLParser.Udp_typeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#udp_data_type.
    def visitUdp_data_type(self, ctx:SystemRDLParser.Udp_data_typeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#udp_usage.
    def visitUdp_usage(self, ctx:SystemRDLParser.Udp_usageContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#udp_comp_type.
    def visitUdp_comp_type(self, ctx:SystemRDLParser.Udp_comp_typeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#udp_default.
    def visitUdp_default(self, ctx:SystemRDLParser.Udp_defaultContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#udp_constraint.
    def visitUdp_constraint(self, ctx:SystemRDLParser.Udp_constraintContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#enum_def.
    def visitEnum_def(self, ctx:SystemRDLParser.Enum_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#enum_entry.
    def visitEnum_entry(self, ctx:SystemRDLParser.Enum_entryContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#enum_prop_assign.
    def visitEnum_prop_assign(self, ctx:SystemRDLParser.Enum_prop_assignContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#struct_def.
    def visitStruct_def(self, ctx:SystemRDLParser.Struct_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#struct_elem.
    def visitStruct_elem(self, ctx:SystemRDLParser.Struct_elemContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#struct_type.
    def visitStruct_type(self, ctx:SystemRDLParser.Struct_typeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constraint_def.
    def visitConstraint_def(self, ctx:SystemRDLParser.Constraint_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constraint_named_def.
    def visitConstraint_named_def(self, ctx:SystemRDLParser.Constraint_named_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constraint_anon_def.
    def visitConstraint_anon_def(self, ctx:SystemRDLParser.Constraint_anon_defContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constraint_body.
    def visitConstraint_body(self, ctx:SystemRDLParser.Constraint_bodyContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constraint_body_elem.
    def visitConstraint_body_elem(self, ctx:SystemRDLParser.Constraint_body_elemContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constraint_insts.
    def visitConstraint_insts(self, ctx:SystemRDLParser.Constraint_instsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constr_relational.
    def visitConstr_relational(self, ctx:SystemRDLParser.Constr_relationalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constr_prop_assign.
    def visitConstr_prop_assign(self, ctx:SystemRDLParser.Constr_prop_assignContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constr_inside_values.
    def visitConstr_inside_values(self, ctx:SystemRDLParser.Constr_inside_valuesContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constr_inside_enum.
    def visitConstr_inside_enum(self, ctx:SystemRDLParser.Constr_inside_enumContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constr_lhs.
    def visitConstr_lhs(self, ctx:SystemRDLParser.Constr_lhsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by SystemRDLParser#constr_inside_value.
    def visitConstr_inside_value(self, ctx:SystemRDLParser.Constr_inside_valueContext):
        return self.visitChildren(ctx)



del SystemRDLParser