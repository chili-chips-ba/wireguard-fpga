
// Generated from SystemRDL.g4 by ANTLR 4.13.2


#include "SystemRDLVisitor.h"

#include "SystemRDLParser.h"


using namespace antlrcpp;

using namespace antlr4;

namespace {

struct SystemRDLParserStaticData final {
  SystemRDLParserStaticData(std::vector<std::string> ruleNames,
                        std::vector<std::string> literalNames,
                        std::vector<std::string> symbolicNames)
      : ruleNames(std::move(ruleNames)), literalNames(std::move(literalNames)),
        symbolicNames(std::move(symbolicNames)),
        vocabulary(this->literalNames, this->symbolicNames) {}

  SystemRDLParserStaticData(const SystemRDLParserStaticData&) = delete;
  SystemRDLParserStaticData(SystemRDLParserStaticData&&) = delete;
  SystemRDLParserStaticData& operator=(const SystemRDLParserStaticData&) = delete;
  SystemRDLParserStaticData& operator=(SystemRDLParserStaticData&&) = delete;

  std::vector<antlr4::dfa::DFA> decisionToDFA;
  antlr4::atn::PredictionContextCache sharedContextCache;
  const std::vector<std::string> ruleNames;
  const std::vector<std::string> literalNames;
  const std::vector<std::string> symbolicNames;
  const antlr4::dfa::Vocabulary vocabulary;
  antlr4::atn::SerializedATNView serializedATN;
  std::unique_ptr<antlr4::atn::ATN> atn;
};

::antlr4::internal::OnceFlag systemrdlParserOnceFlag;
#if ANTLR4_USE_THREAD_LOCAL_CACHE
static thread_local
#endif
std::unique_ptr<SystemRDLParserStaticData> systemrdlParserStaticData = nullptr;

void systemrdlParserInitialize() {
#if ANTLR4_USE_THREAD_LOCAL_CACHE
  if (systemrdlParserStaticData != nullptr) {
    return;
  }
#else
  assert(systemrdlParserStaticData == nullptr);
#endif
  auto staticData = std::make_unique<SystemRDLParserStaticData>(
    std::vector<std::string>{
      "root", "eval_expr_root", "root_elem", "component_def", "explicit_component_inst", 
      "component_inst_alias", "component_named_def", "component_anon_def", 
      "component_body", "component_body_elem", "component_insts", "component_inst", 
      "field_inst_reset", "inst_addr_fixed", "inst_addr_stride", "inst_addr_align", 
      "component_inst_type", "component_type", "component_type_primary", 
      "param_def", "param_def_elem", "param_inst", "param_assignment", "expr", 
      "expr_primary", "concatenate", "replicate", "paren_expr", "cast", 
      "cast_width_expr", "range_suffix", "array_suffix", "array_type_suffix", 
      "data_type", "basic_data_type", "literal", "number", "string_literal", 
      "boolean_literal", "array_literal", "struct_literal", "struct_kv", 
      "enum_literal", "accesstype_literal", "onreadtype_literal", "onwritetype_literal", 
      "addressingtype_literal", "precedencetype_literal", "instance_ref", 
      "instance_ref_element", "prop_ref", "local_property_assignment", "dynamic_property_assignment", 
      "normal_prop_assign", "encode_prop_assign", "prop_mod_assign", "prop_assignment_rhs", 
      "prop_keyword", "prop_mod", "udp_def", "udp_attr", "udp_type", "udp_data_type", 
      "udp_usage", "udp_comp_type", "udp_default", "udp_constraint", "enum_def", 
      "enum_entry", "enum_prop_assign", "struct_def", "struct_elem", "struct_type", 
      "constraint_def", "constraint_named_def", "constraint_anon_def", "constraint_body", 
      "constraint_body_elem", "constraint_insts", "constr_relational", "constr_prop_assign", 
      "constr_inside_values", "constr_inside_enum", "constr_lhs", "constr_inside_value"
    },
    std::vector<std::string>{
      "", "';'", "'{'", "'}'", "','", "'#'", "'('", "')'", "'.'", "'\\u003F'", 
      "':'", "'''", "'['", "']'", "'::'", "'->'", "", "", "'boolean'", "'bit'", 
      "'longint'", "'unsigned'", "'string'", "'accesstype'", "'addressingtype'", 
      "'onreadtype'", "'onwritetype'", "'alias'", "'external'", "'internal'", 
      "'addrmap'", "'regfile'", "'reg'", "'field'", "'mem'", "'signal'", 
      "'true'", "'false'", "'na'", "'rw'", "'wr'", "'r'", "'w'", "'rw1'", 
      "'w1'", "'rclr'", "'rset'", "'ruser'", "'woset'", "'woclr'", "'wot'", 
      "'wzs'", "'wzc'", "'wzt'", "'wclr'", "'wset'", "'wuser'", "'compact'", 
      "'regalign'", "'fullalign'", "'hw'", "'sw'", "'posedge'", "'negedge'", 
      "'bothedge'", "'level'", "'nonsticky'", "'abstract'", "'all'", "'component'", 
      "'componentwidth'", "'constraint'", "'default'", "'enum'", "'encode'", 
      "'inside'", "'number'", "'property'", "'ref'", "'struct'", "'this'", 
      "'type'", "'alternate'", "'byte'", "'int'", "'precedencetype'", "'real'", 
      "'shortint'", "'shortreal'", "'signed'", "'with'", "'within'", "", 
      "", "", "", "'+'", "'-'", "'!'", "'~'", "'&&'", "'~&'", "'&'", "'|'", 
      "'||'", "'~|'", "'^'", "", "'<<'", "'>>'", "'*'", "'**'", "'/'", "'%'", 
      "'=='", "'='", "'!='", "'<='", "'<'", "'>='", "'>'", "'@'", "'+='", 
      "'%='"
    },
    std::vector<std::string>{
      "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SL_COMMENT", 
      "ML_COMMENT", "BOOLEAN_kw", "BIT_kw", "LONGINT_kw", "UNSIGNED_kw", 
      "STRING_kw", "ACCESSTYPE_kw", "ADDRESSINGTYPE_kw", "ONREADTYPE_kw", 
      "ONWRITETYPE_kw", "ALIAS_kw", "EXTERNAL_kw", "INTERNAL_kw", "ADDRMAP_kw", 
      "REGFILE_kw", "REG_kw", "FIELD_kw", "MEM_kw", "SIGNAL_kw", "TRUE_kw", 
      "FALSE_kw", "NA_kw", "RW_kw", "WR_kw", "R_kw", "W_kw", "RW1_kw", "W1_kw", 
      "RCLR_kw", "RSET_kw", "RUSER_kw", "WOSET_kw", "WOCLR_kw", "WOT_kw", 
      "WZS_kw", "WZC_kw", "WZT_kw", "WCLR_kw", "WSET_kw", "WUSER_kw", "COMPACT_kw", 
      "REGALIGN_kw", "FULLALIGN_kw", "HW_kw", "SW_kw", "POSEDGE_kw", "NEGEDGE_kw", 
      "BOTHEDGE_kw", "LEVEL_kw", "NONSTICKY_kw", "ABSTRACT_kw", "ALL_kw", 
      "COMPONENT_kw", "COMPONENTWIDTH_kw", "CONSTRAINT_kw", "DEFAULT_kw", 
      "ENUM_kw", "ENCODE_kw", "INSIDE_kw", "NUMBER_kw", "PROPERTY_kw", "REF_kw", 
      "STRUCT_kw", "THIS_kw", "TYPE_kw", "ALTERNATE_kw", "BYTE_kw", "INT_kw", 
      "PRECEDENCETYPE_kw", "REAL_kw", "SHORTINT_kw", "SHORTREAL_kw", "SIGNED_kw", 
      "WITH_kw", "WITHIN_kw", "INT", "HEX_INT", "VLOG_INT", "STRING", "PLUS", 
      "MINUS", "BNOT", "NOT", "BAND", "NAND", "AND", "OR", "BOR", "NOR", 
      "XOR", "XNOR", "LSHIFT", "RSHIFT", "MULT", "EXP", "DIV", "MOD", "EQ", 
      "ASSIGN", "NEQ", "LEQ", "LT", "GEQ", "GT", "AT", "INC", "ALIGN", "WS", 
      "ID"
    }
  );
  static const int32_t serializedATNSegment[] = {
  	4,1,125,810,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,
  	7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,2,14,7,
  	14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,2,19,7,19,2,20,7,20,2,21,7,
  	21,2,22,7,22,2,23,7,23,2,24,7,24,2,25,7,25,2,26,7,26,2,27,7,27,2,28,7,
  	28,2,29,7,29,2,30,7,30,2,31,7,31,2,32,7,32,2,33,7,33,2,34,7,34,2,35,7,
  	35,2,36,7,36,2,37,7,37,2,38,7,38,2,39,7,39,2,40,7,40,2,41,7,41,2,42,7,
  	42,2,43,7,43,2,44,7,44,2,45,7,45,2,46,7,46,2,47,7,47,2,48,7,48,2,49,7,
  	49,2,50,7,50,2,51,7,51,2,52,7,52,2,53,7,53,2,54,7,54,2,55,7,55,2,56,7,
  	56,2,57,7,57,2,58,7,58,2,59,7,59,2,60,7,60,2,61,7,61,2,62,7,62,2,63,7,
  	63,2,64,7,64,2,65,7,65,2,66,7,66,2,67,7,67,2,68,7,68,2,69,7,69,2,70,7,
  	70,2,71,7,71,2,72,7,72,2,73,7,73,2,74,7,74,2,75,7,75,2,76,7,76,2,77,7,
  	77,2,78,7,78,2,79,7,79,2,80,7,80,2,81,7,81,2,82,7,82,2,83,7,83,2,84,7,
  	84,1,0,1,0,1,0,5,0,174,8,0,10,0,12,0,177,9,0,1,0,1,0,1,1,1,1,1,1,1,2,
  	1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,192,8,2,1,3,1,3,1,3,1,3,1,3,3,3,199,8,
  	3,3,3,201,8,3,1,3,1,3,1,3,1,3,1,3,3,3,208,8,3,1,3,1,3,1,3,1,3,1,3,1,3,
  	1,3,1,3,3,3,218,8,3,1,4,3,4,221,8,4,1,4,3,4,224,8,4,1,4,1,4,1,4,1,5,1,
  	5,1,5,1,6,1,6,1,6,3,6,235,8,6,1,6,1,6,1,7,1,7,1,7,1,8,1,8,1,8,1,8,5,8,
  	246,8,8,10,8,12,8,249,9,8,1,8,1,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,260,
  	8,9,1,10,3,10,263,8,10,1,10,1,10,1,10,5,10,268,8,10,10,10,12,10,271,9,
  	10,1,11,1,11,4,11,275,8,11,11,11,12,11,276,1,11,3,11,280,8,11,1,11,3,
  	11,283,8,11,1,11,3,11,286,8,11,1,11,3,11,289,8,11,1,11,3,11,292,8,11,
  	1,12,1,12,1,12,1,13,1,13,1,13,1,14,1,14,1,14,1,15,1,15,1,15,1,16,1,16,
  	1,17,1,17,3,17,310,8,17,1,18,1,18,1,19,1,19,1,19,1,19,1,19,5,19,319,8,
  	19,10,19,12,19,322,9,19,1,19,1,19,1,20,1,20,1,20,3,20,329,8,20,1,20,1,
  	20,3,20,333,8,20,1,21,1,21,1,21,1,21,1,21,5,21,340,8,21,10,21,12,21,343,
  	9,21,1,21,1,21,1,22,1,22,1,22,1,22,1,22,1,22,1,23,1,23,1,23,1,23,3,23,
  	357,8,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,
  	1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,
  	1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,1,23,5,23,
  	398,8,23,10,23,12,23,401,9,23,1,24,1,24,1,24,1,24,1,24,1,24,1,24,1,24,
  	1,24,3,24,412,8,24,1,25,1,25,1,25,1,25,5,25,418,8,25,10,25,12,25,421,
  	9,25,1,25,1,25,1,26,1,26,1,26,1,26,1,26,1,27,1,27,1,27,1,27,1,28,1,28,
  	1,28,1,28,1,28,1,28,1,28,1,28,1,28,1,28,1,28,1,28,3,28,446,8,28,1,29,
  	1,29,3,29,450,8,29,1,30,1,30,1,30,1,30,1,30,1,30,1,31,1,31,1,31,1,31,
  	1,32,1,32,1,32,1,33,1,33,3,33,467,8,33,1,34,1,34,3,34,471,8,34,1,34,3,
  	34,474,8,34,1,35,1,35,1,35,1,35,1,35,1,35,1,35,1,35,1,35,3,35,485,8,35,
  	1,36,1,36,1,36,3,36,490,8,36,1,37,1,37,1,38,1,38,1,39,1,39,1,39,1,39,
  	1,39,1,39,1,39,1,39,5,39,504,8,39,10,39,12,39,507,9,39,1,39,1,39,3,39,
  	511,8,39,1,40,1,40,1,40,1,40,1,40,1,40,1,40,1,40,1,40,1,40,5,40,523,8,
  	40,10,40,12,40,526,9,40,1,40,1,40,3,40,530,8,40,1,41,1,41,1,41,1,41,1,
  	42,1,42,1,42,1,42,1,43,1,43,1,44,1,44,1,45,1,45,1,46,1,46,1,47,1,47,1,
  	48,1,48,1,48,5,48,553,8,48,10,48,12,48,556,9,48,1,49,1,49,5,49,560,8,
  	49,10,49,12,49,563,9,49,1,50,1,50,1,50,1,50,3,50,569,8,50,1,51,3,51,572,
  	8,51,1,51,1,51,3,51,576,8,51,1,51,1,51,3,51,580,8,51,1,51,3,51,583,8,
  	51,1,52,1,52,1,52,1,52,1,52,1,52,1,52,1,52,3,52,593,8,52,1,53,1,53,3,
  	53,597,8,53,1,53,1,53,3,53,601,8,53,1,54,1,54,1,54,1,54,1,55,1,55,1,55,
  	1,56,1,56,3,56,612,8,56,1,57,1,57,1,58,1,58,1,59,1,59,1,59,1,59,1,59,
  	1,59,4,59,624,8,59,11,59,12,59,625,1,59,1,59,1,60,1,60,1,60,1,60,3,60,
  	634,8,60,1,61,1,61,1,61,1,61,3,61,640,8,61,1,62,1,62,1,62,3,62,645,8,
  	62,1,63,1,63,1,63,1,63,1,63,5,63,652,8,63,10,63,12,63,655,9,63,1,64,1,
  	64,3,64,659,8,64,1,65,1,65,1,65,1,65,1,66,1,66,1,66,1,66,1,67,1,67,1,
  	67,1,67,1,67,1,67,4,67,675,8,67,11,67,12,67,676,1,67,1,67,1,68,1,68,1,
  	68,3,68,684,8,68,1,68,1,68,1,68,1,68,5,68,690,8,68,10,68,12,68,693,9,
  	68,1,68,3,68,696,8,68,1,69,1,69,1,69,1,69,1,70,3,70,703,8,70,1,70,1,70,
  	1,70,1,70,3,70,709,8,70,1,70,1,70,1,70,1,70,5,70,715,8,70,10,70,12,70,
  	718,9,70,1,70,1,70,1,71,1,71,1,71,3,71,725,8,71,1,72,1,72,3,72,729,8,
  	72,1,73,1,73,3,73,733,8,73,1,73,1,73,1,73,3,73,738,8,73,1,74,1,74,1,74,
  	1,74,1,75,1,75,1,75,1,76,1,76,1,76,1,76,5,76,751,8,76,10,76,12,76,754,
  	9,76,1,76,1,76,1,77,1,77,1,77,1,77,3,77,762,8,77,1,78,1,78,1,78,5,78,
  	767,8,78,10,78,12,78,770,9,78,1,79,1,79,1,79,1,79,1,80,1,80,1,80,1,80,
  	1,81,1,81,1,81,1,81,1,81,1,81,5,81,786,8,81,10,81,12,81,789,9,81,1,81,
  	1,81,1,82,1,82,1,82,1,82,1,83,1,83,3,83,799,8,83,1,84,1,84,1,84,1,84,
  	1,84,1,84,1,84,3,84,808,8,84,1,84,0,1,46,85,0,2,4,6,8,10,12,14,16,18,
  	20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,
  	66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,
  	110,112,114,116,118,120,122,124,126,128,130,132,134,136,138,140,142,144,
  	146,148,150,152,154,156,158,160,162,164,166,168,0,24,1,0,28,29,1,0,30,
  	34,3,0,96,99,101,103,105,107,2,0,110,110,112,113,1,0,96,97,1,0,108,109,
  	1,0,117,120,2,0,114,114,116,116,1,0,106,107,1,0,18,20,1,0,23,26,1,0,19,
  	20,3,0,18,18,22,22,125,125,1,0,36,37,1,0,38,44,1,0,45,47,1,0,48,56,1,
  	0,57,59,1,0,60,61,3,0,45,46,48,49,60,61,1,0,62,66,2,0,76,76,78,78,2,0,
  	68,68,71,71,2,0,114,114,116,120,843,0,175,1,0,0,0,2,180,1,0,0,0,4,191,
  	1,0,0,0,6,217,1,0,0,0,8,220,1,0,0,0,10,228,1,0,0,0,12,231,1,0,0,0,14,
  	238,1,0,0,0,16,241,1,0,0,0,18,259,1,0,0,0,20,262,1,0,0,0,22,272,1,0,0,
  	0,24,293,1,0,0,0,26,296,1,0,0,0,28,299,1,0,0,0,30,302,1,0,0,0,32,305,
  	1,0,0,0,34,309,1,0,0,0,36,311,1,0,0,0,38,313,1,0,0,0,40,325,1,0,0,0,42,
  	334,1,0,0,0,44,346,1,0,0,0,46,356,1,0,0,0,48,411,1,0,0,0,50,413,1,0,0,
  	0,52,424,1,0,0,0,54,429,1,0,0,0,56,445,1,0,0,0,58,449,1,0,0,0,60,451,
  	1,0,0,0,62,457,1,0,0,0,64,461,1,0,0,0,66,466,1,0,0,0,68,473,1,0,0,0,70,
  	484,1,0,0,0,72,489,1,0,0,0,74,491,1,0,0,0,76,493,1,0,0,0,78,510,1,0,0,
  	0,80,529,1,0,0,0,82,531,1,0,0,0,84,535,1,0,0,0,86,539,1,0,0,0,88,541,
  	1,0,0,0,90,543,1,0,0,0,92,545,1,0,0,0,94,547,1,0,0,0,96,549,1,0,0,0,98,
  	557,1,0,0,0,100,564,1,0,0,0,102,582,1,0,0,0,104,592,1,0,0,0,106,596,1,
  	0,0,0,108,602,1,0,0,0,110,606,1,0,0,0,112,611,1,0,0,0,114,613,1,0,0,0,
  	116,615,1,0,0,0,118,617,1,0,0,0,120,633,1,0,0,0,122,635,1,0,0,0,124,644,
  	1,0,0,0,126,646,1,0,0,0,128,658,1,0,0,0,130,660,1,0,0,0,132,664,1,0,0,
  	0,134,668,1,0,0,0,136,680,1,0,0,0,138,697,1,0,0,0,140,702,1,0,0,0,142,
  	721,1,0,0,0,144,728,1,0,0,0,146,737,1,0,0,0,148,739,1,0,0,0,150,743,1,
  	0,0,0,152,746,1,0,0,0,154,761,1,0,0,0,156,763,1,0,0,0,158,771,1,0,0,0,
  	160,775,1,0,0,0,162,779,1,0,0,0,164,792,1,0,0,0,166,798,1,0,0,0,168,807,
  	1,0,0,0,170,171,3,4,2,0,171,172,5,1,0,0,172,174,1,0,0,0,173,170,1,0,0,
  	0,174,177,1,0,0,0,175,173,1,0,0,0,175,176,1,0,0,0,176,178,1,0,0,0,177,
  	175,1,0,0,0,178,179,5,0,0,1,179,1,1,0,0,0,180,181,3,46,23,0,181,182,5,
  	0,0,1,182,3,1,0,0,0,183,192,3,6,3,0,184,192,3,134,67,0,185,192,3,118,
  	59,0,186,192,3,140,70,0,187,192,3,146,73,0,188,192,3,8,4,0,189,192,3,
  	102,51,0,190,192,3,104,52,0,191,183,1,0,0,0,191,184,1,0,0,0,191,185,1,
  	0,0,0,191,186,1,0,0,0,191,187,1,0,0,0,191,188,1,0,0,0,191,189,1,0,0,0,
  	191,190,1,0,0,0,192,5,1,0,0,0,193,200,3,12,6,0,194,195,3,32,16,0,195,
  	196,3,20,10,0,196,201,1,0,0,0,197,199,3,20,10,0,198,197,1,0,0,0,198,199,
  	1,0,0,0,199,201,1,0,0,0,200,194,1,0,0,0,200,198,1,0,0,0,201,218,1,0,0,
  	0,202,207,3,14,7,0,203,204,3,32,16,0,204,205,3,20,10,0,205,208,1,0,0,
  	0,206,208,3,20,10,0,207,203,1,0,0,0,207,206,1,0,0,0,208,218,1,0,0,0,209,
  	210,3,32,16,0,210,211,3,12,6,0,211,212,3,20,10,0,212,218,1,0,0,0,213,
  	214,3,32,16,0,214,215,3,14,7,0,215,216,3,20,10,0,216,218,1,0,0,0,217,
  	193,1,0,0,0,217,202,1,0,0,0,217,209,1,0,0,0,217,213,1,0,0,0,218,7,1,0,
  	0,0,219,221,3,32,16,0,220,219,1,0,0,0,220,221,1,0,0,0,221,223,1,0,0,0,
  	222,224,3,10,5,0,223,222,1,0,0,0,223,224,1,0,0,0,224,225,1,0,0,0,225,
  	226,5,125,0,0,226,227,3,20,10,0,227,9,1,0,0,0,228,229,5,27,0,0,229,230,
  	5,125,0,0,230,11,1,0,0,0,231,232,3,34,17,0,232,234,5,125,0,0,233,235,
  	3,38,19,0,234,233,1,0,0,0,234,235,1,0,0,0,235,236,1,0,0,0,236,237,3,16,
  	8,0,237,13,1,0,0,0,238,239,3,34,17,0,239,240,3,16,8,0,240,15,1,0,0,0,
  	241,247,5,2,0,0,242,243,3,18,9,0,243,244,5,1,0,0,244,246,1,0,0,0,245,
  	242,1,0,0,0,246,249,1,0,0,0,247,245,1,0,0,0,247,248,1,0,0,0,248,250,1,
  	0,0,0,249,247,1,0,0,0,250,251,5,3,0,0,251,17,1,0,0,0,252,260,3,6,3,0,
  	253,260,3,134,67,0,254,260,3,140,70,0,255,260,3,146,73,0,256,260,3,8,
  	4,0,257,260,3,102,51,0,258,260,3,104,52,0,259,252,1,0,0,0,259,253,1,0,
  	0,0,259,254,1,0,0,0,259,255,1,0,0,0,259,256,1,0,0,0,259,257,1,0,0,0,259,
  	258,1,0,0,0,260,19,1,0,0,0,261,263,3,42,21,0,262,261,1,0,0,0,262,263,
  	1,0,0,0,263,264,1,0,0,0,264,269,3,22,11,0,265,266,5,4,0,0,266,268,3,22,
  	11,0,267,265,1,0,0,0,268,271,1,0,0,0,269,267,1,0,0,0,269,270,1,0,0,0,
  	270,21,1,0,0,0,271,269,1,0,0,0,272,279,5,125,0,0,273,275,3,62,31,0,274,
  	273,1,0,0,0,275,276,1,0,0,0,276,274,1,0,0,0,276,277,1,0,0,0,277,280,1,
  	0,0,0,278,280,3,60,30,0,279,274,1,0,0,0,279,278,1,0,0,0,279,280,1,0,0,
  	0,280,282,1,0,0,0,281,283,3,24,12,0,282,281,1,0,0,0,282,283,1,0,0,0,283,
  	285,1,0,0,0,284,286,3,26,13,0,285,284,1,0,0,0,285,286,1,0,0,0,286,288,
  	1,0,0,0,287,289,3,28,14,0,288,287,1,0,0,0,288,289,1,0,0,0,289,291,1,0,
  	0,0,290,292,3,30,15,0,291,290,1,0,0,0,291,292,1,0,0,0,292,23,1,0,0,0,
  	293,294,5,115,0,0,294,295,3,46,23,0,295,25,1,0,0,0,296,297,5,121,0,0,
  	297,298,3,46,23,0,298,27,1,0,0,0,299,300,5,122,0,0,300,301,3,46,23,0,
  	301,29,1,0,0,0,302,303,5,123,0,0,303,304,3,46,23,0,304,31,1,0,0,0,305,
  	306,7,0,0,0,306,33,1,0,0,0,307,310,3,36,18,0,308,310,5,35,0,0,309,307,
  	1,0,0,0,309,308,1,0,0,0,310,35,1,0,0,0,311,312,7,1,0,0,312,37,1,0,0,0,
  	313,314,5,5,0,0,314,315,5,6,0,0,315,320,3,40,20,0,316,317,5,4,0,0,317,
  	319,3,40,20,0,318,316,1,0,0,0,319,322,1,0,0,0,320,318,1,0,0,0,320,321,
  	1,0,0,0,321,323,1,0,0,0,322,320,1,0,0,0,323,324,5,7,0,0,324,39,1,0,0,
  	0,325,326,3,66,33,0,326,328,5,125,0,0,327,329,3,64,32,0,328,327,1,0,0,
  	0,328,329,1,0,0,0,329,332,1,0,0,0,330,331,5,115,0,0,331,333,3,46,23,0,
  	332,330,1,0,0,0,332,333,1,0,0,0,333,41,1,0,0,0,334,335,5,5,0,0,335,336,
  	5,6,0,0,336,341,3,44,22,0,337,338,5,4,0,0,338,340,3,44,22,0,339,337,1,
  	0,0,0,340,343,1,0,0,0,341,339,1,0,0,0,341,342,1,0,0,0,342,344,1,0,0,0,
  	343,341,1,0,0,0,344,345,5,7,0,0,345,43,1,0,0,0,346,347,5,8,0,0,347,348,
  	5,125,0,0,348,349,5,6,0,0,349,350,3,46,23,0,350,351,5,7,0,0,351,45,1,
  	0,0,0,352,353,6,23,-1,0,353,354,7,2,0,0,354,357,3,48,24,0,355,357,3,48,
  	24,0,356,352,1,0,0,0,356,355,1,0,0,0,357,399,1,0,0,0,358,359,10,13,0,
  	0,359,360,5,111,0,0,360,398,3,46,23,14,361,362,10,12,0,0,362,363,7,3,
  	0,0,363,398,3,46,23,13,364,365,10,11,0,0,365,366,7,4,0,0,366,398,3,46,
  	23,12,367,368,10,10,0,0,368,369,7,5,0,0,369,398,3,46,23,11,370,371,10,
  	9,0,0,371,372,7,6,0,0,372,398,3,46,23,10,373,374,10,8,0,0,374,375,7,7,
  	0,0,375,398,3,46,23,9,376,377,10,7,0,0,377,378,5,102,0,0,378,398,3,46,
  	23,8,379,380,10,6,0,0,380,381,7,8,0,0,381,398,3,46,23,7,382,383,10,5,
  	0,0,383,384,5,103,0,0,384,398,3,46,23,6,385,386,10,4,0,0,386,387,5,100,
  	0,0,387,398,3,46,23,5,388,389,10,3,0,0,389,390,5,104,0,0,390,398,3,46,
  	23,4,391,392,10,2,0,0,392,393,5,9,0,0,393,394,3,46,23,0,394,395,5,10,
  	0,0,395,396,3,46,23,2,396,398,1,0,0,0,397,358,1,0,0,0,397,361,1,0,0,0,
  	397,364,1,0,0,0,397,367,1,0,0,0,397,370,1,0,0,0,397,373,1,0,0,0,397,376,
  	1,0,0,0,397,379,1,0,0,0,397,382,1,0,0,0,397,385,1,0,0,0,397,388,1,0,0,
  	0,397,391,1,0,0,0,398,401,1,0,0,0,399,397,1,0,0,0,399,400,1,0,0,0,400,
  	47,1,0,0,0,401,399,1,0,0,0,402,412,3,70,35,0,403,412,3,50,25,0,404,412,
  	3,52,26,0,405,412,3,54,27,0,406,412,3,56,28,0,407,412,3,100,50,0,408,
  	412,3,96,48,0,409,412,3,80,40,0,410,412,3,78,39,0,411,402,1,0,0,0,411,
  	403,1,0,0,0,411,404,1,0,0,0,411,405,1,0,0,0,411,406,1,0,0,0,411,407,1,
  	0,0,0,411,408,1,0,0,0,411,409,1,0,0,0,411,410,1,0,0,0,412,49,1,0,0,0,
  	413,414,5,2,0,0,414,419,3,46,23,0,415,416,5,4,0,0,416,418,3,46,23,0,417,
  	415,1,0,0,0,418,421,1,0,0,0,419,417,1,0,0,0,419,420,1,0,0,0,420,422,1,
  	0,0,0,421,419,1,0,0,0,422,423,5,3,0,0,423,51,1,0,0,0,424,425,5,2,0,0,
  	425,426,3,46,23,0,426,427,3,50,25,0,427,428,5,3,0,0,428,53,1,0,0,0,429,
  	430,5,6,0,0,430,431,3,46,23,0,431,432,5,7,0,0,432,55,1,0,0,0,433,434,
  	7,9,0,0,434,435,5,11,0,0,435,436,5,6,0,0,436,437,3,46,23,0,437,438,5,
  	7,0,0,438,446,1,0,0,0,439,440,3,58,29,0,440,441,5,11,0,0,441,442,5,6,
  	0,0,442,443,3,46,23,0,443,444,5,7,0,0,444,446,1,0,0,0,445,433,1,0,0,0,
  	445,439,1,0,0,0,446,57,1,0,0,0,447,450,3,70,35,0,448,450,3,54,27,0,449,
  	447,1,0,0,0,449,448,1,0,0,0,450,59,1,0,0,0,451,452,5,12,0,0,452,453,3,
  	46,23,0,453,454,5,10,0,0,454,455,3,46,23,0,455,456,5,13,0,0,456,61,1,
  	0,0,0,457,458,5,12,0,0,458,459,3,46,23,0,459,460,5,13,0,0,460,63,1,0,
  	0,0,461,462,5,12,0,0,462,463,5,13,0,0,463,65,1,0,0,0,464,467,3,68,34,
  	0,465,467,7,10,0,0,466,464,1,0,0,0,466,465,1,0,0,0,467,67,1,0,0,0,468,
  	470,7,11,0,0,469,471,5,21,0,0,470,469,1,0,0,0,470,471,1,0,0,0,471,474,
  	1,0,0,0,472,474,7,12,0,0,473,468,1,0,0,0,473,472,1,0,0,0,474,69,1,0,0,
  	0,475,485,3,72,36,0,476,485,3,74,37,0,477,485,3,76,38,0,478,485,3,86,
  	43,0,479,485,3,88,44,0,480,485,3,90,45,0,481,485,3,92,46,0,482,485,3,
  	94,47,0,483,485,3,84,42,0,484,475,1,0,0,0,484,476,1,0,0,0,484,477,1,0,
  	0,0,484,478,1,0,0,0,484,479,1,0,0,0,484,480,1,0,0,0,484,481,1,0,0,0,484,
  	482,1,0,0,0,484,483,1,0,0,0,485,71,1,0,0,0,486,490,5,92,0,0,487,490,5,
  	93,0,0,488,490,5,94,0,0,489,486,1,0,0,0,489,487,1,0,0,0,489,488,1,0,0,
  	0,490,73,1,0,0,0,491,492,5,95,0,0,492,75,1,0,0,0,493,494,7,13,0,0,494,
  	77,1,0,0,0,495,496,5,11,0,0,496,497,5,2,0,0,497,511,5,3,0,0,498,499,5,
  	11,0,0,499,500,5,2,0,0,500,505,3,46,23,0,501,502,5,4,0,0,502,504,3,46,
  	23,0,503,501,1,0,0,0,504,507,1,0,0,0,505,503,1,0,0,0,505,506,1,0,0,0,
  	506,508,1,0,0,0,507,505,1,0,0,0,508,509,5,3,0,0,509,511,1,0,0,0,510,495,
  	1,0,0,0,510,498,1,0,0,0,511,79,1,0,0,0,512,513,5,125,0,0,513,514,5,11,
  	0,0,514,515,5,2,0,0,515,530,5,3,0,0,516,517,5,125,0,0,517,518,5,11,0,
  	0,518,519,5,2,0,0,519,524,3,82,41,0,520,521,5,4,0,0,521,523,3,82,41,0,
  	522,520,1,0,0,0,523,526,1,0,0,0,524,522,1,0,0,0,524,525,1,0,0,0,525,527,
  	1,0,0,0,526,524,1,0,0,0,527,528,5,3,0,0,528,530,1,0,0,0,529,512,1,0,0,
  	0,529,516,1,0,0,0,530,81,1,0,0,0,531,532,5,125,0,0,532,533,5,10,0,0,533,
  	534,3,46,23,0,534,83,1,0,0,0,535,536,5,125,0,0,536,537,5,14,0,0,537,538,
  	5,125,0,0,538,85,1,0,0,0,539,540,7,14,0,0,540,87,1,0,0,0,541,542,7,15,
  	0,0,542,89,1,0,0,0,543,544,7,16,0,0,544,91,1,0,0,0,545,546,7,17,0,0,546,
  	93,1,0,0,0,547,548,7,18,0,0,548,95,1,0,0,0,549,554,3,98,49,0,550,551,
  	5,8,0,0,551,553,3,98,49,0,552,550,1,0,0,0,553,556,1,0,0,0,554,552,1,0,
  	0,0,554,555,1,0,0,0,555,97,1,0,0,0,556,554,1,0,0,0,557,561,5,125,0,0,
  	558,560,3,62,31,0,559,558,1,0,0,0,560,563,1,0,0,0,561,559,1,0,0,0,561,
  	562,1,0,0,0,562,99,1,0,0,0,563,561,1,0,0,0,564,565,3,96,48,0,565,568,
  	5,15,0,0,566,569,3,114,57,0,567,569,5,125,0,0,568,566,1,0,0,0,568,567,
  	1,0,0,0,569,101,1,0,0,0,570,572,5,72,0,0,571,570,1,0,0,0,571,572,1,0,
  	0,0,572,573,1,0,0,0,573,583,3,106,53,0,574,576,5,72,0,0,575,574,1,0,0,
  	0,575,576,1,0,0,0,576,577,1,0,0,0,577,583,3,108,54,0,578,580,5,72,0,0,
  	579,578,1,0,0,0,579,580,1,0,0,0,580,581,1,0,0,0,581,583,3,110,55,0,582,
  	571,1,0,0,0,582,575,1,0,0,0,582,579,1,0,0,0,583,103,1,0,0,0,584,585,3,
  	96,48,0,585,586,5,15,0,0,586,587,3,106,53,0,587,593,1,0,0,0,588,589,3,
  	96,48,0,589,590,5,15,0,0,590,591,3,108,54,0,591,593,1,0,0,0,592,584,1,
  	0,0,0,592,588,1,0,0,0,593,105,1,0,0,0,594,597,3,114,57,0,595,597,5,125,
  	0,0,596,594,1,0,0,0,596,595,1,0,0,0,597,600,1,0,0,0,598,599,5,115,0,0,
  	599,601,3,112,56,0,600,598,1,0,0,0,600,601,1,0,0,0,601,107,1,0,0,0,602,
  	603,5,74,0,0,603,604,5,115,0,0,604,605,5,125,0,0,605,109,1,0,0,0,606,
  	607,3,116,58,0,607,608,5,125,0,0,608,111,1,0,0,0,609,612,3,94,47,0,610,
  	612,3,46,23,0,611,609,1,0,0,0,611,610,1,0,0,0,612,113,1,0,0,0,613,614,
  	7,19,0,0,614,115,1,0,0,0,615,616,7,20,0,0,616,117,1,0,0,0,617,618,5,77,
  	0,0,618,619,5,125,0,0,619,623,5,2,0,0,620,621,3,120,60,0,621,622,5,1,
  	0,0,622,624,1,0,0,0,623,620,1,0,0,0,624,625,1,0,0,0,625,623,1,0,0,0,625,
  	626,1,0,0,0,626,627,1,0,0,0,627,628,5,3,0,0,628,119,1,0,0,0,629,634,3,
  	122,61,0,630,634,3,126,63,0,631,634,3,130,65,0,632,634,3,132,66,0,633,
  	629,1,0,0,0,633,630,1,0,0,0,633,631,1,0,0,0,633,632,1,0,0,0,634,121,1,
  	0,0,0,635,636,5,81,0,0,636,637,5,115,0,0,637,639,3,124,62,0,638,640,3,
  	64,32,0,639,638,1,0,0,0,639,640,1,0,0,0,640,123,1,0,0,0,641,645,3,36,
  	18,0,642,645,7,21,0,0,643,645,3,68,34,0,644,641,1,0,0,0,644,642,1,0,0,
  	0,644,643,1,0,0,0,645,125,1,0,0,0,646,647,5,69,0,0,647,648,5,115,0,0,
  	648,653,3,128,64,0,649,650,5,103,0,0,650,652,3,128,64,0,651,649,1,0,0,
  	0,652,655,1,0,0,0,653,651,1,0,0,0,653,654,1,0,0,0,654,127,1,0,0,0,655,
  	653,1,0,0,0,656,659,3,34,17,0,657,659,7,22,0,0,658,656,1,0,0,0,658,657,
  	1,0,0,0,659,129,1,0,0,0,660,661,5,72,0,0,661,662,5,115,0,0,662,663,3,
  	46,23,0,663,131,1,0,0,0,664,665,5,71,0,0,665,666,5,115,0,0,666,667,5,
  	70,0,0,667,133,1,0,0,0,668,669,5,73,0,0,669,670,5,125,0,0,670,674,5,2,
  	0,0,671,672,3,136,68,0,672,673,5,1,0,0,673,675,1,0,0,0,674,671,1,0,0,
  	0,675,676,1,0,0,0,676,674,1,0,0,0,676,677,1,0,0,0,677,678,1,0,0,0,678,
  	679,5,3,0,0,679,135,1,0,0,0,680,683,5,125,0,0,681,682,5,115,0,0,682,684,
  	3,46,23,0,683,681,1,0,0,0,683,684,1,0,0,0,684,695,1,0,0,0,685,691,5,2,
  	0,0,686,687,3,138,69,0,687,688,5,1,0,0,688,690,1,0,0,0,689,686,1,0,0,
  	0,690,693,1,0,0,0,691,689,1,0,0,0,691,692,1,0,0,0,692,694,1,0,0,0,693,
  	691,1,0,0,0,694,696,5,3,0,0,695,685,1,0,0,0,695,696,1,0,0,0,696,137,1,
  	0,0,0,697,698,5,125,0,0,698,699,5,115,0,0,699,700,3,46,23,0,700,139,1,
  	0,0,0,701,703,5,67,0,0,702,701,1,0,0,0,702,703,1,0,0,0,703,704,1,0,0,
  	0,704,705,5,79,0,0,705,708,5,125,0,0,706,707,5,10,0,0,707,709,5,125,0,
  	0,708,706,1,0,0,0,708,709,1,0,0,0,709,710,1,0,0,0,710,716,5,2,0,0,711,
  	712,3,142,71,0,712,713,5,1,0,0,713,715,1,0,0,0,714,711,1,0,0,0,715,718,
  	1,0,0,0,716,714,1,0,0,0,716,717,1,0,0,0,717,719,1,0,0,0,718,716,1,0,0,
  	0,719,720,5,3,0,0,720,141,1,0,0,0,721,722,3,144,72,0,722,724,5,125,0,
  	0,723,725,3,64,32,0,724,723,1,0,0,0,724,725,1,0,0,0,725,143,1,0,0,0,726,
  	729,3,66,33,0,727,729,3,34,17,0,728,726,1,0,0,0,728,727,1,0,0,0,729,145,
  	1,0,0,0,730,732,3,148,74,0,731,733,3,156,78,0,732,731,1,0,0,0,732,733,
  	1,0,0,0,733,738,1,0,0,0,734,735,3,150,75,0,735,736,3,156,78,0,736,738,
  	1,0,0,0,737,730,1,0,0,0,737,734,1,0,0,0,738,147,1,0,0,0,739,740,5,71,
  	0,0,740,741,5,125,0,0,741,742,3,152,76,0,742,149,1,0,0,0,743,744,5,71,
  	0,0,744,745,3,152,76,0,745,151,1,0,0,0,746,752,5,2,0,0,747,748,3,154,
  	77,0,748,749,5,1,0,0,749,751,1,0,0,0,750,747,1,0,0,0,751,754,1,0,0,0,
  	752,750,1,0,0,0,752,753,1,0,0,0,753,755,1,0,0,0,754,752,1,0,0,0,755,756,
  	5,3,0,0,756,153,1,0,0,0,757,762,3,158,79,0,758,762,3,160,80,0,759,762,
  	3,162,81,0,760,762,3,164,82,0,761,757,1,0,0,0,761,758,1,0,0,0,761,759,
  	1,0,0,0,761,760,1,0,0,0,762,155,1,0,0,0,763,768,5,125,0,0,764,765,5,4,
  	0,0,765,767,5,125,0,0,766,764,1,0,0,0,767,770,1,0,0,0,768,766,1,0,0,0,
  	768,769,1,0,0,0,769,157,1,0,0,0,770,768,1,0,0,0,771,772,3,46,23,0,772,
  	773,7,23,0,0,773,774,3,46,23,0,774,159,1,0,0,0,775,776,5,125,0,0,776,
  	777,5,115,0,0,777,778,3,46,23,0,778,161,1,0,0,0,779,780,3,166,83,0,780,
  	781,5,75,0,0,781,782,5,2,0,0,782,787,3,168,84,0,783,784,5,4,0,0,784,786,
  	3,168,84,0,785,783,1,0,0,0,786,789,1,0,0,0,787,785,1,0,0,0,787,788,1,
  	0,0,0,788,790,1,0,0,0,789,787,1,0,0,0,790,791,5,3,0,0,791,163,1,0,0,0,
  	792,793,3,166,83,0,793,794,5,75,0,0,794,795,5,125,0,0,795,165,1,0,0,0,
  	796,799,5,80,0,0,797,799,3,96,48,0,798,796,1,0,0,0,798,797,1,0,0,0,799,
  	167,1,0,0,0,800,808,3,46,23,0,801,802,5,12,0,0,802,803,3,46,23,0,803,
  	804,5,10,0,0,804,805,3,46,23,0,805,806,5,13,0,0,806,808,1,0,0,0,807,800,
  	1,0,0,0,807,801,1,0,0,0,808,169,1,0,0,0,74,175,191,198,200,207,217,220,
  	223,234,247,259,262,269,276,279,282,285,288,291,309,320,328,332,341,356,
  	397,399,411,419,445,449,466,470,473,484,489,505,510,524,529,554,561,568,
  	571,575,579,582,592,596,600,611,625,633,639,644,653,658,676,683,691,695,
  	702,708,716,724,728,732,737,752,761,768,787,798,807
  };
  staticData->serializedATN = antlr4::atn::SerializedATNView(serializedATNSegment, sizeof(serializedATNSegment) / sizeof(serializedATNSegment[0]));

  antlr4::atn::ATNDeserializer deserializer;
  staticData->atn = deserializer.deserialize(staticData->serializedATN);

  const size_t count = staticData->atn->getNumberOfDecisions();
  staticData->decisionToDFA.reserve(count);
  for (size_t i = 0; i < count; i++) { 
    staticData->decisionToDFA.emplace_back(staticData->atn->getDecisionState(i), i);
  }
  systemrdlParserStaticData = std::move(staticData);
}

}

SystemRDLParser::SystemRDLParser(TokenStream *input) : SystemRDLParser(input, antlr4::atn::ParserATNSimulatorOptions()) {}

SystemRDLParser::SystemRDLParser(TokenStream *input, const antlr4::atn::ParserATNSimulatorOptions &options) : Parser(input) {
  SystemRDLParser::initialize();
  _interpreter = new atn::ParserATNSimulator(this, *systemrdlParserStaticData->atn, systemrdlParserStaticData->decisionToDFA, systemrdlParserStaticData->sharedContextCache, options);
}

SystemRDLParser::~SystemRDLParser() {
  delete _interpreter;
}

const atn::ATN& SystemRDLParser::getATN() const {
  return *systemrdlParserStaticData->atn;
}

std::string SystemRDLParser::getGrammarFileName() const {
  return "SystemRDL.g4";
}

const std::vector<std::string>& SystemRDLParser::getRuleNames() const {
  return systemrdlParserStaticData->ruleNames;
}

const dfa::Vocabulary& SystemRDLParser::getVocabulary() const {
  return systemrdlParserStaticData->vocabulary;
}

antlr4::atn::SerializedATNView SystemRDLParser::getSerializedATN() const {
  return systemrdlParserStaticData->serializedATN;
}


//----------------- RootContext ------------------------------------------------------------------

SystemRDLParser::RootContext::RootContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::RootContext::EOF() {
  return getToken(SystemRDLParser::EOF, 0);
}

std::vector<SystemRDLParser::Root_elemContext *> SystemRDLParser::RootContext::root_elem() {
  return getRuleContexts<SystemRDLParser::Root_elemContext>();
}

SystemRDLParser::Root_elemContext* SystemRDLParser::RootContext::root_elem(size_t i) {
  return getRuleContext<SystemRDLParser::Root_elemContext>(i);
}


size_t SystemRDLParser::RootContext::getRuleIndex() const {
  return SystemRDLParser::RuleRoot;
}


std::any SystemRDLParser::RootContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitRoot(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::RootContext* SystemRDLParser::root() {
  RootContext *_localctx = _tracker.createInstance<RootContext>(_ctx, getState());
  enterRule(_localctx, 0, SystemRDLParser::RuleRoot);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(175);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while ((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & -1151971457975189504) != 0) || ((((_la - 64) & ~ 0x3fULL) == 0) &&
      ((1ULL << (_la - 64)) & 2305843009213736847) != 0)) {
      setState(170);
      root_elem();
      setState(171);
      match(SystemRDLParser::T__0);
      setState(177);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(178);
    match(SystemRDLParser::EOF);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Eval_expr_rootContext ------------------------------------------------------------------

SystemRDLParser::Eval_expr_rootContext::Eval_expr_rootContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::ExprContext* SystemRDLParser::Eval_expr_rootContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

tree::TerminalNode* SystemRDLParser::Eval_expr_rootContext::EOF() {
  return getToken(SystemRDLParser::EOF, 0);
}


size_t SystemRDLParser::Eval_expr_rootContext::getRuleIndex() const {
  return SystemRDLParser::RuleEval_expr_root;
}


std::any SystemRDLParser::Eval_expr_rootContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitEval_expr_root(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Eval_expr_rootContext* SystemRDLParser::eval_expr_root() {
  Eval_expr_rootContext *_localctx = _tracker.createInstance<Eval_expr_rootContext>(_ctx, getState());
  enterRule(_localctx, 2, SystemRDLParser::RuleEval_expr_root);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(180);
    expr(0);
    setState(181);
    match(SystemRDLParser::EOF);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Root_elemContext ------------------------------------------------------------------

SystemRDLParser::Root_elemContext::Root_elemContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Component_defContext* SystemRDLParser::Root_elemContext::component_def() {
  return getRuleContext<SystemRDLParser::Component_defContext>(0);
}

SystemRDLParser::Enum_defContext* SystemRDLParser::Root_elemContext::enum_def() {
  return getRuleContext<SystemRDLParser::Enum_defContext>(0);
}

SystemRDLParser::Udp_defContext* SystemRDLParser::Root_elemContext::udp_def() {
  return getRuleContext<SystemRDLParser::Udp_defContext>(0);
}

SystemRDLParser::Struct_defContext* SystemRDLParser::Root_elemContext::struct_def() {
  return getRuleContext<SystemRDLParser::Struct_defContext>(0);
}

SystemRDLParser::Constraint_defContext* SystemRDLParser::Root_elemContext::constraint_def() {
  return getRuleContext<SystemRDLParser::Constraint_defContext>(0);
}

SystemRDLParser::Explicit_component_instContext* SystemRDLParser::Root_elemContext::explicit_component_inst() {
  return getRuleContext<SystemRDLParser::Explicit_component_instContext>(0);
}

SystemRDLParser::Local_property_assignmentContext* SystemRDLParser::Root_elemContext::local_property_assignment() {
  return getRuleContext<SystemRDLParser::Local_property_assignmentContext>(0);
}

SystemRDLParser::Dynamic_property_assignmentContext* SystemRDLParser::Root_elemContext::dynamic_property_assignment() {
  return getRuleContext<SystemRDLParser::Dynamic_property_assignmentContext>(0);
}


size_t SystemRDLParser::Root_elemContext::getRuleIndex() const {
  return SystemRDLParser::RuleRoot_elem;
}


std::any SystemRDLParser::Root_elemContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitRoot_elem(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Root_elemContext* SystemRDLParser::root_elem() {
  Root_elemContext *_localctx = _tracker.createInstance<Root_elemContext>(_ctx, getState());
  enterRule(_localctx, 4, SystemRDLParser::RuleRoot_elem);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(191);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 1, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(183);
      component_def();
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(184);
      enum_def();
      break;
    }

    case 3: {
      enterOuterAlt(_localctx, 3);
      setState(185);
      udp_def();
      break;
    }

    case 4: {
      enterOuterAlt(_localctx, 4);
      setState(186);
      struct_def();
      break;
    }

    case 5: {
      enterOuterAlt(_localctx, 5);
      setState(187);
      constraint_def();
      break;
    }

    case 6: {
      enterOuterAlt(_localctx, 6);
      setState(188);
      explicit_component_inst();
      break;
    }

    case 7: {
      enterOuterAlt(_localctx, 7);
      setState(189);
      local_property_assignment();
      break;
    }

    case 8: {
      enterOuterAlt(_localctx, 8);
      setState(190);
      dynamic_property_assignment();
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_defContext ------------------------------------------------------------------

SystemRDLParser::Component_defContext::Component_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Component_named_defContext* SystemRDLParser::Component_defContext::component_named_def() {
  return getRuleContext<SystemRDLParser::Component_named_defContext>(0);
}

SystemRDLParser::Component_inst_typeContext* SystemRDLParser::Component_defContext::component_inst_type() {
  return getRuleContext<SystemRDLParser::Component_inst_typeContext>(0);
}

SystemRDLParser::Component_instsContext* SystemRDLParser::Component_defContext::component_insts() {
  return getRuleContext<SystemRDLParser::Component_instsContext>(0);
}

SystemRDLParser::Component_anon_defContext* SystemRDLParser::Component_defContext::component_anon_def() {
  return getRuleContext<SystemRDLParser::Component_anon_defContext>(0);
}


size_t SystemRDLParser::Component_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_def;
}


std::any SystemRDLParser::Component_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_defContext* SystemRDLParser::component_def() {
  Component_defContext *_localctx = _tracker.createInstance<Component_defContext>(_ctx, getState());
  enterRule(_localctx, 6, SystemRDLParser::RuleComponent_def);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(217);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 5, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(193);
      component_named_def();
      setState(200);
      _errHandler->sync(this);
      switch (_input->LA(1)) {
        case SystemRDLParser::EXTERNAL_kw:
        case SystemRDLParser::INTERNAL_kw: {
          setState(194);
          component_inst_type();
          setState(195);
          component_insts();
          break;
        }

        case SystemRDLParser::T__0:
        case SystemRDLParser::T__4:
        case SystemRDLParser::ID: {
          setState(198);
          _errHandler->sync(this);

          _la = _input->LA(1);
          if (_la == SystemRDLParser::T__4 || _la == SystemRDLParser::ID) {
            setState(197);
            component_insts();
          }
          break;
        }

      default:
        throw NoViableAltException(this);
      }
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(202);
      component_anon_def();
      setState(207);
      _errHandler->sync(this);
      switch (_input->LA(1)) {
        case SystemRDLParser::EXTERNAL_kw:
        case SystemRDLParser::INTERNAL_kw: {
          setState(203);
          component_inst_type();
          setState(204);
          component_insts();
          break;
        }

        case SystemRDLParser::T__4:
        case SystemRDLParser::ID: {
          setState(206);
          component_insts();
          break;
        }

      default:
        throw NoViableAltException(this);
      }
      break;
    }

    case 3: {
      enterOuterAlt(_localctx, 3);
      setState(209);
      component_inst_type();
      setState(210);
      component_named_def();
      setState(211);
      component_insts();
      break;
    }

    case 4: {
      enterOuterAlt(_localctx, 4);
      setState(213);
      component_inst_type();
      setState(214);
      component_anon_def();
      setState(215);
      component_insts();
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Explicit_component_instContext ------------------------------------------------------------------

SystemRDLParser::Explicit_component_instContext::Explicit_component_instContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Explicit_component_instContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

SystemRDLParser::Component_instsContext* SystemRDLParser::Explicit_component_instContext::component_insts() {
  return getRuleContext<SystemRDLParser::Component_instsContext>(0);
}

SystemRDLParser::Component_inst_typeContext* SystemRDLParser::Explicit_component_instContext::component_inst_type() {
  return getRuleContext<SystemRDLParser::Component_inst_typeContext>(0);
}

SystemRDLParser::Component_inst_aliasContext* SystemRDLParser::Explicit_component_instContext::component_inst_alias() {
  return getRuleContext<SystemRDLParser::Component_inst_aliasContext>(0);
}


size_t SystemRDLParser::Explicit_component_instContext::getRuleIndex() const {
  return SystemRDLParser::RuleExplicit_component_inst;
}


std::any SystemRDLParser::Explicit_component_instContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitExplicit_component_inst(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Explicit_component_instContext* SystemRDLParser::explicit_component_inst() {
  Explicit_component_instContext *_localctx = _tracker.createInstance<Explicit_component_instContext>(_ctx, getState());
  enterRule(_localctx, 8, SystemRDLParser::RuleExplicit_component_inst);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(220);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::EXTERNAL_kw

    || _la == SystemRDLParser::INTERNAL_kw) {
      setState(219);
      component_inst_type();
    }
    setState(223);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::ALIAS_kw) {
      setState(222);
      component_inst_alias();
    }
    setState(225);
    match(SystemRDLParser::ID);
    setState(226);
    component_insts();
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_inst_aliasContext ------------------------------------------------------------------

SystemRDLParser::Component_inst_aliasContext::Component_inst_aliasContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Component_inst_aliasContext::ALIAS_kw() {
  return getToken(SystemRDLParser::ALIAS_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Component_inst_aliasContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}


size_t SystemRDLParser::Component_inst_aliasContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_inst_alias;
}


std::any SystemRDLParser::Component_inst_aliasContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_inst_alias(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_inst_aliasContext* SystemRDLParser::component_inst_alias() {
  Component_inst_aliasContext *_localctx = _tracker.createInstance<Component_inst_aliasContext>(_ctx, getState());
  enterRule(_localctx, 10, SystemRDLParser::RuleComponent_inst_alias);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(228);
    match(SystemRDLParser::ALIAS_kw);
    setState(229);
    match(SystemRDLParser::ID);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_named_defContext ------------------------------------------------------------------

SystemRDLParser::Component_named_defContext::Component_named_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Component_typeContext* SystemRDLParser::Component_named_defContext::component_type() {
  return getRuleContext<SystemRDLParser::Component_typeContext>(0);
}

tree::TerminalNode* SystemRDLParser::Component_named_defContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

SystemRDLParser::Component_bodyContext* SystemRDLParser::Component_named_defContext::component_body() {
  return getRuleContext<SystemRDLParser::Component_bodyContext>(0);
}

SystemRDLParser::Param_defContext* SystemRDLParser::Component_named_defContext::param_def() {
  return getRuleContext<SystemRDLParser::Param_defContext>(0);
}


size_t SystemRDLParser::Component_named_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_named_def;
}


std::any SystemRDLParser::Component_named_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_named_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_named_defContext* SystemRDLParser::component_named_def() {
  Component_named_defContext *_localctx = _tracker.createInstance<Component_named_defContext>(_ctx, getState());
  enterRule(_localctx, 12, SystemRDLParser::RuleComponent_named_def);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(231);
    component_type();
    setState(232);
    match(SystemRDLParser::ID);
    setState(234);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::T__4) {
      setState(233);
      param_def();
    }
    setState(236);
    component_body();
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_anon_defContext ------------------------------------------------------------------

SystemRDLParser::Component_anon_defContext::Component_anon_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Component_typeContext* SystemRDLParser::Component_anon_defContext::component_type() {
  return getRuleContext<SystemRDLParser::Component_typeContext>(0);
}

SystemRDLParser::Component_bodyContext* SystemRDLParser::Component_anon_defContext::component_body() {
  return getRuleContext<SystemRDLParser::Component_bodyContext>(0);
}


size_t SystemRDLParser::Component_anon_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_anon_def;
}


std::any SystemRDLParser::Component_anon_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_anon_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_anon_defContext* SystemRDLParser::component_anon_def() {
  Component_anon_defContext *_localctx = _tracker.createInstance<Component_anon_defContext>(_ctx, getState());
  enterRule(_localctx, 14, SystemRDLParser::RuleComponent_anon_def);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(238);
    component_type();
    setState(239);
    component_body();
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_bodyContext ------------------------------------------------------------------

SystemRDLParser::Component_bodyContext::Component_bodyContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::Component_body_elemContext *> SystemRDLParser::Component_bodyContext::component_body_elem() {
  return getRuleContexts<SystemRDLParser::Component_body_elemContext>();
}

SystemRDLParser::Component_body_elemContext* SystemRDLParser::Component_bodyContext::component_body_elem(size_t i) {
  return getRuleContext<SystemRDLParser::Component_body_elemContext>(i);
}


size_t SystemRDLParser::Component_bodyContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_body;
}


std::any SystemRDLParser::Component_bodyContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_body(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_bodyContext* SystemRDLParser::component_body() {
  Component_bodyContext *_localctx = _tracker.createInstance<Component_bodyContext>(_ctx, getState());
  enterRule(_localctx, 16, SystemRDLParser::RuleComponent_body);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(241);
    match(SystemRDLParser::T__1);
    setState(247);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while ((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & -1151971457975189504) != 0) || ((((_la - 64) & ~ 0x3fULL) == 0) &&
      ((1ULL << (_la - 64)) & 2305843009213728655) != 0)) {
      setState(242);
      component_body_elem();
      setState(243);
      match(SystemRDLParser::T__0);
      setState(249);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(250);
    match(SystemRDLParser::T__2);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_body_elemContext ------------------------------------------------------------------

SystemRDLParser::Component_body_elemContext::Component_body_elemContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Component_defContext* SystemRDLParser::Component_body_elemContext::component_def() {
  return getRuleContext<SystemRDLParser::Component_defContext>(0);
}

SystemRDLParser::Enum_defContext* SystemRDLParser::Component_body_elemContext::enum_def() {
  return getRuleContext<SystemRDLParser::Enum_defContext>(0);
}

SystemRDLParser::Struct_defContext* SystemRDLParser::Component_body_elemContext::struct_def() {
  return getRuleContext<SystemRDLParser::Struct_defContext>(0);
}

SystemRDLParser::Constraint_defContext* SystemRDLParser::Component_body_elemContext::constraint_def() {
  return getRuleContext<SystemRDLParser::Constraint_defContext>(0);
}

SystemRDLParser::Explicit_component_instContext* SystemRDLParser::Component_body_elemContext::explicit_component_inst() {
  return getRuleContext<SystemRDLParser::Explicit_component_instContext>(0);
}

SystemRDLParser::Local_property_assignmentContext* SystemRDLParser::Component_body_elemContext::local_property_assignment() {
  return getRuleContext<SystemRDLParser::Local_property_assignmentContext>(0);
}

SystemRDLParser::Dynamic_property_assignmentContext* SystemRDLParser::Component_body_elemContext::dynamic_property_assignment() {
  return getRuleContext<SystemRDLParser::Dynamic_property_assignmentContext>(0);
}


size_t SystemRDLParser::Component_body_elemContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_body_elem;
}


std::any SystemRDLParser::Component_body_elemContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_body_elem(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_body_elemContext* SystemRDLParser::component_body_elem() {
  Component_body_elemContext *_localctx = _tracker.createInstance<Component_body_elemContext>(_ctx, getState());
  enterRule(_localctx, 18, SystemRDLParser::RuleComponent_body_elem);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(259);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 10, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(252);
      component_def();
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(253);
      enum_def();
      break;
    }

    case 3: {
      enterOuterAlt(_localctx, 3);
      setState(254);
      struct_def();
      break;
    }

    case 4: {
      enterOuterAlt(_localctx, 4);
      setState(255);
      constraint_def();
      break;
    }

    case 5: {
      enterOuterAlt(_localctx, 5);
      setState(256);
      explicit_component_inst();
      break;
    }

    case 6: {
      enterOuterAlt(_localctx, 6);
      setState(257);
      local_property_assignment();
      break;
    }

    case 7: {
      enterOuterAlt(_localctx, 7);
      setState(258);
      dynamic_property_assignment();
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_instsContext ------------------------------------------------------------------

SystemRDLParser::Component_instsContext::Component_instsContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::Component_instContext *> SystemRDLParser::Component_instsContext::component_inst() {
  return getRuleContexts<SystemRDLParser::Component_instContext>();
}

SystemRDLParser::Component_instContext* SystemRDLParser::Component_instsContext::component_inst(size_t i) {
  return getRuleContext<SystemRDLParser::Component_instContext>(i);
}

SystemRDLParser::Param_instContext* SystemRDLParser::Component_instsContext::param_inst() {
  return getRuleContext<SystemRDLParser::Param_instContext>(0);
}


size_t SystemRDLParser::Component_instsContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_insts;
}


std::any SystemRDLParser::Component_instsContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_insts(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_instsContext* SystemRDLParser::component_insts() {
  Component_instsContext *_localctx = _tracker.createInstance<Component_instsContext>(_ctx, getState());
  enterRule(_localctx, 20, SystemRDLParser::RuleComponent_insts);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(262);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::T__4) {
      setState(261);
      param_inst();
    }
    setState(264);
    component_inst();
    setState(269);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SystemRDLParser::T__3) {
      setState(265);
      match(SystemRDLParser::T__3);
      setState(266);
      component_inst();
      setState(271);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_instContext ------------------------------------------------------------------

SystemRDLParser::Component_instContext::Component_instContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Component_instContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

SystemRDLParser::Range_suffixContext* SystemRDLParser::Component_instContext::range_suffix() {
  return getRuleContext<SystemRDLParser::Range_suffixContext>(0);
}

SystemRDLParser::Field_inst_resetContext* SystemRDLParser::Component_instContext::field_inst_reset() {
  return getRuleContext<SystemRDLParser::Field_inst_resetContext>(0);
}

SystemRDLParser::Inst_addr_fixedContext* SystemRDLParser::Component_instContext::inst_addr_fixed() {
  return getRuleContext<SystemRDLParser::Inst_addr_fixedContext>(0);
}

SystemRDLParser::Inst_addr_strideContext* SystemRDLParser::Component_instContext::inst_addr_stride() {
  return getRuleContext<SystemRDLParser::Inst_addr_strideContext>(0);
}

SystemRDLParser::Inst_addr_alignContext* SystemRDLParser::Component_instContext::inst_addr_align() {
  return getRuleContext<SystemRDLParser::Inst_addr_alignContext>(0);
}

std::vector<SystemRDLParser::Array_suffixContext *> SystemRDLParser::Component_instContext::array_suffix() {
  return getRuleContexts<SystemRDLParser::Array_suffixContext>();
}

SystemRDLParser::Array_suffixContext* SystemRDLParser::Component_instContext::array_suffix(size_t i) {
  return getRuleContext<SystemRDLParser::Array_suffixContext>(i);
}


size_t SystemRDLParser::Component_instContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_inst;
}


std::any SystemRDLParser::Component_instContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_inst(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_instContext* SystemRDLParser::component_inst() {
  Component_instContext *_localctx = _tracker.createInstance<Component_instContext>(_ctx, getState());
  enterRule(_localctx, 22, SystemRDLParser::RuleComponent_inst);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(272);
    match(SystemRDLParser::ID);
    setState(279);
    _errHandler->sync(this);

    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 14, _ctx)) {
    case 1: {
      setState(274); 
      _errHandler->sync(this);
      _la = _input->LA(1);
      do {
        setState(273);
        array_suffix();
        setState(276); 
        _errHandler->sync(this);
        _la = _input->LA(1);
      } while (_la == SystemRDLParser::T__11);
      break;
    }

    case 2: {
      setState(278);
      range_suffix();
      break;
    }

    default:
      break;
    }
    setState(282);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::ASSIGN) {
      setState(281);
      field_inst_reset();
    }
    setState(285);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::AT) {
      setState(284);
      inst_addr_fixed();
    }
    setState(288);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::INC) {
      setState(287);
      inst_addr_stride();
    }
    setState(291);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::ALIGN) {
      setState(290);
      inst_addr_align();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Field_inst_resetContext ------------------------------------------------------------------

SystemRDLParser::Field_inst_resetContext::Field_inst_resetContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::ExprContext* SystemRDLParser::Field_inst_resetContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

tree::TerminalNode* SystemRDLParser::Field_inst_resetContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}


size_t SystemRDLParser::Field_inst_resetContext::getRuleIndex() const {
  return SystemRDLParser::RuleField_inst_reset;
}


std::any SystemRDLParser::Field_inst_resetContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitField_inst_reset(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Field_inst_resetContext* SystemRDLParser::field_inst_reset() {
  Field_inst_resetContext *_localctx = _tracker.createInstance<Field_inst_resetContext>(_ctx, getState());
  enterRule(_localctx, 24, SystemRDLParser::RuleField_inst_reset);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(293);
    antlrcpp::downCast<Field_inst_resetContext *>(_localctx)->op = match(SystemRDLParser::ASSIGN);
    setState(294);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Inst_addr_fixedContext ------------------------------------------------------------------

SystemRDLParser::Inst_addr_fixedContext::Inst_addr_fixedContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::ExprContext* SystemRDLParser::Inst_addr_fixedContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

tree::TerminalNode* SystemRDLParser::Inst_addr_fixedContext::AT() {
  return getToken(SystemRDLParser::AT, 0);
}


size_t SystemRDLParser::Inst_addr_fixedContext::getRuleIndex() const {
  return SystemRDLParser::RuleInst_addr_fixed;
}


std::any SystemRDLParser::Inst_addr_fixedContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitInst_addr_fixed(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Inst_addr_fixedContext* SystemRDLParser::inst_addr_fixed() {
  Inst_addr_fixedContext *_localctx = _tracker.createInstance<Inst_addr_fixedContext>(_ctx, getState());
  enterRule(_localctx, 26, SystemRDLParser::RuleInst_addr_fixed);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(296);
    antlrcpp::downCast<Inst_addr_fixedContext *>(_localctx)->op = match(SystemRDLParser::AT);
    setState(297);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Inst_addr_strideContext ------------------------------------------------------------------

SystemRDLParser::Inst_addr_strideContext::Inst_addr_strideContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::ExprContext* SystemRDLParser::Inst_addr_strideContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

tree::TerminalNode* SystemRDLParser::Inst_addr_strideContext::INC() {
  return getToken(SystemRDLParser::INC, 0);
}


size_t SystemRDLParser::Inst_addr_strideContext::getRuleIndex() const {
  return SystemRDLParser::RuleInst_addr_stride;
}


std::any SystemRDLParser::Inst_addr_strideContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitInst_addr_stride(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Inst_addr_strideContext* SystemRDLParser::inst_addr_stride() {
  Inst_addr_strideContext *_localctx = _tracker.createInstance<Inst_addr_strideContext>(_ctx, getState());
  enterRule(_localctx, 28, SystemRDLParser::RuleInst_addr_stride);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(299);
    antlrcpp::downCast<Inst_addr_strideContext *>(_localctx)->op = match(SystemRDLParser::INC);
    setState(300);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Inst_addr_alignContext ------------------------------------------------------------------

SystemRDLParser::Inst_addr_alignContext::Inst_addr_alignContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::ExprContext* SystemRDLParser::Inst_addr_alignContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

tree::TerminalNode* SystemRDLParser::Inst_addr_alignContext::ALIGN() {
  return getToken(SystemRDLParser::ALIGN, 0);
}


size_t SystemRDLParser::Inst_addr_alignContext::getRuleIndex() const {
  return SystemRDLParser::RuleInst_addr_align;
}


std::any SystemRDLParser::Inst_addr_alignContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitInst_addr_align(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Inst_addr_alignContext* SystemRDLParser::inst_addr_align() {
  Inst_addr_alignContext *_localctx = _tracker.createInstance<Inst_addr_alignContext>(_ctx, getState());
  enterRule(_localctx, 30, SystemRDLParser::RuleInst_addr_align);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(302);
    antlrcpp::downCast<Inst_addr_alignContext *>(_localctx)->op = match(SystemRDLParser::ALIGN);
    setState(303);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_inst_typeContext ------------------------------------------------------------------

SystemRDLParser::Component_inst_typeContext::Component_inst_typeContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Component_inst_typeContext::EXTERNAL_kw() {
  return getToken(SystemRDLParser::EXTERNAL_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Component_inst_typeContext::INTERNAL_kw() {
  return getToken(SystemRDLParser::INTERNAL_kw, 0);
}


size_t SystemRDLParser::Component_inst_typeContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_inst_type;
}


std::any SystemRDLParser::Component_inst_typeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_inst_type(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_inst_typeContext* SystemRDLParser::component_inst_type() {
  Component_inst_typeContext *_localctx = _tracker.createInstance<Component_inst_typeContext>(_ctx, getState());
  enterRule(_localctx, 32, SystemRDLParser::RuleComponent_inst_type);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(305);
    antlrcpp::downCast<Component_inst_typeContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!(_la == SystemRDLParser::EXTERNAL_kw

    || _la == SystemRDLParser::INTERNAL_kw)) {
      antlrcpp::downCast<Component_inst_typeContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_typeContext ------------------------------------------------------------------

SystemRDLParser::Component_typeContext::Component_typeContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Component_type_primaryContext* SystemRDLParser::Component_typeContext::component_type_primary() {
  return getRuleContext<SystemRDLParser::Component_type_primaryContext>(0);
}

tree::TerminalNode* SystemRDLParser::Component_typeContext::SIGNAL_kw() {
  return getToken(SystemRDLParser::SIGNAL_kw, 0);
}


size_t SystemRDLParser::Component_typeContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_type;
}


std::any SystemRDLParser::Component_typeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_type(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_typeContext* SystemRDLParser::component_type() {
  Component_typeContext *_localctx = _tracker.createInstance<Component_typeContext>(_ctx, getState());
  enterRule(_localctx, 34, SystemRDLParser::RuleComponent_type);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(309);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::ADDRMAP_kw:
      case SystemRDLParser::REGFILE_kw:
      case SystemRDLParser::REG_kw:
      case SystemRDLParser::FIELD_kw:
      case SystemRDLParser::MEM_kw: {
        enterOuterAlt(_localctx, 1);
        setState(307);
        component_type_primary();
        break;
      }

      case SystemRDLParser::SIGNAL_kw: {
        enterOuterAlt(_localctx, 2);
        setState(308);
        antlrcpp::downCast<Component_typeContext *>(_localctx)->kw = match(SystemRDLParser::SIGNAL_kw);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Component_type_primaryContext ------------------------------------------------------------------

SystemRDLParser::Component_type_primaryContext::Component_type_primaryContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Component_type_primaryContext::ADDRMAP_kw() {
  return getToken(SystemRDLParser::ADDRMAP_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Component_type_primaryContext::REGFILE_kw() {
  return getToken(SystemRDLParser::REGFILE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Component_type_primaryContext::REG_kw() {
  return getToken(SystemRDLParser::REG_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Component_type_primaryContext::FIELD_kw() {
  return getToken(SystemRDLParser::FIELD_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Component_type_primaryContext::MEM_kw() {
  return getToken(SystemRDLParser::MEM_kw, 0);
}


size_t SystemRDLParser::Component_type_primaryContext::getRuleIndex() const {
  return SystemRDLParser::RuleComponent_type_primary;
}


std::any SystemRDLParser::Component_type_primaryContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitComponent_type_primary(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Component_type_primaryContext* SystemRDLParser::component_type_primary() {
  Component_type_primaryContext *_localctx = _tracker.createInstance<Component_type_primaryContext>(_ctx, getState());
  enterRule(_localctx, 36, SystemRDLParser::RuleComponent_type_primary);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(311);
    antlrcpp::downCast<Component_type_primaryContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & 33285996544) != 0))) {
      antlrcpp::downCast<Component_type_primaryContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Param_defContext ------------------------------------------------------------------

SystemRDLParser::Param_defContext::Param_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::Param_def_elemContext *> SystemRDLParser::Param_defContext::param_def_elem() {
  return getRuleContexts<SystemRDLParser::Param_def_elemContext>();
}

SystemRDLParser::Param_def_elemContext* SystemRDLParser::Param_defContext::param_def_elem(size_t i) {
  return getRuleContext<SystemRDLParser::Param_def_elemContext>(i);
}


size_t SystemRDLParser::Param_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleParam_def;
}


std::any SystemRDLParser::Param_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitParam_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Param_defContext* SystemRDLParser::param_def() {
  Param_defContext *_localctx = _tracker.createInstance<Param_defContext>(_ctx, getState());
  enterRule(_localctx, 38, SystemRDLParser::RuleParam_def);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(313);
    match(SystemRDLParser::T__4);
    setState(314);
    match(SystemRDLParser::T__5);
    setState(315);
    param_def_elem();
    setState(320);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SystemRDLParser::T__3) {
      setState(316);
      match(SystemRDLParser::T__3);
      setState(317);
      param_def_elem();
      setState(322);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(323);
    match(SystemRDLParser::T__6);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Param_def_elemContext ------------------------------------------------------------------

SystemRDLParser::Param_def_elemContext::Param_def_elemContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Data_typeContext* SystemRDLParser::Param_def_elemContext::data_type() {
  return getRuleContext<SystemRDLParser::Data_typeContext>(0);
}

tree::TerminalNode* SystemRDLParser::Param_def_elemContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

SystemRDLParser::Array_type_suffixContext* SystemRDLParser::Param_def_elemContext::array_type_suffix() {
  return getRuleContext<SystemRDLParser::Array_type_suffixContext>(0);
}

tree::TerminalNode* SystemRDLParser::Param_def_elemContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

SystemRDLParser::ExprContext* SystemRDLParser::Param_def_elemContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Param_def_elemContext::getRuleIndex() const {
  return SystemRDLParser::RuleParam_def_elem;
}


std::any SystemRDLParser::Param_def_elemContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitParam_def_elem(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Param_def_elemContext* SystemRDLParser::param_def_elem() {
  Param_def_elemContext *_localctx = _tracker.createInstance<Param_def_elemContext>(_ctx, getState());
  enterRule(_localctx, 40, SystemRDLParser::RuleParam_def_elem);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(325);
    data_type();
    setState(326);
    match(SystemRDLParser::ID);
    setState(328);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::T__11) {
      setState(327);
      array_type_suffix();
    }
    setState(332);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::ASSIGN) {
      setState(330);
      match(SystemRDLParser::ASSIGN);
      setState(331);
      expr(0);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Param_instContext ------------------------------------------------------------------

SystemRDLParser::Param_instContext::Param_instContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::Param_assignmentContext *> SystemRDLParser::Param_instContext::param_assignment() {
  return getRuleContexts<SystemRDLParser::Param_assignmentContext>();
}

SystemRDLParser::Param_assignmentContext* SystemRDLParser::Param_instContext::param_assignment(size_t i) {
  return getRuleContext<SystemRDLParser::Param_assignmentContext>(i);
}


size_t SystemRDLParser::Param_instContext::getRuleIndex() const {
  return SystemRDLParser::RuleParam_inst;
}


std::any SystemRDLParser::Param_instContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitParam_inst(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Param_instContext* SystemRDLParser::param_inst() {
  Param_instContext *_localctx = _tracker.createInstance<Param_instContext>(_ctx, getState());
  enterRule(_localctx, 42, SystemRDLParser::RuleParam_inst);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(334);
    match(SystemRDLParser::T__4);
    setState(335);
    match(SystemRDLParser::T__5);
    setState(336);
    param_assignment();
    setState(341);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SystemRDLParser::T__3) {
      setState(337);
      match(SystemRDLParser::T__3);
      setState(338);
      param_assignment();
      setState(343);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(344);
    match(SystemRDLParser::T__6);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Param_assignmentContext ------------------------------------------------------------------

SystemRDLParser::Param_assignmentContext::Param_assignmentContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Param_assignmentContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

SystemRDLParser::ExprContext* SystemRDLParser::Param_assignmentContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Param_assignmentContext::getRuleIndex() const {
  return SystemRDLParser::RuleParam_assignment;
}


std::any SystemRDLParser::Param_assignmentContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitParam_assignment(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Param_assignmentContext* SystemRDLParser::param_assignment() {
  Param_assignmentContext *_localctx = _tracker.createInstance<Param_assignmentContext>(_ctx, getState());
  enterRule(_localctx, 44, SystemRDLParser::RuleParam_assignment);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(346);
    match(SystemRDLParser::T__7);
    setState(347);
    match(SystemRDLParser::ID);
    setState(348);
    match(SystemRDLParser::T__5);
    setState(349);
    expr(0);
    setState(350);
    match(SystemRDLParser::T__6);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- ExprContext ------------------------------------------------------------------

SystemRDLParser::ExprContext::ExprContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}


size_t SystemRDLParser::ExprContext::getRuleIndex() const {
  return SystemRDLParser::RuleExpr;
}

void SystemRDLParser::ExprContext::copyFrom(ExprContext *ctx) {
  ParserRuleContext::copyFrom(ctx);
}

//----------------- BinaryExprContext ------------------------------------------------------------------

std::vector<SystemRDLParser::ExprContext *> SystemRDLParser::BinaryExprContext::expr() {
  return getRuleContexts<SystemRDLParser::ExprContext>();
}

SystemRDLParser::ExprContext* SystemRDLParser::BinaryExprContext::expr(size_t i) {
  return getRuleContext<SystemRDLParser::ExprContext>(i);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::EXP() {
  return getToken(SystemRDLParser::EXP, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::MULT() {
  return getToken(SystemRDLParser::MULT, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::DIV() {
  return getToken(SystemRDLParser::DIV, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::MOD() {
  return getToken(SystemRDLParser::MOD, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::PLUS() {
  return getToken(SystemRDLParser::PLUS, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::MINUS() {
  return getToken(SystemRDLParser::MINUS, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::LSHIFT() {
  return getToken(SystemRDLParser::LSHIFT, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::RSHIFT() {
  return getToken(SystemRDLParser::RSHIFT, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::LT() {
  return getToken(SystemRDLParser::LT, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::LEQ() {
  return getToken(SystemRDLParser::LEQ, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::GT() {
  return getToken(SystemRDLParser::GT, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::GEQ() {
  return getToken(SystemRDLParser::GEQ, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::EQ() {
  return getToken(SystemRDLParser::EQ, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::NEQ() {
  return getToken(SystemRDLParser::NEQ, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::AND() {
  return getToken(SystemRDLParser::AND, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::XOR() {
  return getToken(SystemRDLParser::XOR, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::XNOR() {
  return getToken(SystemRDLParser::XNOR, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::OR() {
  return getToken(SystemRDLParser::OR, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::BAND() {
  return getToken(SystemRDLParser::BAND, 0);
}

tree::TerminalNode* SystemRDLParser::BinaryExprContext::BOR() {
  return getToken(SystemRDLParser::BOR, 0);
}

SystemRDLParser::BinaryExprContext::BinaryExprContext(ExprContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::BinaryExprContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitBinaryExpr(this);
  else
    return visitor->visitChildren(this);
}
//----------------- UnaryExprContext ------------------------------------------------------------------

SystemRDLParser::Expr_primaryContext* SystemRDLParser::UnaryExprContext::expr_primary() {
  return getRuleContext<SystemRDLParser::Expr_primaryContext>(0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::PLUS() {
  return getToken(SystemRDLParser::PLUS, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::MINUS() {
  return getToken(SystemRDLParser::MINUS, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::BNOT() {
  return getToken(SystemRDLParser::BNOT, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::NOT() {
  return getToken(SystemRDLParser::NOT, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::AND() {
  return getToken(SystemRDLParser::AND, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::NAND() {
  return getToken(SystemRDLParser::NAND, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::OR() {
  return getToken(SystemRDLParser::OR, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::NOR() {
  return getToken(SystemRDLParser::NOR, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::XOR() {
  return getToken(SystemRDLParser::XOR, 0);
}

tree::TerminalNode* SystemRDLParser::UnaryExprContext::XNOR() {
  return getToken(SystemRDLParser::XNOR, 0);
}

SystemRDLParser::UnaryExprContext::UnaryExprContext(ExprContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::UnaryExprContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUnaryExpr(this);
  else
    return visitor->visitChildren(this);
}
//----------------- NOPContext ------------------------------------------------------------------

SystemRDLParser::Expr_primaryContext* SystemRDLParser::NOPContext::expr_primary() {
  return getRuleContext<SystemRDLParser::Expr_primaryContext>(0);
}

SystemRDLParser::NOPContext::NOPContext(ExprContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::NOPContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitNOP(this);
  else
    return visitor->visitChildren(this);
}
//----------------- TernaryExprContext ------------------------------------------------------------------

std::vector<SystemRDLParser::ExprContext *> SystemRDLParser::TernaryExprContext::expr() {
  return getRuleContexts<SystemRDLParser::ExprContext>();
}

SystemRDLParser::ExprContext* SystemRDLParser::TernaryExprContext::expr(size_t i) {
  return getRuleContext<SystemRDLParser::ExprContext>(i);
}

SystemRDLParser::TernaryExprContext::TernaryExprContext(ExprContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::TernaryExprContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitTernaryExpr(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::ExprContext* SystemRDLParser::expr() {
   return expr(0);
}

SystemRDLParser::ExprContext* SystemRDLParser::expr(int precedence) {
  ParserRuleContext *parentContext = _ctx;
  size_t parentState = getState();
  SystemRDLParser::ExprContext *_localctx = _tracker.createInstance<ExprContext>(_ctx, parentState);
  SystemRDLParser::ExprContext *previousContext = _localctx;
  (void)previousContext; // Silence compiler, in case the context is not used by generated code.
  size_t startState = 46;
  enterRecursionRule(_localctx, 46, SystemRDLParser::RuleExpr, precedence);

    size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    unrollRecursionContexts(parentContext);
  });
  try {
    size_t alt;
    enterOuterAlt(_localctx, 1);
    setState(356);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::PLUS:
      case SystemRDLParser::MINUS:
      case SystemRDLParser::BNOT:
      case SystemRDLParser::NOT:
      case SystemRDLParser::NAND:
      case SystemRDLParser::AND:
      case SystemRDLParser::OR:
      case SystemRDLParser::NOR:
      case SystemRDLParser::XOR:
      case SystemRDLParser::XNOR: {
        _localctx = _tracker.createInstance<UnaryExprContext>(_localctx);
        _ctx = _localctx;
        previousContext = _localctx;

        setState(353);
        antlrcpp::downCast<UnaryExprContext *>(_localctx)->op = _input->LT(1);
        _la = _input->LA(1);
        if (!(((((_la - 96) & ~ 0x3fULL) == 0) &&
          ((1ULL << (_la - 96)) & 3823) != 0))) {
          antlrcpp::downCast<UnaryExprContext *>(_localctx)->op = _errHandler->recoverInline(this);
        }
        else {
          _errHandler->reportMatch(this);
          consume();
        }
        setState(354);
        expr_primary();
        break;
      }

      case SystemRDLParser::T__1:
      case SystemRDLParser::T__5:
      case SystemRDLParser::T__10:
      case SystemRDLParser::BOOLEAN_kw:
      case SystemRDLParser::BIT_kw:
      case SystemRDLParser::LONGINT_kw:
      case SystemRDLParser::TRUE_kw:
      case SystemRDLParser::FALSE_kw:
      case SystemRDLParser::NA_kw:
      case SystemRDLParser::RW_kw:
      case SystemRDLParser::WR_kw:
      case SystemRDLParser::R_kw:
      case SystemRDLParser::W_kw:
      case SystemRDLParser::RW1_kw:
      case SystemRDLParser::W1_kw:
      case SystemRDLParser::RCLR_kw:
      case SystemRDLParser::RSET_kw:
      case SystemRDLParser::RUSER_kw:
      case SystemRDLParser::WOSET_kw:
      case SystemRDLParser::WOCLR_kw:
      case SystemRDLParser::WOT_kw:
      case SystemRDLParser::WZS_kw:
      case SystemRDLParser::WZC_kw:
      case SystemRDLParser::WZT_kw:
      case SystemRDLParser::WCLR_kw:
      case SystemRDLParser::WSET_kw:
      case SystemRDLParser::WUSER_kw:
      case SystemRDLParser::COMPACT_kw:
      case SystemRDLParser::REGALIGN_kw:
      case SystemRDLParser::FULLALIGN_kw:
      case SystemRDLParser::HW_kw:
      case SystemRDLParser::SW_kw:
      case SystemRDLParser::INT:
      case SystemRDLParser::HEX_INT:
      case SystemRDLParser::VLOG_INT:
      case SystemRDLParser::STRING:
      case SystemRDLParser::ID: {
        _localctx = _tracker.createInstance<NOPContext>(_localctx);
        _ctx = _localctx;
        previousContext = _localctx;
        setState(355);
        expr_primary();
        break;
      }

    default:
      throw NoViableAltException(this);
    }
    _ctx->stop = _input->LT(-1);
    setState(399);
    _errHandler->sync(this);
    alt = getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 26, _ctx);
    while (alt != 2 && alt != atn::ATN::INVALID_ALT_NUMBER) {
      if (alt == 1) {
        if (!_parseListeners.empty())
          triggerExitRuleEvent();
        previousContext = _localctx;
        setState(397);
        _errHandler->sync(this);
        switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 25, _ctx)) {
        case 1: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(358);

          if (!(precpred(_ctx, 13))) throw FailedPredicateException(this, "precpred(_ctx, 13)");
          setState(359);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = match(SystemRDLParser::EXP);
          setState(360);
          expr(14);
          break;
        }

        case 2: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(361);

          if (!(precpred(_ctx, 12))) throw FailedPredicateException(this, "precpred(_ctx, 12)");
          setState(362);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _input->LT(1);
          _la = _input->LA(1);
          if (!(((((_la - 110) & ~ 0x3fULL) == 0) &&
            ((1ULL << (_la - 110)) & 13) != 0))) {
            antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _errHandler->recoverInline(this);
          }
          else {
            _errHandler->reportMatch(this);
            consume();
          }
          setState(363);
          expr(13);
          break;
        }

        case 3: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(364);

          if (!(precpred(_ctx, 11))) throw FailedPredicateException(this, "precpred(_ctx, 11)");
          setState(365);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _input->LT(1);
          _la = _input->LA(1);
          if (!(_la == SystemRDLParser::PLUS

          || _la == SystemRDLParser::MINUS)) {
            antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _errHandler->recoverInline(this);
          }
          else {
            _errHandler->reportMatch(this);
            consume();
          }
          setState(366);
          expr(12);
          break;
        }

        case 4: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(367);

          if (!(precpred(_ctx, 10))) throw FailedPredicateException(this, "precpred(_ctx, 10)");
          setState(368);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _input->LT(1);
          _la = _input->LA(1);
          if (!(_la == SystemRDLParser::LSHIFT

          || _la == SystemRDLParser::RSHIFT)) {
            antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _errHandler->recoverInline(this);
          }
          else {
            _errHandler->reportMatch(this);
            consume();
          }
          setState(369);
          expr(11);
          break;
        }

        case 5: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(370);

          if (!(precpred(_ctx, 9))) throw FailedPredicateException(this, "precpred(_ctx, 9)");
          setState(371);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _input->LT(1);
          _la = _input->LA(1);
          if (!(((((_la - 117) & ~ 0x3fULL) == 0) &&
            ((1ULL << (_la - 117)) & 15) != 0))) {
            antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _errHandler->recoverInline(this);
          }
          else {
            _errHandler->reportMatch(this);
            consume();
          }
          setState(372);
          expr(10);
          break;
        }

        case 6: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(373);

          if (!(precpred(_ctx, 8))) throw FailedPredicateException(this, "precpred(_ctx, 8)");
          setState(374);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _input->LT(1);
          _la = _input->LA(1);
          if (!(_la == SystemRDLParser::EQ

          || _la == SystemRDLParser::NEQ)) {
            antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _errHandler->recoverInline(this);
          }
          else {
            _errHandler->reportMatch(this);
            consume();
          }
          setState(375);
          expr(9);
          break;
        }

        case 7: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(376);

          if (!(precpred(_ctx, 7))) throw FailedPredicateException(this, "precpred(_ctx, 7)");
          setState(377);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = match(SystemRDLParser::AND);
          setState(378);
          expr(8);
          break;
        }

        case 8: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(379);

          if (!(precpred(_ctx, 6))) throw FailedPredicateException(this, "precpred(_ctx, 6)");
          setState(380);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _input->LT(1);
          _la = _input->LA(1);
          if (!(_la == SystemRDLParser::XOR

          || _la == SystemRDLParser::XNOR)) {
            antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = _errHandler->recoverInline(this);
          }
          else {
            _errHandler->reportMatch(this);
            consume();
          }
          setState(381);
          expr(7);
          break;
        }

        case 9: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(382);

          if (!(precpred(_ctx, 5))) throw FailedPredicateException(this, "precpred(_ctx, 5)");
          setState(383);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = match(SystemRDLParser::OR);
          setState(384);
          expr(6);
          break;
        }

        case 10: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(385);

          if (!(precpred(_ctx, 4))) throw FailedPredicateException(this, "precpred(_ctx, 4)");
          setState(386);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = match(SystemRDLParser::BAND);
          setState(387);
          expr(5);
          break;
        }

        case 11: {
          auto newContext = _tracker.createInstance<BinaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(388);

          if (!(precpred(_ctx, 3))) throw FailedPredicateException(this, "precpred(_ctx, 3)");
          setState(389);
          antlrcpp::downCast<BinaryExprContext *>(_localctx)->op = match(SystemRDLParser::BOR);
          setState(390);
          expr(4);
          break;
        }

        case 12: {
          auto newContext = _tracker.createInstance<TernaryExprContext>(_tracker.createInstance<ExprContext>(parentContext, parentState));
          _localctx = newContext;
          pushNewRecursionContext(newContext, startState, RuleExpr);
          setState(391);

          if (!(precpred(_ctx, 2))) throw FailedPredicateException(this, "precpred(_ctx, 2)");
          setState(392);
          antlrcpp::downCast<TernaryExprContext *>(_localctx)->op = match(SystemRDLParser::T__8);
          setState(393);
          expr(0);
          setState(394);
          match(SystemRDLParser::T__9);
          setState(395);
          expr(2);
          break;
        }

        default:
          break;
        } 
      }
      setState(401);
      _errHandler->sync(this);
      alt = getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 26, _ctx);
    }
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }
  return _localctx;
}

//----------------- Expr_primaryContext ------------------------------------------------------------------

SystemRDLParser::Expr_primaryContext::Expr_primaryContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::LiteralContext* SystemRDLParser::Expr_primaryContext::literal() {
  return getRuleContext<SystemRDLParser::LiteralContext>(0);
}

SystemRDLParser::ConcatenateContext* SystemRDLParser::Expr_primaryContext::concatenate() {
  return getRuleContext<SystemRDLParser::ConcatenateContext>(0);
}

SystemRDLParser::ReplicateContext* SystemRDLParser::Expr_primaryContext::replicate() {
  return getRuleContext<SystemRDLParser::ReplicateContext>(0);
}

SystemRDLParser::Paren_exprContext* SystemRDLParser::Expr_primaryContext::paren_expr() {
  return getRuleContext<SystemRDLParser::Paren_exprContext>(0);
}

SystemRDLParser::CastContext* SystemRDLParser::Expr_primaryContext::cast() {
  return getRuleContext<SystemRDLParser::CastContext>(0);
}

SystemRDLParser::Prop_refContext* SystemRDLParser::Expr_primaryContext::prop_ref() {
  return getRuleContext<SystemRDLParser::Prop_refContext>(0);
}

SystemRDLParser::Instance_refContext* SystemRDLParser::Expr_primaryContext::instance_ref() {
  return getRuleContext<SystemRDLParser::Instance_refContext>(0);
}

SystemRDLParser::Struct_literalContext* SystemRDLParser::Expr_primaryContext::struct_literal() {
  return getRuleContext<SystemRDLParser::Struct_literalContext>(0);
}

SystemRDLParser::Array_literalContext* SystemRDLParser::Expr_primaryContext::array_literal() {
  return getRuleContext<SystemRDLParser::Array_literalContext>(0);
}


size_t SystemRDLParser::Expr_primaryContext::getRuleIndex() const {
  return SystemRDLParser::RuleExpr_primary;
}


std::any SystemRDLParser::Expr_primaryContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitExpr_primary(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Expr_primaryContext* SystemRDLParser::expr_primary() {
  Expr_primaryContext *_localctx = _tracker.createInstance<Expr_primaryContext>(_ctx, getState());
  enterRule(_localctx, 48, SystemRDLParser::RuleExpr_primary);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(411);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 27, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(402);
      literal();
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(403);
      concatenate();
      break;
    }

    case 3: {
      enterOuterAlt(_localctx, 3);
      setState(404);
      replicate();
      break;
    }

    case 4: {
      enterOuterAlt(_localctx, 4);
      setState(405);
      paren_expr();
      break;
    }

    case 5: {
      enterOuterAlt(_localctx, 5);
      setState(406);
      cast();
      break;
    }

    case 6: {
      enterOuterAlt(_localctx, 6);
      setState(407);
      prop_ref();
      break;
    }

    case 7: {
      enterOuterAlt(_localctx, 7);
      setState(408);
      instance_ref();
      break;
    }

    case 8: {
      enterOuterAlt(_localctx, 8);
      setState(409);
      struct_literal();
      break;
    }

    case 9: {
      enterOuterAlt(_localctx, 9);
      setState(410);
      array_literal();
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- ConcatenateContext ------------------------------------------------------------------

SystemRDLParser::ConcatenateContext::ConcatenateContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::ExprContext *> SystemRDLParser::ConcatenateContext::expr() {
  return getRuleContexts<SystemRDLParser::ExprContext>();
}

SystemRDLParser::ExprContext* SystemRDLParser::ConcatenateContext::expr(size_t i) {
  return getRuleContext<SystemRDLParser::ExprContext>(i);
}


size_t SystemRDLParser::ConcatenateContext::getRuleIndex() const {
  return SystemRDLParser::RuleConcatenate;
}


std::any SystemRDLParser::ConcatenateContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConcatenate(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::ConcatenateContext* SystemRDLParser::concatenate() {
  ConcatenateContext *_localctx = _tracker.createInstance<ConcatenateContext>(_ctx, getState());
  enterRule(_localctx, 50, SystemRDLParser::RuleConcatenate);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(413);
    match(SystemRDLParser::T__1);
    setState(414);
    expr(0);
    setState(419);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SystemRDLParser::T__3) {
      setState(415);
      match(SystemRDLParser::T__3);
      setState(416);
      expr(0);
      setState(421);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(422);
    match(SystemRDLParser::T__2);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- ReplicateContext ------------------------------------------------------------------

SystemRDLParser::ReplicateContext::ReplicateContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::ExprContext* SystemRDLParser::ReplicateContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

SystemRDLParser::ConcatenateContext* SystemRDLParser::ReplicateContext::concatenate() {
  return getRuleContext<SystemRDLParser::ConcatenateContext>(0);
}


size_t SystemRDLParser::ReplicateContext::getRuleIndex() const {
  return SystemRDLParser::RuleReplicate;
}


std::any SystemRDLParser::ReplicateContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitReplicate(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::ReplicateContext* SystemRDLParser::replicate() {
  ReplicateContext *_localctx = _tracker.createInstance<ReplicateContext>(_ctx, getState());
  enterRule(_localctx, 52, SystemRDLParser::RuleReplicate);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(424);
    match(SystemRDLParser::T__1);
    setState(425);
    expr(0);
    setState(426);
    concatenate();
    setState(427);
    match(SystemRDLParser::T__2);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Paren_exprContext ------------------------------------------------------------------

SystemRDLParser::Paren_exprContext::Paren_exprContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::ExprContext* SystemRDLParser::Paren_exprContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Paren_exprContext::getRuleIndex() const {
  return SystemRDLParser::RuleParen_expr;
}


std::any SystemRDLParser::Paren_exprContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitParen_expr(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Paren_exprContext* SystemRDLParser::paren_expr() {
  Paren_exprContext *_localctx = _tracker.createInstance<Paren_exprContext>(_ctx, getState());
  enterRule(_localctx, 54, SystemRDLParser::RuleParen_expr);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(429);
    match(SystemRDLParser::T__5);
    setState(430);
    expr(0);
    setState(431);
    match(SystemRDLParser::T__6);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- CastContext ------------------------------------------------------------------

SystemRDLParser::CastContext::CastContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}


size_t SystemRDLParser::CastContext::getRuleIndex() const {
  return SystemRDLParser::RuleCast;
}

void SystemRDLParser::CastContext::copyFrom(CastContext *ctx) {
  ParserRuleContext::copyFrom(ctx);
}

//----------------- CastWidthContext ------------------------------------------------------------------

SystemRDLParser::Cast_width_exprContext* SystemRDLParser::CastWidthContext::cast_width_expr() {
  return getRuleContext<SystemRDLParser::Cast_width_exprContext>(0);
}

SystemRDLParser::ExprContext* SystemRDLParser::CastWidthContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

SystemRDLParser::CastWidthContext::CastWidthContext(CastContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::CastWidthContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitCastWidth(this);
  else
    return visitor->visitChildren(this);
}
//----------------- CastTypeContext ------------------------------------------------------------------

SystemRDLParser::ExprContext* SystemRDLParser::CastTypeContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

tree::TerminalNode* SystemRDLParser::CastTypeContext::BOOLEAN_kw() {
  return getToken(SystemRDLParser::BOOLEAN_kw, 0);
}

tree::TerminalNode* SystemRDLParser::CastTypeContext::BIT_kw() {
  return getToken(SystemRDLParser::BIT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::CastTypeContext::LONGINT_kw() {
  return getToken(SystemRDLParser::LONGINT_kw, 0);
}

SystemRDLParser::CastTypeContext::CastTypeContext(CastContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::CastTypeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitCastType(this);
  else
    return visitor->visitChildren(this);
}
SystemRDLParser::CastContext* SystemRDLParser::cast() {
  CastContext *_localctx = _tracker.createInstance<CastContext>(_ctx, getState());
  enterRule(_localctx, 56, SystemRDLParser::RuleCast);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(445);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::BOOLEAN_kw:
      case SystemRDLParser::BIT_kw:
      case SystemRDLParser::LONGINT_kw: {
        _localctx = _tracker.createInstance<SystemRDLParser::CastTypeContext>(_localctx);
        enterOuterAlt(_localctx, 1);
        setState(433);
        antlrcpp::downCast<CastTypeContext *>(_localctx)->typ = _input->LT(1);
        _la = _input->LA(1);
        if (!((((_la & ~ 0x3fULL) == 0) &&
          ((1ULL << _la) & 1835008) != 0))) {
          antlrcpp::downCast<CastTypeContext *>(_localctx)->typ = _errHandler->recoverInline(this);
        }
        else {
          _errHandler->reportMatch(this);
          consume();
        }
        setState(434);
        antlrcpp::downCast<CastTypeContext *>(_localctx)->op = match(SystemRDLParser::T__10);
        setState(435);
        match(SystemRDLParser::T__5);
        setState(436);
        expr(0);
        setState(437);
        match(SystemRDLParser::T__6);
        break;
      }

      case SystemRDLParser::T__5:
      case SystemRDLParser::TRUE_kw:
      case SystemRDLParser::FALSE_kw:
      case SystemRDLParser::NA_kw:
      case SystemRDLParser::RW_kw:
      case SystemRDLParser::WR_kw:
      case SystemRDLParser::R_kw:
      case SystemRDLParser::W_kw:
      case SystemRDLParser::RW1_kw:
      case SystemRDLParser::W1_kw:
      case SystemRDLParser::RCLR_kw:
      case SystemRDLParser::RSET_kw:
      case SystemRDLParser::RUSER_kw:
      case SystemRDLParser::WOSET_kw:
      case SystemRDLParser::WOCLR_kw:
      case SystemRDLParser::WOT_kw:
      case SystemRDLParser::WZS_kw:
      case SystemRDLParser::WZC_kw:
      case SystemRDLParser::WZT_kw:
      case SystemRDLParser::WCLR_kw:
      case SystemRDLParser::WSET_kw:
      case SystemRDLParser::WUSER_kw:
      case SystemRDLParser::COMPACT_kw:
      case SystemRDLParser::REGALIGN_kw:
      case SystemRDLParser::FULLALIGN_kw:
      case SystemRDLParser::HW_kw:
      case SystemRDLParser::SW_kw:
      case SystemRDLParser::INT:
      case SystemRDLParser::HEX_INT:
      case SystemRDLParser::VLOG_INT:
      case SystemRDLParser::STRING:
      case SystemRDLParser::ID: {
        _localctx = _tracker.createInstance<SystemRDLParser::CastWidthContext>(_localctx);
        enterOuterAlt(_localctx, 2);
        setState(439);
        cast_width_expr();
        setState(440);
        antlrcpp::downCast<CastWidthContext *>(_localctx)->op = match(SystemRDLParser::T__10);
        setState(441);
        match(SystemRDLParser::T__5);
        setState(442);
        expr(0);
        setState(443);
        match(SystemRDLParser::T__6);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Cast_width_exprContext ------------------------------------------------------------------

SystemRDLParser::Cast_width_exprContext::Cast_width_exprContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::LiteralContext* SystemRDLParser::Cast_width_exprContext::literal() {
  return getRuleContext<SystemRDLParser::LiteralContext>(0);
}

SystemRDLParser::Paren_exprContext* SystemRDLParser::Cast_width_exprContext::paren_expr() {
  return getRuleContext<SystemRDLParser::Paren_exprContext>(0);
}


size_t SystemRDLParser::Cast_width_exprContext::getRuleIndex() const {
  return SystemRDLParser::RuleCast_width_expr;
}


std::any SystemRDLParser::Cast_width_exprContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitCast_width_expr(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Cast_width_exprContext* SystemRDLParser::cast_width_expr() {
  Cast_width_exprContext *_localctx = _tracker.createInstance<Cast_width_exprContext>(_ctx, getState());
  enterRule(_localctx, 58, SystemRDLParser::RuleCast_width_expr);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(449);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::TRUE_kw:
      case SystemRDLParser::FALSE_kw:
      case SystemRDLParser::NA_kw:
      case SystemRDLParser::RW_kw:
      case SystemRDLParser::WR_kw:
      case SystemRDLParser::R_kw:
      case SystemRDLParser::W_kw:
      case SystemRDLParser::RW1_kw:
      case SystemRDLParser::W1_kw:
      case SystemRDLParser::RCLR_kw:
      case SystemRDLParser::RSET_kw:
      case SystemRDLParser::RUSER_kw:
      case SystemRDLParser::WOSET_kw:
      case SystemRDLParser::WOCLR_kw:
      case SystemRDLParser::WOT_kw:
      case SystemRDLParser::WZS_kw:
      case SystemRDLParser::WZC_kw:
      case SystemRDLParser::WZT_kw:
      case SystemRDLParser::WCLR_kw:
      case SystemRDLParser::WSET_kw:
      case SystemRDLParser::WUSER_kw:
      case SystemRDLParser::COMPACT_kw:
      case SystemRDLParser::REGALIGN_kw:
      case SystemRDLParser::FULLALIGN_kw:
      case SystemRDLParser::HW_kw:
      case SystemRDLParser::SW_kw:
      case SystemRDLParser::INT:
      case SystemRDLParser::HEX_INT:
      case SystemRDLParser::VLOG_INT:
      case SystemRDLParser::STRING:
      case SystemRDLParser::ID: {
        enterOuterAlt(_localctx, 1);
        setState(447);
        literal();
        break;
      }

      case SystemRDLParser::T__5: {
        enterOuterAlt(_localctx, 2);
        setState(448);
        paren_expr();
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Range_suffixContext ------------------------------------------------------------------

SystemRDLParser::Range_suffixContext::Range_suffixContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::ExprContext *> SystemRDLParser::Range_suffixContext::expr() {
  return getRuleContexts<SystemRDLParser::ExprContext>();
}

SystemRDLParser::ExprContext* SystemRDLParser::Range_suffixContext::expr(size_t i) {
  return getRuleContext<SystemRDLParser::ExprContext>(i);
}


size_t SystemRDLParser::Range_suffixContext::getRuleIndex() const {
  return SystemRDLParser::RuleRange_suffix;
}


std::any SystemRDLParser::Range_suffixContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitRange_suffix(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Range_suffixContext* SystemRDLParser::range_suffix() {
  Range_suffixContext *_localctx = _tracker.createInstance<Range_suffixContext>(_ctx, getState());
  enterRule(_localctx, 60, SystemRDLParser::RuleRange_suffix);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(451);
    match(SystemRDLParser::T__11);
    setState(452);
    expr(0);
    setState(453);
    match(SystemRDLParser::T__9);
    setState(454);
    expr(0);
    setState(455);
    match(SystemRDLParser::T__12);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Array_suffixContext ------------------------------------------------------------------

SystemRDLParser::Array_suffixContext::Array_suffixContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::ExprContext* SystemRDLParser::Array_suffixContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Array_suffixContext::getRuleIndex() const {
  return SystemRDLParser::RuleArray_suffix;
}


std::any SystemRDLParser::Array_suffixContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitArray_suffix(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Array_suffixContext* SystemRDLParser::array_suffix() {
  Array_suffixContext *_localctx = _tracker.createInstance<Array_suffixContext>(_ctx, getState());
  enterRule(_localctx, 62, SystemRDLParser::RuleArray_suffix);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(457);
    match(SystemRDLParser::T__11);
    setState(458);
    expr(0);
    setState(459);
    match(SystemRDLParser::T__12);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Array_type_suffixContext ------------------------------------------------------------------

SystemRDLParser::Array_type_suffixContext::Array_type_suffixContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}


size_t SystemRDLParser::Array_type_suffixContext::getRuleIndex() const {
  return SystemRDLParser::RuleArray_type_suffix;
}


std::any SystemRDLParser::Array_type_suffixContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitArray_type_suffix(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Array_type_suffixContext* SystemRDLParser::array_type_suffix() {
  Array_type_suffixContext *_localctx = _tracker.createInstance<Array_type_suffixContext>(_ctx, getState());
  enterRule(_localctx, 64, SystemRDLParser::RuleArray_type_suffix);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(461);
    match(SystemRDLParser::T__11);
    setState(462);
    match(SystemRDLParser::T__12);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Data_typeContext ------------------------------------------------------------------

SystemRDLParser::Data_typeContext::Data_typeContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Basic_data_typeContext* SystemRDLParser::Data_typeContext::basic_data_type() {
  return getRuleContext<SystemRDLParser::Basic_data_typeContext>(0);
}

tree::TerminalNode* SystemRDLParser::Data_typeContext::ACCESSTYPE_kw() {
  return getToken(SystemRDLParser::ACCESSTYPE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Data_typeContext::ADDRESSINGTYPE_kw() {
  return getToken(SystemRDLParser::ADDRESSINGTYPE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Data_typeContext::ONREADTYPE_kw() {
  return getToken(SystemRDLParser::ONREADTYPE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Data_typeContext::ONWRITETYPE_kw() {
  return getToken(SystemRDLParser::ONWRITETYPE_kw, 0);
}


size_t SystemRDLParser::Data_typeContext::getRuleIndex() const {
  return SystemRDLParser::RuleData_type;
}


std::any SystemRDLParser::Data_typeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitData_type(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Data_typeContext* SystemRDLParser::data_type() {
  Data_typeContext *_localctx = _tracker.createInstance<Data_typeContext>(_ctx, getState());
  enterRule(_localctx, 66, SystemRDLParser::RuleData_type);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(466);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::BOOLEAN_kw:
      case SystemRDLParser::BIT_kw:
      case SystemRDLParser::LONGINT_kw:
      case SystemRDLParser::STRING_kw:
      case SystemRDLParser::ID: {
        enterOuterAlt(_localctx, 1);
        setState(464);
        basic_data_type();
        break;
      }

      case SystemRDLParser::ACCESSTYPE_kw:
      case SystemRDLParser::ADDRESSINGTYPE_kw:
      case SystemRDLParser::ONREADTYPE_kw:
      case SystemRDLParser::ONWRITETYPE_kw: {
        enterOuterAlt(_localctx, 2);
        setState(465);
        antlrcpp::downCast<Data_typeContext *>(_localctx)->kw = _input->LT(1);
        _la = _input->LA(1);
        if (!((((_la & ~ 0x3fULL) == 0) &&
          ((1ULL << _la) & 125829120) != 0))) {
          antlrcpp::downCast<Data_typeContext *>(_localctx)->kw = _errHandler->recoverInline(this);
        }
        else {
          _errHandler->reportMatch(this);
          consume();
        }
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Basic_data_typeContext ------------------------------------------------------------------

SystemRDLParser::Basic_data_typeContext::Basic_data_typeContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Basic_data_typeContext::BIT_kw() {
  return getToken(SystemRDLParser::BIT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Basic_data_typeContext::LONGINT_kw() {
  return getToken(SystemRDLParser::LONGINT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Basic_data_typeContext::UNSIGNED_kw() {
  return getToken(SystemRDLParser::UNSIGNED_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Basic_data_typeContext::STRING_kw() {
  return getToken(SystemRDLParser::STRING_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Basic_data_typeContext::BOOLEAN_kw() {
  return getToken(SystemRDLParser::BOOLEAN_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Basic_data_typeContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}


size_t SystemRDLParser::Basic_data_typeContext::getRuleIndex() const {
  return SystemRDLParser::RuleBasic_data_type;
}


std::any SystemRDLParser::Basic_data_typeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitBasic_data_type(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Basic_data_typeContext* SystemRDLParser::basic_data_type() {
  Basic_data_typeContext *_localctx = _tracker.createInstance<Basic_data_typeContext>(_ctx, getState());
  enterRule(_localctx, 68, SystemRDLParser::RuleBasic_data_type);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(473);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::BIT_kw:
      case SystemRDLParser::LONGINT_kw: {
        enterOuterAlt(_localctx, 1);
        setState(468);
        antlrcpp::downCast<Basic_data_typeContext *>(_localctx)->kw = _input->LT(1);
        _la = _input->LA(1);
        if (!(_la == SystemRDLParser::BIT_kw

        || _la == SystemRDLParser::LONGINT_kw)) {
          antlrcpp::downCast<Basic_data_typeContext *>(_localctx)->kw = _errHandler->recoverInline(this);
        }
        else {
          _errHandler->reportMatch(this);
          consume();
        }
        setState(470);
        _errHandler->sync(this);

        _la = _input->LA(1);
        if (_la == SystemRDLParser::UNSIGNED_kw) {
          setState(469);
          match(SystemRDLParser::UNSIGNED_kw);
        }
        break;
      }

      case SystemRDLParser::BOOLEAN_kw:
      case SystemRDLParser::STRING_kw:
      case SystemRDLParser::ID: {
        enterOuterAlt(_localctx, 2);
        setState(472);
        antlrcpp::downCast<Basic_data_typeContext *>(_localctx)->kw = _input->LT(1);
        _la = _input->LA(1);
        if (!(_la == SystemRDLParser::BOOLEAN_kw

        || _la == SystemRDLParser::STRING_kw || _la == SystemRDLParser::ID)) {
          antlrcpp::downCast<Basic_data_typeContext *>(_localctx)->kw = _errHandler->recoverInline(this);
        }
        else {
          _errHandler->reportMatch(this);
          consume();
        }
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- LiteralContext ------------------------------------------------------------------

SystemRDLParser::LiteralContext::LiteralContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::NumberContext* SystemRDLParser::LiteralContext::number() {
  return getRuleContext<SystemRDLParser::NumberContext>(0);
}

SystemRDLParser::String_literalContext* SystemRDLParser::LiteralContext::string_literal() {
  return getRuleContext<SystemRDLParser::String_literalContext>(0);
}

SystemRDLParser::Boolean_literalContext* SystemRDLParser::LiteralContext::boolean_literal() {
  return getRuleContext<SystemRDLParser::Boolean_literalContext>(0);
}

SystemRDLParser::Accesstype_literalContext* SystemRDLParser::LiteralContext::accesstype_literal() {
  return getRuleContext<SystemRDLParser::Accesstype_literalContext>(0);
}

SystemRDLParser::Onreadtype_literalContext* SystemRDLParser::LiteralContext::onreadtype_literal() {
  return getRuleContext<SystemRDLParser::Onreadtype_literalContext>(0);
}

SystemRDLParser::Onwritetype_literalContext* SystemRDLParser::LiteralContext::onwritetype_literal() {
  return getRuleContext<SystemRDLParser::Onwritetype_literalContext>(0);
}

SystemRDLParser::Addressingtype_literalContext* SystemRDLParser::LiteralContext::addressingtype_literal() {
  return getRuleContext<SystemRDLParser::Addressingtype_literalContext>(0);
}

SystemRDLParser::Precedencetype_literalContext* SystemRDLParser::LiteralContext::precedencetype_literal() {
  return getRuleContext<SystemRDLParser::Precedencetype_literalContext>(0);
}

SystemRDLParser::Enum_literalContext* SystemRDLParser::LiteralContext::enum_literal() {
  return getRuleContext<SystemRDLParser::Enum_literalContext>(0);
}


size_t SystemRDLParser::LiteralContext::getRuleIndex() const {
  return SystemRDLParser::RuleLiteral;
}


std::any SystemRDLParser::LiteralContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitLiteral(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::LiteralContext* SystemRDLParser::literal() {
  LiteralContext *_localctx = _tracker.createInstance<LiteralContext>(_ctx, getState());
  enterRule(_localctx, 70, SystemRDLParser::RuleLiteral);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(484);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::INT:
      case SystemRDLParser::HEX_INT:
      case SystemRDLParser::VLOG_INT: {
        enterOuterAlt(_localctx, 1);
        setState(475);
        number();
        break;
      }

      case SystemRDLParser::STRING: {
        enterOuterAlt(_localctx, 2);
        setState(476);
        string_literal();
        break;
      }

      case SystemRDLParser::TRUE_kw:
      case SystemRDLParser::FALSE_kw: {
        enterOuterAlt(_localctx, 3);
        setState(477);
        boolean_literal();
        break;
      }

      case SystemRDLParser::NA_kw:
      case SystemRDLParser::RW_kw:
      case SystemRDLParser::WR_kw:
      case SystemRDLParser::R_kw:
      case SystemRDLParser::W_kw:
      case SystemRDLParser::RW1_kw:
      case SystemRDLParser::W1_kw: {
        enterOuterAlt(_localctx, 4);
        setState(478);
        accesstype_literal();
        break;
      }

      case SystemRDLParser::RCLR_kw:
      case SystemRDLParser::RSET_kw:
      case SystemRDLParser::RUSER_kw: {
        enterOuterAlt(_localctx, 5);
        setState(479);
        onreadtype_literal();
        break;
      }

      case SystemRDLParser::WOSET_kw:
      case SystemRDLParser::WOCLR_kw:
      case SystemRDLParser::WOT_kw:
      case SystemRDLParser::WZS_kw:
      case SystemRDLParser::WZC_kw:
      case SystemRDLParser::WZT_kw:
      case SystemRDLParser::WCLR_kw:
      case SystemRDLParser::WSET_kw:
      case SystemRDLParser::WUSER_kw: {
        enterOuterAlt(_localctx, 6);
        setState(480);
        onwritetype_literal();
        break;
      }

      case SystemRDLParser::COMPACT_kw:
      case SystemRDLParser::REGALIGN_kw:
      case SystemRDLParser::FULLALIGN_kw: {
        enterOuterAlt(_localctx, 7);
        setState(481);
        addressingtype_literal();
        break;
      }

      case SystemRDLParser::HW_kw:
      case SystemRDLParser::SW_kw: {
        enterOuterAlt(_localctx, 8);
        setState(482);
        precedencetype_literal();
        break;
      }

      case SystemRDLParser::ID: {
        enterOuterAlt(_localctx, 9);
        setState(483);
        enum_literal();
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- NumberContext ------------------------------------------------------------------

SystemRDLParser::NumberContext::NumberContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}


size_t SystemRDLParser::NumberContext::getRuleIndex() const {
  return SystemRDLParser::RuleNumber;
}

void SystemRDLParser::NumberContext::copyFrom(NumberContext *ctx) {
  ParserRuleContext::copyFrom(ctx);
}

//----------------- NumberHexContext ------------------------------------------------------------------

tree::TerminalNode* SystemRDLParser::NumberHexContext::HEX_INT() {
  return getToken(SystemRDLParser::HEX_INT, 0);
}

SystemRDLParser::NumberHexContext::NumberHexContext(NumberContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::NumberHexContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitNumberHex(this);
  else
    return visitor->visitChildren(this);
}
//----------------- NumberVerilogContext ------------------------------------------------------------------

tree::TerminalNode* SystemRDLParser::NumberVerilogContext::VLOG_INT() {
  return getToken(SystemRDLParser::VLOG_INT, 0);
}

SystemRDLParser::NumberVerilogContext::NumberVerilogContext(NumberContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::NumberVerilogContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitNumberVerilog(this);
  else
    return visitor->visitChildren(this);
}
//----------------- NumberIntContext ------------------------------------------------------------------

tree::TerminalNode* SystemRDLParser::NumberIntContext::INT() {
  return getToken(SystemRDLParser::INT, 0);
}

SystemRDLParser::NumberIntContext::NumberIntContext(NumberContext *ctx) { copyFrom(ctx); }


std::any SystemRDLParser::NumberIntContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitNumberInt(this);
  else
    return visitor->visitChildren(this);
}
SystemRDLParser::NumberContext* SystemRDLParser::number() {
  NumberContext *_localctx = _tracker.createInstance<NumberContext>(_ctx, getState());
  enterRule(_localctx, 72, SystemRDLParser::RuleNumber);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(489);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::INT: {
        _localctx = _tracker.createInstance<SystemRDLParser::NumberIntContext>(_localctx);
        enterOuterAlt(_localctx, 1);
        setState(486);
        match(SystemRDLParser::INT);
        break;
      }

      case SystemRDLParser::HEX_INT: {
        _localctx = _tracker.createInstance<SystemRDLParser::NumberHexContext>(_localctx);
        enterOuterAlt(_localctx, 2);
        setState(487);
        match(SystemRDLParser::HEX_INT);
        break;
      }

      case SystemRDLParser::VLOG_INT: {
        _localctx = _tracker.createInstance<SystemRDLParser::NumberVerilogContext>(_localctx);
        enterOuterAlt(_localctx, 3);
        setState(488);
        match(SystemRDLParser::VLOG_INT);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- String_literalContext ------------------------------------------------------------------

SystemRDLParser::String_literalContext::String_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::String_literalContext::STRING() {
  return getToken(SystemRDLParser::STRING, 0);
}


size_t SystemRDLParser::String_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleString_literal;
}


std::any SystemRDLParser::String_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitString_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::String_literalContext* SystemRDLParser::string_literal() {
  String_literalContext *_localctx = _tracker.createInstance<String_literalContext>(_ctx, getState());
  enterRule(_localctx, 74, SystemRDLParser::RuleString_literal);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(491);
    match(SystemRDLParser::STRING);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Boolean_literalContext ------------------------------------------------------------------

SystemRDLParser::Boolean_literalContext::Boolean_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Boolean_literalContext::TRUE_kw() {
  return getToken(SystemRDLParser::TRUE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Boolean_literalContext::FALSE_kw() {
  return getToken(SystemRDLParser::FALSE_kw, 0);
}


size_t SystemRDLParser::Boolean_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleBoolean_literal;
}


std::any SystemRDLParser::Boolean_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitBoolean_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Boolean_literalContext* SystemRDLParser::boolean_literal() {
  Boolean_literalContext *_localctx = _tracker.createInstance<Boolean_literalContext>(_ctx, getState());
  enterRule(_localctx, 76, SystemRDLParser::RuleBoolean_literal);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(493);
    antlrcpp::downCast<Boolean_literalContext *>(_localctx)->val = _input->LT(1);
    _la = _input->LA(1);
    if (!(_la == SystemRDLParser::TRUE_kw

    || _la == SystemRDLParser::FALSE_kw)) {
      antlrcpp::downCast<Boolean_literalContext *>(_localctx)->val = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Array_literalContext ------------------------------------------------------------------

SystemRDLParser::Array_literalContext::Array_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::ExprContext *> SystemRDLParser::Array_literalContext::expr() {
  return getRuleContexts<SystemRDLParser::ExprContext>();
}

SystemRDLParser::ExprContext* SystemRDLParser::Array_literalContext::expr(size_t i) {
  return getRuleContext<SystemRDLParser::ExprContext>(i);
}


size_t SystemRDLParser::Array_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleArray_literal;
}


std::any SystemRDLParser::Array_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitArray_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Array_literalContext* SystemRDLParser::array_literal() {
  Array_literalContext *_localctx = _tracker.createInstance<Array_literalContext>(_ctx, getState());
  enterRule(_localctx, 78, SystemRDLParser::RuleArray_literal);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(510);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 37, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(495);
      match(SystemRDLParser::T__10);
      setState(496);
      match(SystemRDLParser::T__1);
      setState(497);
      match(SystemRDLParser::T__2);
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(498);
      match(SystemRDLParser::T__10);
      setState(499);
      match(SystemRDLParser::T__1);
      setState(500);
      expr(0);
      setState(505);
      _errHandler->sync(this);
      _la = _input->LA(1);
      while (_la == SystemRDLParser::T__3) {
        setState(501);
        match(SystemRDLParser::T__3);
        setState(502);
        expr(0);
        setState(507);
        _errHandler->sync(this);
        _la = _input->LA(1);
      }
      setState(508);
      match(SystemRDLParser::T__2);
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Struct_literalContext ------------------------------------------------------------------

SystemRDLParser::Struct_literalContext::Struct_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Struct_literalContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

std::vector<SystemRDLParser::Struct_kvContext *> SystemRDLParser::Struct_literalContext::struct_kv() {
  return getRuleContexts<SystemRDLParser::Struct_kvContext>();
}

SystemRDLParser::Struct_kvContext* SystemRDLParser::Struct_literalContext::struct_kv(size_t i) {
  return getRuleContext<SystemRDLParser::Struct_kvContext>(i);
}


size_t SystemRDLParser::Struct_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleStruct_literal;
}


std::any SystemRDLParser::Struct_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitStruct_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Struct_literalContext* SystemRDLParser::struct_literal() {
  Struct_literalContext *_localctx = _tracker.createInstance<Struct_literalContext>(_ctx, getState());
  enterRule(_localctx, 80, SystemRDLParser::RuleStruct_literal);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(529);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 39, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(512);
      match(SystemRDLParser::ID);
      setState(513);
      match(SystemRDLParser::T__10);
      setState(514);
      match(SystemRDLParser::T__1);
      setState(515);
      match(SystemRDLParser::T__2);
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(516);
      match(SystemRDLParser::ID);
      setState(517);
      match(SystemRDLParser::T__10);
      setState(518);
      match(SystemRDLParser::T__1);
      setState(519);
      struct_kv();
      setState(524);
      _errHandler->sync(this);
      _la = _input->LA(1);
      while (_la == SystemRDLParser::T__3) {
        setState(520);
        match(SystemRDLParser::T__3);
        setState(521);
        struct_kv();
        setState(526);
        _errHandler->sync(this);
        _la = _input->LA(1);
      }
      setState(527);
      match(SystemRDLParser::T__2);
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Struct_kvContext ------------------------------------------------------------------

SystemRDLParser::Struct_kvContext::Struct_kvContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Struct_kvContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

SystemRDLParser::ExprContext* SystemRDLParser::Struct_kvContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Struct_kvContext::getRuleIndex() const {
  return SystemRDLParser::RuleStruct_kv;
}


std::any SystemRDLParser::Struct_kvContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitStruct_kv(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Struct_kvContext* SystemRDLParser::struct_kv() {
  Struct_kvContext *_localctx = _tracker.createInstance<Struct_kvContext>(_ctx, getState());
  enterRule(_localctx, 82, SystemRDLParser::RuleStruct_kv);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(531);
    match(SystemRDLParser::ID);
    setState(532);
    match(SystemRDLParser::T__9);
    setState(533);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Enum_literalContext ------------------------------------------------------------------

SystemRDLParser::Enum_literalContext::Enum_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<tree::TerminalNode *> SystemRDLParser::Enum_literalContext::ID() {
  return getTokens(SystemRDLParser::ID);
}

tree::TerminalNode* SystemRDLParser::Enum_literalContext::ID(size_t i) {
  return getToken(SystemRDLParser::ID, i);
}


size_t SystemRDLParser::Enum_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleEnum_literal;
}


std::any SystemRDLParser::Enum_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitEnum_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Enum_literalContext* SystemRDLParser::enum_literal() {
  Enum_literalContext *_localctx = _tracker.createInstance<Enum_literalContext>(_ctx, getState());
  enterRule(_localctx, 84, SystemRDLParser::RuleEnum_literal);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(535);
    match(SystemRDLParser::ID);
    setState(536);
    match(SystemRDLParser::T__13);
    setState(537);
    match(SystemRDLParser::ID);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Accesstype_literalContext ------------------------------------------------------------------

SystemRDLParser::Accesstype_literalContext::Accesstype_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Accesstype_literalContext::NA_kw() {
  return getToken(SystemRDLParser::NA_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Accesstype_literalContext::RW_kw() {
  return getToken(SystemRDLParser::RW_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Accesstype_literalContext::WR_kw() {
  return getToken(SystemRDLParser::WR_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Accesstype_literalContext::R_kw() {
  return getToken(SystemRDLParser::R_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Accesstype_literalContext::W_kw() {
  return getToken(SystemRDLParser::W_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Accesstype_literalContext::RW1_kw() {
  return getToken(SystemRDLParser::RW1_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Accesstype_literalContext::W1_kw() {
  return getToken(SystemRDLParser::W1_kw, 0);
}


size_t SystemRDLParser::Accesstype_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleAccesstype_literal;
}


std::any SystemRDLParser::Accesstype_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitAccesstype_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Accesstype_literalContext* SystemRDLParser::accesstype_literal() {
  Accesstype_literalContext *_localctx = _tracker.createInstance<Accesstype_literalContext>(_ctx, getState());
  enterRule(_localctx, 86, SystemRDLParser::RuleAccesstype_literal);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(539);
    antlrcpp::downCast<Accesstype_literalContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & 34909494181888) != 0))) {
      antlrcpp::downCast<Accesstype_literalContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Onreadtype_literalContext ------------------------------------------------------------------

SystemRDLParser::Onreadtype_literalContext::Onreadtype_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Onreadtype_literalContext::RCLR_kw() {
  return getToken(SystemRDLParser::RCLR_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onreadtype_literalContext::RSET_kw() {
  return getToken(SystemRDLParser::RSET_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onreadtype_literalContext::RUSER_kw() {
  return getToken(SystemRDLParser::RUSER_kw, 0);
}


size_t SystemRDLParser::Onreadtype_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleOnreadtype_literal;
}


std::any SystemRDLParser::Onreadtype_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitOnreadtype_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Onreadtype_literalContext* SystemRDLParser::onreadtype_literal() {
  Onreadtype_literalContext *_localctx = _tracker.createInstance<Onreadtype_literalContext>(_ctx, getState());
  enterRule(_localctx, 88, SystemRDLParser::RuleOnreadtype_literal);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(541);
    antlrcpp::downCast<Onreadtype_literalContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & 246290604621824) != 0))) {
      antlrcpp::downCast<Onreadtype_literalContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Onwritetype_literalContext ------------------------------------------------------------------

SystemRDLParser::Onwritetype_literalContext::Onwritetype_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WOSET_kw() {
  return getToken(SystemRDLParser::WOSET_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WOCLR_kw() {
  return getToken(SystemRDLParser::WOCLR_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WOT_kw() {
  return getToken(SystemRDLParser::WOT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WZS_kw() {
  return getToken(SystemRDLParser::WZS_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WZC_kw() {
  return getToken(SystemRDLParser::WZC_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WZT_kw() {
  return getToken(SystemRDLParser::WZT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WCLR_kw() {
  return getToken(SystemRDLParser::WCLR_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WSET_kw() {
  return getToken(SystemRDLParser::WSET_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Onwritetype_literalContext::WUSER_kw() {
  return getToken(SystemRDLParser::WUSER_kw, 0);
}


size_t SystemRDLParser::Onwritetype_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleOnwritetype_literal;
}


std::any SystemRDLParser::Onwritetype_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitOnwritetype_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Onwritetype_literalContext* SystemRDLParser::onwritetype_literal() {
  Onwritetype_literalContext *_localctx = _tracker.createInstance<Onwritetype_literalContext>(_ctx, getState());
  enterRule(_localctx, 90, SystemRDLParser::RuleOnwritetype_literal);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(543);
    antlrcpp::downCast<Onwritetype_literalContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & 143833713099145216) != 0))) {
      antlrcpp::downCast<Onwritetype_literalContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Addressingtype_literalContext ------------------------------------------------------------------

SystemRDLParser::Addressingtype_literalContext::Addressingtype_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Addressingtype_literalContext::COMPACT_kw() {
  return getToken(SystemRDLParser::COMPACT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Addressingtype_literalContext::REGALIGN_kw() {
  return getToken(SystemRDLParser::REGALIGN_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Addressingtype_literalContext::FULLALIGN_kw() {
  return getToken(SystemRDLParser::FULLALIGN_kw, 0);
}


size_t SystemRDLParser::Addressingtype_literalContext::getRuleIndex() const {
  return SystemRDLParser::RuleAddressingtype_literal;
}


std::any SystemRDLParser::Addressingtype_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitAddressingtype_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Addressingtype_literalContext* SystemRDLParser::addressingtype_literal() {
  Addressingtype_literalContext *_localctx = _tracker.createInstance<Addressingtype_literalContext>(_ctx, getState());
  enterRule(_localctx, 92, SystemRDLParser::RuleAddressingtype_literal);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(545);
    antlrcpp::downCast<Addressingtype_literalContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & 1008806316530991104) != 0))) {
      antlrcpp::downCast<Addressingtype_literalContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Precedencetype_literalContext ------------------------------------------------------------------

SystemRDLParser::Precedencetype_literalContext::Precedencetype_literalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Precedencetype_literalContext::HW_kw() {
  return getToken(SystemRDLParser::HW_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Precedencetype_literalContext::SW_kw() {
  return getToken(SystemRDLParser::SW_kw, 0);
}


size_t SystemRDLParser::Precedencetype_literalContext::getRuleIndex() const {
  return SystemRDLParser::RulePrecedencetype_literal;
}


std::any SystemRDLParser::Precedencetype_literalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitPrecedencetype_literal(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Precedencetype_literalContext* SystemRDLParser::precedencetype_literal() {
  Precedencetype_literalContext *_localctx = _tracker.createInstance<Precedencetype_literalContext>(_ctx, getState());
  enterRule(_localctx, 94, SystemRDLParser::RulePrecedencetype_literal);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(547);
    antlrcpp::downCast<Precedencetype_literalContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!(_la == SystemRDLParser::HW_kw

    || _la == SystemRDLParser::SW_kw)) {
      antlrcpp::downCast<Precedencetype_literalContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Instance_refContext ------------------------------------------------------------------

SystemRDLParser::Instance_refContext::Instance_refContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::Instance_ref_elementContext *> SystemRDLParser::Instance_refContext::instance_ref_element() {
  return getRuleContexts<SystemRDLParser::Instance_ref_elementContext>();
}

SystemRDLParser::Instance_ref_elementContext* SystemRDLParser::Instance_refContext::instance_ref_element(size_t i) {
  return getRuleContext<SystemRDLParser::Instance_ref_elementContext>(i);
}


size_t SystemRDLParser::Instance_refContext::getRuleIndex() const {
  return SystemRDLParser::RuleInstance_ref;
}


std::any SystemRDLParser::Instance_refContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitInstance_ref(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Instance_refContext* SystemRDLParser::instance_ref() {
  Instance_refContext *_localctx = _tracker.createInstance<Instance_refContext>(_ctx, getState());
  enterRule(_localctx, 96, SystemRDLParser::RuleInstance_ref);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    size_t alt;
    enterOuterAlt(_localctx, 1);
    setState(549);
    instance_ref_element();
    setState(554);
    _errHandler->sync(this);
    alt = getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 40, _ctx);
    while (alt != 2 && alt != atn::ATN::INVALID_ALT_NUMBER) {
      if (alt == 1) {
        setState(550);
        match(SystemRDLParser::T__7);
        setState(551);
        instance_ref_element(); 
      }
      setState(556);
      _errHandler->sync(this);
      alt = getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 40, _ctx);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Instance_ref_elementContext ------------------------------------------------------------------

SystemRDLParser::Instance_ref_elementContext::Instance_ref_elementContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Instance_ref_elementContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

std::vector<SystemRDLParser::Array_suffixContext *> SystemRDLParser::Instance_ref_elementContext::array_suffix() {
  return getRuleContexts<SystemRDLParser::Array_suffixContext>();
}

SystemRDLParser::Array_suffixContext* SystemRDLParser::Instance_ref_elementContext::array_suffix(size_t i) {
  return getRuleContext<SystemRDLParser::Array_suffixContext>(i);
}


size_t SystemRDLParser::Instance_ref_elementContext::getRuleIndex() const {
  return SystemRDLParser::RuleInstance_ref_element;
}


std::any SystemRDLParser::Instance_ref_elementContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitInstance_ref_element(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Instance_ref_elementContext* SystemRDLParser::instance_ref_element() {
  Instance_ref_elementContext *_localctx = _tracker.createInstance<Instance_ref_elementContext>(_ctx, getState());
  enterRule(_localctx, 98, SystemRDLParser::RuleInstance_ref_element);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    size_t alt;
    enterOuterAlt(_localctx, 1);
    setState(557);
    match(SystemRDLParser::ID);
    setState(561);
    _errHandler->sync(this);
    alt = getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 41, _ctx);
    while (alt != 2 && alt != atn::ATN::INVALID_ALT_NUMBER) {
      if (alt == 1) {
        setState(558);
        array_suffix(); 
      }
      setState(563);
      _errHandler->sync(this);
      alt = getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 41, _ctx);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Prop_refContext ------------------------------------------------------------------

SystemRDLParser::Prop_refContext::Prop_refContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Instance_refContext* SystemRDLParser::Prop_refContext::instance_ref() {
  return getRuleContext<SystemRDLParser::Instance_refContext>(0);
}

SystemRDLParser::Prop_keywordContext* SystemRDLParser::Prop_refContext::prop_keyword() {
  return getRuleContext<SystemRDLParser::Prop_keywordContext>(0);
}

tree::TerminalNode* SystemRDLParser::Prop_refContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}


size_t SystemRDLParser::Prop_refContext::getRuleIndex() const {
  return SystemRDLParser::RuleProp_ref;
}


std::any SystemRDLParser::Prop_refContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitProp_ref(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Prop_refContext* SystemRDLParser::prop_ref() {
  Prop_refContext *_localctx = _tracker.createInstance<Prop_refContext>(_ctx, getState());
  enterRule(_localctx, 100, SystemRDLParser::RuleProp_ref);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(564);
    instance_ref();
    setState(565);
    match(SystemRDLParser::T__14);
    setState(568);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::RCLR_kw:
      case SystemRDLParser::RSET_kw:
      case SystemRDLParser::WOSET_kw:
      case SystemRDLParser::WOCLR_kw:
      case SystemRDLParser::HW_kw:
      case SystemRDLParser::SW_kw: {
        setState(566);
        prop_keyword();
        break;
      }

      case SystemRDLParser::ID: {
        setState(567);
        match(SystemRDLParser::ID);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Local_property_assignmentContext ------------------------------------------------------------------

SystemRDLParser::Local_property_assignmentContext::Local_property_assignmentContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Normal_prop_assignContext* SystemRDLParser::Local_property_assignmentContext::normal_prop_assign() {
  return getRuleContext<SystemRDLParser::Normal_prop_assignContext>(0);
}

tree::TerminalNode* SystemRDLParser::Local_property_assignmentContext::DEFAULT_kw() {
  return getToken(SystemRDLParser::DEFAULT_kw, 0);
}

SystemRDLParser::Encode_prop_assignContext* SystemRDLParser::Local_property_assignmentContext::encode_prop_assign() {
  return getRuleContext<SystemRDLParser::Encode_prop_assignContext>(0);
}

SystemRDLParser::Prop_mod_assignContext* SystemRDLParser::Local_property_assignmentContext::prop_mod_assign() {
  return getRuleContext<SystemRDLParser::Prop_mod_assignContext>(0);
}


size_t SystemRDLParser::Local_property_assignmentContext::getRuleIndex() const {
  return SystemRDLParser::RuleLocal_property_assignment;
}


std::any SystemRDLParser::Local_property_assignmentContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitLocal_property_assignment(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Local_property_assignmentContext* SystemRDLParser::local_property_assignment() {
  Local_property_assignmentContext *_localctx = _tracker.createInstance<Local_property_assignmentContext>(_ctx, getState());
  enterRule(_localctx, 102, SystemRDLParser::RuleLocal_property_assignment);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(582);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 46, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(571);
      _errHandler->sync(this);

      _la = _input->LA(1);
      if (_la == SystemRDLParser::DEFAULT_kw) {
        setState(570);
        match(SystemRDLParser::DEFAULT_kw);
      }
      setState(573);
      normal_prop_assign();
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(575);
      _errHandler->sync(this);

      _la = _input->LA(1);
      if (_la == SystemRDLParser::DEFAULT_kw) {
        setState(574);
        match(SystemRDLParser::DEFAULT_kw);
      }
      setState(577);
      encode_prop_assign();
      break;
    }

    case 3: {
      enterOuterAlt(_localctx, 3);
      setState(579);
      _errHandler->sync(this);

      _la = _input->LA(1);
      if (_la == SystemRDLParser::DEFAULT_kw) {
        setState(578);
        match(SystemRDLParser::DEFAULT_kw);
      }
      setState(581);
      prop_mod_assign();
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Dynamic_property_assignmentContext ------------------------------------------------------------------

SystemRDLParser::Dynamic_property_assignmentContext::Dynamic_property_assignmentContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Instance_refContext* SystemRDLParser::Dynamic_property_assignmentContext::instance_ref() {
  return getRuleContext<SystemRDLParser::Instance_refContext>(0);
}

SystemRDLParser::Normal_prop_assignContext* SystemRDLParser::Dynamic_property_assignmentContext::normal_prop_assign() {
  return getRuleContext<SystemRDLParser::Normal_prop_assignContext>(0);
}

SystemRDLParser::Encode_prop_assignContext* SystemRDLParser::Dynamic_property_assignmentContext::encode_prop_assign() {
  return getRuleContext<SystemRDLParser::Encode_prop_assignContext>(0);
}


size_t SystemRDLParser::Dynamic_property_assignmentContext::getRuleIndex() const {
  return SystemRDLParser::RuleDynamic_property_assignment;
}


std::any SystemRDLParser::Dynamic_property_assignmentContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitDynamic_property_assignment(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Dynamic_property_assignmentContext* SystemRDLParser::dynamic_property_assignment() {
  Dynamic_property_assignmentContext *_localctx = _tracker.createInstance<Dynamic_property_assignmentContext>(_ctx, getState());
  enterRule(_localctx, 104, SystemRDLParser::RuleDynamic_property_assignment);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(592);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 47, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(584);
      instance_ref();
      setState(585);
      match(SystemRDLParser::T__14);
      setState(586);
      normal_prop_assign();
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(588);
      instance_ref();
      setState(589);
      match(SystemRDLParser::T__14);
      setState(590);
      encode_prop_assign();
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Normal_prop_assignContext ------------------------------------------------------------------

SystemRDLParser::Normal_prop_assignContext::Normal_prop_assignContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Prop_keywordContext* SystemRDLParser::Normal_prop_assignContext::prop_keyword() {
  return getRuleContext<SystemRDLParser::Prop_keywordContext>(0);
}

tree::TerminalNode* SystemRDLParser::Normal_prop_assignContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

tree::TerminalNode* SystemRDLParser::Normal_prop_assignContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

SystemRDLParser::Prop_assignment_rhsContext* SystemRDLParser::Normal_prop_assignContext::prop_assignment_rhs() {
  return getRuleContext<SystemRDLParser::Prop_assignment_rhsContext>(0);
}


size_t SystemRDLParser::Normal_prop_assignContext::getRuleIndex() const {
  return SystemRDLParser::RuleNormal_prop_assign;
}


std::any SystemRDLParser::Normal_prop_assignContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitNormal_prop_assign(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Normal_prop_assignContext* SystemRDLParser::normal_prop_assign() {
  Normal_prop_assignContext *_localctx = _tracker.createInstance<Normal_prop_assignContext>(_ctx, getState());
  enterRule(_localctx, 106, SystemRDLParser::RuleNormal_prop_assign);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(596);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::RCLR_kw:
      case SystemRDLParser::RSET_kw:
      case SystemRDLParser::WOSET_kw:
      case SystemRDLParser::WOCLR_kw:
      case SystemRDLParser::HW_kw:
      case SystemRDLParser::SW_kw: {
        setState(594);
        prop_keyword();
        break;
      }

      case SystemRDLParser::ID: {
        setState(595);
        match(SystemRDLParser::ID);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
    setState(600);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::ASSIGN) {
      setState(598);
      match(SystemRDLParser::ASSIGN);
      setState(599);
      prop_assignment_rhs();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Encode_prop_assignContext ------------------------------------------------------------------

SystemRDLParser::Encode_prop_assignContext::Encode_prop_assignContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Encode_prop_assignContext::ENCODE_kw() {
  return getToken(SystemRDLParser::ENCODE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Encode_prop_assignContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

tree::TerminalNode* SystemRDLParser::Encode_prop_assignContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}


size_t SystemRDLParser::Encode_prop_assignContext::getRuleIndex() const {
  return SystemRDLParser::RuleEncode_prop_assign;
}


std::any SystemRDLParser::Encode_prop_assignContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitEncode_prop_assign(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Encode_prop_assignContext* SystemRDLParser::encode_prop_assign() {
  Encode_prop_assignContext *_localctx = _tracker.createInstance<Encode_prop_assignContext>(_ctx, getState());
  enterRule(_localctx, 108, SystemRDLParser::RuleEncode_prop_assign);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(602);
    match(SystemRDLParser::ENCODE_kw);
    setState(603);
    match(SystemRDLParser::ASSIGN);
    setState(604);
    match(SystemRDLParser::ID);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Prop_mod_assignContext ------------------------------------------------------------------

SystemRDLParser::Prop_mod_assignContext::Prop_mod_assignContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Prop_modContext* SystemRDLParser::Prop_mod_assignContext::prop_mod() {
  return getRuleContext<SystemRDLParser::Prop_modContext>(0);
}

tree::TerminalNode* SystemRDLParser::Prop_mod_assignContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}


size_t SystemRDLParser::Prop_mod_assignContext::getRuleIndex() const {
  return SystemRDLParser::RuleProp_mod_assign;
}


std::any SystemRDLParser::Prop_mod_assignContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitProp_mod_assign(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Prop_mod_assignContext* SystemRDLParser::prop_mod_assign() {
  Prop_mod_assignContext *_localctx = _tracker.createInstance<Prop_mod_assignContext>(_ctx, getState());
  enterRule(_localctx, 110, SystemRDLParser::RuleProp_mod_assign);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(606);
    prop_mod();
    setState(607);
    match(SystemRDLParser::ID);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Prop_assignment_rhsContext ------------------------------------------------------------------

SystemRDLParser::Prop_assignment_rhsContext::Prop_assignment_rhsContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Precedencetype_literalContext* SystemRDLParser::Prop_assignment_rhsContext::precedencetype_literal() {
  return getRuleContext<SystemRDLParser::Precedencetype_literalContext>(0);
}

SystemRDLParser::ExprContext* SystemRDLParser::Prop_assignment_rhsContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Prop_assignment_rhsContext::getRuleIndex() const {
  return SystemRDLParser::RuleProp_assignment_rhs;
}


std::any SystemRDLParser::Prop_assignment_rhsContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitProp_assignment_rhs(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Prop_assignment_rhsContext* SystemRDLParser::prop_assignment_rhs() {
  Prop_assignment_rhsContext *_localctx = _tracker.createInstance<Prop_assignment_rhsContext>(_ctx, getState());
  enterRule(_localctx, 112, SystemRDLParser::RuleProp_assignment_rhs);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(611);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 50, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(609);
      precedencetype_literal();
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(610);
      expr(0);
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Prop_keywordContext ------------------------------------------------------------------

SystemRDLParser::Prop_keywordContext::Prop_keywordContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Prop_keywordContext::SW_kw() {
  return getToken(SystemRDLParser::SW_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_keywordContext::HW_kw() {
  return getToken(SystemRDLParser::HW_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_keywordContext::RCLR_kw() {
  return getToken(SystemRDLParser::RCLR_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_keywordContext::RSET_kw() {
  return getToken(SystemRDLParser::RSET_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_keywordContext::WOCLR_kw() {
  return getToken(SystemRDLParser::WOCLR_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_keywordContext::WOSET_kw() {
  return getToken(SystemRDLParser::WOSET_kw, 0);
}


size_t SystemRDLParser::Prop_keywordContext::getRuleIndex() const {
  return SystemRDLParser::RuleProp_keyword;
}


std::any SystemRDLParser::Prop_keywordContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitProp_keyword(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Prop_keywordContext* SystemRDLParser::prop_keyword() {
  Prop_keywordContext *_localctx = _tracker.createInstance<Prop_keywordContext>(_ctx, getState());
  enterRule(_localctx, 114, SystemRDLParser::RuleProp_keyword);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(613);
    antlrcpp::downCast<Prop_keywordContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & 3459714491866939392) != 0))) {
      antlrcpp::downCast<Prop_keywordContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Prop_modContext ------------------------------------------------------------------

SystemRDLParser::Prop_modContext::Prop_modContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Prop_modContext::POSEDGE_kw() {
  return getToken(SystemRDLParser::POSEDGE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_modContext::NEGEDGE_kw() {
  return getToken(SystemRDLParser::NEGEDGE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_modContext::BOTHEDGE_kw() {
  return getToken(SystemRDLParser::BOTHEDGE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_modContext::LEVEL_kw() {
  return getToken(SystemRDLParser::LEVEL_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Prop_modContext::NONSTICKY_kw() {
  return getToken(SystemRDLParser::NONSTICKY_kw, 0);
}


size_t SystemRDLParser::Prop_modContext::getRuleIndex() const {
  return SystemRDLParser::RuleProp_mod;
}


std::any SystemRDLParser::Prop_modContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitProp_mod(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Prop_modContext* SystemRDLParser::prop_mod() {
  Prop_modContext *_localctx = _tracker.createInstance<Prop_modContext>(_ctx, getState());
  enterRule(_localctx, 116, SystemRDLParser::RuleProp_mod);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(615);
    antlrcpp::downCast<Prop_modContext *>(_localctx)->kw = _input->LT(1);
    _la = _input->LA(1);
    if (!(((((_la - 62) & ~ 0x3fULL) == 0) &&
      ((1ULL << (_la - 62)) & 31) != 0))) {
      antlrcpp::downCast<Prop_modContext *>(_localctx)->kw = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Udp_defContext ------------------------------------------------------------------

SystemRDLParser::Udp_defContext::Udp_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Udp_defContext::PROPERTY_kw() {
  return getToken(SystemRDLParser::PROPERTY_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Udp_defContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

std::vector<SystemRDLParser::Udp_attrContext *> SystemRDLParser::Udp_defContext::udp_attr() {
  return getRuleContexts<SystemRDLParser::Udp_attrContext>();
}

SystemRDLParser::Udp_attrContext* SystemRDLParser::Udp_defContext::udp_attr(size_t i) {
  return getRuleContext<SystemRDLParser::Udp_attrContext>(i);
}


size_t SystemRDLParser::Udp_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleUdp_def;
}


std::any SystemRDLParser::Udp_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUdp_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Udp_defContext* SystemRDLParser::udp_def() {
  Udp_defContext *_localctx = _tracker.createInstance<Udp_defContext>(_ctx, getState());
  enterRule(_localctx, 118, SystemRDLParser::RuleUdp_def);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(617);
    match(SystemRDLParser::PROPERTY_kw);
    setState(618);
    match(SystemRDLParser::ID);
    setState(619);
    match(SystemRDLParser::T__1);
    setState(623); 
    _errHandler->sync(this);
    _la = _input->LA(1);
    do {
      setState(620);
      udp_attr();
      setState(621);
      match(SystemRDLParser::T__0);
      setState(625); 
      _errHandler->sync(this);
      _la = _input->LA(1);
    } while (((((_la - 69) & ~ 0x3fULL) == 0) &&
      ((1ULL << (_la - 69)) & 4109) != 0));
    setState(627);
    match(SystemRDLParser::T__2);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Udp_attrContext ------------------------------------------------------------------

SystemRDLParser::Udp_attrContext::Udp_attrContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Udp_typeContext* SystemRDLParser::Udp_attrContext::udp_type() {
  return getRuleContext<SystemRDLParser::Udp_typeContext>(0);
}

SystemRDLParser::Udp_usageContext* SystemRDLParser::Udp_attrContext::udp_usage() {
  return getRuleContext<SystemRDLParser::Udp_usageContext>(0);
}

SystemRDLParser::Udp_defaultContext* SystemRDLParser::Udp_attrContext::udp_default() {
  return getRuleContext<SystemRDLParser::Udp_defaultContext>(0);
}

SystemRDLParser::Udp_constraintContext* SystemRDLParser::Udp_attrContext::udp_constraint() {
  return getRuleContext<SystemRDLParser::Udp_constraintContext>(0);
}


size_t SystemRDLParser::Udp_attrContext::getRuleIndex() const {
  return SystemRDLParser::RuleUdp_attr;
}


std::any SystemRDLParser::Udp_attrContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUdp_attr(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Udp_attrContext* SystemRDLParser::udp_attr() {
  Udp_attrContext *_localctx = _tracker.createInstance<Udp_attrContext>(_ctx, getState());
  enterRule(_localctx, 120, SystemRDLParser::RuleUdp_attr);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(633);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::TYPE_kw: {
        enterOuterAlt(_localctx, 1);
        setState(629);
        udp_type();
        break;
      }

      case SystemRDLParser::COMPONENT_kw: {
        enterOuterAlt(_localctx, 2);
        setState(630);
        udp_usage();
        break;
      }

      case SystemRDLParser::DEFAULT_kw: {
        enterOuterAlt(_localctx, 3);
        setState(631);
        udp_default();
        break;
      }

      case SystemRDLParser::CONSTRAINT_kw: {
        enterOuterAlt(_localctx, 4);
        setState(632);
        udp_constraint();
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Udp_typeContext ------------------------------------------------------------------

SystemRDLParser::Udp_typeContext::Udp_typeContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Udp_typeContext::TYPE_kw() {
  return getToken(SystemRDLParser::TYPE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Udp_typeContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

SystemRDLParser::Udp_data_typeContext* SystemRDLParser::Udp_typeContext::udp_data_type() {
  return getRuleContext<SystemRDLParser::Udp_data_typeContext>(0);
}

SystemRDLParser::Array_type_suffixContext* SystemRDLParser::Udp_typeContext::array_type_suffix() {
  return getRuleContext<SystemRDLParser::Array_type_suffixContext>(0);
}


size_t SystemRDLParser::Udp_typeContext::getRuleIndex() const {
  return SystemRDLParser::RuleUdp_type;
}


std::any SystemRDLParser::Udp_typeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUdp_type(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Udp_typeContext* SystemRDLParser::udp_type() {
  Udp_typeContext *_localctx = _tracker.createInstance<Udp_typeContext>(_ctx, getState());
  enterRule(_localctx, 122, SystemRDLParser::RuleUdp_type);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(635);
    match(SystemRDLParser::TYPE_kw);
    setState(636);
    match(SystemRDLParser::ASSIGN);
    setState(637);
    udp_data_type();
    setState(639);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::T__11) {
      setState(638);
      array_type_suffix();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Udp_data_typeContext ------------------------------------------------------------------

SystemRDLParser::Udp_data_typeContext::Udp_data_typeContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Component_type_primaryContext* SystemRDLParser::Udp_data_typeContext::component_type_primary() {
  return getRuleContext<SystemRDLParser::Component_type_primaryContext>(0);
}

tree::TerminalNode* SystemRDLParser::Udp_data_typeContext::REF_kw() {
  return getToken(SystemRDLParser::REF_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Udp_data_typeContext::NUMBER_kw() {
  return getToken(SystemRDLParser::NUMBER_kw, 0);
}

SystemRDLParser::Basic_data_typeContext* SystemRDLParser::Udp_data_typeContext::basic_data_type() {
  return getRuleContext<SystemRDLParser::Basic_data_typeContext>(0);
}


size_t SystemRDLParser::Udp_data_typeContext::getRuleIndex() const {
  return SystemRDLParser::RuleUdp_data_type;
}


std::any SystemRDLParser::Udp_data_typeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUdp_data_type(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Udp_data_typeContext* SystemRDLParser::udp_data_type() {
  Udp_data_typeContext *_localctx = _tracker.createInstance<Udp_data_typeContext>(_ctx, getState());
  enterRule(_localctx, 124, SystemRDLParser::RuleUdp_data_type);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(644);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::ADDRMAP_kw:
      case SystemRDLParser::REGFILE_kw:
      case SystemRDLParser::REG_kw:
      case SystemRDLParser::FIELD_kw:
      case SystemRDLParser::MEM_kw: {
        enterOuterAlt(_localctx, 1);
        setState(641);
        component_type_primary();
        break;
      }

      case SystemRDLParser::NUMBER_kw:
      case SystemRDLParser::REF_kw: {
        enterOuterAlt(_localctx, 2);
        setState(642);
        antlrcpp::downCast<Udp_data_typeContext *>(_localctx)->kw = _input->LT(1);
        _la = _input->LA(1);
        if (!(_la == SystemRDLParser::NUMBER_kw

        || _la == SystemRDLParser::REF_kw)) {
          antlrcpp::downCast<Udp_data_typeContext *>(_localctx)->kw = _errHandler->recoverInline(this);
        }
        else {
          _errHandler->reportMatch(this);
          consume();
        }
        break;
      }

      case SystemRDLParser::BOOLEAN_kw:
      case SystemRDLParser::BIT_kw:
      case SystemRDLParser::LONGINT_kw:
      case SystemRDLParser::STRING_kw:
      case SystemRDLParser::ID: {
        enterOuterAlt(_localctx, 3);
        setState(643);
        basic_data_type();
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Udp_usageContext ------------------------------------------------------------------

SystemRDLParser::Udp_usageContext::Udp_usageContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Udp_usageContext::COMPONENT_kw() {
  return getToken(SystemRDLParser::COMPONENT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Udp_usageContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

std::vector<SystemRDLParser::Udp_comp_typeContext *> SystemRDLParser::Udp_usageContext::udp_comp_type() {
  return getRuleContexts<SystemRDLParser::Udp_comp_typeContext>();
}

SystemRDLParser::Udp_comp_typeContext* SystemRDLParser::Udp_usageContext::udp_comp_type(size_t i) {
  return getRuleContext<SystemRDLParser::Udp_comp_typeContext>(i);
}

std::vector<tree::TerminalNode *> SystemRDLParser::Udp_usageContext::OR() {
  return getTokens(SystemRDLParser::OR);
}

tree::TerminalNode* SystemRDLParser::Udp_usageContext::OR(size_t i) {
  return getToken(SystemRDLParser::OR, i);
}


size_t SystemRDLParser::Udp_usageContext::getRuleIndex() const {
  return SystemRDLParser::RuleUdp_usage;
}


std::any SystemRDLParser::Udp_usageContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUdp_usage(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Udp_usageContext* SystemRDLParser::udp_usage() {
  Udp_usageContext *_localctx = _tracker.createInstance<Udp_usageContext>(_ctx, getState());
  enterRule(_localctx, 126, SystemRDLParser::RuleUdp_usage);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(646);
    match(SystemRDLParser::COMPONENT_kw);
    setState(647);
    match(SystemRDLParser::ASSIGN);
    setState(648);
    udp_comp_type();
    setState(653);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SystemRDLParser::OR) {
      setState(649);
      match(SystemRDLParser::OR);
      setState(650);
      udp_comp_type();
      setState(655);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Udp_comp_typeContext ------------------------------------------------------------------

SystemRDLParser::Udp_comp_typeContext::Udp_comp_typeContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Component_typeContext* SystemRDLParser::Udp_comp_typeContext::component_type() {
  return getRuleContext<SystemRDLParser::Component_typeContext>(0);
}

tree::TerminalNode* SystemRDLParser::Udp_comp_typeContext::CONSTRAINT_kw() {
  return getToken(SystemRDLParser::CONSTRAINT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Udp_comp_typeContext::ALL_kw() {
  return getToken(SystemRDLParser::ALL_kw, 0);
}


size_t SystemRDLParser::Udp_comp_typeContext::getRuleIndex() const {
  return SystemRDLParser::RuleUdp_comp_type;
}


std::any SystemRDLParser::Udp_comp_typeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUdp_comp_type(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Udp_comp_typeContext* SystemRDLParser::udp_comp_type() {
  Udp_comp_typeContext *_localctx = _tracker.createInstance<Udp_comp_typeContext>(_ctx, getState());
  enterRule(_localctx, 128, SystemRDLParser::RuleUdp_comp_type);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(658);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::ADDRMAP_kw:
      case SystemRDLParser::REGFILE_kw:
      case SystemRDLParser::REG_kw:
      case SystemRDLParser::FIELD_kw:
      case SystemRDLParser::MEM_kw:
      case SystemRDLParser::SIGNAL_kw: {
        enterOuterAlt(_localctx, 1);
        setState(656);
        component_type();
        break;
      }

      case SystemRDLParser::ALL_kw:
      case SystemRDLParser::CONSTRAINT_kw: {
        enterOuterAlt(_localctx, 2);
        setState(657);
        antlrcpp::downCast<Udp_comp_typeContext *>(_localctx)->kw = _input->LT(1);
        _la = _input->LA(1);
        if (!(_la == SystemRDLParser::ALL_kw

        || _la == SystemRDLParser::CONSTRAINT_kw)) {
          antlrcpp::downCast<Udp_comp_typeContext *>(_localctx)->kw = _errHandler->recoverInline(this);
        }
        else {
          _errHandler->reportMatch(this);
          consume();
        }
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Udp_defaultContext ------------------------------------------------------------------

SystemRDLParser::Udp_defaultContext::Udp_defaultContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Udp_defaultContext::DEFAULT_kw() {
  return getToken(SystemRDLParser::DEFAULT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Udp_defaultContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

SystemRDLParser::ExprContext* SystemRDLParser::Udp_defaultContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Udp_defaultContext::getRuleIndex() const {
  return SystemRDLParser::RuleUdp_default;
}


std::any SystemRDLParser::Udp_defaultContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUdp_default(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Udp_defaultContext* SystemRDLParser::udp_default() {
  Udp_defaultContext *_localctx = _tracker.createInstance<Udp_defaultContext>(_ctx, getState());
  enterRule(_localctx, 130, SystemRDLParser::RuleUdp_default);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(660);
    match(SystemRDLParser::DEFAULT_kw);
    setState(661);
    match(SystemRDLParser::ASSIGN);
    setState(662);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Udp_constraintContext ------------------------------------------------------------------

SystemRDLParser::Udp_constraintContext::Udp_constraintContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Udp_constraintContext::CONSTRAINT_kw() {
  return getToken(SystemRDLParser::CONSTRAINT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Udp_constraintContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

tree::TerminalNode* SystemRDLParser::Udp_constraintContext::COMPONENTWIDTH_kw() {
  return getToken(SystemRDLParser::COMPONENTWIDTH_kw, 0);
}


size_t SystemRDLParser::Udp_constraintContext::getRuleIndex() const {
  return SystemRDLParser::RuleUdp_constraint;
}


std::any SystemRDLParser::Udp_constraintContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitUdp_constraint(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Udp_constraintContext* SystemRDLParser::udp_constraint() {
  Udp_constraintContext *_localctx = _tracker.createInstance<Udp_constraintContext>(_ctx, getState());
  enterRule(_localctx, 132, SystemRDLParser::RuleUdp_constraint);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(664);
    match(SystemRDLParser::CONSTRAINT_kw);
    setState(665);
    match(SystemRDLParser::ASSIGN);
    setState(666);
    match(SystemRDLParser::COMPONENTWIDTH_kw);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Enum_defContext ------------------------------------------------------------------

SystemRDLParser::Enum_defContext::Enum_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Enum_defContext::ENUM_kw() {
  return getToken(SystemRDLParser::ENUM_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Enum_defContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

std::vector<SystemRDLParser::Enum_entryContext *> SystemRDLParser::Enum_defContext::enum_entry() {
  return getRuleContexts<SystemRDLParser::Enum_entryContext>();
}

SystemRDLParser::Enum_entryContext* SystemRDLParser::Enum_defContext::enum_entry(size_t i) {
  return getRuleContext<SystemRDLParser::Enum_entryContext>(i);
}


size_t SystemRDLParser::Enum_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleEnum_def;
}


std::any SystemRDLParser::Enum_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitEnum_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Enum_defContext* SystemRDLParser::enum_def() {
  Enum_defContext *_localctx = _tracker.createInstance<Enum_defContext>(_ctx, getState());
  enterRule(_localctx, 134, SystemRDLParser::RuleEnum_def);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(668);
    match(SystemRDLParser::ENUM_kw);
    setState(669);
    match(SystemRDLParser::ID);
    setState(670);
    match(SystemRDLParser::T__1);
    setState(674); 
    _errHandler->sync(this);
    _la = _input->LA(1);
    do {
      setState(671);
      enum_entry();
      setState(672);
      match(SystemRDLParser::T__0);
      setState(676); 
      _errHandler->sync(this);
      _la = _input->LA(1);
    } while (_la == SystemRDLParser::ID);
    setState(678);
    match(SystemRDLParser::T__2);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Enum_entryContext ------------------------------------------------------------------

SystemRDLParser::Enum_entryContext::Enum_entryContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Enum_entryContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

tree::TerminalNode* SystemRDLParser::Enum_entryContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

SystemRDLParser::ExprContext* SystemRDLParser::Enum_entryContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}

std::vector<SystemRDLParser::Enum_prop_assignContext *> SystemRDLParser::Enum_entryContext::enum_prop_assign() {
  return getRuleContexts<SystemRDLParser::Enum_prop_assignContext>();
}

SystemRDLParser::Enum_prop_assignContext* SystemRDLParser::Enum_entryContext::enum_prop_assign(size_t i) {
  return getRuleContext<SystemRDLParser::Enum_prop_assignContext>(i);
}


size_t SystemRDLParser::Enum_entryContext::getRuleIndex() const {
  return SystemRDLParser::RuleEnum_entry;
}


std::any SystemRDLParser::Enum_entryContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitEnum_entry(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Enum_entryContext* SystemRDLParser::enum_entry() {
  Enum_entryContext *_localctx = _tracker.createInstance<Enum_entryContext>(_ctx, getState());
  enterRule(_localctx, 136, SystemRDLParser::RuleEnum_entry);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(680);
    match(SystemRDLParser::ID);
    setState(683);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::ASSIGN) {
      setState(681);
      match(SystemRDLParser::ASSIGN);
      setState(682);
      expr(0);
    }
    setState(695);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::T__1) {
      setState(685);
      match(SystemRDLParser::T__1);
      setState(691);
      _errHandler->sync(this);
      _la = _input->LA(1);
      while (_la == SystemRDLParser::ID) {
        setState(686);
        enum_prop_assign();
        setState(687);
        match(SystemRDLParser::T__0);
        setState(693);
        _errHandler->sync(this);
        _la = _input->LA(1);
      }
      setState(694);
      match(SystemRDLParser::T__2);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Enum_prop_assignContext ------------------------------------------------------------------

SystemRDLParser::Enum_prop_assignContext::Enum_prop_assignContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Enum_prop_assignContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

tree::TerminalNode* SystemRDLParser::Enum_prop_assignContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

SystemRDLParser::ExprContext* SystemRDLParser::Enum_prop_assignContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Enum_prop_assignContext::getRuleIndex() const {
  return SystemRDLParser::RuleEnum_prop_assign;
}


std::any SystemRDLParser::Enum_prop_assignContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitEnum_prop_assign(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Enum_prop_assignContext* SystemRDLParser::enum_prop_assign() {
  Enum_prop_assignContext *_localctx = _tracker.createInstance<Enum_prop_assignContext>(_ctx, getState());
  enterRule(_localctx, 138, SystemRDLParser::RuleEnum_prop_assign);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(697);
    match(SystemRDLParser::ID);
    setState(698);
    match(SystemRDLParser::ASSIGN);
    setState(699);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Struct_defContext ------------------------------------------------------------------

SystemRDLParser::Struct_defContext::Struct_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Struct_defContext::STRUCT_kw() {
  return getToken(SystemRDLParser::STRUCT_kw, 0);
}

std::vector<tree::TerminalNode *> SystemRDLParser::Struct_defContext::ID() {
  return getTokens(SystemRDLParser::ID);
}

tree::TerminalNode* SystemRDLParser::Struct_defContext::ID(size_t i) {
  return getToken(SystemRDLParser::ID, i);
}

tree::TerminalNode* SystemRDLParser::Struct_defContext::ABSTRACT_kw() {
  return getToken(SystemRDLParser::ABSTRACT_kw, 0);
}

std::vector<SystemRDLParser::Struct_elemContext *> SystemRDLParser::Struct_defContext::struct_elem() {
  return getRuleContexts<SystemRDLParser::Struct_elemContext>();
}

SystemRDLParser::Struct_elemContext* SystemRDLParser::Struct_defContext::struct_elem(size_t i) {
  return getRuleContext<SystemRDLParser::Struct_elemContext>(i);
}


size_t SystemRDLParser::Struct_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleStruct_def;
}


std::any SystemRDLParser::Struct_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitStruct_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Struct_defContext* SystemRDLParser::struct_def() {
  Struct_defContext *_localctx = _tracker.createInstance<Struct_defContext>(_ctx, getState());
  enterRule(_localctx, 140, SystemRDLParser::RuleStruct_def);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(702);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::ABSTRACT_kw) {
      setState(701);
      match(SystemRDLParser::ABSTRACT_kw);
    }
    setState(704);
    match(SystemRDLParser::STRUCT_kw);
    setState(705);
    antlrcpp::downCast<Struct_defContext *>(_localctx)->name = match(SystemRDLParser::ID);
    setState(708);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::T__9) {
      setState(706);
      match(SystemRDLParser::T__9);
      setState(707);
      antlrcpp::downCast<Struct_defContext *>(_localctx)->base = match(SystemRDLParser::ID);
    }
    setState(710);
    match(SystemRDLParser::T__1);
    setState(716);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while ((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & 67777593344) != 0) || _la == SystemRDLParser::ID) {
      setState(711);
      struct_elem();
      setState(712);
      match(SystemRDLParser::T__0);
      setState(718);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(719);
    match(SystemRDLParser::T__2);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Struct_elemContext ------------------------------------------------------------------

SystemRDLParser::Struct_elemContext::Struct_elemContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Struct_typeContext* SystemRDLParser::Struct_elemContext::struct_type() {
  return getRuleContext<SystemRDLParser::Struct_typeContext>(0);
}

tree::TerminalNode* SystemRDLParser::Struct_elemContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

SystemRDLParser::Array_type_suffixContext* SystemRDLParser::Struct_elemContext::array_type_suffix() {
  return getRuleContext<SystemRDLParser::Array_type_suffixContext>(0);
}


size_t SystemRDLParser::Struct_elemContext::getRuleIndex() const {
  return SystemRDLParser::RuleStruct_elem;
}


std::any SystemRDLParser::Struct_elemContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitStruct_elem(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Struct_elemContext* SystemRDLParser::struct_elem() {
  Struct_elemContext *_localctx = _tracker.createInstance<Struct_elemContext>(_ctx, getState());
  enterRule(_localctx, 142, SystemRDLParser::RuleStruct_elem);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(721);
    struct_type();
    setState(722);
    match(SystemRDLParser::ID);
    setState(724);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SystemRDLParser::T__11) {
      setState(723);
      array_type_suffix();
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Struct_typeContext ------------------------------------------------------------------

SystemRDLParser::Struct_typeContext::Struct_typeContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Data_typeContext* SystemRDLParser::Struct_typeContext::data_type() {
  return getRuleContext<SystemRDLParser::Data_typeContext>(0);
}

SystemRDLParser::Component_typeContext* SystemRDLParser::Struct_typeContext::component_type() {
  return getRuleContext<SystemRDLParser::Component_typeContext>(0);
}


size_t SystemRDLParser::Struct_typeContext::getRuleIndex() const {
  return SystemRDLParser::RuleStruct_type;
}


std::any SystemRDLParser::Struct_typeContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitStruct_type(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Struct_typeContext* SystemRDLParser::struct_type() {
  Struct_typeContext *_localctx = _tracker.createInstance<Struct_typeContext>(_ctx, getState());
  enterRule(_localctx, 144, SystemRDLParser::RuleStruct_type);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(728);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::BOOLEAN_kw:
      case SystemRDLParser::BIT_kw:
      case SystemRDLParser::LONGINT_kw:
      case SystemRDLParser::STRING_kw:
      case SystemRDLParser::ACCESSTYPE_kw:
      case SystemRDLParser::ADDRESSINGTYPE_kw:
      case SystemRDLParser::ONREADTYPE_kw:
      case SystemRDLParser::ONWRITETYPE_kw:
      case SystemRDLParser::ID: {
        enterOuterAlt(_localctx, 1);
        setState(726);
        data_type();
        break;
      }

      case SystemRDLParser::ADDRMAP_kw:
      case SystemRDLParser::REGFILE_kw:
      case SystemRDLParser::REG_kw:
      case SystemRDLParser::FIELD_kw:
      case SystemRDLParser::MEM_kw:
      case SystemRDLParser::SIGNAL_kw: {
        enterOuterAlt(_localctx, 2);
        setState(727);
        component_type();
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constraint_defContext ------------------------------------------------------------------

SystemRDLParser::Constraint_defContext::Constraint_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Constraint_named_defContext* SystemRDLParser::Constraint_defContext::constraint_named_def() {
  return getRuleContext<SystemRDLParser::Constraint_named_defContext>(0);
}

SystemRDLParser::Constraint_instsContext* SystemRDLParser::Constraint_defContext::constraint_insts() {
  return getRuleContext<SystemRDLParser::Constraint_instsContext>(0);
}

SystemRDLParser::Constraint_anon_defContext* SystemRDLParser::Constraint_defContext::constraint_anon_def() {
  return getRuleContext<SystemRDLParser::Constraint_anon_defContext>(0);
}


size_t SystemRDLParser::Constraint_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstraint_def;
}


std::any SystemRDLParser::Constraint_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstraint_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constraint_defContext* SystemRDLParser::constraint_def() {
  Constraint_defContext *_localctx = _tracker.createInstance<Constraint_defContext>(_ctx, getState());
  enterRule(_localctx, 146, SystemRDLParser::RuleConstraint_def);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(737);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 67, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(730);
      constraint_named_def();
      setState(732);
      _errHandler->sync(this);

      _la = _input->LA(1);
      if (_la == SystemRDLParser::ID) {
        setState(731);
        constraint_insts();
      }
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(734);
      constraint_anon_def();
      setState(735);
      constraint_insts();
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constraint_named_defContext ------------------------------------------------------------------

SystemRDLParser::Constraint_named_defContext::Constraint_named_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Constraint_named_defContext::CONSTRAINT_kw() {
  return getToken(SystemRDLParser::CONSTRAINT_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Constraint_named_defContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

SystemRDLParser::Constraint_bodyContext* SystemRDLParser::Constraint_named_defContext::constraint_body() {
  return getRuleContext<SystemRDLParser::Constraint_bodyContext>(0);
}


size_t SystemRDLParser::Constraint_named_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstraint_named_def;
}


std::any SystemRDLParser::Constraint_named_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstraint_named_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constraint_named_defContext* SystemRDLParser::constraint_named_def() {
  Constraint_named_defContext *_localctx = _tracker.createInstance<Constraint_named_defContext>(_ctx, getState());
  enterRule(_localctx, 148, SystemRDLParser::RuleConstraint_named_def);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(739);
    match(SystemRDLParser::CONSTRAINT_kw);
    setState(740);
    match(SystemRDLParser::ID);
    setState(741);
    constraint_body();
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constraint_anon_defContext ------------------------------------------------------------------

SystemRDLParser::Constraint_anon_defContext::Constraint_anon_defContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Constraint_anon_defContext::CONSTRAINT_kw() {
  return getToken(SystemRDLParser::CONSTRAINT_kw, 0);
}

SystemRDLParser::Constraint_bodyContext* SystemRDLParser::Constraint_anon_defContext::constraint_body() {
  return getRuleContext<SystemRDLParser::Constraint_bodyContext>(0);
}


size_t SystemRDLParser::Constraint_anon_defContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstraint_anon_def;
}


std::any SystemRDLParser::Constraint_anon_defContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstraint_anon_def(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constraint_anon_defContext* SystemRDLParser::constraint_anon_def() {
  Constraint_anon_defContext *_localctx = _tracker.createInstance<Constraint_anon_defContext>(_ctx, getState());
  enterRule(_localctx, 150, SystemRDLParser::RuleConstraint_anon_def);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(743);
    match(SystemRDLParser::CONSTRAINT_kw);
    setState(744);
    constraint_body();
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constraint_bodyContext ------------------------------------------------------------------

SystemRDLParser::Constraint_bodyContext::Constraint_bodyContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::Constraint_body_elemContext *> SystemRDLParser::Constraint_bodyContext::constraint_body_elem() {
  return getRuleContexts<SystemRDLParser::Constraint_body_elemContext>();
}

SystemRDLParser::Constraint_body_elemContext* SystemRDLParser::Constraint_bodyContext::constraint_body_elem(size_t i) {
  return getRuleContext<SystemRDLParser::Constraint_body_elemContext>(i);
}


size_t SystemRDLParser::Constraint_bodyContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstraint_body;
}


std::any SystemRDLParser::Constraint_bodyContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstraint_body(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constraint_bodyContext* SystemRDLParser::constraint_body() {
  Constraint_bodyContext *_localctx = _tracker.createInstance<Constraint_bodyContext>(_ctx, getState());
  enterRule(_localctx, 152, SystemRDLParser::RuleConstraint_body);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(746);
    match(SystemRDLParser::T__1);
    setState(752);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while ((((_la & ~ 0x3fULL) == 0) &&
      ((1ULL << _la) & 4611685949709748292) != 0) || ((((_la - 80) & ~ 0x3fULL) == 0) &&
      ((1ULL << (_la - 80)) & 35184622694401) != 0)) {
      setState(747);
      constraint_body_elem();
      setState(748);
      match(SystemRDLParser::T__0);
      setState(754);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(755);
    match(SystemRDLParser::T__2);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constraint_body_elemContext ------------------------------------------------------------------

SystemRDLParser::Constraint_body_elemContext::Constraint_body_elemContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Constr_relationalContext* SystemRDLParser::Constraint_body_elemContext::constr_relational() {
  return getRuleContext<SystemRDLParser::Constr_relationalContext>(0);
}

SystemRDLParser::Constr_prop_assignContext* SystemRDLParser::Constraint_body_elemContext::constr_prop_assign() {
  return getRuleContext<SystemRDLParser::Constr_prop_assignContext>(0);
}

SystemRDLParser::Constr_inside_valuesContext* SystemRDLParser::Constraint_body_elemContext::constr_inside_values() {
  return getRuleContext<SystemRDLParser::Constr_inside_valuesContext>(0);
}

SystemRDLParser::Constr_inside_enumContext* SystemRDLParser::Constraint_body_elemContext::constr_inside_enum() {
  return getRuleContext<SystemRDLParser::Constr_inside_enumContext>(0);
}


size_t SystemRDLParser::Constraint_body_elemContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstraint_body_elem;
}


std::any SystemRDLParser::Constraint_body_elemContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstraint_body_elem(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constraint_body_elemContext* SystemRDLParser::constraint_body_elem() {
  Constraint_body_elemContext *_localctx = _tracker.createInstance<Constraint_body_elemContext>(_ctx, getState());
  enterRule(_localctx, 154, SystemRDLParser::RuleConstraint_body_elem);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(761);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 69, _ctx)) {
    case 1: {
      enterOuterAlt(_localctx, 1);
      setState(757);
      constr_relational();
      break;
    }

    case 2: {
      enterOuterAlt(_localctx, 2);
      setState(758);
      constr_prop_assign();
      break;
    }

    case 3: {
      enterOuterAlt(_localctx, 3);
      setState(759);
      constr_inside_values();
      break;
    }

    case 4: {
      enterOuterAlt(_localctx, 4);
      setState(760);
      constr_inside_enum();
      break;
    }

    default:
      break;
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constraint_instsContext ------------------------------------------------------------------

SystemRDLParser::Constraint_instsContext::Constraint_instsContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<tree::TerminalNode *> SystemRDLParser::Constraint_instsContext::ID() {
  return getTokens(SystemRDLParser::ID);
}

tree::TerminalNode* SystemRDLParser::Constraint_instsContext::ID(size_t i) {
  return getToken(SystemRDLParser::ID, i);
}


size_t SystemRDLParser::Constraint_instsContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstraint_insts;
}


std::any SystemRDLParser::Constraint_instsContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstraint_insts(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constraint_instsContext* SystemRDLParser::constraint_insts() {
  Constraint_instsContext *_localctx = _tracker.createInstance<Constraint_instsContext>(_ctx, getState());
  enterRule(_localctx, 156, SystemRDLParser::RuleConstraint_insts);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(763);
    match(SystemRDLParser::ID);
    setState(768);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SystemRDLParser::T__3) {
      setState(764);
      match(SystemRDLParser::T__3);
      setState(765);
      match(SystemRDLParser::ID);
      setState(770);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constr_relationalContext ------------------------------------------------------------------

SystemRDLParser::Constr_relationalContext::Constr_relationalContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::ExprContext *> SystemRDLParser::Constr_relationalContext::expr() {
  return getRuleContexts<SystemRDLParser::ExprContext>();
}

SystemRDLParser::ExprContext* SystemRDLParser::Constr_relationalContext::expr(size_t i) {
  return getRuleContext<SystemRDLParser::ExprContext>(i);
}

tree::TerminalNode* SystemRDLParser::Constr_relationalContext::LT() {
  return getToken(SystemRDLParser::LT, 0);
}

tree::TerminalNode* SystemRDLParser::Constr_relationalContext::LEQ() {
  return getToken(SystemRDLParser::LEQ, 0);
}

tree::TerminalNode* SystemRDLParser::Constr_relationalContext::GT() {
  return getToken(SystemRDLParser::GT, 0);
}

tree::TerminalNode* SystemRDLParser::Constr_relationalContext::GEQ() {
  return getToken(SystemRDLParser::GEQ, 0);
}

tree::TerminalNode* SystemRDLParser::Constr_relationalContext::EQ() {
  return getToken(SystemRDLParser::EQ, 0);
}

tree::TerminalNode* SystemRDLParser::Constr_relationalContext::NEQ() {
  return getToken(SystemRDLParser::NEQ, 0);
}


size_t SystemRDLParser::Constr_relationalContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstr_relational;
}


std::any SystemRDLParser::Constr_relationalContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstr_relational(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constr_relationalContext* SystemRDLParser::constr_relational() {
  Constr_relationalContext *_localctx = _tracker.createInstance<Constr_relationalContext>(_ctx, getState());
  enterRule(_localctx, 158, SystemRDLParser::RuleConstr_relational);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(771);
    expr(0);
    setState(772);
    antlrcpp::downCast<Constr_relationalContext *>(_localctx)->op = _input->LT(1);
    _la = _input->LA(1);
    if (!(((((_la - 114) & ~ 0x3fULL) == 0) &&
      ((1ULL << (_la - 114)) & 125) != 0))) {
      antlrcpp::downCast<Constr_relationalContext *>(_localctx)->op = _errHandler->recoverInline(this);
    }
    else {
      _errHandler->reportMatch(this);
      consume();
    }
    setState(773);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constr_prop_assignContext ------------------------------------------------------------------

SystemRDLParser::Constr_prop_assignContext::Constr_prop_assignContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Constr_prop_assignContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}

tree::TerminalNode* SystemRDLParser::Constr_prop_assignContext::ASSIGN() {
  return getToken(SystemRDLParser::ASSIGN, 0);
}

SystemRDLParser::ExprContext* SystemRDLParser::Constr_prop_assignContext::expr() {
  return getRuleContext<SystemRDLParser::ExprContext>(0);
}


size_t SystemRDLParser::Constr_prop_assignContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstr_prop_assign;
}


std::any SystemRDLParser::Constr_prop_assignContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstr_prop_assign(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constr_prop_assignContext* SystemRDLParser::constr_prop_assign() {
  Constr_prop_assignContext *_localctx = _tracker.createInstance<Constr_prop_assignContext>(_ctx, getState());
  enterRule(_localctx, 160, SystemRDLParser::RuleConstr_prop_assign);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(775);
    match(SystemRDLParser::ID);
    setState(776);
    match(SystemRDLParser::ASSIGN);
    setState(777);
    expr(0);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constr_inside_valuesContext ------------------------------------------------------------------

SystemRDLParser::Constr_inside_valuesContext::Constr_inside_valuesContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Constr_lhsContext* SystemRDLParser::Constr_inside_valuesContext::constr_lhs() {
  return getRuleContext<SystemRDLParser::Constr_lhsContext>(0);
}

tree::TerminalNode* SystemRDLParser::Constr_inside_valuesContext::INSIDE_kw() {
  return getToken(SystemRDLParser::INSIDE_kw, 0);
}

std::vector<SystemRDLParser::Constr_inside_valueContext *> SystemRDLParser::Constr_inside_valuesContext::constr_inside_value() {
  return getRuleContexts<SystemRDLParser::Constr_inside_valueContext>();
}

SystemRDLParser::Constr_inside_valueContext* SystemRDLParser::Constr_inside_valuesContext::constr_inside_value(size_t i) {
  return getRuleContext<SystemRDLParser::Constr_inside_valueContext>(i);
}


size_t SystemRDLParser::Constr_inside_valuesContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstr_inside_values;
}


std::any SystemRDLParser::Constr_inside_valuesContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstr_inside_values(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constr_inside_valuesContext* SystemRDLParser::constr_inside_values() {
  Constr_inside_valuesContext *_localctx = _tracker.createInstance<Constr_inside_valuesContext>(_ctx, getState());
  enterRule(_localctx, 162, SystemRDLParser::RuleConstr_inside_values);
  size_t _la = 0;

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(779);
    constr_lhs();
    setState(780);
    match(SystemRDLParser::INSIDE_kw);
    setState(781);
    match(SystemRDLParser::T__1);
    setState(782);
    constr_inside_value();
    setState(787);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SystemRDLParser::T__3) {
      setState(783);
      match(SystemRDLParser::T__3);
      setState(784);
      constr_inside_value();
      setState(789);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(790);
    match(SystemRDLParser::T__2);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constr_inside_enumContext ------------------------------------------------------------------

SystemRDLParser::Constr_inside_enumContext::Constr_inside_enumContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

SystemRDLParser::Constr_lhsContext* SystemRDLParser::Constr_inside_enumContext::constr_lhs() {
  return getRuleContext<SystemRDLParser::Constr_lhsContext>(0);
}

tree::TerminalNode* SystemRDLParser::Constr_inside_enumContext::INSIDE_kw() {
  return getToken(SystemRDLParser::INSIDE_kw, 0);
}

tree::TerminalNode* SystemRDLParser::Constr_inside_enumContext::ID() {
  return getToken(SystemRDLParser::ID, 0);
}


size_t SystemRDLParser::Constr_inside_enumContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstr_inside_enum;
}


std::any SystemRDLParser::Constr_inside_enumContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstr_inside_enum(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constr_inside_enumContext* SystemRDLParser::constr_inside_enum() {
  Constr_inside_enumContext *_localctx = _tracker.createInstance<Constr_inside_enumContext>(_ctx, getState());
  enterRule(_localctx, 164, SystemRDLParser::RuleConstr_inside_enum);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(792);
    constr_lhs();
    setState(793);
    match(SystemRDLParser::INSIDE_kw);
    setState(794);
    match(SystemRDLParser::ID);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constr_lhsContext ------------------------------------------------------------------

SystemRDLParser::Constr_lhsContext::Constr_lhsContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

tree::TerminalNode* SystemRDLParser::Constr_lhsContext::THIS_kw() {
  return getToken(SystemRDLParser::THIS_kw, 0);
}

SystemRDLParser::Instance_refContext* SystemRDLParser::Constr_lhsContext::instance_ref() {
  return getRuleContext<SystemRDLParser::Instance_refContext>(0);
}


size_t SystemRDLParser::Constr_lhsContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstr_lhs;
}


std::any SystemRDLParser::Constr_lhsContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstr_lhs(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constr_lhsContext* SystemRDLParser::constr_lhs() {
  Constr_lhsContext *_localctx = _tracker.createInstance<Constr_lhsContext>(_ctx, getState());
  enterRule(_localctx, 166, SystemRDLParser::RuleConstr_lhs);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(798);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::THIS_kw: {
        enterOuterAlt(_localctx, 1);
        setState(796);
        match(SystemRDLParser::THIS_kw);
        break;
      }

      case SystemRDLParser::ID: {
        enterOuterAlt(_localctx, 2);
        setState(797);
        instance_ref();
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constr_inside_valueContext ------------------------------------------------------------------

SystemRDLParser::Constr_inside_valueContext::Constr_inside_valueContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<SystemRDLParser::ExprContext *> SystemRDLParser::Constr_inside_valueContext::expr() {
  return getRuleContexts<SystemRDLParser::ExprContext>();
}

SystemRDLParser::ExprContext* SystemRDLParser::Constr_inside_valueContext::expr(size_t i) {
  return getRuleContext<SystemRDLParser::ExprContext>(i);
}


size_t SystemRDLParser::Constr_inside_valueContext::getRuleIndex() const {
  return SystemRDLParser::RuleConstr_inside_value;
}


std::any SystemRDLParser::Constr_inside_valueContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<SystemRDLVisitor*>(visitor))
    return parserVisitor->visitConstr_inside_value(this);
  else
    return visitor->visitChildren(this);
}

SystemRDLParser::Constr_inside_valueContext* SystemRDLParser::constr_inside_value() {
  Constr_inside_valueContext *_localctx = _tracker.createInstance<Constr_inside_valueContext>(_ctx, getState());
  enterRule(_localctx, 168, SystemRDLParser::RuleConstr_inside_value);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    setState(807);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SystemRDLParser::T__1:
      case SystemRDLParser::T__5:
      case SystemRDLParser::T__10:
      case SystemRDLParser::BOOLEAN_kw:
      case SystemRDLParser::BIT_kw:
      case SystemRDLParser::LONGINT_kw:
      case SystemRDLParser::TRUE_kw:
      case SystemRDLParser::FALSE_kw:
      case SystemRDLParser::NA_kw:
      case SystemRDLParser::RW_kw:
      case SystemRDLParser::WR_kw:
      case SystemRDLParser::R_kw:
      case SystemRDLParser::W_kw:
      case SystemRDLParser::RW1_kw:
      case SystemRDLParser::W1_kw:
      case SystemRDLParser::RCLR_kw:
      case SystemRDLParser::RSET_kw:
      case SystemRDLParser::RUSER_kw:
      case SystemRDLParser::WOSET_kw:
      case SystemRDLParser::WOCLR_kw:
      case SystemRDLParser::WOT_kw:
      case SystemRDLParser::WZS_kw:
      case SystemRDLParser::WZC_kw:
      case SystemRDLParser::WZT_kw:
      case SystemRDLParser::WCLR_kw:
      case SystemRDLParser::WSET_kw:
      case SystemRDLParser::WUSER_kw:
      case SystemRDLParser::COMPACT_kw:
      case SystemRDLParser::REGALIGN_kw:
      case SystemRDLParser::FULLALIGN_kw:
      case SystemRDLParser::HW_kw:
      case SystemRDLParser::SW_kw:
      case SystemRDLParser::INT:
      case SystemRDLParser::HEX_INT:
      case SystemRDLParser::VLOG_INT:
      case SystemRDLParser::STRING:
      case SystemRDLParser::PLUS:
      case SystemRDLParser::MINUS:
      case SystemRDLParser::BNOT:
      case SystemRDLParser::NOT:
      case SystemRDLParser::NAND:
      case SystemRDLParser::AND:
      case SystemRDLParser::OR:
      case SystemRDLParser::NOR:
      case SystemRDLParser::XOR:
      case SystemRDLParser::XNOR:
      case SystemRDLParser::ID: {
        enterOuterAlt(_localctx, 1);
        setState(800);
        antlrcpp::downCast<Constr_inside_valueContext *>(_localctx)->val = expr(0);
        break;
      }

      case SystemRDLParser::T__11: {
        enterOuterAlt(_localctx, 2);
        setState(801);
        match(SystemRDLParser::T__11);
        setState(802);
        antlrcpp::downCast<Constr_inside_valueContext *>(_localctx)->l_val = expr(0);
        setState(803);
        match(SystemRDLParser::T__9);
        setState(804);
        antlrcpp::downCast<Constr_inside_valueContext *>(_localctx)->r_val = expr(0);
        setState(805);
        match(SystemRDLParser::T__12);
        break;
      }

    default:
      throw NoViableAltException(this);
    }
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

bool SystemRDLParser::sempred(RuleContext *context, size_t ruleIndex, size_t predicateIndex) {
  switch (ruleIndex) {
    case 23: return exprSempred(antlrcpp::downCast<ExprContext *>(context), predicateIndex);

  default:
    break;
  }
  return true;
}

bool SystemRDLParser::exprSempred(ExprContext *_localctx, size_t predicateIndex) {
  switch (predicateIndex) {
    case 0: return precpred(_ctx, 13);
    case 1: return precpred(_ctx, 12);
    case 2: return precpred(_ctx, 11);
    case 3: return precpred(_ctx, 10);
    case 4: return precpred(_ctx, 9);
    case 5: return precpred(_ctx, 8);
    case 6: return precpred(_ctx, 7);
    case 7: return precpred(_ctx, 6);
    case 8: return precpred(_ctx, 5);
    case 9: return precpred(_ctx, 4);
    case 10: return precpred(_ctx, 3);
    case 11: return precpred(_ctx, 2);

  default:
    break;
  }
  return true;
}

void SystemRDLParser::initialize() {
#if ANTLR4_USE_THREAD_LOCAL_CACHE
  systemrdlParserInitialize();
#else
  ::antlr4::internal::call_once(systemrdlParserOnceFlag, systemrdlParserInitialize);
#endif
}
