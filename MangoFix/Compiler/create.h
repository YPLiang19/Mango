//
//  create.h
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#ifndef create_h
#define create_h
#import "mf_ast.h"

void mf_open_string_literal_buf(void);

void mf_append_string_literal(int letter);

const char* mf_end_string_literal(void);

NSString *mf_create_identifier(char *str);

MFStructEntry *mf_create_struct_entry(NSString *key, MFExpression *valueExpr);

MFDicEntry *mf_create_dic_entry(MFExpression *keyExpr, MFExpression *valueExpr);

MFExpression *mf_create_expression(MFExpressionKind kind);

void mf_build_block_expr(MFBlockExpression *expr, MFTypeSpecifier *returnTypeSpecifier, NSArray<MFParameter *> *params,  MFBlockBody *block);

MFStructDeclare *mf_create_struct_declare(NSArray<MFAnnotation *> *annotationList, NSString *structName, NSString *typeEncodingKey, MFExpression *typeEncodingValueExpr, NSString *keysKey, NSArray<NSString *> *keysValue);

MFTypeSpecifier *mf_create_type_specifier(MFTypeSpecifierKind kind);

MFTypeSpecifier *mf_create_cfuntion_type_specifier( NSArray<NSString *> *typeList);

MFTypeSpecifier *mf_create_struct_type_specifier(NSString *structName);

MFParameter *mf_create_parameter(MFTypeSpecifier *type, NSString *name);

MFDeclaration *mf_create_declaration(BOOL externNativeGlobalVariable, MFDeclarationModifier modifier_list, MFTypeSpecifier *type, NSString *name, MFExpression *initializer);

MFDeclarationStatement *mf_create_declaration_statement(MFDeclaration *declaration);

MFExpressionStatement *mf_create_expression_statement(MFExpression *expr);

MFElseIf *mf_create_else_if(MFExpression *condition,  MFBlockBody *thenBlock);

MFIfStatement *mf_create_if_statement(MFExpression *condition, MFBlockBody *thenBlock,NSArray<MFElseIf *> *elseIfList, MFBlockBody *elseBlocl);

MFCase *mf_create_case(MFExpression *expr,  MFBlockBody *block);

MFSwitchStatement *mf_create_switch_statement(MFExpression *expr, NSArray<MFCase *> *caseList,  MFBlockBody *defaultBlock);

MFForStatement *mf_create_for_statement(MFExpression *initializerExpr, MFDeclaration *declaration,
										  MFExpression *condition, MFExpression *post,  MFBlockBody *block);

MFForEachStatement *mf_create_for_each_statement( MFTypeSpecifier *typeSpecifier, NSString *varName, MFExpression *arrayExpr,  MFBlockBody *block);

MFWhileStatement *mf_create_while_statement(MFExpression *condition,  MFBlockBody *block);

MFDoWhileStatement *mf_create_do_while_statement(  MFBlockBody *block, MFExpression *condition);

MFContinueStatement *mf_create_continue_statement(void);

MFBreakStatement *mf_create_break_statement(void);

MFReturnStatement *mf_create_return_statement(MFExpression *retValExpr);

MFBlockBody *mf_open_block_statement(void);

MFBlockBody *mf_close_block_statement(MFBlockBody *block, NSArray<MFStatement *> *statementList);

MFAnnotation *mf_create_annotation(NSString *name, MFExpression *expr);

void mf_start_class_definition(NSArray<MFAnnotation *> *annotationList, NSString *name, NSArray<MFAnnotation *> *superAnnotationList, NSString *superName, NSArray<NSString *> *protocolNames);

MFClassDefinition *mf_end_class_definition(NSArray<MFMemberDefinition *> *members);

MFFunctionDefinition *mf_create_function_definition(MFTypeSpecifier *returnTypeSpecifier,NSString *name ,NSArray<MFParameter *> *prasms,  MFBlockBody *block);

MFMethodNameItem *mf_create_method_name_item(NSString *name, MFTypeSpecifier *typeSpecifier, NSString *paramName);

MFMethodDefinition *mf_create_method_definition(NSArray<MFAnnotation *> *annotationList, BOOL classMethod, MFTypeSpecifier *returnTypeSpecifier, NSArray<MFMethodNameItem *> *items,  MFBlockBody *block);

MFPropertyDefinition *mf_create_property_definition(NSArray<MFAnnotation *> *annotationList, MFPropertyModifier modifier, MFTypeSpecifier *typeSpecifier, NSString *name);

void mf_add_class_definition(MFClassDefinition *classDefinition);

void mf_add_struct_declare(MFStructDeclare *structDeclare);

void mf_add_statement(MFStatement *statement);

void mf_add_typedef(MFTypeSpecifierKind type, NSString *alias);

void mf_add_typedef_from_alias(NSString *alias_existing, NSString *alias_new);

void mf_add_swift_class_alias(NSString *n1, NSString *n2, NSString *n3, NSString *n4, NSString *n5, NSString *aliasName);

MFInterpreter *mf_get_current_compile_util(void);

void mf_set_current_compile_util(MFInterpreter *interpreter);

#endif /* create_h */
