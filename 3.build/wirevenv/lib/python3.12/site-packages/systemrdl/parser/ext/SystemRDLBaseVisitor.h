
// Generated from SystemRDL.g4 by ANTLR 4.13.2

#pragma once


#include "antlr4-runtime.h"
#include "SystemRDLVisitor.h"


/**
 * This class provides an empty implementation of SystemRDLVisitor, which can be
 * extended to create a visitor which only needs to handle a subset of the available methods.
 */
class  SystemRDLBaseVisitor : public SystemRDLVisitor {
public:

  virtual std::any visitRoot(SystemRDLParser::RootContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitEval_expr_root(SystemRDLParser::Eval_expr_rootContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitRoot_elem(SystemRDLParser::Root_elemContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_def(SystemRDLParser::Component_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitExplicit_component_inst(SystemRDLParser::Explicit_component_instContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_inst_alias(SystemRDLParser::Component_inst_aliasContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_named_def(SystemRDLParser::Component_named_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_anon_def(SystemRDLParser::Component_anon_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_body(SystemRDLParser::Component_bodyContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_body_elem(SystemRDLParser::Component_body_elemContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_insts(SystemRDLParser::Component_instsContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_inst(SystemRDLParser::Component_instContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitField_inst_reset(SystemRDLParser::Field_inst_resetContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitInst_addr_fixed(SystemRDLParser::Inst_addr_fixedContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitInst_addr_stride(SystemRDLParser::Inst_addr_strideContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitInst_addr_align(SystemRDLParser::Inst_addr_alignContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_inst_type(SystemRDLParser::Component_inst_typeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_type(SystemRDLParser::Component_typeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitComponent_type_primary(SystemRDLParser::Component_type_primaryContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitParam_def(SystemRDLParser::Param_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitParam_def_elem(SystemRDLParser::Param_def_elemContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitParam_inst(SystemRDLParser::Param_instContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitParam_assignment(SystemRDLParser::Param_assignmentContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitBinaryExpr(SystemRDLParser::BinaryExprContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUnaryExpr(SystemRDLParser::UnaryExprContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitNOP(SystemRDLParser::NOPContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitTernaryExpr(SystemRDLParser::TernaryExprContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitExpr_primary(SystemRDLParser::Expr_primaryContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConcatenate(SystemRDLParser::ConcatenateContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitReplicate(SystemRDLParser::ReplicateContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitParen_expr(SystemRDLParser::Paren_exprContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitCastType(SystemRDLParser::CastTypeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitCastWidth(SystemRDLParser::CastWidthContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitCast_width_expr(SystemRDLParser::Cast_width_exprContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitRange_suffix(SystemRDLParser::Range_suffixContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitArray_suffix(SystemRDLParser::Array_suffixContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitArray_type_suffix(SystemRDLParser::Array_type_suffixContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitData_type(SystemRDLParser::Data_typeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitBasic_data_type(SystemRDLParser::Basic_data_typeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitLiteral(SystemRDLParser::LiteralContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitNumberInt(SystemRDLParser::NumberIntContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitNumberHex(SystemRDLParser::NumberHexContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitNumberVerilog(SystemRDLParser::NumberVerilogContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitString_literal(SystemRDLParser::String_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitBoolean_literal(SystemRDLParser::Boolean_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitArray_literal(SystemRDLParser::Array_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitStruct_literal(SystemRDLParser::Struct_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitStruct_kv(SystemRDLParser::Struct_kvContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitEnum_literal(SystemRDLParser::Enum_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitAccesstype_literal(SystemRDLParser::Accesstype_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitOnreadtype_literal(SystemRDLParser::Onreadtype_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitOnwritetype_literal(SystemRDLParser::Onwritetype_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitAddressingtype_literal(SystemRDLParser::Addressingtype_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitPrecedencetype_literal(SystemRDLParser::Precedencetype_literalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitInstance_ref(SystemRDLParser::Instance_refContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitInstance_ref_element(SystemRDLParser::Instance_ref_elementContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitProp_ref(SystemRDLParser::Prop_refContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitLocal_property_assignment(SystemRDLParser::Local_property_assignmentContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitDynamic_property_assignment(SystemRDLParser::Dynamic_property_assignmentContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitNormal_prop_assign(SystemRDLParser::Normal_prop_assignContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitEncode_prop_assign(SystemRDLParser::Encode_prop_assignContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitProp_mod_assign(SystemRDLParser::Prop_mod_assignContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitProp_assignment_rhs(SystemRDLParser::Prop_assignment_rhsContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitProp_keyword(SystemRDLParser::Prop_keywordContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitProp_mod(SystemRDLParser::Prop_modContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUdp_def(SystemRDLParser::Udp_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUdp_attr(SystemRDLParser::Udp_attrContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUdp_type(SystemRDLParser::Udp_typeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUdp_data_type(SystemRDLParser::Udp_data_typeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUdp_usage(SystemRDLParser::Udp_usageContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUdp_comp_type(SystemRDLParser::Udp_comp_typeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUdp_default(SystemRDLParser::Udp_defaultContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUdp_constraint(SystemRDLParser::Udp_constraintContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitEnum_def(SystemRDLParser::Enum_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitEnum_entry(SystemRDLParser::Enum_entryContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitEnum_prop_assign(SystemRDLParser::Enum_prop_assignContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitStruct_def(SystemRDLParser::Struct_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitStruct_elem(SystemRDLParser::Struct_elemContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitStruct_type(SystemRDLParser::Struct_typeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstraint_def(SystemRDLParser::Constraint_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstraint_named_def(SystemRDLParser::Constraint_named_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstraint_anon_def(SystemRDLParser::Constraint_anon_defContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstraint_body(SystemRDLParser::Constraint_bodyContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstraint_body_elem(SystemRDLParser::Constraint_body_elemContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstraint_insts(SystemRDLParser::Constraint_instsContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstr_relational(SystemRDLParser::Constr_relationalContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstr_prop_assign(SystemRDLParser::Constr_prop_assignContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstr_inside_values(SystemRDLParser::Constr_inside_valuesContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstr_inside_enum(SystemRDLParser::Constr_inside_enumContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstr_lhs(SystemRDLParser::Constr_lhsContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstr_inside_value(SystemRDLParser::Constr_inside_valueContext *ctx) override {
    return visitChildren(ctx);
  }


};

