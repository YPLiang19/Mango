%{
	#define YYDEBUG 1
	#define YYERROR_VERBOSE
	#import <Foundation/Foundation.h>
	#import "create.h"
	#import "man_ast.h"
	

int yyerror(char const *str);
int yylex(void);

%}

%union{
	void	*identifier;
	void	*expression;
	void	*statement;
	void    *struct_entry;
	void	*dic_entry;
	void	*type_specifier;
	void	*one_case;
	void	*else_if;
	void	*class_definition;
	void	*declare_struct;
	void	*member_definition;
	void	*block_statement;
	void	*list;
	void	*method_name_item;
	void	*function_param;
	void	*declaration;
	MANAssignKind assignment_operator;
	MANPropertyModifier property_modifier_list;



}

%token <identifier> IDENTIFIER
%token <expression> DOUBLE_LITERAL
%token <expression> STRING_LITERAL
%token <expression> INTETER_LITERAL
%token <expression> SELF
%token <expression> SUPER
%token <expression> NIL
%token <expression> YES_
%token <expression> NO_

%token COLON SEMICOLON COMMA  LP RP LB RB LC RC  QUESTION DOT ASSIGN AT POWER
	AND OR NOT EQ NE LT LE GT GE SUB SUB_ASSIGN ADD ADD_ASSIGN ASTERISK_ASSIGN DIV DIV_ASSIGN MOD MOD_ASSIGN INCREMENT DECREMENT
	ANNOTATION_IF CLASS STRUCT DECLARE SELECTOR
	RETURN IF ELSE FOR IN WHILE DO SWITCH CASE DEFAULT BREAK CONTINUE
	PROPERTY WEAK STRONG COPY ASSIGN_MEM NONATOMIC ATOMIC  ASTERISK  VOID
	BOOL_ U_INT INT    DOUBLE C_STRING  CLASS_ SEL_ ID POINTER BLOCK



%type <assignment_operator> assignment_operator
%type <expression> expression expression_opt struct_literal assign_expression ternary_operator_expression logic_or_expression logic_and_expression  
equality_expression relational_expression additive_expression multiplication_expression unary_expression postfix_expression primary_expression  dic block_body annotation_if

%type <identifier> selector selector_1 selector_2

%type <list> identifier_list struct_entry_list dic_entry_list  statement_list protocol_list else_if_list case_list member_definition_list
method_name method_name_1 method_name_2 expression_list function_param_list 

%type <method_name_item> method_name_item
%type <dic_entry> dic_entry
%type <struct_entry> struct_entry
%type <statement> statement  top_statement expression_statement if_statement switch_statement for_statement foreach_statement while_statement do_while_statement
break_statement continue_statement return_statement declaration_statement
%type <type_specifier> type_specifier
%type <block_statement> block_statement default_opt
%type <declare_struct> declare_struct
%type <property_modifier_list> property_modifier_list property_modifier property_rc_modifier  property_atomic_modifier
%type <class_definition> class_definition
%type <member_definition> member_definition property_definition method_definition class_method_definition instance_method_definition
%type <one_case> one_case
%type <else_if> else_if
%type <function_param> function_param
%type <declaration> declaration
%%

compile_util: /*empty*/
			| definition_list
			;


definition_list: definition
			| definition_list definition
			;

definition:  class_definition
			{
				MANClassDefinition *classDefinition = (__bridge_transfer MANClassDefinition *)$1;
				man_add_class_definition(classDefinition);
			}
			| declare_struct
			{
				MANStructDeclare *structDeclare = (__bridge_transfer MANStructDeclare *)$1;
				man_add_struct_declare(structDeclare);
			}
			| top_statement
			{
				MANStatement *statement = (__bridge_transfer MANStatement *)$1;
				man_add_statement(statement);
			}
			;


annotation_if: /* empty */
			{
				$$ = nil;
			}
			| ANNOTATION_IF LP expression RP
			{
				$$ = $3;
			}
			;


declare_struct: annotation_if DECLARE STRUCT IDENTIFIER LC
			IDENTIFIER COLON STRING_LITERAL COMMA
			IDENTIFIER COLON identifier_list
			RC
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				NSString *structName = (__bridge_transfer NSString *)$4;
				NSString *typeEncodingKey = (__bridge_transfer NSString *)$6;
				NSString *typeEncodingValue = (__bridge_transfer NSString *)$8;
				NSString *keysKey = (__bridge_transfer NSString *)$10;
				NSArray *keysValue = (__bridge_transfer NSArray *)$12;
				MANStructDeclare *structDeclare = man_create_struct_declare(annotaionIfConditionExpr, structName, typeEncodingKey, typeEncodingValue.UTF8String, keysKey, keysValue);
				$$ = (__bridge_retained void *)structDeclare;
				
			}
			| annotation_if DECLARE STRUCT IDENTIFIER LC
			IDENTIFIER COLON identifier_list COMMA
			IDENTIFIER COLON STRING_LITERAL
			RC
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				NSString *structName = (__bridge_transfer NSString *)$4;
				NSString *keysKey = (__bridge_transfer NSString *)$6;
				NSArray *keysValue = (__bridge_transfer NSArray *)$8;
				NSString *typeEncodingKey = (__bridge_transfer NSString *)$10;
				NSString *typeEncodingValue = (__bridge_transfer NSString *)$12;
				MANStructDeclare *structDeclare = man_create_struct_declare(annotaionIfConditionExpr, structName, typeEncodingKey, typeEncodingValue.UTF8String, keysKey, keysValue);
				$$ = (__bridge_retained void *)structDeclare;
				
			}
			;

identifier_list: IDENTIFIER
			{
				NSMutableArray *list = [NSMutableArray array];
				NSString *identifier = (__bridge_transfer NSString *)$1;
				[list addObject:identifier];
				$$ = (__bridge_retained void *)list;
				
			}
			| identifier_list COMMA IDENTIFIER
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				NSString *identifier = (__bridge_transfer NSString *)$3;
				[list addObject:identifier];
				$$ = (__bridge_retained void *)list;
			}
			;




class_definition: annotation_if CLASS IDENTIFIER COLON IDENTIFIER LC
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				NSString *name = (__bridge_transfer NSString *)$3;
				NSString *superNmae = (__bridge_transfer NSString *)$5;
				man_start_class_definition(annotaionIfConditionExpr, name, superNmae,nil);
			}
			RC
			{
				MANClassDefinition *classDefinition = man_end_class_definition(nil);
				$$ = (__bridge_retained void *)classDefinition;
			}
			| annotation_if CLASS IDENTIFIER COLON IDENTIFIER LC
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				NSString *name = (__bridge_transfer NSString *)$3;
				NSString *superNmae = (__bridge_transfer NSString *)$5;
				man_start_class_definition(annotaionIfConditionExpr, name, superNmae,nil);
			}
			member_definition_list RC
			{
				NSArray *members = (__bridge_transfer NSArray *)$8;
				MANClassDefinition *classDefinition = man_end_class_definition(members);
				$$ = (__bridge_retained void *)classDefinition;
			}
			| annotation_if CLASS IDENTIFIER COLON IDENTIFIER LT protocol_list GT LC
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				NSString *name = (__bridge_transfer NSString *)$3;
				NSString *superNmae = (__bridge_transfer NSString *)$5;
				NSArray *protocolNames = (__bridge_transfer NSArray *)$7;
				man_start_class_definition(annotaionIfConditionExpr, name, superNmae,protocolNames);
			}
			RC
			{
				MANClassDefinition *classDefinition = man_end_class_definition(nil);
				$$ = (__bridge_retained void *)classDefinition;
			}
			| annotation_if CLASS IDENTIFIER COLON IDENTIFIER LT protocol_list GT LC
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				NSString *name = (__bridge_transfer NSString *)$3;
				NSString *superNmae = (__bridge_transfer NSString *)$5;
				NSArray *protocolNames = (__bridge_transfer NSArray *)$7;
				man_start_class_definition(annotaionIfConditionExpr, name, superNmae,protocolNames);
			}
			member_definition_list RC
			{
				NSArray *members = (__bridge_transfer NSArray *)$11;
				MANClassDefinition *classDefinition = man_end_class_definition(members);
				$$ = (__bridge_retained void *)classDefinition;
			}
			;

protocol_list: IDENTIFIER
			{
				NSMutableArray *list = [NSMutableArray array];
				NSString *identifier = (__bridge_transfer NSString *)$1;
				[list addObject:identifier];
				$$ = (__bridge_retained void *)list;
			}
			| protocol_list COMMA IDENTIFIER
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				NSString *identifier = (__bridge_transfer NSString *)$3;
				[list addObject:identifier];
				$$ = (__bridge_retained void *)list;
			}
			;


property_definition: annotation_if PROPERTY LP property_modifier_list RP type_specifier IDENTIFIER  SEMICOLON
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				MANPropertyModifier modifier = $4;
				MANTypeSpecifier *typeSpecifier = (__bridge_transfer MANTypeSpecifier *)$6;
				NSString *name = (__bridge_transfer NSString *)$7;
				MANPropertyDefinition *propertyDefinition = man_create_property_definition(annotaionIfConditionExpr, modifier, typeSpecifier, name);
				$$ = (__bridge_retained void *)propertyDefinition;
			}
			| annotation_if PROPERTY LP  RP type_specifier IDENTIFIER SEMICOLON
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				MANTypeSpecifier *typeSpecifier = (__bridge_transfer MANTypeSpecifier *)$5;
				NSString *name = (__bridge_transfer NSString *)$6;
				MANPropertyDefinition *propertyDefinition = man_create_property_definition(annotaionIfConditionExpr, 0x00, typeSpecifier, name);
				$$ = (__bridge_retained void *)propertyDefinition;
			}
			;



property_modifier_list: property_modifier
			| property_modifier_list COMMA property_modifier
			{
				$$ = $1 | $3;
			}
			;


property_modifier: property_rc_modifier
				| property_atomic_modifier
			;

property_rc_modifier: WEAK
			{
				$$ = MANPropertyModifierMemWeak;
			}
			| STRONG
			{
				$$ = MANPropertyModifierMemStrong;
			}
			| COPY
			{
				$$ = MANPropertyModifierMemCopy;
			}
			| ASSIGN_MEM
			{
				$$ = MANPropertyModifierMemAssign;
			}
			;

property_atomic_modifier: NONATOMIC
			{
				$$ = MANPropertyModifierNonatomic;
			}
			| ATOMIC
			{
				$$ = MANPropertyModifierAtomic;
			}
			;

type_specifier: VOID
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_VOID);
			}
			| BOOL_
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_BOOL);
			}
			| INT
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_INT);
			}
			| U_INT
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_U_INT);
			}
			| DOUBLE
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_DOUBLE);
			}
			| C_STRING
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_C_STRING);
			}
			|ID
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_OBJECT);
			}
			|CLASS_
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_CLASS);
			}
			|SEL_
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_SEL);
			}
			| BLOCK
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_BLOCK);
			}
			| POINTER
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_POINTER);
			}
			| IDENTIFIER ASTERISK
			{
				$$ =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_OBJECT);
			}
			| STRUCT IDENTIFIER
			{
				$$ =  (__bridge_retained void *)man_create_struct_type_specifier((__bridge_transfer NSString *)$2);
			}
			;


method_definition: instance_method_definition
			| class_method_definition
			;

instance_method_definition: annotation_if SUB LP type_specifier RP method_name block_statement
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)$4;
				NSArray *items = (__bridge_transfer NSArray *)$6;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$7;
				MANMethodDefinition *methodDefinition = man_create_method_definition(annotaionIfConditionExpr, NO, returnTypeSpecifier, items, block);
				$$ = (__bridge_retained void *)methodDefinition;
			}
			;

class_method_definition: annotation_if ADD LP type_specifier RP method_name  block_statement
			{
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)$1;
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)$4;
				NSArray *items = (__bridge_transfer NSArray *)$6;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$7;
				MANMethodDefinition *methodDefinition = man_create_method_definition(annotaionIfConditionExpr, YES, returnTypeSpecifier, items, block);
				$$ = (__bridge_retained void *)methodDefinition;
			}
			;	

method_name: method_name_1
			| method_name_2
			;		

method_name_1: IDENTIFIER
			{
				NSString *name = (__bridge_transfer NSString *)$1;
				MANMethodNameItem *item = man_create_method_name_item(name, nil, nil);
				NSMutableArray *list = [NSMutableArray array];
				[list addObject:item];
				$$ = (__bridge_retained void *)list;
			}
			;

method_name_2: method_name_item
			{
				NSMutableArray *list = [NSMutableArray array];
				MANMethodNameItem *item = (__bridge_transfer MANMethodNameItem *)$1;
				[list addObject:item];
				$$ = (__bridge_retained void *)list;
			}
			| method_name_2 method_name_item
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANMethodNameItem *item = (__bridge_transfer MANMethodNameItem *)$2;
				[list addObject:item];
				$$ = (__bridge_retained void *)list;
			}
			;

method_name_item: IDENTIFIER COLON LP type_specifier RP IDENTIFIER
			{
				NSString *name = (__bridge_transfer NSString *)$1;
				name = [NSString stringWithFormat:@"%@:",name];
				MANTypeSpecifier *typeSpecifier = (__bridge_transfer MANTypeSpecifier *)$4;
				NSString *paramName = (__bridge_transfer NSString *)$6;
				MANMethodNameItem *item = man_create_method_name_item(name, typeSpecifier, paramName);
				$$ = (__bridge_retained void *)item;
			}
		;

member_definition: property_definition
			| method_definition
			;
		
member_definition_list: member_definition
			{
				NSMutableArray *list = [NSMutableArray array];
				MANMemberDefinition *memberDefinition = (__bridge_transfer MANMemberDefinition *)$1;
				[list addObject:memberDefinition];
				$$ = (__bridge_retained void *)list;
			}
			| member_definition_list member_definition
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANMemberDefinition *memberDefinition = (__bridge_transfer MANMemberDefinition *)$2;
				[list addObject:memberDefinition];
				$$ = (__bridge_retained void *)list;
			}
			;

selector: selector_1
			| selector_2
			;

selector_1: IDENTIFIER
			;

selector_2: IDENTIFIER COLON
			{
				NSString *name = (__bridge_transfer NSString *)$1;
				NSString *selector = [NSString stringWithFormat:@"%@:",name];
				$$ = (__bridge_retained void *)selector;
			}
			| selector_2 IDENTIFIER COLON
			{
				NSString *name1 = (__bridge_transfer NSString *)$1;
				NSString *name2 = (__bridge_transfer NSString *)$2;
				NSString *selector = [NSString stringWithFormat:@"%@%@:", name1, name2];
				$$ = (__bridge_retained void *)selector;
			}
			;

expression: assign_expression
			;
	
assign_expression:  ternary_operator_expression
			| primary_expression assignment_operator ternary_operator_expression
			{
				MANAssignExpression *expr = (MANAssignExpression *)man_create_expression(MAN_ASSIGN_EXPRESSION);
				expr.assignKind = $2;
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

assignment_operator: ASSIGN
				{
					$$ = MAN_NORMAL_ASSIGN;
					
				}
                | SUB_ASSIGN
				{
					$$ = MAN_SUB_ASSIGN;
				}
                | ADD_ASSIGN
				{
					$$ = MAN_ADD_ASSIGN;
				}
                | ASTERISK_ASSIGN
				{
					$$ = MAN_MUL_ASSIGN;
				}
                | DIV_ASSIGN
				{
					$$ = MAN_DIV_ASSIGN;
				}
                | MOD_ASSIGN
				{
					$$ = MAN_MOD_ASSIGN;
				}
                ;

ternary_operator_expression: logic_or_expression
 			| logic_or_expression  QUESTION ternary_operator_expression  COLON ternary_operator_expression
			{
				MANTernaryExpression *expr = (MANTernaryExpression *)man_create_expression(MAN_TERNARY_EXPRESSION);
				expr.condition = (__bridge_transfer MANExpression *)$1;
				expr.trueExpr = (__bridge_transfer MANExpression *)$3;
				expr.falseExpr = (__bridge_transfer MANExpression *)$5;
				$$ = (__bridge_retained void *)expr;
			}
			| logic_or_expression  QUESTION COLON ternary_operator_expression
			{
				MANTernaryExpression *expr = (MANTernaryExpression *)man_create_expression(MAN_TERNARY_EXPRESSION);
				expr.condition = (__bridge_transfer MANExpression *)$1;
				expr.falseExpr = (__bridge_transfer MANExpression *)$4;
				$$ = (__bridge_retained void *)expr;
			}
			;

logic_or_expression: logic_and_expression
			| logic_or_expression OR logic_and_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_LOGICAL_OR_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

logic_and_expression: equality_expression
			| logic_and_expression AND equality_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_LOGICAL_AND_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

equality_expression: relational_expression
			| equality_expression EQ relational_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_EQ_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| equality_expression NE relational_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_NE_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

relational_expression: additive_expression
			| relational_expression LT additive_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_LT_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| relational_expression LE additive_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_LE_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| relational_expression GT additive_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_GT_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| relational_expression GE additive_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_GE_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

additive_expression: multiplication_expression
			| additive_expression ADD multiplication_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_ADD_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| additive_expression SUB multiplication_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_SUB_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

multiplication_expression: unary_expression
			| multiplication_expression ASTERISK unary_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_MUL_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| multiplication_expression DIV unary_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_DIV_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| multiplication_expression MOD unary_expression
			{
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_MOD_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)$1;
				expr.right = (__bridge_transfer MANExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

unary_expression: postfix_expression
			| NOT unary_expression
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_LOGICAL_NOT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| SUB unary_expression
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(NSC_NEGATIVE_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			;

postfix_expression: primary_expression
			| primary_expression INCREMENT
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_INCREMENT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$1;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| primary_expression DECREMENT
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_DECREMENT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$1;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			;

expression_list: assign_expression
			{
				NSMutableArray *list = [NSMutableArray array];
				MANExpression *expr = (__bridge_transfer MANExpression *)$1;
				[list addObject:expr];
				$$ = (__bridge_retained void *)list;
			}
			| expression_list COMMA assign_expression
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANExpression *expr = (__bridge_transfer MANExpression *)$3;
				[list addObject:expr];
				$$ = (__bridge_retained void *)list;
			}
			;

dic_entry: primary_expression COLON primary_expression
			{
				MANExpression *keyExpr = (__bridge_transfer MANExpression *)$1;
				MANExpression *valueExpr = (__bridge_transfer MANExpression *)$3;
				MANDicEntry *dicEntry = man_create_dic_entry(keyExpr, valueExpr);
				$$ = (__bridge_retained void *)dicEntry;
			}
			;

dic_entry_list: dic_entry
			{
				NSMutableArray *list = [NSMutableArray array];
				MANDicEntry *dicEntry = (__bridge_transfer MANDicEntry *)$1;
				[list addObject:dicEntry];
				$$ = (__bridge_retained void *)list;
			} 
			| dic_entry_list COMMA dic_entry
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANDicEntry *dicEntry = (__bridge_transfer MANDicEntry *)$3;
				[list addObject:dicEntry];
				$$ = (__bridge_retained void *)list;
			}
			;

dic: AT LC  dic_entry_list RC
			{
				MANDictionaryExpression *expr = (MANDictionaryExpression *)man_create_expression(MAN_DIC_LITERAL_EXPRESSION);
				NSArray *entriesExpr = (__bridge_transfer NSArray *)$3;
				expr.entriesExpr = entriesExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT LC  RC
			{
				MANDictionaryExpression *expr = (MANDictionaryExpression *)man_create_expression(MAN_DIC_LITERAL_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
			;


struct_entry: IDENTIFIER COLON primary_expression
			{
				NSString *key = (__bridge_transfer NSString *)$1;
				MANExpression *valueExpr = (__bridge_transfer MANExpression *)$3;
				MANStructEntry *structEntry = man_create_struct_entry(key, valueExpr);
				$$ = (__bridge_retained void *)structEntry;
			}
			;

struct_entry_list: struct_entry
			{
				NSMutableArray *list = [NSMutableArray array];
				MANStructEntry *structEntry = (__bridge_transfer MANStructEntry *)$1;
				[list addObject:structEntry];
				$$ = (__bridge_retained void *)list;
			}
			| struct_entry_list COMMA struct_entry
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANStructEntry *structEntry = (__bridge_transfer MANStructEntry *)$3;
				[list addObject:structEntry];
				$$ = (__bridge_retained void *)list;
			}
			;

struct_literal:  LC  struct_entry_list RC
			{
				MANStructpression *expr = (MANStructpression *)man_create_expression(MAN_STRUCT_LITERAL_EXPRESSION);
				NSArray *entriesExpr = (__bridge_transfer NSArray *)$2;
				expr.entriesExpr = entriesExpr;
				$$ = (__bridge_retained void *)expr;
			}
			;

primary_expression: IDENTIFIER
			{
				MANIdentifierExpression *expr = (MANIdentifierExpression *)man_create_expression(MAN_IDENTIFIER_EXPRESSION);
				NSString *identifier = (__bridge_transfer NSString *)$1;;
				expr.identifier = identifier;
				$$ = (__bridge_retained void *)expr;
			}
			| primary_expression DOT IDENTIFIER
			{
				MANMemberExpression *expr = (MANMemberExpression *)man_create_expression(MAN_MEMBER_EXPRESSION);
				expr.expr = (__bridge_transfer MANExpression *)$1;
				expr.memberName = (__bridge_transfer NSString *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| primary_expression DOT selector LP RP
			{
				MANExpression *expr = (__bridge_transfer MANExpression *)$1;
				NSString *selector = (__bridge_transfer NSString *)$3;
				MANMemberExpression *memberExpr = (MANMemberExpression *)man_create_expression(MAN_MEMBER_EXPRESSION);
				memberExpr.expr = expr;
				memberExpr.memberName = selector;
				
				MANFunctonCallExpression *funcCallExpr = (MANFunctonCallExpression *)man_create_expression(MAN_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = memberExpr;
				
				$$ = (__bridge_retained void *)funcCallExpr;
			}
			| primary_expression DOT selector LP expression_list RP
			{
				MANExpression *expr = (__bridge_transfer MANExpression *)$1;
				NSString *selector = (__bridge_transfer NSString *)$3;
				MANMemberExpression *memberExpr = (MANMemberExpression *)man_create_expression(MAN_MEMBER_EXPRESSION);
				memberExpr.expr = expr;
				memberExpr.memberName = selector;
				
				MANFunctonCallExpression *funcCallExpr = (MANFunctonCallExpression *)man_create_expression(MAN_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = memberExpr;
				funcCallExpr.args = (__bridge_transfer NSArray<MANExpression *> *)$5;
				
				$$ = (__bridge_retained void *)funcCallExpr;
			}
			| IDENTIFIER LP RP
			{
				MANIdentifierExpression *identifierExpr = (MANIdentifierExpression *)man_create_expression(MAN_IDENTIFIER_EXPRESSION);
				NSString *identifier = (__bridge_transfer NSString *)$1;
				identifierExpr.identifier = identifier;
				MANFunctonCallExpression *funcCallExpr = (MANFunctonCallExpression *)man_create_expression(MAN_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = identifierExpr;
				$$ = (__bridge_retained void *)funcCallExpr;
			}
		    | IDENTIFIER LP expression_list RP
			{
				MANIdentifierExpression *identifierExpr = (MANIdentifierExpression *)man_create_expression(MAN_IDENTIFIER_EXPRESSION);
				NSString *identifier = (__bridge_transfer NSString *)$1;
				identifierExpr.identifier = identifier;
				MANFunctonCallExpression *funcCallExpr = (MANFunctonCallExpression *)man_create_expression(MAN_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = identifierExpr;
				funcCallExpr.args = (__bridge_transfer NSArray<MANExpression *> *)$3;
				$$ = (__bridge_retained void *)funcCallExpr;
			}
			| LP expression RP
			{
				$$ = $2;
			}
			| primary_expression LB expression RB
			{
				MANExpression *arrExpr = (__bridge_transfer MANExpression *)$1;
				MANExpression *indexExpr = (__bridge_transfer MANExpression *)$3;
				
				MANSubScriptExpression *expr = (MANSubScriptExpression *)man_create_expression(MAN_SUB_SCRIPT_EXPRESSION);
				expr.aboveExpr = arrExpr;
				expr.bottomExpr = indexExpr;
				$$ = (__bridge_retained void *)expr;
				
			}
			| YES_
			| NO_
			| INTETER_LITERAL
			| DOUBLE_LITERAL
			| STRING_LITERAL
			| NIL
			{
				MANExpression *expr = man_create_expression(MAN_NIL_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
			| SELECTOR LP selector RP
			{
				MANExpression *expr = man_create_expression(MAN_SELECTOR_EXPRESSION);
				expr.selectorName = (__bridge_transfer NSString *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| AT INTETER_LITERAL
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT DOUBLE_LITERAL
			{
				
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT STRING_LITERAL
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT YES_
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT NO_
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| SELF
			{
				MANExpression *expr = man_create_expression(MAN_SELF_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
			| SUPER
			{
				MANExpression *expr = man_create_expression(MAN_SUPER_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
			| AT LP expression RP
			{
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)$3;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT LB expression_list RB
			{
				MANArrayExpression *expr = (MANArrayExpression *)man_create_expression(MAN_ARRAY_LITERAL_EXPRESSION);
				NSArray *itemExpressions = (__bridge_transfer NSArray *)$3;
				expr.itemExpressions = itemExpressions;
				$$ = (__bridge_retained void *)expr;
			}
			| AT LB  RB
			{
				MANArrayExpression *expr = (MANArrayExpression *)man_create_expression(MAN_ARRAY_LITERAL_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
			| dic
			| struct_literal
			| block_body
			;




block_body:  POWER type_specifier LP  RP block_statement
			{
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)$2;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$5;
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,returnTypeSpecifier,nil,block);
				$$ = (__bridge_retained void *)expr;
				
			}
			|POWER type_specifier block_statement
			{
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)$2;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$3;
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,returnTypeSpecifier,nil,block);
				$$ = (__bridge_retained void *)expr;
				
			}
			| POWER type_specifier LP function_param_list RP block_statement
			{
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)$2;
				NSArray<MANParameter *> *parameter = (__bridge_transfer NSArray<MANParameter *> *)$4;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$6;
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,returnTypeSpecifier,parameter,block);
				$$ = (__bridge_retained void *)expr;
				
			}
			| POWER  LP  RP block_statement
			{
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$4;
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,nil,nil,block);
				$$ = (__bridge_retained void *)expr;
			}
			| POWER block_statement
			{
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$2;
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,nil,nil,block);
				$$ = (__bridge_retained void *)expr;
			}
			| POWER  LP function_param_list RP block_statement
			{
				NSArray<MANParameter *> *parameter = (__bridge_transfer NSArray<MANParameter *> *)$3;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$5;
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,nil,parameter,block);
				$$ = (__bridge_retained void *)expr;
			}
			;


function_param_list: function_param
			{
				NSMutableArray *list = [NSMutableArray array];
				MANParameter *parameter = (__bridge_transfer MANParameter *)$1;
				[list addObject:parameter];
				$$ = (__bridge_retained void *)list;
			}
			| function_param_list COMMA function_param
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANParameter *parameter = (__bridge_transfer MANParameter *)$3;
				[list addObject:parameter];
				$$ = (__bridge_retained void *)list;
			}
			;

function_param: type_specifier IDENTIFIER
			{
				MANTypeSpecifier *type = (__bridge_transfer MANTypeSpecifier *)$1;
				NSString *name = (__bridge_transfer NSString *)$2;
				MANParameter *parameter = man_create_parameter(type, name);
				$$ = (__bridge_retained void *)parameter;
			}
			;

declaration_statement: declaration SEMICOLON
			{
				MANDeclaration *declaration = (__bridge_transfer MANDeclaration *)$1;
				MANDeclarationStatement *statement = man_create_declaration_statement(declaration);
				$$ = (__bridge_retained void *)statement;
			}
			;

declaration: type_specifier IDENTIFIER
			{
				MANTypeSpecifier *type = (__bridge_transfer MANTypeSpecifier *)$1;
				NSString *name = (__bridge_transfer NSString *)$2;
				MANDeclaration *declaration = man_create_declaration(type, name, nil);
				$$ = (__bridge_retained void *)declaration;
			}
			| type_specifier IDENTIFIER ASSIGN expression
			{
				MANTypeSpecifier *type = (__bridge_transfer MANTypeSpecifier *)$1;
				NSString *name = (__bridge_transfer NSString *)$2;
				MANExpression *initializer = (__bridge_transfer MANExpression *)$4;
				MANDeclaration *declaration = man_create_declaration(type, name, initializer);
				$$ = (__bridge_retained void *)declaration;
			}
			;
			


if_statement: IF LP expression RP block_statement
			{
				MANExpression *condition = (__bridge_transfer MANExpression *)$3;
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)$5;
				MANIfStatement *statement = man_create_if_statement(condition, thenBlock, nil, nil);
				$$ = (__bridge_retained void *)statement;
			}
			| IF LP expression RP block_statement ELSE block_statement
			{
				MANExpression *condition = (__bridge_transfer MANExpression *)$3;
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)$5;
				MANBlockBody  *elseBlocl = (__bridge_transfer MANBlockBody  *)$7;
				MANIfStatement *statement = man_create_if_statement(condition, thenBlock, nil, elseBlocl);
				$$ = (__bridge_retained void *)statement;
			}
			| IF LP expression RP block_statement else_if_list
			{
				MANExpression *condition = (__bridge_transfer MANExpression *)$3;
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)$5;
				NSArray<MANElseIf *> *elseIfList = (__bridge_transfer NSArray<MANElseIf *> *)$6;
				MANIfStatement *statement = man_create_if_statement(condition, thenBlock, elseIfList, nil);
				$$ = (__bridge_retained void *)statement;
			}
			| IF LP expression RP block_statement else_if_list ELSE block_statement
			{
				MANExpression *condition = (__bridge_transfer MANExpression *)$3;
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)$5;
				NSArray<MANElseIf *> *elseIfList = (__bridge_transfer NSArray<MANElseIf *> *)$6;
				MANBlockBody  *elseBlocl = (__bridge_transfer MANBlockBody  *)$8;
				MANIfStatement *statement = man_create_if_statement(condition, thenBlock, elseIfList, elseBlocl);
				$$ = (__bridge_retained void *)statement;
			}
			;

else_if_list: else_if
			{
				NSMutableArray *list = [NSMutableArray array];
				MANElseIf *elseIf = (__bridge_transfer MANElseIf *)$1;
				[list addObject:elseIf];
				$$ = (__bridge_retained void *)list;
			}
			| else_if_list else_if
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANElseIf *elseIf = (__bridge_transfer MANElseIf *)$2;
				[list addObject:elseIf];
				$$ = (__bridge_retained void *)list;
			}
			;

else_if: ELSE IF  LP expression RP  block_statement
			{
				MANExpression *condition = (__bridge_transfer MANExpression *)$4;
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)$6;
				MANElseIf *elseIf = man_create_else_if(condition, thenBlock);
				$$ = (__bridge_retained void *)elseIf;
			}
			;

switch_statement: SWITCH LP expression RP LC case_list default_opt RC
			{
				MANExpression *expr = (__bridge_transfer MANExpression *)$3;
				NSArray<MANCase *> *caseList = (__bridge_transfer NSArray *)$6;
				MANBlockBody  *defaultBlock = (__bridge_transfer MANBlockBody  *)$7;
				MANSwitchStatement *statement = man_create_switch_statement(expr,caseList, defaultBlock);
				$$ = (__bridge_retained void *)statement;
			}
			;

case_list: one_case
			{
				NSMutableArray *list = [NSMutableArray array];
				MANCase *case_ = (__bridge_transfer MANCase *)$1;
				[list addObject:case_];
				$$ = (__bridge_retained void *)list;
			}
			| case_list one_case
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANCase *case_ = (__bridge_transfer MANCase *)$2;
				[list addObject:case_];
				$$ = (__bridge_retained void *)list;
			}
			;

one_case: CASE expression COLON block_statement
			{
				MANExpression *expr = (__bridge_transfer MANExpression *)$2;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$4;
				MANCase *case_ = man_create_case(expr, block);
				$$ = (__bridge_retained void *)case_;
			}
			;

default_opt: /* empty */
			{
				$$ = nil;
			}
			| DEFAULT COLON block_statement
			{
				$$ = $3;
			}
			;

expression_opt: /* empty */
			{
				$$ = nil;
			}
			| expression
			;



for_statement: FOR LP expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RP block_statement
			{
				MANExpression *initializerExpr = (__bridge_transfer MANExpression *)$3;
				MANExpression *condition = (__bridge_transfer MANExpression *)$5;
				MANExpression *post = (__bridge_transfer MANExpression *)$7;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$9;
				MANForStatement *statement = man_create_for_statement(initializerExpr, nil,
				condition, post, block);
				$$ = (__bridge_retained void *)statement;
			}

			| FOR LP declaration SEMICOLON  expression_opt SEMICOLON expression_opt RP block_statement
			{
				MANDeclaration *declaration = (__bridge_transfer MANDeclaration *)$3;
				MANExpression *condition = (__bridge_transfer MANExpression *)$5;
				MANExpression *post = (__bridge_transfer MANExpression *)$7;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$9;
				MANForStatement *statement = man_create_for_statement(nil, declaration,
				condition, post, block);
				$$ = (__bridge_retained void *)statement;
			}
			;

while_statement: WHILE LP expression RP block_statement
			{
				MANExpression *condition = (__bridge_transfer MANExpression *)$3;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$5;
				MANWhileStatement *statement = man_create_while_statement( condition, block);
				$$ = (__bridge_retained void *)statement;
			}
			;

do_while_statement: DO block_statement WHILE LP expression RP SEMICOLON
			{
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$2;
				MANExpression *condition = (__bridge_transfer MANExpression *)$5;
				MANDoWhileStatement *statement = man_create_do_while_statement(block, condition);
				$$ = (__bridge_retained void *)statement;
			}
			;

foreach_statement: FOR LP type_specifier IDENTIFIER IN expression RP block_statement
			{
				MANTypeSpecifier *typeSpecifier = (__bridge_transfer MANTypeSpecifier *)$3;
				NSString *varName = (__bridge_transfer NSString *)$4;
				MANExpression *arrayExpr = (__bridge_transfer MANExpression *)$6;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$8;
				MANForEachStatement *statement = man_create_for_each_statement(typeSpecifier, varName, arrayExpr, block);
				$$ = (__bridge_retained void *)statement;
			}
			| FOR  LP IDENTIFIER IN expression RP block_statement
			{
				NSString *varName = (__bridge_transfer NSString *)$3;
				MANExpression *arrayExpr = (__bridge_transfer MANExpression *)$5;
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$7;
				MANForEachStatement *statement = man_create_for_each_statement(nil, varName, arrayExpr, block);
				$$ = (__bridge_retained void *)statement;
			}
			;


continue_statement: CONTINUE SEMICOLON
			{
				MANContinueStatement *statement = man_create_continue_statement();
				$$ = (__bridge_retained void *)statement;
			}
			;


break_statement: BREAK SEMICOLON
			{
				MANBreakStatement *statement = man_create_break_statement();
				$$ = (__bridge_retained void *)statement;
			}
			;


return_statement: RETURN expression_opt SEMICOLON
			{
				MANExpression *expr = (__bridge_transfer MANExpression *)$2;
				MANReturnStatement *statement = man_create_return_statement(expr);
				$$ = (__bridge_retained void *)statement;
			}
			;

expression_statement:expression SEMICOLON
			{
				MANExpression *expr = (__bridge_transfer MANExpression *)$1;
				MANExpressionStatement *statement  = man_create_expression_statement(expr);
				$$ = (__bridge_retained void *)statement;
			}
			;


block_statement: LC
			{
				MANBlockBody  *block = man_open_block_statement();
				$<block_statement>$ = (__bridge_retained void *)block;
			}
			RC
			{
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$<block_statement>2;
				block = man_close_block_statement(block,nil);
				$$ = (__bridge_retained void *)block;
			}
			| LC
			{
				MANBlockBody  *block = man_open_block_statement();
				$<block_statement>$ = (__bridge_retained void *)block;
			}
			statement_list RC
			{
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)$<block_statement>2;
				NSArray *list = (__bridge_transfer NSArray *)$3;
				block = man_close_block_statement(block,list);
				$$ = (__bridge_retained void *)block;
			}
			;


statement_list: statement
			{
				NSMutableArray *list = [NSMutableArray array];
				MANStatement *statement = (__bridge_transfer MANStatement *)$1;
				[list addObject:statement];
				$$ = (__bridge_retained void *)list;
			}
			| statement_list statement
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MANStatement *statement = (__bridge_transfer MANStatement *)$2;
				[list addObject:statement];
				$$ = (__bridge_retained void *)list;
			}
			;


statement:  declaration_statement
			| if_statement
			| switch_statement
			| for_statement
			| foreach_statement
			| while_statement
			| do_while_statement
			| break_statement
			| continue_statement
			| return_statement
			| expression_statement
			;

top_statement: declaration_statement
			| if_statement
			| switch_statement
			| for_statement
			| foreach_statement
			| while_statement
			| do_while_statement
			| expression_statement
			;

%%
