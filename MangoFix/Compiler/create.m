//
//  create.c
//  MangoFix
//
//  Created by Superdan on 2017/11/1.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "create.h"
#import "MFStructDeclareTable.h"

#define STRING_ALLOC_SIZE (256)
static char *st_string_literal_buffer = NULL;
static int st_string_literal_buffer_size = 0;
static int st_string_literal_buffer_alloc_size = 0;


MFInterpreter *mf_get_current_compile_util(){
    return  [NSThread currentThread].threadDictionary[@"current_compile_util"];
}


void mf_set_current_compile_util(MFInterpreter *interpreter){
    if (!interpreter) {
        [[NSThread currentThread].threadDictionary removeObjectForKey:@"current_compile_util"];
    }else{
        [NSThread currentThread].threadDictionary[@"current_compile_util"] = interpreter;
    }
}


NSString *mf_create_identifier(char *str){
	NSString *ocStr = [NSString stringWithUTF8String:str];
	return ocStr;
}


void mf_open_string_literal_buf(){
	st_string_literal_buffer_size = 0;
}


void mf_append_string_literal(int letter){
	if (st_string_literal_buffer_size >= st_string_literal_buffer_alloc_size) {
		st_string_literal_buffer_alloc_size +=  STRING_ALLOC_SIZE;
		char *new_pointer = calloc(st_string_literal_buffer_alloc_size,1);
        memcpy(new_pointer, st_string_literal_buffer, st_string_literal_buffer_size);
		free(st_string_literal_buffer);
		st_string_literal_buffer = new_pointer;
	}
	st_string_literal_buffer[st_string_literal_buffer_size] = letter;
	st_string_literal_buffer_size++;
}


void mf_rest_string_literal_buffer(void){
	free(st_string_literal_buffer);
	st_string_literal_buffer = NULL;
	st_string_literal_buffer_size = 0;
	st_string_literal_buffer_alloc_size = 0;
}


const char *mf_end_string_literal(){
	mf_append_string_literal('\0');
	size_t strLen = strlen(st_string_literal_buffer);
	char *str = calloc(strLen + 1, 1);
	strcpy(str, st_string_literal_buffer);
	mf_rest_string_literal_buffer();
	return str;
}


Class mf_expression_class_of_kind(MFExpressionKind kind){
	switch (kind) {
		case MF_BOOLEAN_EXPRESSION:
		case MF_INT_EXPRESSION:
		case MF_U_INT_EXPRESSION:
		case MF_DOUBLE_EXPRESSION:
		case MF_STRING_EXPRESSION:
		case MF_SELF_EXPRESSION:
		case MF_SELECTOR_EXPRESSION:
		case MF_SUPER_EXPRESSION:
		case MF_NIL_EXPRESSION:
			return [MFExpression class];
		case MF_IDENTIFIER_EXPRESSION:
			return [MFIdentifierExpression class];
		case MF_BLOCK_EXPRESSION:
			return [MFBlockExpression class];
		case MF_ASSIGN_EXPRESSION:
			return [MFAssignExpression class];
		case MF_TERNARY_EXPRESSION:
			return [MFTernaryExpression class];
		case MF_ADD_EXPRESSION:
		case MF_SUB_EXPRESSION:
		case MF_MUL_EXPRESSION:
		case MF_DIV_EXPRESSION:
		case MF_MOD_EXPRESSION:
		case MF_EQ_EXPRESSION:
		case MF_NE_EXPRESSION:
		case MF_GT_EXPRESSION:
		case MF_GE_EXPRESSION:
		case MF_LT_EXPRESSION:
		case MF_LE_EXPRESSION:
		case MF_LOGICAL_AND_EXPRESSION:
		case MF_LOGICAL_OR_EXPRESSION:
			return [MFBinaryExpression class];
		case MF_LOGICAL_NOT_EXPRESSION:
		case MF_INCREMENT_EXPRESSION:
		case MF_DECREMENT_EXPRESSION:
		case NSC_NEGATIVE_EXPRESSION:
        case MF_GET_ADDRESS_EXPRESSION:
		case MF_AT_EXPRESSION:
			return [MFUnaryExpression class];
		case MF_SUB_SCRIPT_EXPRESSION:
			return [MFSubScriptExpression class];
		case MF_MEMBER_EXPRESSION:
			return [MFMemberExpression class];
		case MF_FUNCTION_CALL_EXPRESSION:
			return [MFFunctonCallExpression class];
		case MF_DIC_LITERAL_EXPRESSION:
			return [MFDictionaryExpression class];
		case MF_STRUCT_LITERAL_EXPRESSION:
			return [MFStructpression class];
		case MF_ARRAY_LITERAL_EXPRESSION:
			return [MFArrayExpression class];
        case MF_C_FUNCTION_EXPRESSION:
            return [MFCFuntionExpression class];
		default:
			return [MFExpression class];
	}
}


MFStructEntry *mf_create_struct_entry(NSString *key, MFExpression *valueExpr){
	MFStructEntry *structEntry = [[MFStructEntry alloc] init];
	structEntry.key = key;
	structEntry.valueExpr = valueExpr;
	return structEntry;
}


MFDicEntry *mf_create_dic_entry(MFExpression *keyExpr, MFExpression *valueExpr){
	MFDicEntry *dicEntry = [[MFDicEntry alloc] init];
	dicEntry.keyExpr = keyExpr;
	dicEntry.valueExpr = valueExpr;
	return dicEntry;
}


MFExpression *mf_create_expression(MFExpressionKind kind){
        Class clazz = mf_expression_class_of_kind(kind);
        MFExpression *expr = [[clazz alloc] init];
        expr.lineNumber = mf_get_current_compile_util().currentLineNumber;
        expr.expressionKind = kind;
        if (mf_get_current_compile_util().currentClassDefinition) {
            expr.currentClassName = mf_get_current_compile_util().currentClassDefinition.name;
        }
        return expr;
}


void mf_build_block_expr(MFBlockExpression *expr, MFTypeSpecifier *returnTypeSpecifier, NSArray<MFParameter *> *params, MFBlockBody *block){
	MFFunctionDefinition *func = [[MFFunctionDefinition alloc] init];
    func.lineNumber = mf_get_current_compile_util().currentLineNumber;
	func.kind = MFFunctionDefinitionKindBlock;
	if (!returnTypeSpecifier) {
		returnTypeSpecifier = mf_create_type_specifier(MF_TYPE_VOID);
	}
	func.returnTypeSpecifier = returnTypeSpecifier;
	func.params  = params;
	func.block = block;
	expr.func = func;
}


MFDeclaration *mf_create_declaration(BOOL externNativeGlobalVariable, MFDeclarationModifier modifier_list, MFTypeSpecifier *type, NSString *name, MFExpression *initializer){
	MFDeclaration *declaration = [[MFDeclaration alloc] init];
    declaration.externNativeGlobalVariable = externNativeGlobalVariable;
    declaration.lineNumber =  mf_get_current_compile_util().currentLineNumber;
    declaration.modifier = modifier_list;
	declaration.type = type;
	declaration.name = name;
	declaration.initializer = initializer;
	return declaration;
}


MFDeclarationStatement *mf_create_declaration_statement(MFDeclaration *declaration){
	MFDeclarationStatement *statement = [[MFDeclarationStatement alloc] init];
	statement.kind = MFStatementKindDeclaration;
	statement.declaration = declaration;
	return statement;
}


MFExpressionStatement *mf_create_expression_statement(MFExpression *expr){
	MFExpressionStatement *statement = [[MFExpressionStatement alloc] init];
	statement.kind = MFStatementKindExpression;
	statement.expr = expr;
	return statement;
}


MFElseIf *mf_create_else_if(MFExpression *condition, MFBlockBody *thenBlock){
	MFElseIf *elseIf = [[MFElseIf alloc] init];
	elseIf.condition = condition;
	elseIf.thenBlock = thenBlock;
	return elseIf;
}


MFIfStatement *mf_create_if_statement(MFExpression *condition,MFBlockBody *thenBlock,NSArray<MFElseIf *> *elseIfList,MFBlockBody *elseBlocl){
	MFIfStatement *statement = [[MFIfStatement alloc] init];
	statement.kind = MFStatementKindIf;
	statement.condition = condition;
	statement.thenBlock = thenBlock;
	statement.elseBlocl = elseBlocl;
	statement.elseIfList = elseIfList;
	return statement;
}


MFCase *mf_create_case(MFExpression *expr, MFBlockBody *block){
	MFCase *case_ = [[MFCase alloc] init];
	case_.expr = expr;
	case_.block = block;
	return case_;
}


MFSwitchStatement *mf_create_switch_statement(MFExpression *expr, NSArray<MFCase *> *caseList, MFBlockBody *defaultBlock){
	MFSwitchStatement *statement = [[MFSwitchStatement alloc] init];
	statement.kind = MFStatementKindSwitch;
	statement.expr = expr;
	statement.caseList = caseList;
	statement.defaultBlock = defaultBlock;
	return statement;
}


MFForStatement *mf_create_for_statement(MFExpression *initializerExpr, MFDeclaration *declaration,
										  MFExpression *condition, MFExpression *post, MFBlockBody *block){
	MFForStatement *statement = [[MFForStatement alloc] init];
	statement.kind = MFStatementKindFor;
	statement.initializerExpr = initializerExpr;
	statement.declaration = declaration;
	statement.condition = condition;
	statement.post = post;
	statement.block = block;
	return statement;
}


MFForEachStatement *mf_create_for_each_statement(MFTypeSpecifier *typeSpecifier,NSString *varName, MFExpression *arrayExpr,MFBlockBody *block){
	MFForEachStatement *statement = [[MFForEachStatement alloc] init];
	statement.kind = MFStatementKindForEach;
	if (typeSpecifier) {
		statement.declaration = mf_create_declaration(false, MFDeclarationModifierNone,typeSpecifier, varName, nil);
	}else{
		MFIdentifierExpression *varExpr = (MFIdentifierExpression *)mf_create_expression(MF_IDENTIFIER_EXPRESSION);
		varExpr.identifier = varName;
		statement.identifierExpr = varExpr;
	}
	statement.collectionExpr = arrayExpr;
	statement.block = block;
	return statement;
}


MFWhileStatement *mf_create_while_statement(MFExpression *condition, MFBlockBody *block){
	MFWhileStatement *statement = [[MFWhileStatement alloc] init];
	statement.kind = MFStatementKindWhile;
	statement.condition = condition;
	statement.block = block;
	return statement;
}


MFDoWhileStatement *mf_create_do_while_statement(MFBlockBody *block, MFExpression *condition){
	MFDoWhileStatement *statement = [[MFDoWhileStatement alloc] init];
	statement.kind = MFStatementKindDoWhile;
	statement.block = block;
	statement.condition = condition;
	return statement;
}


MFContinueStatement *mf_create_continue_statement(){
	MFContinueStatement *statement = [[MFContinueStatement alloc] init];
	statement.kind = MFStatementKindContinue;
	return statement;
}


MFBreakStatement *mf_create_break_statement(){
	MFBreakStatement *statement = [[MFBreakStatement alloc] init];
	statement.kind = MFStatementKindBreak;
	return statement;
	
}


MFReturnStatement *mf_create_return_statement(MFExpression *retValExpr){
	MFReturnStatement *statement = [[MFReturnStatement alloc] init];
	statement.kind = MFStatementKindReturn;
	statement.retValExpr = retValExpr;
	return statement;
}


MFBlockBody *mf_open_block_statement(){
	MFBlockBody *block = [[MFBlockBody alloc] init];
	MFInterpreter *interpreter = mf_get_current_compile_util();
	block.outBlock = interpreter.currentBlock;
	interpreter.currentBlock = block;
	return block;
}


MFBlockBody *mf_close_block_statement(MFBlockBody *block, NSArray<MFStatement *> *statementList){
	MFInterpreter *interpreter = mf_get_current_compile_util();
	NSCAssert(block == interpreter.currentBlock, @"block != mf_get_current_compile_util().currentBlock");
	interpreter.currentBlock = block.outBlock;
	block.statementList = statementList;
	return block;
}

MFAnnotation *mf_create_annotation(NSString *name, MFExpression *expr) {
    MFAnnotation *annotation = [[MFAnnotation alloc] init];
    annotation.name = name;
    annotation.expr = expr;
    return annotation;
}


MFStructDeclare *mf_create_struct_declare(NSArray<MFAnnotation *> *annotationList, NSString *structName, NSString *typeEncodingKey, MFExpression *typeEncodingValueExpr, NSString *keysKey, NSArray<NSString *> *keysValue){
	if (![typeEncodingKey isEqualToString:@"typeEncoding"]) {
        mf_throw_error(mf_get_current_compile_util().currentLineNumber, MFSemanticErrorStructDeclareLackFieldEncoding, @"struct: %@ declare lack field typeEncoding",structName);
        return nil;
	}
	if (![keysKey isEqualToString:@"keys"]) {
        mf_throw_error(mf_get_current_compile_util().currentLineNumber, MFSemanticErrorStructDeclareLackFieldKeys, @"struct: %@ declare lack field Keys",structName);
        return nil;
	}
    const char *typeEncodingValue = typeEncodingValueExpr.cstringValue;
	MFStructDeclare *structDeclare = [[MFStructDeclare alloc] init];
	structDeclare.annotationList = annotationList;
	structDeclare.name = structName;
	structDeclare.typeEncoding = typeEncodingValue;
	structDeclare.keys = keysValue;
	return structDeclare;
}

MFTypeSpecifier *mf_create_cfuntion_type_specifier( NSArray<NSString *> *typeList){
    MFTypeSpecifier *typeSpecifier = [[MFTypeSpecifier alloc] init];
    typeSpecifier.typeKind = MF_TYPE_C_FUNCTION;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"void"         : @"v",
                @"BOOL"         : @"B",
                @"int"          : @"i",
                @"long"         : @"l",
                @"int8_t"       : @"c",
                @"int16_t"      : @"s",
                @"int32_t"      : @"i",
                @"int64_t"      : @"q",
                @"u_int"        : @"I",
                @"u_long"       : @"L",
                @"u_int8_t"     : @"C",
                @"u_int16_t"    : @"S",
                @"u_int32_t"    : @"I",
                @"u_int64_t"    : @"Q",
#if defined(__LP64__) && __LP64__
                @"size_t"       : @"Q",
#else
                @"size_t"       : @"I",
#endif
#if defined(__LP64__) && __LP64__
                @"CGFloat"      : @"d",
#else
                @"CGFloat"     : @"f",
#endif
                @"float"        : @"f",
                @"double"       : @"d",
                @"char *"       : @"*",
                @"void *"       : @"^v",
                @"id"           : @"@",
                @"SEL"          : @":",
                @"Class"        : @"#",
                };
    });
    NSMutableArray *typeListEncode  = [NSMutableArray arrayWithCapacity:typeList.count];
    int j = 0;
    for (int i = 0; i < typeList.count; i++) {
        NSString *typeName = typeList[i];
        if (i != 0 && [typeName isEqualToString:@"void"]) {
            continue;
        }
        NSString *typeEncode = nil;
        if ([typeName hasPrefix:@"struct "]) {
            MFStructDeclareTable *structDeclareTable = [MFStructDeclareTable shareInstance];
            NSString *structName = [typeName substringFromIndex:7];
            MFStructDeclare *structDeclare = [structDeclareTable getStructDeclareWithName:structName];
            if (!structDeclare) {
                mf_throw_error(mf_get_current_compile_util().currentLineNumber, MFSemanticErrorStructNoDeclare, @"struct: %@ no declare", structName);
                return nil;
            }
            typeEncode = @(structDeclare.typeEncoding);
        }else{
            typeEncode = dic[typeName];
            if (!typeEncode) {
                mf_throw_error(mf_get_current_compile_util().currentLineNumber, MFSemanticErrorNotSupportCFunctionTypeDeclare, @"not support CFunction type: %@",typeName);
                return nil;
            }
        }
        typeListEncode[j] = typeEncode;
        j++;
    }
    NSString *returnTypeEncode = typeListEncode[0];
    NSArray *paramListTypeEncode = [typeListEncode subarrayWithRange:NSMakeRange(1, typeListEncode.count - 1)];
    typeSpecifier.returnTypeEncode = returnTypeEncode;
    typeSpecifier.paramListTypeEncode = paramListTypeEncode;
    
    return typeSpecifier;
}


MFTypeSpecifier *mf_create_type_specifier(MFTypeSpecifierKind kind){
	MFTypeSpecifier *typeSpecifier = [[MFTypeSpecifier alloc] init];
	typeSpecifier.typeKind = kind;
	return typeSpecifier;
}


MFTypeSpecifier *mf_create_struct_type_specifier(NSString *structName){
	MFTypeSpecifier *typeSpecifier = mf_create_type_specifier(MF_TYPE_STRUCT);
	typeSpecifier.structName = structName;
	return typeSpecifier;
}


MFParameter *mf_create_parameter(MFTypeSpecifier *type, NSString *name){
	MFParameter *parameter = [[MFParameter alloc] init];
	parameter.type = type;
	parameter.name = name;
	parameter.lineNumber = mf_get_current_compile_util().currentLineNumber;
	return parameter;
}


MFFunctionDefinition *mf_create_function_definition(MFTypeSpecifier *returnTypeSpecifier,NSString *name ,NSArray<MFParameter *> *prasms, MFBlockBody *block){
	MFFunctionDefinition *functionDefinition = [[MFFunctionDefinition alloc] init];
	functionDefinition.returnTypeSpecifier = returnTypeSpecifier;
	functionDefinition.name = name;
	functionDefinition.params = prasms;
	functionDefinition.block = block;
	return functionDefinition;
}


MFMethodNameItem *mf_create_method_name_item(NSString *name, MFTypeSpecifier *typeSpecifier, NSString *paramName){
	MFMethodNameItem *item = [[MFMethodNameItem alloc] init];
	item.name = name;
	if (typeSpecifier && paramName) {
		MFParameter *param = [[MFParameter alloc] init];
		param.type = typeSpecifier;
		param.name = paramName;
		item.param = param;
	}
	return item;
}


MFMethodDefinition *mf_create_method_definition(NSArray<MFAnnotation *> *annotationList, BOOL classMethod, MFTypeSpecifier *returnTypeSpecifier, NSArray<MFMethodNameItem *> *items, MFBlockBody *block){
	MFMethodDefinition *methodDefinition = [[MFMethodDefinition alloc] init];
	methodDefinition.annotationList = annotationList;
	methodDefinition.classMethod = classMethod;
	MFFunctionDefinition *funcDefinition = [[MFFunctionDefinition alloc] init];
	funcDefinition.kind = MFFunctionDefinitionKindMethod;
	funcDefinition.returnTypeSpecifier = returnTypeSpecifier;
	NSMutableArray<MFParameter *> *params = [NSMutableArray array];
	MFParameter *selfParam = [[MFParameter alloc] init];
	selfParam.type = mf_create_type_specifier(MF_TYPE_OBJECT);
	selfParam.name = @"self";
    
	MFParameter *selParam = [[MFParameter alloc] init];
	selParam.type = mf_create_type_specifier(MF_TYPE_SEL);
	selParam.name = @"_cmd";
	
	[params addObject:selfParam];
	[params addObject:selParam];
	
	NSMutableString *selector = [NSMutableString string];
	for (MFMethodNameItem *itme in items) {
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


MFPropertyDefinition *mf_create_property_definition(NSArray<MFAnnotation *> *annotationList, MFPropertyModifier modifier, MFTypeSpecifier *typeSpecifier, NSString *name){
	MFPropertyDefinition *propertyDefinition = [[MFPropertyDefinition alloc] init];
	propertyDefinition.annotationList = annotationList;
	propertyDefinition.lineNumber = mf_get_current_compile_util().currentLineNumber;
	propertyDefinition.modifier = modifier;
	propertyDefinition.typeSpecifier = typeSpecifier;
	propertyDefinition.name = name;
	return propertyDefinition;
}


void mf_start_class_definition(NSArray<MFAnnotation *> *annotationList, NSString *name, NSArray<MFAnnotation *> *superAnnotationList, NSString *superName, NSArray<NSString *> *protocolNames){
	MFInterpreter *interpreter = mf_get_current_compile_util();
	MFClassDefinition *classDefinition = [[MFClassDefinition alloc] init];
	classDefinition.lineNumber = interpreter.currentLineNumber;
	classDefinition.annotationList = annotationList;
    classDefinition.superAnnotationList = superAnnotationList;
    if (classDefinition.swiftModuleAnnotation) {
        classDefinition.name = [NSString stringWithFormat:@"%s.%@", classDefinition.swiftModuleAnnotation.expr.cstringValue, name];
        [[MFSwfitClassNameAlisTable shareInstance] addSwiftClassNmae:classDefinition.name alias:name];
    } else {
        NSString *swiftClassName = [[MFSwfitClassNameAlisTable shareInstance] swiftClassNameByAlias:name];
        if (swiftClassName) {
            classDefinition.name = swiftClassName;
        } else {
            classDefinition.name = name;
        }
    }
    
    if (classDefinition.superSwiftModuleAnnotation) {
        classDefinition.superName = [NSString stringWithFormat:@"%s.%@", classDefinition.superSwiftModuleAnnotation.expr.cstringValue, superName];
        [[MFSwfitClassNameAlisTable shareInstance] addSwiftClassNmae:classDefinition.superName alias:superName];
    } else {
        NSString *swiftSuperClassName = [[MFSwfitClassNameAlisTable shareInstance] swiftClassNameByAlias:superName];
        if (swiftSuperClassName) {
            classDefinition.superName = swiftSuperClassName;
        } else {
            classDefinition.superName = superName;
        }
    }
	classDefinition.protocolNames = protocolNames;
	interpreter.currentClassDefinition = classDefinition;
}


MFClassDefinition *mf_end_class_definition(NSArray<MFMemberDefinition *> *members){
	MFInterpreter *interpreter = mf_get_current_compile_util();
	MFClassDefinition *classDefinition = interpreter.currentClassDefinition;
	NSMutableArray<MFPropertyDefinition *> *propertyDefinition = [NSMutableArray array];
	NSMutableArray<MFMethodDefinition *> *classMethods = [NSMutableArray array];
	NSMutableArray<MFMethodDefinition *> *instanceMethods = [NSMutableArray array];
	for (MFMemberDefinition *memberDefinition in members) {
		memberDefinition.classDefinition = classDefinition;
		if ([memberDefinition isKindOfClass:[MFPropertyDefinition class]]) {
			[propertyDefinition addObject:(MFPropertyDefinition *)memberDefinition];
		}else if ([memberDefinition isKindOfClass:[MFMethodDefinition class]]){
			MFMethodDefinition *methodDefinition = (MFMethodDefinition *)memberDefinition;
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


void mf_add_struct_declare(MFStructDeclare *structDeclare){
	MFInterpreter *interpreter = mf_get_current_compile_util();
	interpreter.structDeclareDic[structDeclare.name] = structDeclare;
	[interpreter.topList addObject:structDeclare];
}


void mf_add_class_definition(MFClassDefinition *classDefinition){
	MFInterpreter *interpreter = mf_get_current_compile_util();
	interpreter.classDefinitionDic[classDefinition.name] = classDefinition;
	[interpreter.topList addObject:classDefinition];
}


void mf_add_statement(MFStatement *statement){
	MFInterpreter *interpreter = mf_get_current_compile_util();
	[interpreter.topList addObject:statement];
}

void mf_add_typedef(MFTypeSpecifierKind type, NSString *alias){
    MFTypedefTable *typedefTable = [MFTypedefTable shareInstance];
    [typedefTable typedefType:type identifer:alias];
}

void mf_add_typedef_from_alias(NSString *alias_existing, NSString *alias_new){
    MFTypedefTable *typedefTable = [MFTypedefTable shareInstance];
    MFTypeSpecifierKind type = [typedefTable typeWtihIdentifer:alias_existing];
    if (type == MF_TYPE_UNKNOWN) {
        mf_throw_error(mf_get_current_compile_util().currentLineNumber, MFSemanticErrorTypedefWithUnknownExistingType, @"typedef error, unknown type: %@", alias_existing);
    }
    mf_add_typedef(type, alias_new);
}



void mf_add_swift_class_alias(NSString *n1, NSString *n2, NSString *n3, NSString *n4, NSString *n5, NSString *aliasName) {
    NSMutableString *swiftClassName = [NSMutableString stringWithString:n1];
    if (n2) {
        [swiftClassName appendFormat:@".%@", n2];
    }
    if (n3) {
        [swiftClassName appendFormat:@".%@", n3];
    }
    if (n4) {
        [swiftClassName appendFormat:@".%@", n4];
    }
    if (n5) {
        [swiftClassName appendFormat:@".%@", n5];
    }
    [[MFSwfitClassNameAlisTable shareInstance] addSwiftClassNmae:swiftClassName.copy alias:aliasName];
}











