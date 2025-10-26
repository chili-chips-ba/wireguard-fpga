grammar SystemRDL;

root: (root_elem ';')* EOF;

eval_expr_root: expr EOF;

root_elem : component_def
          | enum_def
          | udp_def
          | struct_def
          | constraint_def
          | explicit_component_inst
          | local_property_assignment
          | dynamic_property_assignment
          ;

//------------------------------------------------------------------------------
// Components
//------------------------------------------------------------------------------

component_def : component_named_def ( (component_inst_type component_insts)
                | component_insts?
                )
              | component_anon_def ( (component_inst_type component_insts)
                | component_insts
                )
              | component_inst_type component_named_def component_insts
              | component_inst_type component_anon_def component_insts
              ;

explicit_component_inst : component_inst_type? component_inst_alias? ID component_insts;

component_inst_alias: ALIAS_kw ID;

component_named_def : component_type ID param_def? component_body;
component_anon_def  : component_type component_body;

component_body: '{' (component_body_elem ';')* '}';

component_body_elem : component_def
                    | enum_def
                    | struct_def
                    | constraint_def
                    | explicit_component_inst
                    | local_property_assignment
                    | dynamic_property_assignment
                    ;


component_insts: param_inst? component_inst (',' component_inst)*;
component_inst: ID ( array_suffix+ | range_suffix )? field_inst_reset?
                inst_addr_fixed?
                inst_addr_stride?
                inst_addr_align?
              ;

field_inst_reset: op=ASSIGN expr;
inst_addr_fixed : op=AT expr;
inst_addr_stride: op=INC expr;
inst_addr_align:  op=ALIGN expr;

component_inst_type : kw=(EXTERNAL_kw | INTERNAL_kw);

component_type: component_type_primary
              | kw=SIGNAL_kw
              ;

component_type_primary: kw=( ADDRMAP_kw
                           | REGFILE_kw
                           | REG_kw
                           | FIELD_kw
                           | MEM_kw
                           )
                      ;
//------------------------------------------------------------------------------
// Parameters
//------------------------------------------------------------------------------
// Parameter definition
param_def: '#' '(' param_def_elem (',' param_def_elem)* ')';
param_def_elem : data_type ID array_type_suffix? (ASSIGN expr)?;

// Parameter assignment list in instantiation
param_inst: '#' '(' param_assignment (',' param_assignment)* ')';
param_assignment: '.' ID '(' expr ')';

//------------------------------------------------------------------------------
// Expressions
//------------------------------------------------------------------------------

expr: op=(PLUS|MINUS|BNOT|NOT|AND|NAND|OR|NOR|XOR|XNOR) expr_primary  #UnaryExpr
    | expr op=EXP expr              #BinaryExpr
    | expr op=(MULT|DIV|MOD) expr   #BinaryExpr
    | expr op=(PLUS|MINUS) expr     #BinaryExpr
    | expr op=(LSHIFT|RSHIFT) expr  #BinaryExpr
    | expr op=(LT|LEQ|GT|GEQ) expr  #BinaryExpr
    | expr op=(EQ|NEQ) expr         #BinaryExpr
    | expr op=AND expr              #BinaryExpr
    | expr op=(XOR|XNOR) expr       #BinaryExpr
    | expr op=OR expr               #BinaryExpr
    | expr op=BAND expr             #BinaryExpr
    | expr op=BOR expr              #BinaryExpr
    | <assoc=right> expr op='?' expr ':' expr #TernaryExpr
    | expr_primary                  #NOP
    ;

expr_primary  : literal
              | concatenate
              | replicate
              | paren_expr
              | cast
              | prop_ref
              | instance_ref
              | struct_literal
              | array_literal
              ;

concatenate   : '{' expr (',' expr)* '}';

replicate     : '{' expr concatenate '}';

paren_expr: '(' expr ')';

cast  : typ=(BOOLEAN_kw|BIT_kw|LONGINT_kw) op='\'' '(' expr ')' #CastType
      | cast_width_expr op='\'' '(' expr ')'               #CastWidth
      ;

cast_width_expr : literal
                | paren_expr
                ;

//------------------------------------------------------------------------------
// Array and Range
//------------------------------------------------------------------------------
range_suffix: '[' expr ':' expr ']';
array_suffix:  '[' expr ']';
array_type_suffix: '[' ']';

//------------------------------------------------------------------------------
// Data Types
//------------------------------------------------------------------------------
data_type : basic_data_type
          | kw=(ACCESSTYPE_kw|ADDRESSINGTYPE_kw|ONREADTYPE_kw|ONWRITETYPE_kw)
          ;

basic_data_type : kw=(BIT_kw|LONGINT_kw) UNSIGNED_kw?
                | kw=(STRING_kw|BOOLEAN_kw|ID)
                ;

//------------------------------------------------------------------------------
// Literals
//------------------------------------------------------------------------------

literal : number
        | string_literal
        | boolean_literal
        | accesstype_literal
        | onreadtype_literal
        | onwritetype_literal
        | addressingtype_literal
        | precedencetype_literal
        | enum_literal
        ;

number : INT        #NumberInt
       | HEX_INT    #NumberHex
       | VLOG_INT   #NumberVerilog
       ;

string_literal  : STRING;

boolean_literal : val=(TRUE_kw|FALSE_kw);

array_literal : '\'' '{' '}'
              | '\'' '{' expr (',' expr )* '}';

struct_literal : ID '\'' '{' '}'
               | ID '\'' '{' struct_kv (',' struct_kv)* '}';

struct_kv : ID ':' expr ;

enum_literal : ID '::' ID;

accesstype_literal : kw=(NA_kw|RW_kw|WR_kw|R_kw|W_kw|RW1_kw|W1_kw);
onreadtype_literal : kw=(RCLR_kw|RSET_kw|RUSER_kw);
onwritetype_literal : kw=(WOSET_kw|WOCLR_kw|WOT_kw|WZS_kw|WZC_kw|WZT_kw|WCLR_kw|WSET_kw|WUSER_kw);
addressingtype_literal : kw=(COMPACT_kw|REGALIGN_kw|FULLALIGN_kw);
precedencetype_literal : kw=(HW_kw|SW_kw);

//------------------------------------------------------------------------------
// References
//------------------------------------------------------------------------------
instance_ref: instance_ref_element ('.' instance_ref_element)*;

instance_ref_element: ID array_suffix*;

prop_ref: instance_ref '->' (prop_keyword | ID);

//------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------

local_property_assignment : DEFAULT_kw? normal_prop_assign
                          | DEFAULT_kw? encode_prop_assign
                          | DEFAULT_kw? prop_mod_assign
                          ;

dynamic_property_assignment : instance_ref '->' normal_prop_assign
                            | instance_ref '->' encode_prop_assign
                            ;

normal_prop_assign: (prop_keyword | ID) ( ASSIGN prop_assignment_rhs )?;

encode_prop_assign: ENCODE_kw ASSIGN ID;

prop_mod_assign   : prop_mod ID;

prop_assignment_rhs : precedencetype_literal
                    | expr
                    ;

prop_keyword: kw=(SW_kw|HW_kw|RCLR_kw|RSET_kw|WOCLR_kw|WOSET_kw);
prop_mod    : kw=(POSEDGE_kw|NEGEDGE_kw|BOTHEDGE_kw|LEVEL_kw|NONSTICKY_kw);

//------------------------------------------------------------------------------
// User-defined properties
//------------------------------------------------------------------------------
udp_def : PROPERTY_kw ID '{' (udp_attr ';')+ '}';

udp_attr: udp_type
        | udp_usage
        | udp_default
        | udp_constraint
        ;

udp_type : TYPE_kw ASSIGN udp_data_type array_type_suffix?;
udp_data_type : component_type_primary
              | kw=(REF_kw|NUMBER_kw)
              | basic_data_type
              ;

udp_usage : COMPONENT_kw ASSIGN udp_comp_type (OR udp_comp_type)*;
udp_comp_type : component_type
              | kw=(CONSTRAINT_kw|ALL_kw)
              ;

udp_default : DEFAULT_kw ASSIGN expr;

udp_constraint : CONSTRAINT_kw ASSIGN COMPONENTWIDTH_kw;

//------------------------------------------------------------------------------
// User-defined enumerations
//------------------------------------------------------------------------------
enum_def: ENUM_kw ID '{' (enum_entry ';')+ '}';

enum_entry: ID (ASSIGN expr)? ('{' (enum_prop_assign ';')* '}')?;

// Only 'name' and 'desc' properties are allowed in enums
// No need to invoke the rest of the grammar for property assignments here.
enum_prop_assign: ID ASSIGN expr;

//------------------------------------------------------------------------------
// User-defined structs
//------------------------------------------------------------------------------
struct_def: ABSTRACT_kw? STRUCT_kw name=ID (':' base=ID)? '{' (struct_elem ';')* '}';

struct_elem: struct_type ID array_type_suffix?;

struct_type : data_type
            | component_type
            ;

//------------------------------------------------------------------------------
// Constraints
//------------------------------------------------------------------------------
constraint_def: constraint_named_def constraint_insts?
              | constraint_anon_def constraint_insts
              ;

constraint_named_def: CONSTRAINT_kw ID constraint_body;
constraint_anon_def: CONSTRAINT_kw constraint_body;

constraint_body: '{' (constraint_body_elem ';')* '}';

constraint_body_elem: constr_relational
                    | constr_prop_assign
                    | constr_inside_values
                    | constr_inside_enum
                    ;


constraint_insts: ID (',' ID)*;

constr_relational: expr op=(LT|LEQ|GT|GEQ|EQ|NEQ) expr;
constr_prop_assign: ID ASSIGN expr;
constr_inside_values: constr_lhs INSIDE_kw '{' constr_inside_value (',' constr_inside_value)*'}';
constr_inside_enum: constr_lhs INSIDE_kw ID;

constr_lhs: THIS_kw
          | instance_ref
          ;

constr_inside_value : val=expr
                    | '[' l_val=expr ':' r_val=expr ']'
                    ;

//==============================================================================
// Lexer
//==============================================================================

SL_COMMENT : ( '//' ~[\r\n]* '\r'? ('\n'|EOF)) -> skip;
ML_COMMENT : ( '/*' .*? '*/' ) -> skip;

//------------------------------------------------------------------------------
// Keywords
//------------------------------------------------------------------------------
BOOLEAN_kw          : 'boolean';
BIT_kw              : 'bit';
LONGINT_kw          : 'longint';
UNSIGNED_kw         : 'unsigned';
STRING_kw           : 'string';
ACCESSTYPE_kw       : 'accesstype';
ADDRESSINGTYPE_kw   : 'addressingtype';
ONREADTYPE_kw       : 'onreadtype';
ONWRITETYPE_kw      : 'onwritetype';


ALIAS_kw    : 'alias';
EXTERNAL_kw : 'external';
INTERNAL_kw : 'internal';

ADDRMAP_kw  : 'addrmap';
REGFILE_kw  : 'regfile';
REG_kw      : 'reg';
FIELD_kw    : 'field';
MEM_kw      : 'mem';
SIGNAL_kw   : 'signal';

// Boolean Literals
TRUE_kw : 'true';
FALSE_kw : 'false';

// Special RDL enum-like literals
NA_kw        : 'na';
RW_kw        : 'rw';
WR_kw        : 'wr';
R_kw         : 'r';
W_kw         : 'w';
RW1_kw       : 'rw1';
W1_kw        : 'w1';
RCLR_kw      : 'rclr';
RSET_kw      : 'rset';
RUSER_kw     : 'ruser';
WOSET_kw     : 'woset';
WOCLR_kw     : 'woclr';
WOT_kw       : 'wot';
WZS_kw       : 'wzs';
WZC_kw       : 'wzc';
WZT_kw       : 'wzt';
WCLR_kw      : 'wclr';
WSET_kw      : 'wset';
WUSER_kw     : 'wuser';
COMPACT_kw   : 'compact';
REGALIGN_kw  : 'regalign';
FULLALIGN_kw : 'fullalign';
HW_kw        : 'hw';
SW_kw        : 'sw';

// Property Modifier keywords
POSEDGE_kw    : 'posedge';
NEGEDGE_kw    : 'negedge';
BOTHEDGE_kw   : 'bothedge';
LEVEL_kw      : 'level';
NONSTICKY_kw  : 'nonsticky';


// Other keywords from 4.4 not covered by above
ABSTRACT_kw       : 'abstract';
ALL_kw            : 'all';
COMPONENT_kw      : 'component';
COMPONENTWIDTH_kw : 'componentwidth';
CONSTRAINT_kw     : 'constraint';
DEFAULT_kw        : 'default';
ENUM_kw           : 'enum';
ENCODE_kw         : 'encode';
INSIDE_kw         : 'inside';
NUMBER_kw         : 'number';
PROPERTY_kw       : 'property';
REF_kw            : 'ref';
STRUCT_kw         : 'struct';
THIS_kw           : 'this';
TYPE_kw           : 'type';

// Reserved keywords from Annex D
ALTERNATE_kw      : 'alternate';
BYTE_kw           : 'byte';
INT_kw            : 'int';
PRECEDENCETYPE_kw : 'precedencetype';
REAL_kw           : 'real';
SHORTINT_kw       : 'shortint';
SHORTREAL_kw      : 'shortreal';
SIGNED_kw         : 'signed';
WITH_kw           : 'with';
WITHIN_kw         : 'within';

//------------------------------------------------------------------------------
// Literals
//------------------------------------------------------------------------------

// Numbers
fragment NUM_BIN : [0-1] [0-1_]* ;
fragment NUM_DEC : [0-9] [0-9_]* ;
fragment NUM_HEX : [0-9a-fA-F] [0-9a-fA-F_]* ;

INT     : NUM_DEC ;
HEX_INT : ('0x'|'0X') NUM_HEX ;
VLOG_INT: [0-9]+ '\'' ( ([bB] NUM_BIN)
                      | ([dD] NUM_DEC)
                      | ([hH] NUM_HEX)
                      )
        ;

fragment ESC : '\\"' | '\\\\' ;
STRING :  '"' (ESC | ~('"'|'\\'))* '"' ;

//------------------------------------------------------------------------------
// Operators
//------------------------------------------------------------------------------

PLUS    : '+' ;
MINUS   : '-' ;
BNOT    : '!' ;
NOT     : '~' ;
BAND    : '&&' ;
NAND    : '~&' ;
AND     : '&' ;
OR      : '|' ;
BOR     : '||' ;
NOR     : '~|' ;
XOR     : '^' ;
XNOR    : '~^' | '^~' ;
LSHIFT  : '<<' ;
RSHIFT  : '>>' ;
MULT    : '*' ;
EXP     : '**' ;
DIV     : '/' ;
MOD     : '%' ;
EQ      : '==' ;
ASSIGN  : '=' ;
NEQ     : '!=' ;
LEQ     : '<=' ;
LT      : '<' ;
GEQ     : '>=' ;
GT      : '>' ;

AT    : '@';
INC   : '+=';
ALIGN : '%=';

//------------------------------------------------------------------------------
WS  :   [ \t\r\n]+ -> skip ;
ID  :   ('\\')? [a-zA-Z_] [a-zA-Z0-9_]* ;
