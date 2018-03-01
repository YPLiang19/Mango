//
//  create.h
//  ananasExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#ifndef create_h
#define create_h
#import "man_ast.h"


typedef NS_ENUM(NSUInteger, MANCompileError) {
	MANCompileErrorStructDeclareRedefinition,
	MANCompileErrorStructDeclareLackTypeEncoding,
	MANCompileErrorStructDeclareLackTypeKeys,
	MANSameClassDefinitionDifferentSuperClass,
	MANRedefinitionPropertyInSameClass,
	MANRedefinitionPropertyInChildClass,
	MANParameterRedefinition,
	
};

void anc_open_string_literal_buf(void);
void anc_append_string_literal(int letter);
const char* anc_end_string_literal(void);
NSString *anc_create_identifier(char *str);
MANDicEntry *anc_create_dic_entry(MANExpression *keyExpr, MANExpression *valueExpr);
MANExpression *anc_create_expression(MANExpressionKind kind);
void anc_build_block_expr(MANBlockExpression *expr, MANTypeSpecifier *returnTypeSpecifier, NSArray<MANParameter *> *params,  MANBlockBody *block);
MANStructDeclare *anc_create_struct_declare(MANExpression *annotaionIfConditionExpr, NSString *structName, NSString *typeEncodingKey, const char *typeEncodingValue, NSString *keysKey, NSArray<NSString *> *keysValue);
MANTypeSpecifier *anc_create_type_specifier(ANATypeSpecifierKind kind);
MANTypeSpecifier *anc_create_struct_type_specifier(NSString *structName);

MANParameter *anc_create_parameter(MANTypeSpecifier *type, NSString *name);
MANDeclaration *anc_create_declaration(MANTypeSpecifier *type, NSString *name, MANExpression *initializer);
MANDeclarationStatement *anc_create_declaration_statement(MANDeclaration *declaration);
MANExpressionStatement *anc_create_expression_statement(MANExpression *expr);
MANElseIf *anc_create_else_if(MANExpression *condition,  MANBlockBody *thenBlock);
MANIfStatement *anc_create_if_statement(MANExpression *condition, MANBlockBody *thenBlock,NSArray<MANElseIf *> *elseIfList, MANBlockBody *elseBlocl);
MANCase *anc_create_case(MANExpression *expr,  MANBlockBody *block);
MANSwitchStatement *anc_create_switch_statement(MANExpression *expr, NSArray<MANCase *> *caseList,  MANBlockBody *defaultBlock);
MANForStatement *anc_create_for_statement(MANExpression *initializerExpr, MANDeclaration *declaration,
										  MANExpression *condition, MANExpression *post,  MANBlockBody *block);
MANForEachStatement *anc_create_for_each_statement( MANTypeSpecifier *typeSpecifier, NSString *varName, MANExpression *arrayExpr,  MANBlockBody *block);
MANWhileStatement *anc_create_while_statement(MANExpression *condition,  MANBlockBody *block);
MANDoWhileStatement *anc_create_do_while_statement(  MANBlockBody *block, MANExpression *condition);
MANContinueStatement *anc_create_continue_statement(void);
MANBreakStatement *anc_create_break_statement(void);
MANReturnStatement *anc_create_return_statement(MANExpression *retValExpr);
 MANBlockBody *anc_open_block_statement(void);
 MANBlockBody *anc_close_block_statement( MANBlockBody *block, NSArray<MANStatement *> *statementList);
void anc_start_class_definition(MANExpression *annotaionIfConditionExpr, NSString *name, NSString *superNmae, NSArray<NSString *> *protocolNames);
MANClassDefinition *anc_end_class_definition(NSArray<MANMemberDefinition *> *members);

MANFunctionDefinition *anc_create_function_definition(MANTypeSpecifier *returnTypeSpecifier,NSString *name ,NSArray<MANParameter *> *prasms,  MANBlockBody *block);
MANMethodNameItem *anc_create_method_name_item(NSString *name, MANTypeSpecifier *typeSpecifier, NSString *paramName);
MANMethodDefinition *anc_create_method_definition(MANExpression *annotaionIfConditionExpr, BOOL classMethod, MANTypeSpecifier *returnTypeSpecifier, NSArray<MANMethodNameItem *> *items,  MANBlockBody *block);
MANPropertyDefinition *anc_create_property_definition(MANExpression *annotaionIfConditionExpr, MANPropertyModifier modifier, MANTypeSpecifier *typeSpecifier, NSString *name);
void anc_add_class_definition(MANClassDefinition *classDefinition);
void anc_add_struct_declare(MANStructDeclare *structDeclare);
void anc_add_statement(MANStatement *statement);

void ane_test(id obj);


MANInterpreter *anc_get_current_compile_util(void);
void anc_set_current_compile_util(MANInterpreter *interpreter);


void anc_compile_err(NSUInteger lineNumber,MANCompileError error,...);

#endif /* create_h */
