
// Generated from SystemRDL.g4 by ANTLR 4.13.2

#pragma once


#include "antlr4-runtime.h"




class  SystemRDLParser : public antlr4::Parser {
public:
  enum {
    T__0 = 1, T__1 = 2, T__2 = 3, T__3 = 4, T__4 = 5, T__5 = 6, T__6 = 7, 
    T__7 = 8, T__8 = 9, T__9 = 10, T__10 = 11, T__11 = 12, T__12 = 13, T__13 = 14, 
    T__14 = 15, SL_COMMENT = 16, ML_COMMENT = 17, BOOLEAN_kw = 18, BIT_kw = 19, 
    LONGINT_kw = 20, UNSIGNED_kw = 21, STRING_kw = 22, ACCESSTYPE_kw = 23, 
    ADDRESSINGTYPE_kw = 24, ONREADTYPE_kw = 25, ONWRITETYPE_kw = 26, ALIAS_kw = 27, 
    EXTERNAL_kw = 28, INTERNAL_kw = 29, ADDRMAP_kw = 30, REGFILE_kw = 31, 
    REG_kw = 32, FIELD_kw = 33, MEM_kw = 34, SIGNAL_kw = 35, TRUE_kw = 36, 
    FALSE_kw = 37, NA_kw = 38, RW_kw = 39, WR_kw = 40, R_kw = 41, W_kw = 42, 
    RW1_kw = 43, W1_kw = 44, RCLR_kw = 45, RSET_kw = 46, RUSER_kw = 47, 
    WOSET_kw = 48, WOCLR_kw = 49, WOT_kw = 50, WZS_kw = 51, WZC_kw = 52, 
    WZT_kw = 53, WCLR_kw = 54, WSET_kw = 55, WUSER_kw = 56, COMPACT_kw = 57, 
    REGALIGN_kw = 58, FULLALIGN_kw = 59, HW_kw = 60, SW_kw = 61, POSEDGE_kw = 62, 
    NEGEDGE_kw = 63, BOTHEDGE_kw = 64, LEVEL_kw = 65, NONSTICKY_kw = 66, 
    ABSTRACT_kw = 67, ALL_kw = 68, COMPONENT_kw = 69, COMPONENTWIDTH_kw = 70, 
    CONSTRAINT_kw = 71, DEFAULT_kw = 72, ENUM_kw = 73, ENCODE_kw = 74, INSIDE_kw = 75, 
    NUMBER_kw = 76, PROPERTY_kw = 77, REF_kw = 78, STRUCT_kw = 79, THIS_kw = 80, 
    TYPE_kw = 81, ALTERNATE_kw = 82, BYTE_kw = 83, INT_kw = 84, PRECEDENCETYPE_kw = 85, 
    REAL_kw = 86, SHORTINT_kw = 87, SHORTREAL_kw = 88, SIGNED_kw = 89, WITH_kw = 90, 
    WITHIN_kw = 91, INT = 92, HEX_INT = 93, VLOG_INT = 94, STRING = 95, 
    PLUS = 96, MINUS = 97, BNOT = 98, NOT = 99, BAND = 100, NAND = 101, 
    AND = 102, OR = 103, BOR = 104, NOR = 105, XOR = 106, XNOR = 107, LSHIFT = 108, 
    RSHIFT = 109, MULT = 110, EXP = 111, DIV = 112, MOD = 113, EQ = 114, 
    ASSIGN = 115, NEQ = 116, LEQ = 117, LT = 118, GEQ = 119, GT = 120, AT = 121, 
    INC = 122, ALIGN = 123, WS = 124, ID = 125
  };

  enum {
    RuleRoot = 0, RuleEval_expr_root = 1, RuleRoot_elem = 2, RuleComponent_def = 3, 
    RuleExplicit_component_inst = 4, RuleComponent_inst_alias = 5, RuleComponent_named_def = 6, 
    RuleComponent_anon_def = 7, RuleComponent_body = 8, RuleComponent_body_elem = 9, 
    RuleComponent_insts = 10, RuleComponent_inst = 11, RuleField_inst_reset = 12, 
    RuleInst_addr_fixed = 13, RuleInst_addr_stride = 14, RuleInst_addr_align = 15, 
    RuleComponent_inst_type = 16, RuleComponent_type = 17, RuleComponent_type_primary = 18, 
    RuleParam_def = 19, RuleParam_def_elem = 20, RuleParam_inst = 21, RuleParam_assignment = 22, 
    RuleExpr = 23, RuleExpr_primary = 24, RuleConcatenate = 25, RuleReplicate = 26, 
    RuleParen_expr = 27, RuleCast = 28, RuleCast_width_expr = 29, RuleRange_suffix = 30, 
    RuleArray_suffix = 31, RuleArray_type_suffix = 32, RuleData_type = 33, 
    RuleBasic_data_type = 34, RuleLiteral = 35, RuleNumber = 36, RuleString_literal = 37, 
    RuleBoolean_literal = 38, RuleArray_literal = 39, RuleStruct_literal = 40, 
    RuleStruct_kv = 41, RuleEnum_literal = 42, RuleAccesstype_literal = 43, 
    RuleOnreadtype_literal = 44, RuleOnwritetype_literal = 45, RuleAddressingtype_literal = 46, 
    RulePrecedencetype_literal = 47, RuleInstance_ref = 48, RuleInstance_ref_element = 49, 
    RuleProp_ref = 50, RuleLocal_property_assignment = 51, RuleDynamic_property_assignment = 52, 
    RuleNormal_prop_assign = 53, RuleEncode_prop_assign = 54, RuleProp_mod_assign = 55, 
    RuleProp_assignment_rhs = 56, RuleProp_keyword = 57, RuleProp_mod = 58, 
    RuleUdp_def = 59, RuleUdp_attr = 60, RuleUdp_type = 61, RuleUdp_data_type = 62, 
    RuleUdp_usage = 63, RuleUdp_comp_type = 64, RuleUdp_default = 65, RuleUdp_constraint = 66, 
    RuleEnum_def = 67, RuleEnum_entry = 68, RuleEnum_prop_assign = 69, RuleStruct_def = 70, 
    RuleStruct_elem = 71, RuleStruct_type = 72, RuleConstraint_def = 73, 
    RuleConstraint_named_def = 74, RuleConstraint_anon_def = 75, RuleConstraint_body = 76, 
    RuleConstraint_body_elem = 77, RuleConstraint_insts = 78, RuleConstr_relational = 79, 
    RuleConstr_prop_assign = 80, RuleConstr_inside_values = 81, RuleConstr_inside_enum = 82, 
    RuleConstr_lhs = 83, RuleConstr_inside_value = 84
  };

  explicit SystemRDLParser(antlr4::TokenStream *input);

  SystemRDLParser(antlr4::TokenStream *input, const antlr4::atn::ParserATNSimulatorOptions &options);

  ~SystemRDLParser() override;

  std::string getGrammarFileName() const override;

  const antlr4::atn::ATN& getATN() const override;

  const std::vector<std::string>& getRuleNames() const override;

  const antlr4::dfa::Vocabulary& getVocabulary() const override;

  antlr4::atn::SerializedATNView getSerializedATN() const override;


  class RootContext;
  class Eval_expr_rootContext;
  class Root_elemContext;
  class Component_defContext;
  class Explicit_component_instContext;
  class Component_inst_aliasContext;
  class Component_named_defContext;
  class Component_anon_defContext;
  class Component_bodyContext;
  class Component_body_elemContext;
  class Component_instsContext;
  class Component_instContext;
  class Field_inst_resetContext;
  class Inst_addr_fixedContext;
  class Inst_addr_strideContext;
  class Inst_addr_alignContext;
  class Component_inst_typeContext;
  class Component_typeContext;
  class Component_type_primaryContext;
  class Param_defContext;
  class Param_def_elemContext;
  class Param_instContext;
  class Param_assignmentContext;
  class ExprContext;
  class Expr_primaryContext;
  class ConcatenateContext;
  class ReplicateContext;
  class Paren_exprContext;
  class CastContext;
  class Cast_width_exprContext;
  class Range_suffixContext;
  class Array_suffixContext;
  class Array_type_suffixContext;
  class Data_typeContext;
  class Basic_data_typeContext;
  class LiteralContext;
  class NumberContext;
  class String_literalContext;
  class Boolean_literalContext;
  class Array_literalContext;
  class Struct_literalContext;
  class Struct_kvContext;
  class Enum_literalContext;
  class Accesstype_literalContext;
  class Onreadtype_literalContext;
  class Onwritetype_literalContext;
  class Addressingtype_literalContext;
  class Precedencetype_literalContext;
  class Instance_refContext;
  class Instance_ref_elementContext;
  class Prop_refContext;
  class Local_property_assignmentContext;
  class Dynamic_property_assignmentContext;
  class Normal_prop_assignContext;
  class Encode_prop_assignContext;
  class Prop_mod_assignContext;
  class Prop_assignment_rhsContext;
  class Prop_keywordContext;
  class Prop_modContext;
  class Udp_defContext;
  class Udp_attrContext;
  class Udp_typeContext;
  class Udp_data_typeContext;
  class Udp_usageContext;
  class Udp_comp_typeContext;
  class Udp_defaultContext;
  class Udp_constraintContext;
  class Enum_defContext;
  class Enum_entryContext;
  class Enum_prop_assignContext;
  class Struct_defContext;
  class Struct_elemContext;
  class Struct_typeContext;
  class Constraint_defContext;
  class Constraint_named_defContext;
  class Constraint_anon_defContext;
  class Constraint_bodyContext;
  class Constraint_body_elemContext;
  class Constraint_instsContext;
  class Constr_relationalContext;
  class Constr_prop_assignContext;
  class Constr_inside_valuesContext;
  class Constr_inside_enumContext;
  class Constr_lhsContext;
  class Constr_inside_valueContext; 

  class  RootContext : public antlr4::ParserRuleContext {
  public:
    RootContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<Root_elemContext *> root_elem();
    Root_elemContext* root_elem(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  RootContext* root();

  class  Eval_expr_rootContext : public antlr4::ParserRuleContext {
  public:
    Eval_expr_rootContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExprContext *expr();
    antlr4::tree::TerminalNode *EOF();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Eval_expr_rootContext* eval_expr_root();

  class  Root_elemContext : public antlr4::ParserRuleContext {
  public:
    Root_elemContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Component_defContext *component_def();
    Enum_defContext *enum_def();
    Udp_defContext *udp_def();
    Struct_defContext *struct_def();
    Constraint_defContext *constraint_def();
    Explicit_component_instContext *explicit_component_inst();
    Local_property_assignmentContext *local_property_assignment();
    Dynamic_property_assignmentContext *dynamic_property_assignment();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Root_elemContext* root_elem();

  class  Component_defContext : public antlr4::ParserRuleContext {
  public:
    Component_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Component_named_defContext *component_named_def();
    Component_inst_typeContext *component_inst_type();
    Component_instsContext *component_insts();
    Component_anon_defContext *component_anon_def();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_defContext* component_def();

  class  Explicit_component_instContext : public antlr4::ParserRuleContext {
  public:
    Explicit_component_instContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    Component_instsContext *component_insts();
    Component_inst_typeContext *component_inst_type();
    Component_inst_aliasContext *component_inst_alias();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Explicit_component_instContext* explicit_component_inst();

  class  Component_inst_aliasContext : public antlr4::ParserRuleContext {
  public:
    Component_inst_aliasContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ALIAS_kw();
    antlr4::tree::TerminalNode *ID();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_inst_aliasContext* component_inst_alias();

  class  Component_named_defContext : public antlr4::ParserRuleContext {
  public:
    Component_named_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Component_typeContext *component_type();
    antlr4::tree::TerminalNode *ID();
    Component_bodyContext *component_body();
    Param_defContext *param_def();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_named_defContext* component_named_def();

  class  Component_anon_defContext : public antlr4::ParserRuleContext {
  public:
    Component_anon_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Component_typeContext *component_type();
    Component_bodyContext *component_body();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_anon_defContext* component_anon_def();

  class  Component_bodyContext : public antlr4::ParserRuleContext {
  public:
    Component_bodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Component_body_elemContext *> component_body_elem();
    Component_body_elemContext* component_body_elem(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_bodyContext* component_body();

  class  Component_body_elemContext : public antlr4::ParserRuleContext {
  public:
    Component_body_elemContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Component_defContext *component_def();
    Enum_defContext *enum_def();
    Struct_defContext *struct_def();
    Constraint_defContext *constraint_def();
    Explicit_component_instContext *explicit_component_inst();
    Local_property_assignmentContext *local_property_assignment();
    Dynamic_property_assignmentContext *dynamic_property_assignment();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_body_elemContext* component_body_elem();

  class  Component_instsContext : public antlr4::ParserRuleContext {
  public:
    Component_instsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Component_instContext *> component_inst();
    Component_instContext* component_inst(size_t i);
    Param_instContext *param_inst();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_instsContext* component_insts();

  class  Component_instContext : public antlr4::ParserRuleContext {
  public:
    Component_instContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    Range_suffixContext *range_suffix();
    Field_inst_resetContext *field_inst_reset();
    Inst_addr_fixedContext *inst_addr_fixed();
    Inst_addr_strideContext *inst_addr_stride();
    Inst_addr_alignContext *inst_addr_align();
    std::vector<Array_suffixContext *> array_suffix();
    Array_suffixContext* array_suffix(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_instContext* component_inst();

  class  Field_inst_resetContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *op = nullptr;
    Field_inst_resetContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExprContext *expr();
    antlr4::tree::TerminalNode *ASSIGN();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Field_inst_resetContext* field_inst_reset();

  class  Inst_addr_fixedContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *op = nullptr;
    Inst_addr_fixedContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExprContext *expr();
    antlr4::tree::TerminalNode *AT();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Inst_addr_fixedContext* inst_addr_fixed();

  class  Inst_addr_strideContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *op = nullptr;
    Inst_addr_strideContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExprContext *expr();
    antlr4::tree::TerminalNode *INC();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Inst_addr_strideContext* inst_addr_stride();

  class  Inst_addr_alignContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *op = nullptr;
    Inst_addr_alignContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExprContext *expr();
    antlr4::tree::TerminalNode *ALIGN();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Inst_addr_alignContext* inst_addr_align();

  class  Component_inst_typeContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Component_inst_typeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EXTERNAL_kw();
    antlr4::tree::TerminalNode *INTERNAL_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_inst_typeContext* component_inst_type();

  class  Component_typeContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Component_typeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Component_type_primaryContext *component_type_primary();
    antlr4::tree::TerminalNode *SIGNAL_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_typeContext* component_type();

  class  Component_type_primaryContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Component_type_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ADDRMAP_kw();
    antlr4::tree::TerminalNode *REGFILE_kw();
    antlr4::tree::TerminalNode *REG_kw();
    antlr4::tree::TerminalNode *FIELD_kw();
    antlr4::tree::TerminalNode *MEM_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Component_type_primaryContext* component_type_primary();

  class  Param_defContext : public antlr4::ParserRuleContext {
  public:
    Param_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Param_def_elemContext *> param_def_elem();
    Param_def_elemContext* param_def_elem(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Param_defContext* param_def();

  class  Param_def_elemContext : public antlr4::ParserRuleContext {
  public:
    Param_def_elemContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Data_typeContext *data_type();
    antlr4::tree::TerminalNode *ID();
    Array_type_suffixContext *array_type_suffix();
    antlr4::tree::TerminalNode *ASSIGN();
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Param_def_elemContext* param_def_elem();

  class  Param_instContext : public antlr4::ParserRuleContext {
  public:
    Param_instContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Param_assignmentContext *> param_assignment();
    Param_assignmentContext* param_assignment(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Param_instContext* param_inst();

  class  Param_assignmentContext : public antlr4::ParserRuleContext {
  public:
    Param_assignmentContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Param_assignmentContext* param_assignment();

  class  ExprContext : public antlr4::ParserRuleContext {
  public:
    ExprContext(antlr4::ParserRuleContext *parent, size_t invokingState);
   
    ExprContext() = default;
    void copyFrom(ExprContext *context);
    using antlr4::ParserRuleContext::copyFrom;

    virtual size_t getRuleIndex() const override;

   
  };

  class  BinaryExprContext : public ExprContext {
  public:
    BinaryExprContext(ExprContext *ctx);

    antlr4::Token *op = nullptr;
    std::vector<ExprContext *> expr();
    ExprContext* expr(size_t i);
    antlr4::tree::TerminalNode *EXP();
    antlr4::tree::TerminalNode *MULT();
    antlr4::tree::TerminalNode *DIV();
    antlr4::tree::TerminalNode *MOD();
    antlr4::tree::TerminalNode *PLUS();
    antlr4::tree::TerminalNode *MINUS();
    antlr4::tree::TerminalNode *LSHIFT();
    antlr4::tree::TerminalNode *RSHIFT();
    antlr4::tree::TerminalNode *LT();
    antlr4::tree::TerminalNode *LEQ();
    antlr4::tree::TerminalNode *GT();
    antlr4::tree::TerminalNode *GEQ();
    antlr4::tree::TerminalNode *EQ();
    antlr4::tree::TerminalNode *NEQ();
    antlr4::tree::TerminalNode *AND();
    antlr4::tree::TerminalNode *XOR();
    antlr4::tree::TerminalNode *XNOR();
    antlr4::tree::TerminalNode *OR();
    antlr4::tree::TerminalNode *BAND();
    antlr4::tree::TerminalNode *BOR();

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  class  UnaryExprContext : public ExprContext {
  public:
    UnaryExprContext(ExprContext *ctx);

    antlr4::Token *op = nullptr;
    Expr_primaryContext *expr_primary();
    antlr4::tree::TerminalNode *PLUS();
    antlr4::tree::TerminalNode *MINUS();
    antlr4::tree::TerminalNode *BNOT();
    antlr4::tree::TerminalNode *NOT();
    antlr4::tree::TerminalNode *AND();
    antlr4::tree::TerminalNode *NAND();
    antlr4::tree::TerminalNode *OR();
    antlr4::tree::TerminalNode *NOR();
    antlr4::tree::TerminalNode *XOR();
    antlr4::tree::TerminalNode *XNOR();

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  class  NOPContext : public ExprContext {
  public:
    NOPContext(ExprContext *ctx);

    Expr_primaryContext *expr_primary();

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  class  TernaryExprContext : public ExprContext {
  public:
    TernaryExprContext(ExprContext *ctx);

    antlr4::Token *op = nullptr;
    std::vector<ExprContext *> expr();
    ExprContext* expr(size_t i);

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  ExprContext* expr();
  ExprContext* expr(int precedence);
  class  Expr_primaryContext : public antlr4::ParserRuleContext {
  public:
    Expr_primaryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    ConcatenateContext *concatenate();
    ReplicateContext *replicate();
    Paren_exprContext *paren_expr();
    CastContext *cast();
    Prop_refContext *prop_ref();
    Instance_refContext *instance_ref();
    Struct_literalContext *struct_literal();
    Array_literalContext *array_literal();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Expr_primaryContext* expr_primary();

  class  ConcatenateContext : public antlr4::ParserRuleContext {
  public:
    ConcatenateContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExprContext *> expr();
    ExprContext* expr(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  ConcatenateContext* concatenate();

  class  ReplicateContext : public antlr4::ParserRuleContext {
  public:
    ReplicateContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExprContext *expr();
    ConcatenateContext *concatenate();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  ReplicateContext* replicate();

  class  Paren_exprContext : public antlr4::ParserRuleContext {
  public:
    Paren_exprContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Paren_exprContext* paren_expr();

  class  CastContext : public antlr4::ParserRuleContext {
  public:
    CastContext(antlr4::ParserRuleContext *parent, size_t invokingState);
   
    CastContext() = default;
    void copyFrom(CastContext *context);
    using antlr4::ParserRuleContext::copyFrom;

    virtual size_t getRuleIndex() const override;

   
  };

  class  CastWidthContext : public CastContext {
  public:
    CastWidthContext(CastContext *ctx);

    antlr4::Token *op = nullptr;
    Cast_width_exprContext *cast_width_expr();
    ExprContext *expr();

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  class  CastTypeContext : public CastContext {
  public:
    CastTypeContext(CastContext *ctx);

    antlr4::Token *typ = nullptr;
    antlr4::Token *op = nullptr;
    ExprContext *expr();
    antlr4::tree::TerminalNode *BOOLEAN_kw();
    antlr4::tree::TerminalNode *BIT_kw();
    antlr4::tree::TerminalNode *LONGINT_kw();

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  CastContext* cast();

  class  Cast_width_exprContext : public antlr4::ParserRuleContext {
  public:
    Cast_width_exprContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    LiteralContext *literal();
    Paren_exprContext *paren_expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Cast_width_exprContext* cast_width_expr();

  class  Range_suffixContext : public antlr4::ParserRuleContext {
  public:
    Range_suffixContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExprContext *> expr();
    ExprContext* expr(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Range_suffixContext* range_suffix();

  class  Array_suffixContext : public antlr4::ParserRuleContext {
  public:
    Array_suffixContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Array_suffixContext* array_suffix();

  class  Array_type_suffixContext : public antlr4::ParserRuleContext {
  public:
    Array_type_suffixContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Array_type_suffixContext* array_type_suffix();

  class  Data_typeContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Data_typeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Basic_data_typeContext *basic_data_type();
    antlr4::tree::TerminalNode *ACCESSTYPE_kw();
    antlr4::tree::TerminalNode *ADDRESSINGTYPE_kw();
    antlr4::tree::TerminalNode *ONREADTYPE_kw();
    antlr4::tree::TerminalNode *ONWRITETYPE_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Data_typeContext* data_type();

  class  Basic_data_typeContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Basic_data_typeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *BIT_kw();
    antlr4::tree::TerminalNode *LONGINT_kw();
    antlr4::tree::TerminalNode *UNSIGNED_kw();
    antlr4::tree::TerminalNode *STRING_kw();
    antlr4::tree::TerminalNode *BOOLEAN_kw();
    antlr4::tree::TerminalNode *ID();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Basic_data_typeContext* basic_data_type();

  class  LiteralContext : public antlr4::ParserRuleContext {
  public:
    LiteralContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    NumberContext *number();
    String_literalContext *string_literal();
    Boolean_literalContext *boolean_literal();
    Accesstype_literalContext *accesstype_literal();
    Onreadtype_literalContext *onreadtype_literal();
    Onwritetype_literalContext *onwritetype_literal();
    Addressingtype_literalContext *addressingtype_literal();
    Precedencetype_literalContext *precedencetype_literal();
    Enum_literalContext *enum_literal();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  LiteralContext* literal();

  class  NumberContext : public antlr4::ParserRuleContext {
  public:
    NumberContext(antlr4::ParserRuleContext *parent, size_t invokingState);
   
    NumberContext() = default;
    void copyFrom(NumberContext *context);
    using antlr4::ParserRuleContext::copyFrom;

    virtual size_t getRuleIndex() const override;

   
  };

  class  NumberHexContext : public NumberContext {
  public:
    NumberHexContext(NumberContext *ctx);

    antlr4::tree::TerminalNode *HEX_INT();

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  class  NumberVerilogContext : public NumberContext {
  public:
    NumberVerilogContext(NumberContext *ctx);

    antlr4::tree::TerminalNode *VLOG_INT();

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  class  NumberIntContext : public NumberContext {
  public:
    NumberIntContext(NumberContext *ctx);

    antlr4::tree::TerminalNode *INT();

    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
  };

  NumberContext* number();

  class  String_literalContext : public antlr4::ParserRuleContext {
  public:
    String_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *STRING();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  String_literalContext* string_literal();

  class  Boolean_literalContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *val = nullptr;
    Boolean_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *TRUE_kw();
    antlr4::tree::TerminalNode *FALSE_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Boolean_literalContext* boolean_literal();

  class  Array_literalContext : public antlr4::ParserRuleContext {
  public:
    Array_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExprContext *> expr();
    ExprContext* expr(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Array_literalContext* array_literal();

  class  Struct_literalContext : public antlr4::ParserRuleContext {
  public:
    Struct_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    std::vector<Struct_kvContext *> struct_kv();
    Struct_kvContext* struct_kv(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Struct_literalContext* struct_literal();

  class  Struct_kvContext : public antlr4::ParserRuleContext {
  public:
    Struct_kvContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Struct_kvContext* struct_kv();

  class  Enum_literalContext : public antlr4::ParserRuleContext {
  public:
    Enum_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<antlr4::tree::TerminalNode *> ID();
    antlr4::tree::TerminalNode* ID(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Enum_literalContext* enum_literal();

  class  Accesstype_literalContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Accesstype_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *NA_kw();
    antlr4::tree::TerminalNode *RW_kw();
    antlr4::tree::TerminalNode *WR_kw();
    antlr4::tree::TerminalNode *R_kw();
    antlr4::tree::TerminalNode *W_kw();
    antlr4::tree::TerminalNode *RW1_kw();
    antlr4::tree::TerminalNode *W1_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Accesstype_literalContext* accesstype_literal();

  class  Onreadtype_literalContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Onreadtype_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *RCLR_kw();
    antlr4::tree::TerminalNode *RSET_kw();
    antlr4::tree::TerminalNode *RUSER_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Onreadtype_literalContext* onreadtype_literal();

  class  Onwritetype_literalContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Onwritetype_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *WOSET_kw();
    antlr4::tree::TerminalNode *WOCLR_kw();
    antlr4::tree::TerminalNode *WOT_kw();
    antlr4::tree::TerminalNode *WZS_kw();
    antlr4::tree::TerminalNode *WZC_kw();
    antlr4::tree::TerminalNode *WZT_kw();
    antlr4::tree::TerminalNode *WCLR_kw();
    antlr4::tree::TerminalNode *WSET_kw();
    antlr4::tree::TerminalNode *WUSER_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Onwritetype_literalContext* onwritetype_literal();

  class  Addressingtype_literalContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Addressingtype_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *COMPACT_kw();
    antlr4::tree::TerminalNode *REGALIGN_kw();
    antlr4::tree::TerminalNode *FULLALIGN_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Addressingtype_literalContext* addressingtype_literal();

  class  Precedencetype_literalContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Precedencetype_literalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *HW_kw();
    antlr4::tree::TerminalNode *SW_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Precedencetype_literalContext* precedencetype_literal();

  class  Instance_refContext : public antlr4::ParserRuleContext {
  public:
    Instance_refContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Instance_ref_elementContext *> instance_ref_element();
    Instance_ref_elementContext* instance_ref_element(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Instance_refContext* instance_ref();

  class  Instance_ref_elementContext : public antlr4::ParserRuleContext {
  public:
    Instance_ref_elementContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    std::vector<Array_suffixContext *> array_suffix();
    Array_suffixContext* array_suffix(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Instance_ref_elementContext* instance_ref_element();

  class  Prop_refContext : public antlr4::ParserRuleContext {
  public:
    Prop_refContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Instance_refContext *instance_ref();
    Prop_keywordContext *prop_keyword();
    antlr4::tree::TerminalNode *ID();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Prop_refContext* prop_ref();

  class  Local_property_assignmentContext : public antlr4::ParserRuleContext {
  public:
    Local_property_assignmentContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Normal_prop_assignContext *normal_prop_assign();
    antlr4::tree::TerminalNode *DEFAULT_kw();
    Encode_prop_assignContext *encode_prop_assign();
    Prop_mod_assignContext *prop_mod_assign();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Local_property_assignmentContext* local_property_assignment();

  class  Dynamic_property_assignmentContext : public antlr4::ParserRuleContext {
  public:
    Dynamic_property_assignmentContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Instance_refContext *instance_ref();
    Normal_prop_assignContext *normal_prop_assign();
    Encode_prop_assignContext *encode_prop_assign();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Dynamic_property_assignmentContext* dynamic_property_assignment();

  class  Normal_prop_assignContext : public antlr4::ParserRuleContext {
  public:
    Normal_prop_assignContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Prop_keywordContext *prop_keyword();
    antlr4::tree::TerminalNode *ID();
    antlr4::tree::TerminalNode *ASSIGN();
    Prop_assignment_rhsContext *prop_assignment_rhs();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Normal_prop_assignContext* normal_prop_assign();

  class  Encode_prop_assignContext : public antlr4::ParserRuleContext {
  public:
    Encode_prop_assignContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ENCODE_kw();
    antlr4::tree::TerminalNode *ASSIGN();
    antlr4::tree::TerminalNode *ID();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Encode_prop_assignContext* encode_prop_assign();

  class  Prop_mod_assignContext : public antlr4::ParserRuleContext {
  public:
    Prop_mod_assignContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Prop_modContext *prop_mod();
    antlr4::tree::TerminalNode *ID();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Prop_mod_assignContext* prop_mod_assign();

  class  Prop_assignment_rhsContext : public antlr4::ParserRuleContext {
  public:
    Prop_assignment_rhsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Precedencetype_literalContext *precedencetype_literal();
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Prop_assignment_rhsContext* prop_assignment_rhs();

  class  Prop_keywordContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Prop_keywordContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *SW_kw();
    antlr4::tree::TerminalNode *HW_kw();
    antlr4::tree::TerminalNode *RCLR_kw();
    antlr4::tree::TerminalNode *RSET_kw();
    antlr4::tree::TerminalNode *WOCLR_kw();
    antlr4::tree::TerminalNode *WOSET_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Prop_keywordContext* prop_keyword();

  class  Prop_modContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Prop_modContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *POSEDGE_kw();
    antlr4::tree::TerminalNode *NEGEDGE_kw();
    antlr4::tree::TerminalNode *BOTHEDGE_kw();
    antlr4::tree::TerminalNode *LEVEL_kw();
    antlr4::tree::TerminalNode *NONSTICKY_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Prop_modContext* prop_mod();

  class  Udp_defContext : public antlr4::ParserRuleContext {
  public:
    Udp_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *PROPERTY_kw();
    antlr4::tree::TerminalNode *ID();
    std::vector<Udp_attrContext *> udp_attr();
    Udp_attrContext* udp_attr(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Udp_defContext* udp_def();

  class  Udp_attrContext : public antlr4::ParserRuleContext {
  public:
    Udp_attrContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Udp_typeContext *udp_type();
    Udp_usageContext *udp_usage();
    Udp_defaultContext *udp_default();
    Udp_constraintContext *udp_constraint();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Udp_attrContext* udp_attr();

  class  Udp_typeContext : public antlr4::ParserRuleContext {
  public:
    Udp_typeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *TYPE_kw();
    antlr4::tree::TerminalNode *ASSIGN();
    Udp_data_typeContext *udp_data_type();
    Array_type_suffixContext *array_type_suffix();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Udp_typeContext* udp_type();

  class  Udp_data_typeContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Udp_data_typeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Component_type_primaryContext *component_type_primary();
    antlr4::tree::TerminalNode *REF_kw();
    antlr4::tree::TerminalNode *NUMBER_kw();
    Basic_data_typeContext *basic_data_type();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Udp_data_typeContext* udp_data_type();

  class  Udp_usageContext : public antlr4::ParserRuleContext {
  public:
    Udp_usageContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *COMPONENT_kw();
    antlr4::tree::TerminalNode *ASSIGN();
    std::vector<Udp_comp_typeContext *> udp_comp_type();
    Udp_comp_typeContext* udp_comp_type(size_t i);
    std::vector<antlr4::tree::TerminalNode *> OR();
    antlr4::tree::TerminalNode* OR(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Udp_usageContext* udp_usage();

  class  Udp_comp_typeContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *kw = nullptr;
    Udp_comp_typeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Component_typeContext *component_type();
    antlr4::tree::TerminalNode *CONSTRAINT_kw();
    antlr4::tree::TerminalNode *ALL_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Udp_comp_typeContext* udp_comp_type();

  class  Udp_defaultContext : public antlr4::ParserRuleContext {
  public:
    Udp_defaultContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *DEFAULT_kw();
    antlr4::tree::TerminalNode *ASSIGN();
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Udp_defaultContext* udp_default();

  class  Udp_constraintContext : public antlr4::ParserRuleContext {
  public:
    Udp_constraintContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *CONSTRAINT_kw();
    antlr4::tree::TerminalNode *ASSIGN();
    antlr4::tree::TerminalNode *COMPONENTWIDTH_kw();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Udp_constraintContext* udp_constraint();

  class  Enum_defContext : public antlr4::ParserRuleContext {
  public:
    Enum_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ENUM_kw();
    antlr4::tree::TerminalNode *ID();
    std::vector<Enum_entryContext *> enum_entry();
    Enum_entryContext* enum_entry(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Enum_defContext* enum_def();

  class  Enum_entryContext : public antlr4::ParserRuleContext {
  public:
    Enum_entryContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    antlr4::tree::TerminalNode *ASSIGN();
    ExprContext *expr();
    std::vector<Enum_prop_assignContext *> enum_prop_assign();
    Enum_prop_assignContext* enum_prop_assign(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Enum_entryContext* enum_entry();

  class  Enum_prop_assignContext : public antlr4::ParserRuleContext {
  public:
    Enum_prop_assignContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    antlr4::tree::TerminalNode *ASSIGN();
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Enum_prop_assignContext* enum_prop_assign();

  class  Struct_defContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *name = nullptr;
    antlr4::Token *base = nullptr;
    Struct_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *STRUCT_kw();
    std::vector<antlr4::tree::TerminalNode *> ID();
    antlr4::tree::TerminalNode* ID(size_t i);
    antlr4::tree::TerminalNode *ABSTRACT_kw();
    std::vector<Struct_elemContext *> struct_elem();
    Struct_elemContext* struct_elem(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Struct_defContext* struct_def();

  class  Struct_elemContext : public antlr4::ParserRuleContext {
  public:
    Struct_elemContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Struct_typeContext *struct_type();
    antlr4::tree::TerminalNode *ID();
    Array_type_suffixContext *array_type_suffix();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Struct_elemContext* struct_elem();

  class  Struct_typeContext : public antlr4::ParserRuleContext {
  public:
    Struct_typeContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Data_typeContext *data_type();
    Component_typeContext *component_type();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Struct_typeContext* struct_type();

  class  Constraint_defContext : public antlr4::ParserRuleContext {
  public:
    Constraint_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Constraint_named_defContext *constraint_named_def();
    Constraint_instsContext *constraint_insts();
    Constraint_anon_defContext *constraint_anon_def();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constraint_defContext* constraint_def();

  class  Constraint_named_defContext : public antlr4::ParserRuleContext {
  public:
    Constraint_named_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *CONSTRAINT_kw();
    antlr4::tree::TerminalNode *ID();
    Constraint_bodyContext *constraint_body();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constraint_named_defContext* constraint_named_def();

  class  Constraint_anon_defContext : public antlr4::ParserRuleContext {
  public:
    Constraint_anon_defContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *CONSTRAINT_kw();
    Constraint_bodyContext *constraint_body();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constraint_anon_defContext* constraint_anon_def();

  class  Constraint_bodyContext : public antlr4::ParserRuleContext {
  public:
    Constraint_bodyContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<Constraint_body_elemContext *> constraint_body_elem();
    Constraint_body_elemContext* constraint_body_elem(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constraint_bodyContext* constraint_body();

  class  Constraint_body_elemContext : public antlr4::ParserRuleContext {
  public:
    Constraint_body_elemContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Constr_relationalContext *constr_relational();
    Constr_prop_assignContext *constr_prop_assign();
    Constr_inside_valuesContext *constr_inside_values();
    Constr_inside_enumContext *constr_inside_enum();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constraint_body_elemContext* constraint_body_elem();

  class  Constraint_instsContext : public antlr4::ParserRuleContext {
  public:
    Constraint_instsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<antlr4::tree::TerminalNode *> ID();
    antlr4::tree::TerminalNode* ID(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constraint_instsContext* constraint_insts();

  class  Constr_relationalContext : public antlr4::ParserRuleContext {
  public:
    antlr4::Token *op = nullptr;
    Constr_relationalContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExprContext *> expr();
    ExprContext* expr(size_t i);
    antlr4::tree::TerminalNode *LT();
    antlr4::tree::TerminalNode *LEQ();
    antlr4::tree::TerminalNode *GT();
    antlr4::tree::TerminalNode *GEQ();
    antlr4::tree::TerminalNode *EQ();
    antlr4::tree::TerminalNode *NEQ();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constr_relationalContext* constr_relational();

  class  Constr_prop_assignContext : public antlr4::ParserRuleContext {
  public:
    Constr_prop_assignContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ID();
    antlr4::tree::TerminalNode *ASSIGN();
    ExprContext *expr();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constr_prop_assignContext* constr_prop_assign();

  class  Constr_inside_valuesContext : public antlr4::ParserRuleContext {
  public:
    Constr_inside_valuesContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Constr_lhsContext *constr_lhs();
    antlr4::tree::TerminalNode *INSIDE_kw();
    std::vector<Constr_inside_valueContext *> constr_inside_value();
    Constr_inside_valueContext* constr_inside_value(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constr_inside_valuesContext* constr_inside_values();

  class  Constr_inside_enumContext : public antlr4::ParserRuleContext {
  public:
    Constr_inside_enumContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    Constr_lhsContext *constr_lhs();
    antlr4::tree::TerminalNode *INSIDE_kw();
    antlr4::tree::TerminalNode *ID();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constr_inside_enumContext* constr_inside_enum();

  class  Constr_lhsContext : public antlr4::ParserRuleContext {
  public:
    Constr_lhsContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *THIS_kw();
    Instance_refContext *instance_ref();


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constr_lhsContext* constr_lhs();

  class  Constr_inside_valueContext : public antlr4::ParserRuleContext {
  public:
    SystemRDLParser::ExprContext *val = nullptr;
    SystemRDLParser::ExprContext *l_val = nullptr;
    SystemRDLParser::ExprContext *r_val = nullptr;
    Constr_inside_valueContext(antlr4::ParserRuleContext *parent, size_t invokingState);
    virtual size_t getRuleIndex() const override;
    std::vector<ExprContext *> expr();
    ExprContext* expr(size_t i);


    virtual std::any accept(antlr4::tree::ParseTreeVisitor *visitor) override;
   
  };

  Constr_inside_valueContext* constr_inside_value();


  bool sempred(antlr4::RuleContext *_localctx, size_t ruleIndex, size_t predicateIndex) override;

  bool exprSempred(ExprContext *_localctx, size_t predicateIndex);

  // By default the static state used to implement the parser is lazily initialized during the first
  // call to the constructor. You can call this function if you wish to initialize the static state
  // ahead of time.
  static void initialize();

private:
};

