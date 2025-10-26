
// Generated from SystemRDL.g4 by ANTLR 4.13.2

#pragma once


#include "antlr4-runtime.h"




class  SystemRDLLexer : public antlr4::Lexer {
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

  explicit SystemRDLLexer(antlr4::CharStream *input);

  ~SystemRDLLexer() override;


  std::string getGrammarFileName() const override;

  const std::vector<std::string>& getRuleNames() const override;

  const std::vector<std::string>& getChannelNames() const override;

  const std::vector<std::string>& getModeNames() const override;

  const antlr4::dfa::Vocabulary& getVocabulary() const override;

  antlr4::atn::SerializedATNView getSerializedATN() const override;

  const antlr4::atn::ATN& getATN() const override;

  // By default the static state used to implement the lexer is lazily initialized during the first
  // call to the constructor. You can call this function if you wish to initialize the static state
  // ahead of time.
  static void initialize();

private:

  // Individual action functions triggered by action() above.

  // Individual semantic predicate functions triggered by sempred() above.

};

