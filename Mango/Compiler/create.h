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
	MANCompileErrorParseErr,
	MANCompileErrorStructDeclareRedefinition,
	MANCompileErrorStructDeclareLackTypeEncoding,
	MANCompileErrorStructDeclareLackTypeKeys,
	MANSameClassDefinitionDifferentSuperClass,
	MANRedefinitionPropertyInSameClass,
	MANRedefinitionPropertyInChildClass,
	MANParameterRedefinition,
	
};

void man_open_string_literal_buf(void);
void man_append_string_literal(int letter);
const char* man_end_string_literal(void);
NSString *man_create_identifier(char *str);
MANStructEntry *man_create_struct_entry(NSString *key, MANExpression *valueExpr);
MANDicEntry *man_create_dic_entry(MANExpression *keyExpr, MANExpression *valueExpr);
MANExpression *man_create_expression(MANExpressionKind kind);
void man_build_block_expr(MANBlockExpression *expr, MANTypeSpecifier *returnTypeSpecifier, NSArray<MANParameter *> *params,  MANBlockBody *block);
MANStructDeclare *man_create_struct_declare(MANExpression *annotaionIfConditionExpr, NSString *structName, NSString *typeEncodingKey, const char *typeEncodingValue, NSString *keysKey, NSArray<NSString *> *keysValue);
MANTypeSpecifier *man_create_type_specifier(ANATypeSpecifierKind kind);
MANTypeSpecifier *man_create_struct_type_specifier(NSString *structName);

MANParameter *man_create_parameter(MANTypeSpecifier *type, NSString *name);
MANDeclaration *man_create_declaration(MANTypeSpecifier *type, NSString *name, MANExpression *initializer);
MANDeclarationStatement *man_create_declaration_statement(MANDeclaration *declaration);
MANExpressionStatement *man_create_expression_statement(MANExpression *expr);
MANElseIf *man_create_else_if(MANExpression *condition,  MANBlockBody *thenBlock);
MANIfStatement *man_create_if_statement(MANExpression *condition, MANBlockBody *thenBlock,NSArray<MANElseIf *> *elseIfList, MANBlockBody *elseBlocl);
MANCase *man_create_case(MANExpression *expr,  MANBlockBody *block);
MANSwitchStatement *man_create_switch_statement(MANExpression *expr, NSArray<MANCase *> *caseList,  MANBlockBody *defaultBlock);
MANForStatement *man_create_for_statement(MANExpression *initializerExpr, MANDeclaration *declaration,
										  MANExpression *condition, MANExpression *post,  MANBlockBody *block);
MANForEachStatement *man_create_for_each_statement( MANTypeSpecifier *typeSpecifier, NSString *varName, MANExpression *arrayExpr,  MANBlockBody *block);
MANWhileStatement *man_create_while_statement(MANExpression *condition,  MANBlockBody *block);
MANDoWhileStatement *man_create_do_while_statement(  MANBlockBody *block, MANExpression *condition);
MANContinueStatement *man_create_continue_statement(void);
MANBreakStatement *man_create_break_statement(void);
MANReturnStatement *man_create_return_statement(MANExpression *retValExpr);
 MANBlockBody *man_open_block_statement(void);
 MANBlockBody *man_close_block_statement( MANBlockBody *block, NSArray<MANStatement *> *statementList);
void man_start_class_definition(MANExpression *annotaionIfConditionExpr, NSString *name, NSString *superNmae, NSArray<NSString *> *protocolNames);
MANClassDefinition *man_end_class_definition(NSArray<MANMemberDefinition *> *members);

MANFunctionDefinition *man_create_function_definition(MANTypeSpecifier *returnTypeSpecifier,NSString *name ,NSArray<MANParameter *> *prasms,  MANBlockBody *block);
MANMethodNameItem *man_create_method_name_item(NSString *name, MANTypeSpecifier *typeSpecifier, NSString *paramName);
MANMethodDefinition *man_create_method_definition(MANExpression *annotaionIfConditionExpr, BOOL classMethod, MANTypeSpecifier *returnTypeSpecifier, NSArray<MANMethodNameItem *> *items,  MANBlockBody *block);
MANPropertyDefinition *man_create_property_definition(MANExpression *annotaionIfConditionExpr, MANPropertyModifier modifier, MANTypeSpecifier *typeSpecifier, NSString *name);
void man_add_class_definition(MANClassDefinition *classDefinition);
void man_add_struct_declare(MANStructDeclare *structDeclare);
void man_add_statement(MANStatement *statement);

void ane_test(id obj);


MANInterpreter *man_get_current_compile_util(void);
void man_set_current_compile_util(MANInterpreter *interpreter);


void man_compile_err(NSUInteger lineNumber,MANCompileError error,...);

#endif /* create_h */
