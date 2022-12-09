%{
	#define YYDEBUG 1
	#define YYERROR_VERBOSE
	#import <Foundation/Foundation.h>
	#import "create.h"
	#import "mf_ast.h"
	

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
    void    *annotation_list;
    void    *annotation;
	MFAssignKind assignment_operator;
	MFPropertyModifier property_modifier_list;
    MFDeclarationModifier declaration_modifier;
}

%token <identifier> IDENTIFIER
%token <identifier> ANNOTATION
%token <expression> DOUBLE_LITERAL
%token <expression> STRING_LITERAL
%token <expression> INTETER_LITERAL
%token <expression> SELF
%token <expression> SUPER
%token <expression> NIL
%token <expression> NULL_
%token <expression> YES_
%token <expression> NO_

%token COLON SEMICOLON COMMA  LP RP LB RB LC RC  QUESTION DOT ASSIGN AT ADDRESS POWER
	AND OR NOT EQ NE LT LE GT GE SUB SUB_ASSIGN ADD ADD_ASSIGN ASTERISK_ASSIGN DIV DIV_ASSIGN MOD MOD_ASSIGN INCREMENT DECREMENT
    CLASS STRUCT DECLARE SELECTOR
	RETURN IF ELSE FOR IN WHILE DO SWITCH CASE DEFAULT BREAK CONTINUE
	PROPERTY WEAK STRONG COPY ASSIGN_MEM NONATOMIC ATOMIC  ASTERISK  VOID
	BOOL_ CHAR U_INT INT DOUBLE C_STRING  CLASS_ SEL_ ID POINTER BLOCK __WEAK __STRONG STATIC C_FUNCTION  TYPEDEF SWIFT_CLASS_ALIAS
    EXTERN




%type <assignment_operator> assignment_operator
%type <expression> expression expression_opt struct_literal assign_expression ternary_operator_expression logic_or_expression logic_and_expression  
equality_expression relational_expression additive_expression multiplication_expression unary_expression postfix_expression primary_expression  dic block_body

%type <identifier> selector selector_1 selector_2 key_work_identifier c_type_identier

%type <list> identifier_list struct_entry_list dic_entry_list  statement_list protocol_list else_if_list case_list member_definition_list
method_name method_name_1 method_name_2 expression_list function_param_list  c_type_identier_list annotation_list

%type <method_name_item> method_name_item
%type <dic_entry> dic_entry
%type <struct_entry> struct_entry
%type <statement> statement  top_statement expression_statement if_statement switch_statement for_statement foreach_statement while_statement do_while_statement
break_statement continue_statement return_statement declaration_statement
%type <type_specifier> type_specifier
%type <block_statement> block_statement default_opt
%type <declare_struct> declare_struct
%type <property_modifier_list> property_modifier_list property_modifier property_rc_modifier  property_atomic_modifier
%type <annotation> annotation
%type <class_definition> class_definition
%type <member_definition> member_definition property_definition method_definition class_method_definition instance_method_definition
%type <one_case> one_case
%type <else_if> else_if
%type <function_param> function_param
%type <declaration> declaration
%type <declaration_modifier> declaration_modifier declaration_modifier_list
%%

compile_util: /*empty*/
			| definition_list
			;


definition_list: definition
			| definition_list definition
			;

definition:  class_definition
			{
				MFClassDefinition *classDefinition = (__bridge_transfer MFClassDefinition *)$1;
				mf_add_class_definition(classDefinition);
			}
			| declare_struct
			{
				MFStructDeclare *structDeclare = (__bridge_transfer MFStructDeclare *)$1;
				mf_add_struct_declare(structDeclare);
			}
			| top_statement
			{
				MFStatement *statement = (__bridge_transfer MFStatement *)$1;
				mf_add_statement(statement);
			}
            | typedef_definition
            | swift_class_alias
			;
            
            


annotation: /* empty */
			{
				$$ = nil;
			}
            | ANNOTATION
            {
                NSString *name = (__bridge_transfer NSString *)$1;
                $$ = (__bridge_retained void *)mf_create_annotation(name, nil);
            }
			| ANNOTATION LP expression RP
			{
                NSString *name = (__bridge_transfer NSString *)$1;
                MFExpression *expr = (__bridge_transfer MFExpression *)$3;
                $$ = (__bridge_retained void *)mf_create_annotation(name, expr);
			}
			;

annotation_list: annotation
            {
                NSMutableArray *list = [NSMutableArray array];
                MFAnnotation *annotation = (__bridge_transfer MFAnnotation *)$1;
                if (annotation) {
                    [list addObject:annotation];
                }
                $$ = (__bridge_retained void *)list;
            }
            |
            annotation_list annotation
            {
                NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
                MFAnnotation *annotation = (__bridge_transfer MFAnnotation *)$2;
                [list addObject:annotation];
                $$ = (__bridge_retained void *)list;
            }
            ;


declare_struct: annotation_list DECLARE STRUCT IDENTIFIER LC
			IDENTIFIER COLON STRING_LITERAL COMMA
			IDENTIFIER COLON identifier_list
			RC
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				NSString *structName = (__bridge_transfer NSString *)$4;
				NSString *typeEncodingKey = (__bridge_transfer NSString *)$6;
				MFExpression *typeEncodingValueExpr = (__bridge_transfer MFExpression *)$8;
				NSString *keysKey = (__bridge_transfer NSString *)$10;
				NSArray *keysValue = (__bridge_transfer NSArray *)$12;
				MFStructDeclare *structDeclare = mf_create_struct_declare(annotationList, structName, typeEncodingKey, typeEncodingValueExpr, keysKey, keysValue);
				$$ = (__bridge_retained void *)structDeclare;
				
			}
			| annotation_list DECLARE STRUCT IDENTIFIER LC
			IDENTIFIER COLON identifier_list COMMA
			IDENTIFIER COLON STRING_LITERAL
			RC
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				NSString *structName = (__bridge_transfer NSString *)$4;
				NSString *keysKey = (__bridge_transfer NSString *)$6;
				NSArray *keysValue = (__bridge_transfer NSArray *)$8;
				NSString *typeEncodingKey = (__bridge_transfer NSString *)$10;
				MFExpression *typeEncodingValueExpr = (__bridge_transfer MFExpression *)$12;
				MFStructDeclare *structDeclare = mf_create_struct_declare(annotationList, structName, typeEncodingKey, typeEncodingValueExpr, keysKey, keysValue);
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




class_definition: annotation_list CLASS IDENTIFIER COLON annotation_list IDENTIFIER LC
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				NSString *name = (__bridge_transfer NSString *)$3;
                NSArray<MFAnnotation *> *superAnnotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$5;
				NSString *superName = (__bridge_transfer NSString *)$6;
				mf_start_class_definition(annotationList, name, superAnnotationList, superName,nil);
			}
			RC
			{
				MFClassDefinition *classDefinition = mf_end_class_definition(nil);
				$$ = (__bridge_retained void *)classDefinition;
			}
			| annotation_list CLASS IDENTIFIER COLON annotation_list IDENTIFIER LC
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				NSString *name = (__bridge_transfer NSString *)$3;
                NSArray<MFAnnotation *> *superAnnotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$5;
				NSString *superName = (__bridge_transfer NSString *)$6;
				mf_start_class_definition(annotationList, name, superAnnotationList, superName,nil);
			}
			member_definition_list RC
			{
				NSArray *members = (__bridge_transfer NSArray *)$9;
				MFClassDefinition *classDefinition = mf_end_class_definition(members);
				$$ = (__bridge_retained void *)classDefinition;
			}
			| annotation_list CLASS IDENTIFIER COLON annotation_list IDENTIFIER LT protocol_list GT LC
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				NSString *name = (__bridge_transfer NSString *)$3;
                NSArray<MFAnnotation *> *superAnnotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$5;
				NSString *superName = (__bridge_transfer NSString *)$6;
				NSArray *protocolNames = (__bridge_transfer NSArray *)$8;
				mf_start_class_definition(annotationList, name, superAnnotationList, superName, protocolNames);
			}
			RC
			{
				MFClassDefinition *classDefinition = mf_end_class_definition(nil);
				$$ = (__bridge_retained void *)classDefinition;
			}
			| annotation_list CLASS IDENTIFIER COLON annotation_list IDENTIFIER LT protocol_list GT LC
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				NSString *name = (__bridge_transfer NSString *)$3;
                NSArray<MFAnnotation *> *superAnnotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$5;
				NSString *superName = (__bridge_transfer NSString *)$6;
				NSArray *protocolNames = (__bridge_transfer NSArray *)$8;
				mf_start_class_definition(annotationList, name, superAnnotationList, superName, protocolNames);
			}
			member_definition_list RC
			{
				NSArray *members = (__bridge_transfer NSArray *)$12;
				MFClassDefinition *classDefinition = mf_end_class_definition(members);
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


property_definition: annotation_list PROPERTY LP property_modifier_list RP type_specifier IDENTIFIER  SEMICOLON
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				MFPropertyModifier modifier = $4;
				MFTypeSpecifier *typeSpecifier = (__bridge_transfer MFTypeSpecifier *)$6;
				NSString *name = (__bridge_transfer NSString *)$7;
				MFPropertyDefinition *propertyDefinition = mf_create_property_definition(annotationList, modifier, typeSpecifier, name);
				$$ = (__bridge_retained void *)propertyDefinition;
			}
			| annotation_list PROPERTY LP  RP type_specifier IDENTIFIER SEMICOLON
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				MFTypeSpecifier *typeSpecifier = (__bridge_transfer MFTypeSpecifier *)$5;
				NSString *name = (__bridge_transfer NSString *)$6;
				MFPropertyDefinition *propertyDefinition = mf_create_property_definition(annotationList, 0x00, typeSpecifier, name);
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
				$$ = MFPropertyModifierMemWeak;
			}
			| STRONG
			{
				$$ = MFPropertyModifierMemStrong;
			}
			| COPY
			{
				$$ = MFPropertyModifierMemCopy;
			}
			| ASSIGN_MEM
			{
				$$ = MFPropertyModifierMemAssign;
			}
			;

property_atomic_modifier: NONATOMIC
			{
				$$ = MFPropertyModifierNonatomic;
			}
			| ATOMIC
			{
				$$ = MFPropertyModifierAtomic;
			}
			;
            
swift_class_alias: SWIFT_CLASS_ALIAS IDENTIFIER IDENTIFIER SEMICOLON
            {
                mf_add_swift_class_alias((__bridge_transfer NSString *)$2, nil, nil, nil, nil, (__bridge_transfer NSString *)$3);
            }
            | SWIFT_CLASS_ALIAS IDENTIFIER DOT IDENTIFIER  IDENTIFIER SEMICOLON
            {
                mf_add_swift_class_alias((__bridge_transfer NSString *)$2, (__bridge_transfer NSString *)$4, nil, nil, nil, (__bridge_transfer NSString *)$5);
            }
            | SWIFT_CLASS_ALIAS IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER IDENTIFIER SEMICOLON
            {
                mf_add_swift_class_alias((__bridge_transfer NSString *)$2, (__bridge_transfer NSString *)$4, (__bridge_transfer NSString *)$6, nil, nil, (__bridge_transfer NSString *)$7);
            }
            | SWIFT_CLASS_ALIAS IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER IDENTIFIER SEMICOLON
            {
                mf_add_swift_class_alias((__bridge_transfer NSString *)$2, (__bridge_transfer NSString *)$4, (__bridge_transfer NSString *)$6, (__bridge_transfer NSString *)$8, nil, (__bridge_transfer NSString *)$9);
            }
            | SWIFT_CLASS_ALIAS IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER DOT IDENTIFIER IDENTIFIER SEMICOLON
            {
                mf_add_swift_class_alias((__bridge_transfer NSString *)$2, (__bridge_transfer NSString *)$4, (__bridge_transfer NSString *)$6, (__bridge_transfer NSString *)$8, (__bridge_transfer NSString *)$10, (__bridge_transfer NSString *)$11);
            }
            ;


typedef_definition: TYPEDEF BOOL_ IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_BOOL, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF INT IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_INT, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF U_INT IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_U_INT, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF DOUBLE IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_DOUBLE, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF C_STRING IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_C_STRING, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF ID IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_OBJECT, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF BLOCK IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_BLOCK, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF CLASS_ IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_CLASS, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF SEL_ IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_SEL, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF POINTER IDENTIFIER SEMICOLON
            {
                mf_add_typedef(MF_TYPE_POINTER, (__bridge_transfer NSString *)$3);
            }
            | TYPEDEF IDENTIFIER IDENTIFIER SEMICOLON
            {
                mf_add_typedef_from_alias((__bridge_transfer NSString *)$2,(__bridge_transfer NSString *)$3);
            }
            ;

type_specifier: VOID
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_VOID);
			}
			| BOOL_
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_BOOL);
			}
			| INT
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_INT);
			}
			| U_INT
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_U_INT);
			}
			| DOUBLE
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_DOUBLE);
			}
			| C_STRING
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_C_STRING);
			}
			|ID
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_OBJECT);
			}
			|CLASS_
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_CLASS);
			}
			|SEL_
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_SEL);
			}
			| BLOCK
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_BLOCK);
			}
			| POINTER
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_POINTER);
			}
            | C_FUNCTION LT c_type_identier_list GT
            {
                NSArray *typeList = (__bridge_transfer NSArray *)$3;
                $$ =  (__bridge_retained void *)mf_create_cfuntion_type_specifier(typeList);
            }
			| IDENTIFIER ASTERISK
			{
				$$ =  (__bridge_retained void *)mf_create_type_specifier(MF_TYPE_OBJECT);
			}
			| STRUCT IDENTIFIER
			{
				$$ =  (__bridge_retained void *)mf_create_struct_type_specifier((__bridge_transfer NSString *)$2);
			}
			| IDENTIFIER
			{
                MFTypedefTable *typedefTable = [MFTypedefTable shareInstance];
                MFTypeSpecifierKind type = [typedefTable typeWtihIdentifer:(__bridge_transfer NSString *)$1];
				$$ = (__bridge_retained void *)mf_create_type_specifier(type);
			}
			;


method_definition: instance_method_definition
			| class_method_definition
			;

instance_method_definition: annotation_list SUB LP type_specifier RP method_name block_statement
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				MFTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MFTypeSpecifier *)$4;
				NSArray *items = (__bridge_transfer NSArray *)$6;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$7;
				MFMethodDefinition *methodDefinition = mf_create_method_definition(annotationList, NO, returnTypeSpecifier, items, block);
				$$ = (__bridge_retained void *)methodDefinition;
			}
			;

class_method_definition: annotation_list ADD LP type_specifier RP method_name  block_statement
			{
                NSArray<MFAnnotation *> *annotationList = (__bridge_transfer NSArray<MFAnnotation *> *)$1;
				MFTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MFTypeSpecifier *)$4;
				NSArray *items = (__bridge_transfer NSArray *)$6;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$7;
				MFMethodDefinition *methodDefinition = mf_create_method_definition(annotationList, YES, returnTypeSpecifier, items, block);
				$$ = (__bridge_retained void *)methodDefinition;
			}
			;	

method_name: method_name_1
			| method_name_2
			;		

method_name_1: IDENTIFIER
			{
				NSString *name = (__bridge_transfer NSString *)$1;
				MFMethodNameItem *item = mf_create_method_name_item(name, nil, nil);
				NSMutableArray *list = [NSMutableArray array];
				[list addObject:item];
				$$ = (__bridge_retained void *)list;
			}
			;

method_name_2: method_name_item
			{
				NSMutableArray *list = [NSMutableArray array];
				MFMethodNameItem *item = (__bridge_transfer MFMethodNameItem *)$1;
				[list addObject:item];
				$$ = (__bridge_retained void *)list;
			}
			| method_name_2 method_name_item
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFMethodNameItem *item = (__bridge_transfer MFMethodNameItem *)$2;
				[list addObject:item];
				$$ = (__bridge_retained void *)list;
			}
			;

method_name_item: IDENTIFIER COLON LP type_specifier RP IDENTIFIER
			{
				NSString *name = (__bridge_transfer NSString *)$1;
				name = [NSString stringWithFormat:@"%@:",name];
				MFTypeSpecifier *typeSpecifier = (__bridge_transfer MFTypeSpecifier *)$4;
				NSString *paramName = (__bridge_transfer NSString *)$6;
				MFMethodNameItem *item = mf_create_method_name_item(name, typeSpecifier, paramName);
				$$ = (__bridge_retained void *)item;
			}
		;

member_definition: property_definition
			| method_definition
			;
		
member_definition_list: member_definition
			{
				NSMutableArray *list = [NSMutableArray array];
				MFMemberDefinition *memberDefinition = (__bridge_transfer MFMemberDefinition *)$1;
				[list addObject:memberDefinition];
				$$ = (__bridge_retained void *)list;
			}
			| member_definition_list member_definition
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFMemberDefinition *memberDefinition = (__bridge_transfer MFMemberDefinition *)$2;
				[list addObject:memberDefinition];
				$$ = (__bridge_retained void *)list;
			}
			;

selector: selector_1
			| selector_2
			;

selector_1: IDENTIFIER
            | key_work_identifier
			;

selector_2: selector_1 COLON
			{
				NSString *name = (__bridge_transfer NSString *)$1;
				NSString *selector = [NSString stringWithFormat:@"%@:",name];
				$$ = (__bridge_retained void *)selector;
			}
			| selector_2 selector_1 COLON
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
				MFAssignExpression *expr = (MFAssignExpression *)mf_create_expression(MF_ASSIGN_EXPRESSION);
				expr.assignKind = $2;
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

assignment_operator: ASSIGN
				{
					$$ = MF_NORMAL_ASSIGN;
					
				}
                | SUB_ASSIGN
				{
					$$ = MF_SUB_ASSIGN;
				}
                | ADD_ASSIGN
				{
					$$ = MF_ADD_ASSIGN;
				}
                | ASTERISK_ASSIGN
				{
					$$ = MF_MUL_ASSIGN;
				}
                | DIV_ASSIGN
				{
					$$ = MF_DIV_ASSIGN;
				}
                | MOD_ASSIGN
				{
					$$ = MF_MOD_ASSIGN;
				}
                ;

ternary_operator_expression: logic_or_expression
 			| logic_or_expression  QUESTION ternary_operator_expression  COLON ternary_operator_expression
			{
				MFTernaryExpression *expr = (MFTernaryExpression *)mf_create_expression(MF_TERNARY_EXPRESSION);
				expr.condition = (__bridge_transfer MFExpression *)$1;
				expr.trueExpr = (__bridge_transfer MFExpression *)$3;
				expr.falseExpr = (__bridge_transfer MFExpression *)$5;
				$$ = (__bridge_retained void *)expr;
			}
			| logic_or_expression  QUESTION COLON ternary_operator_expression
			{
				MFTernaryExpression *expr = (MFTernaryExpression *)mf_create_expression(MF_TERNARY_EXPRESSION);
				expr.condition = (__bridge_transfer MFExpression *)$1;
				expr.falseExpr = (__bridge_transfer MFExpression *)$4;
				$$ = (__bridge_retained void *)expr;
			}
			;

logic_or_expression: logic_and_expression
			| logic_or_expression OR logic_and_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_LOGICAL_OR_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

logic_and_expression: equality_expression
			| logic_and_expression AND equality_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_LOGICAL_AND_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

equality_expression: relational_expression
			| equality_expression EQ relational_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_EQ_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| equality_expression NE relational_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_NE_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

relational_expression: additive_expression
			| relational_expression LT additive_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_LT_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| relational_expression LE additive_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_LE_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| relational_expression GT additive_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_GT_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| relational_expression GE additive_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_GE_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

additive_expression: multiplication_expression
			| additive_expression ADD multiplication_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_ADD_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| additive_expression SUB multiplication_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_SUB_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

multiplication_expression: unary_expression
			| multiplication_expression ASTERISK unary_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_MUL_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| multiplication_expression DIV unary_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_DIV_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| multiplication_expression MOD unary_expression
			{
				MFBinaryExpression *expr = (MFBinaryExpression *)mf_create_expression(MF_MOD_EXPRESSION);
				expr.left = (__bridge_transfer MFExpression *)$1;
				expr.right = (__bridge_transfer MFExpression *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			;

unary_expression: postfix_expression
			| NOT unary_expression
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_LOGICAL_NOT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| SUB unary_expression
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(NSC_NEGATIVE_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			;

postfix_expression: primary_expression
			| primary_expression INCREMENT
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_INCREMENT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$1;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| primary_expression DECREMENT
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_DECREMENT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$1;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			;

expression_list: assign_expression
			{
				NSMutableArray *list = [NSMutableArray array];
				MFExpression *expr = (__bridge_transfer MFExpression *)$1;
				[list addObject:expr];
				$$ = (__bridge_retained void *)list;
			}
			| expression_list COMMA assign_expression
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFExpression *expr = (__bridge_transfer MFExpression *)$3;
				[list addObject:expr];
				$$ = (__bridge_retained void *)list;
			}
			;

dic_entry: primary_expression COLON primary_expression
			{
				MFExpression *keyExpr = (__bridge_transfer MFExpression *)$1;
				MFExpression *valueExpr = (__bridge_transfer MFExpression *)$3;
				MFDicEntry *dicEntry = mf_create_dic_entry(keyExpr, valueExpr);
				$$ = (__bridge_retained void *)dicEntry;
			}
			;

dic_entry_list: dic_entry
			{
				NSMutableArray *list = [NSMutableArray array];
				MFDicEntry *dicEntry = (__bridge_transfer MFDicEntry *)$1;
				[list addObject:dicEntry];
				$$ = (__bridge_retained void *)list;
			} 
			| dic_entry_list COMMA dic_entry
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFDicEntry *dicEntry = (__bridge_transfer MFDicEntry *)$3;
				[list addObject:dicEntry];
				$$ = (__bridge_retained void *)list;
			}
			;

dic: AT LC  dic_entry_list RC
			{
				MFDictionaryExpression *expr = (MFDictionaryExpression *)mf_create_expression(MF_DIC_LITERAL_EXPRESSION);
				NSArray *entriesExpr = (__bridge_transfer NSArray *)$3;
				expr.entriesExpr = entriesExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT LC  RC
			{
				MFDictionaryExpression *expr = (MFDictionaryExpression *)mf_create_expression(MF_DIC_LITERAL_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
			;


struct_entry: IDENTIFIER COLON primary_expression
			{
				NSString *key = (__bridge_transfer NSString *)$1;
				MFExpression *valueExpr = (__bridge_transfer MFExpression *)$3;
				MFStructEntry *structEntry = mf_create_struct_entry(key, valueExpr);
				$$ = (__bridge_retained void *)structEntry;
			}
			;

struct_entry_list: struct_entry
			{
				NSMutableArray *list = [NSMutableArray array];
				MFStructEntry *structEntry = (__bridge_transfer MFStructEntry *)$1;
				[list addObject:structEntry];
				$$ = (__bridge_retained void *)list;
			}
			| struct_entry_list COMMA struct_entry
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFStructEntry *structEntry = (__bridge_transfer MFStructEntry *)$3;
				[list addObject:structEntry];
				$$ = (__bridge_retained void *)list;
			}
			;

struct_literal:  LC  struct_entry_list RC
			{
				MFStructpression *expr = (MFStructpression *)mf_create_expression(MF_STRUCT_LITERAL_EXPRESSION);
				NSArray *entriesExpr = (__bridge_transfer NSArray *)$2;
				expr.entriesExpr = entriesExpr;
				$$ = (__bridge_retained void *)expr;
			}
			;

c_type_identier: key_work_identifier
            | IDENTIFIER
            | VOID ASTERISK
            {
                $$ = (__bridge_retained void *)@"void *";
            }
            | CHAR ASTERISK
            {
                $$ = (__bridge_retained void *)@"char *";
            }
            | STRUCT IDENTIFIER
            {
                $$ = (__bridge_retained void *)[NSString stringWithFormat:@"struct %@",(__bridge_transfer NSString *)$2];
            }
            ;

c_type_identier_list:c_type_identier
            {
                NSMutableArray *list = [NSMutableArray array];
                NSString *identifer = (__bridge_transfer NSString *)$1;
                [list addObject:identifer];
                $$ = (__bridge_retained void *)list;
            }
            | c_type_identier_list COMMA c_type_identier
            {
                    NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
                    NSString *identifer = (__bridge_transfer NSString *)$3;
                    [list addObject:identifer];
                    $$ = (__bridge_retained void *)list;
            }
            ;

key_work_identifier: ID
            {
                $$ = (__bridge_retained void *)@"id";
            }
            | CLASS
            {
                $$ = (__bridge_retained void *)@"class";
            }
            | CLASS_
            {
                $$ = (__bridge_retained void *)@"Class";
            }
            | COPY
            {
                $$ = (__bridge_retained void *)@"copy";
            }
            | BOOL_
            {
                $$ = (__bridge_retained void *)@"BOOL";
            }
            | INT
            {
                $$ = (__bridge_retained void *)@"int";
            }
            | U_INT
            {
                $$ = (__bridge_retained void *)@"uint";
            }
            | DOUBLE
            {
                $$ = (__bridge_retained void *)@"double";
            }
            | SEL_
            {
                $$ = (__bridge_retained void *)@"SEL";
            }
            | VOID
            {
                $$ = (__bridge_retained void *)@"void";
            }
            ;

primary_expression: IDENTIFIER
			{
				MFIdentifierExpression *expr = (MFIdentifierExpression *)mf_create_expression(MF_IDENTIFIER_EXPRESSION);
				NSString *identifier = (__bridge_transfer NSString *)$1;;
				expr.identifier = identifier;
				$$ = (__bridge_retained void *)expr;
			}
            | ADDRESS IDENTIFIER
            {
                MFIdentifierExpression *identiferExpr = (MFIdentifierExpression *)mf_create_expression(MF_IDENTIFIER_EXPRESSION);
                NSString *identifier = (__bridge_transfer NSString *)$2;;
                identiferExpr.identifier = identifier;
                
                MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_GET_ADDRESS_EXPRESSION);
                expr.expr = identiferExpr;
                $$ = (__bridge_retained void *)expr;
            }
			| primary_expression DOT IDENTIFIER
			{
				MFMemberExpression *expr = (MFMemberExpression *)mf_create_expression(MF_MEMBER_EXPRESSION);
				expr.expr = (__bridge_transfer MFExpression *)$1;
				expr.memberName = (__bridge_transfer NSString *)$3;
				$$ = (__bridge_retained void *)expr;
			}

            | primary_expression DOT key_work_identifier
            {
                MFMemberExpression *expr = (MFMemberExpression *)mf_create_expression(MF_MEMBER_EXPRESSION);
                expr.expr = (__bridge_transfer MFExpression *)$1;
                expr.memberName = (__bridge_transfer NSString *)$3;
                $$ = (__bridge_retained void *)expr;
            }
			| primary_expression DOT selector LP RP
			{
				MFExpression *expr = (__bridge_transfer MFExpression *)$1;
				NSString *selector = (__bridge_transfer NSString *)$3;
				MFMemberExpression *memberExpr = (MFMemberExpression *)mf_create_expression(MF_MEMBER_EXPRESSION);
				memberExpr.expr = expr;
				memberExpr.memberName = selector;
				
				MFFunctonCallExpression *funcCallExpr = (MFFunctonCallExpression *)mf_create_expression(MF_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = memberExpr;
				
				$$ = (__bridge_retained void *)funcCallExpr;
			}
			| primary_expression DOT selector LP expression_list RP
			{
				MFExpression *expr = (__bridge_transfer MFExpression *)$1;
				NSString *selector = (__bridge_transfer NSString *)$3;
				MFMemberExpression *memberExpr = (MFMemberExpression *)mf_create_expression(MF_MEMBER_EXPRESSION);
				memberExpr.expr = expr;
				memberExpr.memberName = selector;
				
				MFFunctonCallExpression *funcCallExpr = (MFFunctonCallExpression *)mf_create_expression(MF_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = memberExpr;
				funcCallExpr.args = (__bridge_transfer NSArray<MFExpression *> *)$5;
				
				$$ = (__bridge_retained void *)funcCallExpr;
			}
			| primary_expression LP RP
			{
                MFExpression *expr = (__bridge_transfer MFExpression *)$1;
				MFFunctonCallExpression *funcCallExpr = (MFFunctonCallExpression *)mf_create_expression(MF_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = expr;
				$$ = (__bridge_retained void *)funcCallExpr;
			}
		    | primary_expression LP expression_list RP
			{
                MFExpression *expr = (__bridge_transfer MFExpression *)$1;
				MFFunctonCallExpression *funcCallExpr = (MFFunctonCallExpression *)mf_create_expression(MF_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = expr;
				funcCallExpr.args = (__bridge_transfer NSArray<MFExpression *> *)$3;
				$$ = (__bridge_retained void *)funcCallExpr;
			}
			| LP expression RP
			{
				$$ = $2;
			}
			| primary_expression LB expression RB
			{
				MFExpression *arrExpr = (__bridge_transfer MFExpression *)$1;
				MFExpression *indexExpr = (__bridge_transfer MFExpression *)$3;
				
				MFSubScriptExpression *expr = (MFSubScriptExpression *)mf_create_expression(MF_SUB_SCRIPT_EXPRESSION);
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
			| NULL_
			| SELECTOR LP selector RP
			{
				MFExpression *expr = mf_create_expression(MF_SELECTOR_EXPRESSION);
				expr.selectorName = (__bridge_transfer NSString *)$3;
				$$ = (__bridge_retained void *)expr;
			}
			| AT INTETER_LITERAL
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_AT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT DOUBLE_LITERAL
			{
				
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_AT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT STRING_LITERAL
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_AT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT YES_
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_AT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT NO_
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_AT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$2;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| SELF
			{
				MFExpression *expr = mf_create_expression(MF_SELF_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
			| SUPER
			{
				MFExpression *expr = mf_create_expression(MF_SUPER_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
			| AT LP expression RP
			{
				MFUnaryExpression *expr = (MFUnaryExpression *)mf_create_expression(MF_AT_EXPRESSION);
				MFExpression *subExpr = (__bridge_transfer MFExpression *)$3;
				expr.expr = subExpr;
				$$ = (__bridge_retained void *)expr;
			}
			| AT LB expression_list RB
			{
				MFArrayExpression *expr = (MFArrayExpression *)mf_create_expression(MF_ARRAY_LITERAL_EXPRESSION);
				NSArray *itemExpressions = (__bridge_transfer NSArray *)$3;
				expr.itemExpressions = itemExpressions;
				$$ = (__bridge_retained void *)expr;
			}
			| AT LB  RB
			{
				MFArrayExpression *expr = (MFArrayExpression *)mf_create_expression(MF_ARRAY_LITERAL_EXPRESSION);
				$$ = (__bridge_retained void *)expr;
			}
            | C_FUNCTION LP expression  RP
            {
                MFCFuntionExpression *expr = (MFCFuntionExpression *)mf_create_expression(MF_C_FUNCTION_EXPRESSION);
                MFExpression *cfunNameOrPointerExpr = (__bridge_transfer MFExpression *)$3;
                expr.cfunNameOrPointerExpr = cfunNameOrPointerExpr;
                $$ = (__bridge_retained void *)expr;
            }
			| dic
			| struct_literal
			| block_body
			;




block_body:  POWER type_specifier LP  RP block_statement
			{
				MFTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MFTypeSpecifier *)$2;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$5;
				MFBlockExpression *expr = (MFBlockExpression *)mf_create_expression(MF_BLOCK_EXPRESSION);
				mf_build_block_expr(expr,returnTypeSpecifier,nil,block);
				$$ = (__bridge_retained void *)expr;
				
			}
			|POWER type_specifier block_statement
			{
				MFTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MFTypeSpecifier *)$2;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$3;
				MFBlockExpression *expr = (MFBlockExpression *)mf_create_expression(MF_BLOCK_EXPRESSION);
				mf_build_block_expr(expr,returnTypeSpecifier,nil,block);
				$$ = (__bridge_retained void *)expr;
				
			}
			| POWER type_specifier LP function_param_list RP block_statement
			{
				MFTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MFTypeSpecifier *)$2;
				NSArray<MFParameter *> *parameter = (__bridge_transfer NSArray<MFParameter *> *)$4;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$6;
				MFBlockExpression *expr = (MFBlockExpression *)mf_create_expression(MF_BLOCK_EXPRESSION);
				mf_build_block_expr(expr,returnTypeSpecifier,parameter,block);
				$$ = (__bridge_retained void *)expr;
				
			}
			| POWER  LP  RP block_statement
			{
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$4;
				MFBlockExpression *expr = (MFBlockExpression *)mf_create_expression(MF_BLOCK_EXPRESSION);
				mf_build_block_expr(expr,nil,nil,block);
				$$ = (__bridge_retained void *)expr;
			}
			| POWER block_statement
			{
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$2;
				MFBlockExpression *expr = (MFBlockExpression *)mf_create_expression(MF_BLOCK_EXPRESSION);
				mf_build_block_expr(expr,nil,nil,block);
				$$ = (__bridge_retained void *)expr;
			}
			| POWER  LP function_param_list RP block_statement
			{
				NSArray<MFParameter *> *parameter = (__bridge_transfer NSArray<MFParameter *> *)$3;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$5;
				MFBlockExpression *expr = (MFBlockExpression *)mf_create_expression(MF_BLOCK_EXPRESSION);
				mf_build_block_expr(expr,nil,parameter,block);
				$$ = (__bridge_retained void *)expr;
			}
			;


function_param_list: function_param
			{
				NSMutableArray *list = [NSMutableArray array];
				MFParameter *parameter = (__bridge_transfer MFParameter *)$1;
				[list addObject:parameter];
				$$ = (__bridge_retained void *)list;
			}
			| function_param_list COMMA function_param
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFParameter *parameter = (__bridge_transfer MFParameter *)$3;
				[list addObject:parameter];
				$$ = (__bridge_retained void *)list;
			}
			;

function_param: type_specifier IDENTIFIER
			{
				MFTypeSpecifier *type = (__bridge_transfer MFTypeSpecifier *)$1;
				NSString *name = (__bridge_transfer NSString *)$2;
				MFParameter *parameter = mf_create_parameter(type, name);
				$$ = (__bridge_retained void *)parameter;
			}
			;

declaration_statement: declaration SEMICOLON
			{
				MFDeclaration *declaration = (__bridge_transfer MFDeclaration *)$1;
				MFDeclarationStatement *statement = mf_create_declaration_statement(declaration);
				$$ = (__bridge_retained void *)statement;
			}

declaration_modifier:__WEAK
            {
               $$ = MFDeclarationModifierWeak;
            }
            | __STRONG
            {
               $$ = MFDeclarationModifierStrong;
            }
            | STATIC
            {
                $$ = MFDeclarationModifierStatic;
            }
            ;

declaration_modifier_list:declaration_modifier
            | declaration_modifier_list declaration_modifier
            {
                $$ = $1 | $2;
            }
            ;

declaration: declaration_modifier_list type_specifier IDENTIFIER
			{
				MFTypeSpecifier *type = (__bridge_transfer MFTypeSpecifier *)$2;
				NSString *name = (__bridge_transfer NSString *)$3;
				MFDeclaration *declaration = mf_create_declaration(false, $1,type, name, nil);
                
				$$ = (__bridge_retained void *)declaration;
			}
			| declaration_modifier_list type_specifier IDENTIFIER ASSIGN expression
			{
				MFTypeSpecifier *type = (__bridge_transfer MFTypeSpecifier *)$2;
				NSString *name = (__bridge_transfer NSString *)$3;
				MFExpression *initializer = (__bridge_transfer MFExpression *)$5;
				MFDeclaration *declaration = mf_create_declaration(false, $1,type, name, initializer);
				$$ = (__bridge_retained void *)declaration;
			}
            | type_specifier IDENTIFIER
            {
                MFTypeSpecifier *type = (__bridge_transfer MFTypeSpecifier *)$1;
                NSString *name = (__bridge_transfer NSString *)$2;
                MFDeclaration *declaration = mf_create_declaration(false, MFDeclarationModifierNone, type, name, nil);
                $$ = (__bridge_retained void *)declaration;
            }
            | type_specifier IDENTIFIER ASSIGN expression
            {
                MFTypeSpecifier *type = (__bridge_transfer MFTypeSpecifier *)$1;
                NSString *name = (__bridge_transfer NSString *)$2;
                MFExpression *initializer = (__bridge_transfer MFExpression *)$4;
                MFDeclaration *declaration = mf_create_declaration(false, MFDeclarationModifierNone, type, name, initializer);
                $$ = (__bridge_retained void *)declaration;
            }
            | EXTERN type_specifier IDENTIFIER
            {
                MFTypeSpecifier *type = (__bridge_transfer MFTypeSpecifier *)$2;
                NSString *name = (__bridge_transfer NSString *)$3;
                MFDeclaration *declaration = mf_create_declaration(true, MFDeclarationModifierNone, type, name, nil);
                $$ = (__bridge_retained void *)declaration;
            }
			;
			


if_statement: IF LP expression RP block_statement
			{
				MFExpression *condition = (__bridge_transfer MFExpression *)$3;
				MFBlockBody  *thenBlock = (__bridge_transfer MFBlockBody  *)$5;
				MFIfStatement *statement = mf_create_if_statement(condition, thenBlock, nil, nil);
				$$ = (__bridge_retained void *)statement;
			}
			| IF LP expression RP block_statement ELSE block_statement
			{
				MFExpression *condition = (__bridge_transfer MFExpression *)$3;
				MFBlockBody  *thenBlock = (__bridge_transfer MFBlockBody  *)$5;
				MFBlockBody  *elseBlocl = (__bridge_transfer MFBlockBody  *)$7;
				MFIfStatement *statement = mf_create_if_statement(condition, thenBlock, nil, elseBlocl);
				$$ = (__bridge_retained void *)statement;
			}
			| IF LP expression RP block_statement else_if_list
			{
				MFExpression *condition = (__bridge_transfer MFExpression *)$3;
				MFBlockBody  *thenBlock = (__bridge_transfer MFBlockBody  *)$5;
				NSArray<MFElseIf *> *elseIfList = (__bridge_transfer NSArray<MFElseIf *> *)$6;
				MFIfStatement *statement = mf_create_if_statement(condition, thenBlock, elseIfList, nil);
				$$ = (__bridge_retained void *)statement;
			}
			| IF LP expression RP block_statement else_if_list ELSE block_statement
			{
				MFExpression *condition = (__bridge_transfer MFExpression *)$3;
				MFBlockBody  *thenBlock = (__bridge_transfer MFBlockBody  *)$5;
				NSArray<MFElseIf *> *elseIfList = (__bridge_transfer NSArray<MFElseIf *> *)$6;
				MFBlockBody  *elseBlocl = (__bridge_transfer MFBlockBody  *)$8;
				MFIfStatement *statement = mf_create_if_statement(condition, thenBlock, elseIfList, elseBlocl);
				$$ = (__bridge_retained void *)statement;
			}
			;

else_if_list: else_if
			{
				NSMutableArray *list = [NSMutableArray array];
				MFElseIf *elseIf = (__bridge_transfer MFElseIf *)$1;
				[list addObject:elseIf];
				$$ = (__bridge_retained void *)list;
			}
			| else_if_list else_if
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFElseIf *elseIf = (__bridge_transfer MFElseIf *)$2;
				[list addObject:elseIf];
				$$ = (__bridge_retained void *)list;
			}
			;

else_if: ELSE IF  LP expression RP  block_statement
			{
				MFExpression *condition = (__bridge_transfer MFExpression *)$4;
				MFBlockBody  *thenBlock = (__bridge_transfer MFBlockBody  *)$6;
				MFElseIf *elseIf = mf_create_else_if(condition, thenBlock);
				$$ = (__bridge_retained void *)elseIf;
			}
			;

switch_statement: SWITCH LP expression RP LC case_list default_opt RC
			{
				MFExpression *expr = (__bridge_transfer MFExpression *)$3;
				NSArray<MFCase *> *caseList = (__bridge_transfer NSArray *)$6;
				MFBlockBody  *defaultBlock = (__bridge_transfer MFBlockBody  *)$7;
				MFSwitchStatement *statement = mf_create_switch_statement(expr,caseList, defaultBlock);
				$$ = (__bridge_retained void *)statement;
			}
			;

case_list: one_case
			{
				NSMutableArray *list = [NSMutableArray array];
				MFCase *case_ = (__bridge_transfer MFCase *)$1;
				[list addObject:case_];
				$$ = (__bridge_retained void *)list;
			}
			| case_list one_case
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFCase *case_ = (__bridge_transfer MFCase *)$2;
				[list addObject:case_];
				$$ = (__bridge_retained void *)list;
			}
			;

one_case: CASE expression COLON block_statement
			{
				MFExpression *expr = (__bridge_transfer MFExpression *)$2;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$4;
				MFCase *case_ = mf_create_case(expr, block);
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
				MFExpression *initializerExpr = (__bridge_transfer MFExpression *)$3;
				MFExpression *condition = (__bridge_transfer MFExpression *)$5;
				MFExpression *post = (__bridge_transfer MFExpression *)$7;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$9;
				MFForStatement *statement = mf_create_for_statement(initializerExpr, nil,
				condition, post, block);
				$$ = (__bridge_retained void *)statement;
			}

			| FOR LP declaration SEMICOLON  expression_opt SEMICOLON expression_opt RP block_statement
			{
				MFDeclaration *declaration = (__bridge_transfer MFDeclaration *)$3;
				MFExpression *condition = (__bridge_transfer MFExpression *)$5;
				MFExpression *post = (__bridge_transfer MFExpression *)$7;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$9;
				MFForStatement *statement = mf_create_for_statement(nil, declaration,
				condition, post, block);
				$$ = (__bridge_retained void *)statement;
			}
			;

while_statement: WHILE LP expression RP block_statement
			{
				MFExpression *condition = (__bridge_transfer MFExpression *)$3;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$5;
				MFWhileStatement *statement = mf_create_while_statement( condition, block);
				$$ = (__bridge_retained void *)statement;
			}
			;

do_while_statement: DO block_statement WHILE LP expression RP SEMICOLON
			{
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$2;
				MFExpression *condition = (__bridge_transfer MFExpression *)$5;
				MFDoWhileStatement *statement = mf_create_do_while_statement(block, condition);
				$$ = (__bridge_retained void *)statement;
			}
			;

foreach_statement: FOR LP type_specifier IDENTIFIER IN expression RP block_statement
			{
				MFTypeSpecifier *typeSpecifier = (__bridge_transfer MFTypeSpecifier *)$3;
				NSString *varName = (__bridge_transfer NSString *)$4;
				MFExpression *arrayExpr = (__bridge_transfer MFExpression *)$6;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$8;
				MFForEachStatement *statement = mf_create_for_each_statement(typeSpecifier, varName, arrayExpr, block);
				$$ = (__bridge_retained void *)statement;
			}
			| FOR  LP IDENTIFIER IN expression RP block_statement
			{
				NSString *varName = (__bridge_transfer NSString *)$3;
				MFExpression *arrayExpr = (__bridge_transfer MFExpression *)$5;
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$7;
				MFForEachStatement *statement = mf_create_for_each_statement(nil, varName, arrayExpr, block);
				$$ = (__bridge_retained void *)statement;
			}
			;


continue_statement: CONTINUE SEMICOLON
			{
				MFContinueStatement *statement = mf_create_continue_statement();
				$$ = (__bridge_retained void *)statement;
			}
			;


break_statement: BREAK SEMICOLON
			{
				MFBreakStatement *statement = mf_create_break_statement();
				$$ = (__bridge_retained void *)statement;
			}
			;


return_statement: RETURN expression_opt SEMICOLON
			{
				MFExpression *expr = (__bridge_transfer MFExpression *)$2;
				MFReturnStatement *statement = mf_create_return_statement(expr);
				$$ = (__bridge_retained void *)statement;
			}
			;

expression_statement:expression SEMICOLON
			{
				MFExpression *expr = (__bridge_transfer MFExpression *)$1;
				MFExpressionStatement *statement  = mf_create_expression_statement(expr);
				$$ = (__bridge_retained void *)statement;
			}
			;


block_statement: LC
			{
				MFBlockBody  *block = mf_open_block_statement();
				$<block_statement>$ = (__bridge_retained void *)block;
			}
			RC
			{
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$<block_statement>2;
				block = mf_close_block_statement(block,nil);
				$$ = (__bridge_retained void *)block;
			}
			| LC
			{
				MFBlockBody  *block = mf_open_block_statement();
				$<block_statement>$ = (__bridge_retained void *)block;
			}
			statement_list RC
			{
				MFBlockBody  *block = (__bridge_transfer MFBlockBody  *)$<block_statement>2;
				NSArray *list = (__bridge_transfer NSArray *)$3;
				block = mf_close_block_statement(block,list);
				$$ = (__bridge_retained void *)block;
			}
			;


statement_list: statement
			{
				NSMutableArray *list = [NSMutableArray array];
				MFStatement *statement = (__bridge_transfer MFStatement *)$1;
				[list addObject:statement];
				$$ = (__bridge_retained void *)list;
			}
			| statement_list statement
			{
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)$1;
				MFStatement *statement = (__bridge_transfer MFStatement *)$2;
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
