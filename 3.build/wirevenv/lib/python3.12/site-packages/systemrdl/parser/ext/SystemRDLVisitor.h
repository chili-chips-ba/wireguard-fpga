
// Generated from SystemRDL.g4 by ANTLR 4.13.2

#pragma once


#include "antlr4-runtime.h"
#include "SystemRDLParser.h"



/**
 * This class defines an abstract visitor for a parse tree
 * produced by SystemRDLParser.
 */
class  SystemRDLVisitor : public antlr4::tree::AbstractParseTreeVisitor {
public:

  /**
   * Visit parse trees produced by SystemRDLParser.
   */
    virtual std::any visitRoot(SystemRDLParser::RootContext *context) = 0;

    virtual std::any visitEval_expr_root(SystemRDLParser::Eval_expr_rootContext *context) = 0;

    virtual std::any visitRoot_elem(SystemRDLParser::Root_elemContext *context) = 0;

    virtual std::any visitComponent_def(SystemRDLParser::Component_defContext *context) = 0;

    virtual std::any visitExplicit_component_inst(SystemRDLParser::Explicit_component_instContext *context) = 0;

    virtual std::any visitComponent_inst_alias(SystemRDLParser::Component_inst_aliasContext *context) = 0;

    virtual std::any visitComponent_named_def(SystemRDLParser::Component_named_defContext *context) = 0;

    virtual std::any visitComponent_anon_def(SystemRDLParser::Component_anon_defContext *context) = 0;

    virtual std::any visitComponent_body(SystemRDLParser::Component_bodyContext *context) = 0;

    virtual std::any visitComponent_body_elem(SystemRDLParser::Component_body_elemContext *context) = 0;

    virtual std::any visitComponent_insts(SystemRDLParser::Component_instsContext *context) = 0;

    virtual std::any visitComponent_inst(SystemRDLParser::Component_instContext *context) = 0;

    virtual std::any visitField_inst_reset(SystemRDLParser::Field_inst_resetContext *context) = 0;

    virtual std::any visitInst_addr_fixed(SystemRDLParser::Inst_addr_fixedContext *context) = 0;

    virtual std::any visitInst_addr_stride(SystemRDLParser::Inst_addr_strideContext *context) = 0;

    virtual std::any visitInst_addr_align(SystemRDLParser::Inst_addr_alignContext *context) = 0;

    virtual std::any visitComponent_inst_type(SystemRDLParser::Component_inst_typeContext *context) = 0;

    virtual std::any visitComponent_type(SystemRDLParser::Component_typeContext *context) = 0;

    virtual std::any visitComponent_type_primary(SystemRDLParser::Component_type_primaryContext *context) = 0;

    virtual std::any visitParam_def(SystemRDLParser::Param_defContext *context) = 0;

    virtual std::any visitParam_def_elem(SystemRDLParser::Param_def_elemContext *context) = 0;

    virtual std::any visitParam_inst(SystemRDLParser::Param_instContext *context) = 0;

    virtual std::any visitParam_assignment(SystemRDLParser::Param_assignmentContext *context) = 0;

    virtual std::any visitBinaryExpr(SystemRDLParser::BinaryExprContext *context) = 0;

    virtual std::any visitUnaryExpr(SystemRDLParser::UnaryExprContext *context) = 0;

    virtual std::any visitNOP(SystemRDLParser::NOPContext *context) = 0;

    virtual std::any visitTernaryExpr(SystemRDLParser::TernaryExprContext *context) = 0;

    virtual std::any visitExpr_primary(SystemRDLParser::Expr_primaryContext *context) = 0;

    virtual std::any visitConcatenate(SystemRDLParser::ConcatenateContext *context) = 0;

    virtual std::any visitReplicate(SystemRDLParser::ReplicateContext *context) = 0;

    virtual std::any visitParen_expr(SystemRDLParser::Paren_exprContext *context) = 0;

    virtual std::any visitCastType(SystemRDLParser::CastTypeContext *context) = 0;

    virtual std::any visitCastWidth(SystemRDLParser::CastWidthContext *context) = 0;

    virtual std::any visitCast_width_expr(SystemRDLParser::Cast_width_exprContext *context) = 0;

    virtual std::any visitRange_suffix(SystemRDLParser::Range_suffixContext *context) = 0;

    virtual std::any visitArray_suffix(SystemRDLParser::Array_suffixContext *context) = 0;

    virtual std::any visitArray_type_suffix(SystemRDLParser::Array_type_suffixContext *context) = 0;

    virtual std::any visitData_type(SystemRDLParser::Data_typeContext *context) = 0;

    virtual std::any visitBasic_data_type(SystemRDLParser::Basic_data_typeContext *context) = 0;

    virtual std::any visitLiteral(SystemRDLParser::LiteralContext *context) = 0;

    virtual std::any visitNumberInt(SystemRDLParser::NumberIntContext *context) = 0;

    virtual std::any visitNumberHex(SystemRDLParser::NumberHexContext *context) = 0;

    virtual std::any visitNumberVerilog(SystemRDLParser::NumberVerilogContext *context) = 0;

    virtual std::any visitString_literal(SystemRDLParser::String_literalContext *context) = 0;

    virtual std::any visitBoolean_literal(SystemRDLParser::Boolean_literalContext *context) = 0;

    virtual std::any visitArray_literal(SystemRDLParser::Array_literalContext *context) = 0;

    virtual std::any visitStruct_literal(SystemRDLParser::Struct_literalContext *context) = 0;

    virtual std::any visitStruct_kv(SystemRDLParser::Struct_kvContext *context) = 0;

    virtual std::any visitEnum_literal(SystemRDLParser::Enum_literalContext *context) = 0;

    virtual std::any visitAccesstype_literal(SystemRDLParser::Accesstype_literalContext *context) = 0;

    virtual std::any visitOnreadtype_literal(SystemRDLParser::Onreadtype_literalContext *context) = 0;

    virtual std::any visitOnwritetype_literal(SystemRDLParser::Onwritetype_literalContext *context) = 0;

    virtual std::any visitAddressingtype_literal(SystemRDLParser::Addressingtype_literalContext *context) = 0;

    virtual std::any visitPrecedencetype_literal(SystemRDLParser::Precedencetype_literalContext *context) = 0;

    virtual std::any visitInstance_ref(SystemRDLParser::Instance_refContext *context) = 0;

    virtual std::any visitInstance_ref_element(SystemRDLParser::Instance_ref_elementContext *context) = 0;

    virtual std::any visitProp_ref(SystemRDLParser::Prop_refContext *context) = 0;

    virtual std::any visitLocal_property_assignment(SystemRDLParser::Local_property_assignmentContext *context) = 0;

    virtual std::any visitDynamic_property_assignment(SystemRDLParser::Dynamic_property_assignmentContext *context) = 0;

    virtual std::any visitNormal_prop_assign(SystemRDLParser::Normal_prop_assignContext *context) = 0;

    virtual std::any visitEncode_prop_assign(SystemRDLParser::Encode_prop_assignContext *context) = 0;

    virtual std::any visitProp_mod_assign(SystemRDLParser::Prop_mod_assignContext *context) = 0;

    virtual std::any visitProp_assignment_rhs(SystemRDLParser::Prop_assignment_rhsContext *context) = 0;

    virtual std::any visitProp_keyword(SystemRDLParser::Prop_keywordContext *context) = 0;

    virtual std::any visitProp_mod(SystemRDLParser::Prop_modContext *context) = 0;

    virtual std::any visitUdp_def(SystemRDLParser::Udp_defContext *context) = 0;

    virtual std::any visitUdp_attr(SystemRDLParser::Udp_attrContext *context) = 0;

    virtual std::any visitUdp_type(SystemRDLParser::Udp_typeContext *context) = 0;

    virtual std::any visitUdp_data_type(SystemRDLParser::Udp_data_typeContext *context) = 0;

    virtual std::any visitUdp_usage(SystemRDLParser::Udp_usageContext *context) = 0;

    virtual std::any visitUdp_comp_type(SystemRDLParser::Udp_comp_typeContext *context) = 0;

    virtual std::any visitUdp_default(SystemRDLParser::Udp_defaultContext *context) = 0;

    virtual std::any visitUdp_constraint(SystemRDLParser::Udp_constraintContext *context) = 0;

    virtual std::any visitEnum_def(SystemRDLParser::Enum_defContext *context) = 0;

    virtual std::any visitEnum_entry(SystemRDLParser::Enum_entryContext *context) = 0;

    virtual std::any visitEnum_prop_assign(SystemRDLParser::Enum_prop_assignContext *context) = 0;

    virtual std::any visitStruct_def(SystemRDLParser::Struct_defContext *context) = 0;

    virtual std::any visitStruct_elem(SystemRDLParser::Struct_elemContext *context) = 0;

    virtual std::any visitStruct_type(SystemRDLParser::Struct_typeContext *context) = 0;

    virtual std::any visitConstraint_def(SystemRDLParser::Constraint_defContext *context) = 0;

    virtual std::any visitConstraint_named_def(SystemRDLParser::Constraint_named_defContext *context) = 0;

    virtual std::any visitConstraint_anon_def(SystemRDLParser::Constraint_anon_defContext *context) = 0;

    virtual std::any visitConstraint_body(SystemRDLParser::Constraint_bodyContext *context) = 0;

    virtual std::any visitConstraint_body_elem(SystemRDLParser::Constraint_body_elemContext *context) = 0;

    virtual std::any visitConstraint_insts(SystemRDLParser::Constraint_instsContext *context) = 0;

    virtual std::any visitConstr_relational(SystemRDLParser::Constr_relationalContext *context) = 0;

    virtual std::any visitConstr_prop_assign(SystemRDLParser::Constr_prop_assignContext *context) = 0;

    virtual std::any visitConstr_inside_values(SystemRDLParser::Constr_inside_valuesContext *context) = 0;

    virtual std::any visitConstr_inside_enum(SystemRDLParser::Constr_inside_enumContext *context) = 0;

    virtual std::any visitConstr_lhs(SystemRDLParser::Constr_lhsContext *context) = 0;

    virtual std::any visitConstr_inside_value(SystemRDLParser::Constr_inside_valueContext *context) = 0;


};

