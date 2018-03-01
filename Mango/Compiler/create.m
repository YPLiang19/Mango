//
//  create.c
//  ananasExample
//
//  Created by Superdan on 2017/11/1.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "create.h"



static MANInterpreter *st_current_compile_util;


#define STRING_ALLOC_SIZE (256)
static char *st_string_literal_buffer = NULL;
static int st_string_literal_buffer_size = 0;
static int st_string_literal_buffer_alloc_size = 0;



int yyerror(char const *str){
	printf("line:%zd: %s\n",anc_get_current_compile_util().currentLineNumber,str);
	return 0;
}


MANInterpreter *anc_get_current_compile_util(){
	return st_current_compile_util;
}

void anc_set_current_compile_util(MANInterpreter *interpreter){
	st_current_compile_util = interpreter;
}



NSString *anc_create_identifier(char *str){
	NSString *ocStr = [NSString stringWithUTF8String:str];
	return ocStr;
}




void anc_open_string_literal_buf(){
	st_string_literal_buffer_size = 0;
}

void anc_append_string_literal(int letter){
	if (st_string_literal_buffer_size >= st_string_literal_buffer_alloc_size) {
		st_string_literal_buffer_alloc_size +=  STRING_ALLOC_SIZE;
		void *new_pointer = realloc(st_string_literal_buffer, st_string_literal_buffer_alloc_size);
		free(st_string_literal_buffer);
		st_string_literal_buffer = new_pointer;
	}
	
	st_string_literal_buffer[st_string_literal_buffer_size] = letter;
	st_string_literal_buffer_size++;
}

void anc_rest_string_literal_buffer(void){
	free(st_string_literal_buffer);
	st_string_literal_buffer = NULL;
	st_string_literal_buffer_size = 0;
	st_string_literal_buffer_alloc_size = 0;
	
}

const char *anc_end_string_literal(){
	anc_append_string_literal('\0');
	size_t strLen = strlen(st_string_literal_buffer);
	char *str = malloc(strLen + 1);
	strcpy(str, st_string_literal_buffer);
	anc_rest_string_literal_buffer();
	
	return str;
}

Class anc_expression_class_of_kind(MANExpressionKind kind){
	switch (kind) {
		case MAN_BOOLEAN_EXPRESSION:
		case MAN_INT_EXPRESSION:
		case MAN_U_INT_EXPRESSION:
		case MAN_FLOAT_EXPRESSION:
		case MAN_DOUBLE_EXPRESSION:
		case MAN_STRING_EXPRESSION:
		case MAN_SELF_EXPRESSION:
		case MAN_SELECTOR_EXPRESSION:
		case MAN_SUPER_EXPRESSION:
		case MAN_NIL_EXPRESSION:
			return [MANExpression class];
		case MAN_IDENTIFIER_EXPRESSION:
			return [MANIdentifierExpression class];
		case MAN_BLOCK_EXPRESSION:
			return [MANBlockExpression class];
		case MAN_ASSIGN_EXPRESSION:
			return [MANAssignExpression class];
		case MAN_TERNARY_EXPRESSION:
			return [MANTernaryExpression class];
		case MAN_ADD_EXPRESSION:
		case MAN_SUB_EXPRESSION:
		case MAN_MUL_EXPRESSION:
		case MAN_DIV_EXPRESSION:
		case MAN_MOD_EXPRESSION:
		case MAN_EQ_EXPRESSION:
		case MAN_NE_EXPRESSION:
		case MAN_GT_EXPRESSION:
		case MAN_GE_EXPRESSION:
		case MAN_LT_EXPRESSION:
		case MAN_LE_EXPRESSION:
		case MAN_LOGICAL_AND_EXPRESSION:
		case MAN_LOGICAL_OR_EXPRESSION:
			return [MANBinaryExpression class];
		case MAN_LOGICAL_NOT_EXPRESSION:
		case MAN_INCREMENT_EXPRESSION:
		case MAN_DECREMENT_EXPRESSION:
		case NSC_NEGATIVE_EXPRESSION:
		case MAN_AT_EXPRESSION:
			return [MANUnaryExpression class];
		case MAN_INDEX_EXPRESSION:
			return [MANIndexExpression class];
		case MAN_MEMBER_EXPRESSION:
			return [MANMemberExpression class];
		case MAN_FUNCTION_CALL_EXPRESSION:
			return [MANFunctonCallExpression class];
		case MAN_DIC_LITERAL_EXPRESSION:
			return [MANDictionaryExpression class];
		case MAN_STRUCT_LITERAL_EXPRESSION:
			return [MANStructpression class];
		case MAN_ARRAY_LITERAL_EXPRESSION:
			return [MANArrayExpression class];
		default:
			return [MANExpression class];
	}
	
}

MANDicEntry *anc_create_dic_entry(MANExpression *keyExpr, MANExpression *valueExpr){
	MANDicEntry *dicEntry = [[MANDicEntry alloc] init];
	dicEntry.keyExpr = keyExpr;
	dicEntry.valueExpr = valueExpr;
	return dicEntry;
}

MANExpression *anc_create_expression(MANExpressionKind kind){
	Class clazz = anc_expression_class_of_kind(kind);
	MANExpression *expr = [[clazz alloc] init];
	expr.expressionKind = kind;
	return expr;
}


void anc_build_block_expr(MANBlockExpression *expr, MANTypeSpecifier *returnTypeSpecifier, NSArray<MANParameter *> *params, MANBlockBody *block){
	MANFunctionDefinition *func = [[MANFunctionDefinition alloc] init];
	func.kind = MANFunctionDefinitionKindBlock;
	if (!returnTypeSpecifier) {
		returnTypeSpecifier = anc_create_type_specifier(MAN_TYPE_VOID);
	}
	func.returnTypeSpecifier = returnTypeSpecifier;
	func.params  = params;
	func.block = block;
	expr.func = func;
	
}



MANDeclaration *anc_create_declaration(MANTypeSpecifier *type, NSString *name, MANExpression *initializer){
	MANDeclaration *declaration = [[MANDeclaration alloc] init];
	declaration.type = type;
	declaration.name = name;
	declaration.initializer = initializer;
	return declaration;
}

MANDeclarationStatement *anc_create_declaration_statement(MANDeclaration *declaration){
	MANDeclarationStatement *statement = [[MANDeclarationStatement alloc] init];
	statement.kind = MANStatementKindDeclaration;
	statement.declaration = declaration;
	return statement;
	
}



MANExpressionStatement *anc_create_expression_statement(MANExpression *expr){
	MANExpressionStatement *statement = [[MANExpressionStatement alloc] init];
	statement.kind = MANStatementKindExpression;
	statement.expr = expr;
	return statement;
}

MANElseIf *anc_create_else_if(MANExpression *condition, MANBlockBody *thenBlock){
	MANElseIf *elseIf = [[MANElseIf alloc] init];
	elseIf.condition = condition;
	elseIf.thenBlock = thenBlock;
	return elseIf;
}


MANIfStatement *anc_create_if_statement(MANExpression *condition,MANBlockBody *thenBlock,NSArray<MANElseIf *> *elseIfList,MANBlockBody *elseBlocl){
	MANIfStatement *statement = [[MANIfStatement alloc] init];

	
	statement.kind = MANStatementKindIf;
	statement.condition = condition;
	statement.thenBlock = thenBlock;
	statement.elseBlocl = elseBlocl;
	statement.elseIfList = elseIfList;
	return statement;
}



MANCase *anc_create_case(MANExpression *expr, MANBlockBody *block){
	MANCase *case_ = [[MANCase alloc] init];
	case_.expr = expr;
	case_.block = block;
	return case_;
}

MANSwitchStatement *anc_create_switch_statement(MANExpression *expr, NSArray<MANCase *> *caseList, MANBlockBody *defaultBlock){
	MANSwitchStatement *statement = [[MANSwitchStatement alloc] init];
	
	statement.kind = MANStatementKindSwitch;
	statement.expr = expr;
	statement.caseList = caseList;
	statement.defaultBlock = defaultBlock;
	return statement;
}


MANForStatement *anc_create_for_statement(MANExpression *initializerExpr, MANDeclaration *declaration,
										  MANExpression *condition, MANExpression *post, MANBlockBody *block){
	MANForStatement *statement = [[MANForStatement alloc] init];
	
	statement.kind = MANStatementKindFor;
	statement.initializerExpr = initializerExpr;
	statement.declaration = declaration;
	statement.condition = condition;
	statement.post = post;
	statement.block = block;
	return statement;
}


MANForEachStatement *anc_create_for_each_statement(MANTypeSpecifier *typeSpecifier,NSString *varName, MANExpression *arrayExpr,MANBlockBody *block){
	MANForEachStatement *statement = [[MANForEachStatement alloc] init];
	
	
	statement.kind = MANStatementKindForEach;
	if (typeSpecifier) {
		statement.declaration = anc_create_declaration(typeSpecifier, varName, nil);
	}else{
		MANIdentifierExpression *varExpr = (MANIdentifierExpression *)anc_create_expression(MAN_IDENTIFIER_EXPRESSION);
		varExpr.identifier = varName;
		statement.identifierExpr = varExpr;
	}
	
	statement.arrayExpr = arrayExpr;
	statement.block = block;
	return statement;
}


MANWhileStatement *anc_create_while_statement(MANExpression *condition, MANBlockBody *block){
	MANWhileStatement *statement = [[MANWhileStatement alloc] init];
	statement.kind = MANStatementKindWhile;
	statement.condition = condition;
	statement.block = block;
	return statement;
}

MANDoWhileStatement *anc_create_do_while_statement(MANBlockBody *block, MANExpression *condition){
	MANDoWhileStatement *statement = [[MANDoWhileStatement alloc] init];
	statement.kind = MANStatementKindDoWhile;
	statement.block = block;
	statement.condition = condition;
	return statement;
}

MANContinueStatement *anc_create_continue_statement(){
	MANContinueStatement *statement = [[MANContinueStatement alloc] init];
	statement.kind = MANStatementKindContinue;
	return statement;
}


MANBreakStatement *anc_create_break_statement(){
	MANBreakStatement *statement = [[MANBreakStatement alloc] init];
	statement.kind = MANStatementKindBreak;
	return statement;
	
}

MANReturnStatement *anc_create_return_statement(MANExpression *retValExpr){
	MANReturnStatement *statement = [[MANReturnStatement alloc] init];
	statement.kind = MANStatementKindReturn;
	statement.retValExpr = retValExpr;
	return statement;
}



MANBlockBody *anc_open_block_statement(){
	MANBlockBody *block = [[MANBlockBody alloc] init];
	MANInterpreter *interpreter = anc_get_current_compile_util();
	block.outBlock = interpreter.currentBlock;
	interpreter.currentBlock = block;
	return block;
	
}

MANBlockBody *anc_close_block_statement(MANBlockBody *block, NSArray<MANStatement *> *statementList){
	MANInterpreter *interpreter = anc_get_current_compile_util();
	NSCAssert(block == interpreter.currentBlock, @"block != anc_get_current_compile_util().currentBlock");
	interpreter.currentBlock = block.outBlock;
	block.statementList = statementList;
	return block;
}









MANStructDeclare *anc_create_struct_declare(MANExpression *annotaionIfConditionExpr, NSString *structName, NSString *typeEncodingKey, const char *typeEncodingValue, NSString *keysKey, NSArray<NSString *> *keysValue){
	if (![typeEncodingKey isEqualToString:@"typeEncoding"]) {
		anc_compile_err(0, MANCompileErrorStructDeclareLackTypeEncoding);
	}
	
	if (![keysKey isEqualToString:@"keys"]) {
		anc_compile_err(0, MANCompileErrorStructDeclareLackTypeKeys);
	}
	
	MANStructDeclare *structDeclare = [[MANStructDeclare alloc] init];
	structDeclare.annotationIfConditionExpr = annotaionIfConditionExpr;
	structDeclare.lineNumber = 0;
	structDeclare.name = structName;
	structDeclare.typeEncoding = typeEncodingValue;
	structDeclare.keys = keysValue;
	
	return structDeclare;
	
}

MANTypeSpecifier *anc_create_type_specifier(ANATypeSpecifierKind kind){
	MANTypeSpecifier *typeSpecifier = [[MANTypeSpecifier alloc] init];
	typeSpecifier.typeKind = kind;
	return typeSpecifier;
}

MANTypeSpecifier *anc_create_struct_type_specifier(NSString *structName){
	MANTypeSpecifier *typeSpecifier = anc_create_type_specifier(MAN_TYPE_STRUCT);
	typeSpecifier.structName = structName;
	return typeSpecifier;
}


MANParameter *anc_create_parameter(MANTypeSpecifier *type, NSString *name){
	MANParameter *parameter = [[MANParameter alloc] init];
	parameter.type = type;
	parameter.name = name;
	parameter.lineNumber = anc_get_current_compile_util().currentLineNumber;
	return parameter;
}

MANFunctionDefinition *anc_create_function_definition(MANTypeSpecifier *returnTypeSpecifier,NSString *name ,NSArray<MANParameter *> *prasms,
													  MANBlockBody *block){
	MANFunctionDefinition *functionDefinition = [[MANFunctionDefinition alloc] init];
	functionDefinition.returnTypeSpecifier = returnTypeSpecifier;
	functionDefinition.name = name;
	functionDefinition.params = prasms;
	functionDefinition.block = block;
	return functionDefinition;
}

MANMethodNameItem *anc_create_method_name_item(NSString *name, MANTypeSpecifier *typeSpecifier, NSString *paramName){
	MANMethodNameItem *item = [[MANMethodNameItem alloc] init];
	item.name = name;
	if (typeSpecifier && paramName) {
		MANParameter *param = [[MANParameter alloc] init];
		param.type = typeSpecifier;
		param.name = paramName;
		item.param = param;
	}
	
	
	return item;
	
}

MANMethodDefinition *anc_create_method_definition(MANExpression *annotaionIfConditionExpr, BOOL classMethod, MANTypeSpecifier *returnTypeSpecifier, NSArray<MANMethodNameItem *> *items, MANBlockBody *block){
	MANMethodDefinition *methodDefinition = [[MANMethodDefinition alloc] init];
	methodDefinition.annotationIfConditionExpr = annotaionIfConditionExpr;
	methodDefinition.classMethod = classMethod;
	MANFunctionDefinition *funcDefinition = [[MANFunctionDefinition alloc] init];
	funcDefinition.kind = MANFunctionDefinitionKindMethod;
	funcDefinition.returnTypeSpecifier = returnTypeSpecifier;
	NSMutableArray<MANParameter *> *params = [NSMutableArray array];
	MANParameter *selfParam = [[MANParameter alloc] init];
	selfParam.type = anc_create_type_specifier(MAN_TYPE_OBJECT);
	selfParam.name = @"self";
	
	MANParameter *selParam = [[MANParameter alloc] init];
	selParam.type = anc_create_type_specifier(MAN_TYPE_SEL);
	selParam.name = @"_cmd";
	
	[params addObject:selfParam];
	[params addObject:selParam];
	
	NSMutableString *selector = [NSMutableString string];
	for (MANMethodNameItem *itme in items) {
		[selector appendString:itme.name];
		if (itme.param) {
			[params addObject:itme.param];
		}
		
	}
	funcDefinition.name = selector;
	funcDefinition.params = params;
	funcDefinition.block = block;
	methodDefinition.functionDefinition = funcDefinition;
	return methodDefinition;
	
}

MANPropertyDefinition *anc_create_property_definition(MANExpression *annotaionIfConditionExpr, MANPropertyModifier modifier, MANTypeSpecifier *typeSpecifier, NSString *name){
	MANPropertyDefinition *propertyDefinition = [[MANPropertyDefinition alloc] init];
	propertyDefinition.annotationIfConditionExpr = annotaionIfConditionExpr;
	propertyDefinition.lineNumber = anc_get_current_compile_util().currentLineNumber;
	propertyDefinition.modifier = modifier;
	propertyDefinition.typeSpecifier = typeSpecifier;
	propertyDefinition.name = name;
	return propertyDefinition;
}

void anc_start_class_definition(MANExpression *annotaionIfConditionExpr, NSString *name, NSString *superNmae, NSArray<NSString *> *protocolNames){
	MANInterpreter *interpreter = anc_get_current_compile_util();
	MANClassDefinition *classDefinition = [[MANClassDefinition alloc] init];
	classDefinition.lineNumber = interpreter.currentLineNumber;
	classDefinition.annotationIfConditionExpr = annotaionIfConditionExpr;
	classDefinition.name = name;
	classDefinition.superNmae = superNmae;
	classDefinition.protocolNames = protocolNames;
	interpreter.currentClassDefinition = classDefinition;
}


MANClassDefinition *anc_end_class_definition(NSArray<MANMemberDefinition *> *members){
	MANInterpreter *interpreter = anc_get_current_compile_util();
	MANClassDefinition *classDefinition = interpreter.currentClassDefinition;
	NSMutableArray<MANPropertyDefinition *> *propertyDefinition = [NSMutableArray array];
	NSMutableArray<MANMethodDefinition *> *classMethods = [NSMutableArray array];
	NSMutableArray<MANMethodDefinition *> *instanceMethods = [NSMutableArray array];
	for (MANMemberDefinition *memberDefinition in members) {
		memberDefinition.classDefinition = classDefinition;
		if ([memberDefinition isKindOfClass:[MANPropertyDefinition class]]) {
			[propertyDefinition addObject:(MANPropertyDefinition *)memberDefinition];
		}else if ([memberDefinition isKindOfClass:[MANMethodDefinition class]]){
			MANMethodDefinition *methodDefinition = (MANMethodDefinition *)memberDefinition;
			if (methodDefinition.classMethod) {
				[classMethods addObject:methodDefinition];
			}else{
				[instanceMethods addObject:methodDefinition];
			}
		}
	}
	classDefinition.properties = propertyDefinition;
	classDefinition.classMethods = classMethods;
	classDefinition.instanceMethods = instanceMethods;
	interpreter.currentClassDefinition = nil;
	return classDefinition;
}

void anc_add_struct_declare(MANStructDeclare *structDeclare){
	MANInterpreter *interpreter = anc_get_current_compile_util();
	interpreter.structDeclareDic[structDeclare.name] = structDeclare;
	[interpreter.topList addObject:structDeclare];
}

void anc_add_class_definition(MANClassDefinition *classDefinition){
	MANInterpreter *interpreter = anc_get_current_compile_util();
	interpreter.classDefinitionDic[classDefinition.name] = classDefinition;
	[interpreter.topList addObject:classDefinition];
	
}

void anc_add_statement(MANStatement *statement){
	MANInterpreter *interpreter = anc_get_current_compile_util();
	[interpreter.topList addObject:statement];

}




void ane_test(id obj){
	NSLog(@"%@",obj);
}













