//
//  execute.m
//  ananasExample
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "create.h"
#import "execute.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "util.h"
#import "ffi.h"
#import "runenv.h"

static NSMutableDictionary *_propKeys;
static const void *propKey(NSString *propName) {
	if (!_propKeys) _propKeys = [[NSMutableDictionary alloc] init];
	id key = _propKeys[propName];
	if (!key) {
		key = [propName copy];
		[_propKeys setObject:key forKey:propName];
	}
	return (__bridge const void *)(key);
}


static MANValue *default_value_with_type_specifier(MANInterpreter *inter, MANTypeSpecifier *typeSpecifier){
	MANValue *value = [[MANValue alloc] init];
	value.type = typeSpecifier;
	if (typeSpecifier.typeKind == MAN_TYPE_STRUCT) {
		 size_t size = mango_struct_size_with_encoding([typeSpecifier typeEncoding]);
		value.pointerValue = malloc(size);
	}
	return value;
}



static void execute_declaration(MANInterpreter *inter, MANScopeChain *scope, MANDeclaration *declaration){
	MANValue *value;
	if (declaration.initializer) {
		value = ane_eval_expression(inter, scope, declaration.initializer);
	}else{
		value = default_value_with_type_specifier(inter, declaration.type);
	}
	scope.vars[declaration.name] = value;
}





static MANStatementResult *execute_else_if_list(MANInterpreter *inter, MANScopeChain *scope,NSArray<MANElseIf *> *elseIfList,BOOL *executed){
	MANStatementResult *res;
	*executed = NO;
	for (MANElseIf *elseIf in elseIfList) {
		MANValue *conValue = ane_eval_expression(inter, scope, elseIf.condition);
		if ([conValue isSubtantial]) {
			MANScopeChain *conScope = [MANScopeChain scopeChainWithNext:scope];
			res = ane_execute_statement_list(inter, conScope, elseIf.thenBlock.statementList);
			*executed = YES;
			break;
		}
	}
	return res ?: [MANStatementResult normalResult];
}

static MANStatementResult *execute_if_statement(MANInterpreter *inter, MANScopeChain *scope, MANIfStatement *statement){
	MANStatementResult *res;
	MANValue *conValue = ane_eval_expression(inter, scope, statement.condition);
	if ([conValue isSubtantial]) {
		MANScopeChain *conScope = [MANScopeChain scopeChainWithNext:scope];
		res = ane_execute_statement_list(inter, conScope, statement.thenBlock.statementList);
	}else{
		BOOL executed;
		res = execute_else_if_list(inter, scope, statement.elseIfList, &executed);
		if (!executed && statement.elseBlocl) {
			MANScopeChain *elseScope = [MANScopeChain scopeChainWithNext:scope];
			res = ane_execute_statement_list(inter, elseScope, statement.elseBlocl.statementList);
		}
	}
	return res ?: [MANStatementResult normalResult];
	
}


static MANStatementResult *execute_switch_statement(MANInterpreter *inter, MANScopeChain *scope, MANSwitchStatement *statement){
	MANStatementResult *res;
	MANValue *value = ane_eval_expression(inter, scope, statement.expr);
	BOOL hasMatch = NO;
	for (MANCase *case_ in statement.caseList) {
		if (!hasMatch) {
			MANValue *caseValue = ane_eval_expression(inter, scope, case_.expr);
			BOOL equal = mango_equal_value(case_.expr.lineNumber, value, caseValue);
			if (equal) {
				hasMatch = YES;
			}else{
				continue;
			}
		}
		MANScopeChain *caseScope = [MANScopeChain scopeChainWithNext:scope];
		res = ane_execute_statement_list(inter, caseScope, case_.block.statementList);
		if (res.type != MANStatementResultTypeNormal) {
			break;
		}
	}
	res = res ?: [MANStatementResult normalResult];
	if (res.type == MANStatementResultTypeNormal) {
		MANScopeChain *defaultCaseScope = [MANScopeChain scopeChainWithNext:scope];
		res = ane_execute_statement_list(inter, defaultCaseScope, statement.defaultBlock.statementList);
	}
	
	if (res.type == MANStatementResultTypeBreak) {
		res.type = MANStatementResultTypeNormal;
	}
	
	return res;
}



static MANStatementResult *execute_for_statement(MANInterpreter *inter, MANScopeChain *scope, MANForStatement *statement){
	MANStatementResult *res;
	MANScopeChain *forScope = [MANScopeChain scopeChainWithNext:scope];
	if (statement.initializerExpr) {
		ane_eval_expression(inter, forScope, statement.initializerExpr);
	}else if (statement.declaration){
		execute_declaration(inter, forScope, statement.declaration);
	}
	
	for (;;) {
		MANValue *conValue = ane_eval_expression(inter, forScope, statement.condition);
		if (![conValue isSubtantial]) {
			break;
		}
		res = ane_execute_statement_list(inter, forScope, statement.block.statementList);
		if (res.type == MANStatementResultTypeReturn) {
			break;
		}else if (res.type == MANStatementResultTypeBreak) {
			res.type = MANStatementResultTypeNormal;
			break;
		}else if (res.type == MANStatementResultTypeContinue){
			res.type = MANStatementResultTypeNormal;
		}
		if (statement.post) {
			ane_eval_expression(inter, forScope, statement.post);
		}
		
	}
	
	return res ?: [MANStatementResult normalResult];
	
}


static MANStatementResult *execute_for_each_statement(MANInterpreter *inter, MANScopeChain *scope, MANForEachStatement *statement){
	MANStatementResult *res;
	MANScopeChain *forScope = [MANScopeChain scopeChainWithNext:scope];

	if (statement.declaration) {
		execute_declaration(inter, forScope, statement.declaration);
		MANIdentifierExpression *identifierExpr = [[MANIdentifierExpression alloc] init];
		identifierExpr.expressionKind = MAN_IDENTIFIER_EXPRESSION;
		identifierExpr.identifier = statement.declaration.name;
		statement.identifierExpr = identifierExpr;
	}
	
	
	
	MANValue *arrValue = ane_eval_expression(inter, scope, statement.arrayExpr);
	if (arrValue.type.typeKind != MAN_TYPE_OBJECT) {
		NSCAssert(0, @"");
	}
	
	for (id var in arrValue.objectValue) {
		MANValue *operValue = [[MANValue alloc] init];
		operValue.type = anc_create_type_specifier(MAN_TYPE_OBJECT);
		operValue.objectValue = var;
		mango_assign_value_to_identifer_expr(inter, forScope, statement.identifierExpr.identifier, operValue);
		
		res = ane_execute_statement_list(inter, forScope, statement.block.statementList);
		if (res.type == MANStatementResultTypeReturn) {
			break;
		}else if (res.type == MANStatementResultTypeBreak) {
			res.type = MANStatementResultTypeNormal;
			break;
		}else if (res.type == MANStatementResultTypeContinue){
			res.type = MANStatementResultTypeNormal;
		}
	}
	return res ?: [MANStatementResult normalResult];
	
}

static MANStatementResult *execute_while_statement(MANInterpreter *inter, MANScopeChain *scope,  MANWhileStatement *statement){
	MANStatementResult *res;
	MANScopeChain *whileScope = [MANScopeChain scopeChainWithNext:scope];
	for (;;) {
		MANValue *conValue = ane_eval_expression(inter, whileScope, statement.condition);
		if (![conValue isSubtantial]) {
			break;
		}
		res = ane_execute_statement_list(inter, whileScope, statement.block.statementList);
		if (res.type == MANStatementResultTypeReturn) {
			break;
		}else if (res.type == MANStatementResultTypeBreak) {
			res.type = MANStatementResultTypeNormal;
			break;
		}else if (res.type == MANStatementResultTypeContinue){
			res.type = MANStatementResultTypeNormal;
		}
	}
	return res ?: [MANStatementResult normalResult];
}

static MANStatementResult *execute_do_while_statement(MANInterpreter *inter, MANScopeChain *scope,  MANDoWhileStatement *statement){
	MANStatementResult *res;
	MANScopeChain *whileScope = [MANScopeChain scopeChainWithNext:scope];
	for (;;) {
		res = ane_execute_statement_list(inter, whileScope, statement.block.statementList);
		if (res.type == MANStatementResultTypeReturn) {
			break;
		}else if (res.type == MANStatementResultTypeBreak) {
			res.type = MANStatementResultTypeNormal;
			break;
		}else if (res.type == MANStatementResultTypeContinue){
			res.type = MANStatementResultTypeNormal;
		}
		MANValue *conValue = ane_eval_expression(inter, whileScope, statement.condition);
		if (![conValue isSubtantial]) {
			break;
		}
	}
	return res ?: [MANStatementResult normalResult];
}



static MANStatementResult *execute_return_statement(MANInterpreter *inter, MANScopeChain *scope,  MANReturnStatement *statement){
	MANStatementResult *res = [MANStatementResult returnResult];
	if (statement.retValExpr) {
		res.reutrnValue = ane_eval_expression(inter, scope, statement.retValExpr);
	}else{
		res.reutrnValue = [MANValue voidValueInstance];
	}
	return res;
}


static MANStatementResult *execute_break_statement(){
	return [MANStatementResult breakResult];
}


static MANStatementResult *execute_continue_statement(){
	return [MANStatementResult continueResult];
}



static  MANStatementResult *execute_statement(MANInterpreter *inter, MANScopeChain *scope, __kindof MANStatement *statement){
	MANStatementResult *res;
	switch (statement.kind) {
		case MANStatementKindExpression:
			ane_eval_expression(inter, scope, [(MANExpressionStatement *)statement expr]);
			res = [MANStatementResult normalResult];
			break;
		case MANStatementKindDeclaration:{
			execute_declaration(inter, scope, [(MANDeclarationStatement *)statement declaration]);
			res = [MANStatementResult normalResult];
			break;
		}
		case MANStatementKindIf:{
			res = execute_if_statement(inter, scope, statement);
			break;
		}
		case MANStatementKindSwitch:{
			res = execute_switch_statement(inter, scope, statement);
			break;
		}
		case MANStatementKindFor:{
			res = execute_for_statement(inter, scope, statement);
			break;
		}
		case MANStatementKindForEach:{
			res = execute_for_each_statement(inter, scope, statement);
			break;
		}
		case MANStatementKindWhile:{
			res = execute_while_statement(inter, scope, statement);
			break;
		}
		case MANStatementKindDoWhile:{
			res = execute_do_while_statement(inter, scope, statement);
			break;
		}
		case MANStatementKindReturn:{
			res = execute_return_statement(inter, scope, statement);
			break;
		}
		case MANStatementKindBreak:{
			res = execute_break_statement();
			break;
		}
		case MANStatementKindContinue:{
			res = execute_continue_statement();
			break;
		}
			
		default:
			break;
	}
	return res;
}


MANStatementResult *ane_execute_statement_list(MANInterpreter *inter, MANScopeChain *scope, NSArray<MANStatement *> *statementList){
	MANStatementResult *result;
	if (statementList.count) {
		for (MANStatement *statement in statementList) {
			result = execute_statement(inter, scope, statement);
			if (result.type != MANStatementResultTypeNormal) {
				break;
			}
		}
	}else{
		result = [MANStatementResult normalResult];
	}
	return result;
}


MANValue * mango_call_mango_function(MANInterpreter *inter, MANScopeChain *scope, MANFunctionDefinition *func, NSArray<MANValue *> *args){
	NSArray<MANParameter *> *params = func.params;
	if (params.count != args.count) {
		NSCAssert(0, @"");
	}
	MANScopeChain *funScope = [MANScopeChain scopeChainWithNext:scope];
	NSUInteger i = 0;
	for (MANParameter *param in params) {
		funScope.vars[param.name] = args[i];
		i++;
	}
	
	MANStatementResult *res = ane_execute_statement_list(inter, funScope, func.block.statementList);
	if (res.type == MANStatementResultTypeReturn) {
		return res.reutrnValue;
	}else{
		return [MANValue voidValueInstance];
	}
}


static void define_class(MANInterpreter *interpreter,MANClassDefinition *classDefinition){
	if (classDefinition.annotationIfExprResult == AnnotationIfExprResultNoComputed) {
		MANExpression *annotationIfConditionExpr = classDefinition.annotationIfConditionExpr;
		if (annotationIfConditionExpr) {
			MANValue *value = ane_eval_expression(interpreter, interpreter.topScope, annotationIfConditionExpr);
			classDefinition.annotationIfExprResult = value.isSubtantial ? AnnotationIfExprResultTrue : AnnotationIfExprResultFalse;
			if (!value.isSubtantial) {
				return;
			}
		}else{
			classDefinition.annotationIfExprResult = AnnotationIfExprResultTrue;
		}
	}
	
	
	if (classDefinition.annotationIfExprResult != AnnotationIfExprResultTrue) {
		return;
	}
	
	Class clazz = NSClassFromString(classDefinition.name);
	if (!clazz) {
		NSString *superClassName = classDefinition.superNmae;
		Class superClass = NSClassFromString(superClassName);
		if (!superClass) {
			define_class(interpreter, interpreter.classDefinitionDic[superClassName]);
		}
		
		if (!superClass) {
			NSCAssert(0, @"not found super class: %@",classDefinition.name);
			return;
		}
		Class clazz = objc_allocateClassPair(superClass, classDefinition.name.UTF8String, 0);
		objc_registerClassPair(clazz);
	}else{
		Class superClass = class_getSuperclass(clazz);
		char const *superClassName = class_getName(superClass);
		if (strcmp(classDefinition.superNmae.UTF8String, superClassName)) {
			NSCAssert(0, @"类 %@ 在Mango中与OC中父类名称不一致,Mango:%@ OC:%s ",classDefinition.name,classDefinition.superNmae, superClassName);
			return;
		}
	}
}




void getterInter(ffi_cif *cif, void *ret, void **args, void *userdata){
	MANPropertyDefinition *propDef = (__bridge MANPropertyDefinition *)userdata;
	id _self = (__bridge id)(*(void **)args[0]);
	NSString *propName = propDef.name;
	MANValue *value = objc_getAssociatedObject(_self, propKey(propName));
	value = value?:[[MANValue alloc] init];
	const char *type = [propDef.typeSpecifier typeEncoding];
	[value assign2CValuePointer:ret typeEncoding:type];
}


void setterInter(ffi_cif *cif, void *ret, void **args, void *userdata){
	MANPropertyDefinition *propDef = (__bridge MANPropertyDefinition *)userdata;
	id _self = (__bridge id)(*(void **)args[0]);
	const char *type = [propDef.typeSpecifier typeEncoding];
	MANValue *value = [[MANValue alloc] initWithCValuePointer:args[2] typeEncoding:type];
	NSString *propName = propDef.name;
	
	objc_AssociationPolicy associationPolicy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
	MANPropertyModifier modifier = propDef.modifier;
	switch (modifier & MANPropertyModifierMemMask) {
		case MANPropertyModifierMemStrong:
			switch (modifier & MANPropertyModifierAtomicMask) {
				case MANPropertyModifierAtomic:
					associationPolicy = OBJC_ASSOCIATION_RETAIN;
					break;
				case MANPropertyModifierNonatomic:
					associationPolicy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
					break;
				default:
					break;
			}
			break;
		case MANPropertyModifierMemWeak:
		case MANPropertyModifierMemAssign:
			associationPolicy = OBJC_ASSOCIATION_ASSIGN;
			break;
			
		case MANPropertyModifierMemCopy:
			switch (modifier & MANPropertyModifierAtomicMask) {
				case MANPropertyModifierAtomic:
					associationPolicy = OBJC_ASSOCIATION_COPY;
					break;
				case MANPropertyModifierNonatomic:
					associationPolicy = OBJC_ASSOCIATION_COPY_NONATOMIC;
					break;
				default:
					break;
			}
			break;
			
		default:
			break;
	}
	objc_setAssociatedObject(_self, propKey(propName), value, associationPolicy);
	
	
	
	
}
static void replace_getter_method(MANInterpreter *inter ,Class clazz, MANPropertyDefinition *prop){
	SEL getterSEL = NSSelectorFromString(prop.name);
	const char *retTypeEncoding  = [prop.typeSpecifier typeEncoding];
	ffi_type *returnType = mango_ffi_type_with_type_encoding(retTypeEncoding);
	unsigned int argCount = 2;
	ffi_type **argTypes = malloc(sizeof(ffi_type *) * argCount);
	argTypes[0] = &ffi_type_pointer;
	argTypes[1] = &ffi_type_pointer;


	void *imp = NULL;
	ffi_cif *cifPtr = malloc(sizeof(ffi_cif));
	ffi_prep_cif(cifPtr, FFI_DEFAULT_ABI, argCount, returnType, argTypes);
	ffi_closure *closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&imp);
	ffi_prep_closure_loc(closure, cifPtr, getterInter, (__bridge void *)prop, imp);
	
	class_replaceMethod(clazz, getterSEL, (IMP)imp, mango_str_append(retTypeEncoding, "@:"));
}

static void replace_setter_method(MANInterpreter *inter ,Class clazz, MANPropertyDefinition *prop){
	NSString *str1 = [[prop.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
	NSString *str2 = prop.name.length > 1 ? [prop.name substringFromIndex:1] : nil;
	SEL setterSEL = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",str1,str2]);
	const char *prtTypeEncoding  = [prop.typeSpecifier typeEncoding];
	ffi_type *returnType = &ffi_type_void;
	unsigned int argCount = 3;
	ffi_type **argTypes = malloc(sizeof(ffi_type *) * argCount);
	argTypes[0] = &ffi_type_pointer;
	argTypes[1] = &ffi_type_pointer;
	argTypes[2] = mango_ffi_type_with_type_encoding([prop.typeSpecifier typeEncoding]);
	if (argTypes[2] == NULL) {
		NSCAssert(0, @"");
	}

	void *imp = NULL;
	ffi_cif *cifPtr = malloc(sizeof(ffi_cif));
	ffi_prep_cif(cifPtr, FFI_DEFAULT_ABI, argCount, returnType, argTypes);
	ffi_closure *closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&imp);
	ffi_prep_closure_loc(closure, cifPtr, setterInter, (__bridge void *)prop, imp);
	
	class_replaceMethod(clazz, setterSEL, (IMP)imp, mango_str_append("v@:", prtTypeEncoding));
}



static void replace_prop(MANInterpreter *inter ,Class clazz, MANPropertyDefinition *prop){
	if (prop.annotationIfConditionExpr) {
		MANValue *conValue = ane_eval_expression(inter, inter.topScope, prop.annotationIfConditionExpr);
		if (![conValue isSubtantial]) {
			return;
		}
	}
	
	objc_property_attribute_t type = {"T", [prop.typeSpecifier typeEncoding]};
	objc_property_attribute_t memAttr = {"",""};
	switch (prop.modifier & MANPropertyModifierMemMask) {
		case MANPropertyModifierMemStrong:
			memAttr.name = "&";
			break;
		case MANPropertyModifierMemWeak:
			memAttr.name = "W";
			break;
		case MANPropertyModifierMemCopy:
			memAttr.name = "C";
			break;
		default:
			break;
	}
	
	objc_property_attribute_t atomicAttr = {"",""};
	switch (prop.modifier & MANPropertyModifierAtomicMask) {
		case MANPropertyModifierAtomic:
			break;
		case MANPropertyModifierNonatomic:
			atomicAttr.name = "N";
			break;
		default:
			break;
	}
	objc_property_attribute_t attrs[] = { type, memAttr, atomicAttr };
	class_replaceProperty(clazz, prop.name.UTF8String, attrs, 3);
	
	replace_getter_method(inter, clazz, prop);
	replace_setter_method(inter, clazz, prop);
	
}







static void mango_forward_invocation(__unsafe_unretained id assignSlf, SEL sel, NSInvocation *invocation)
{
	
	BOOL classMethod = object_isClass(assignSlf);
	MANMethodMapTableItem *map = [[ANANASMethodMapTable shareInstance] getMethodMapTableItemWith:classMethod ? assignSlf : [assignSlf class] classMethod:classMethod sel:invocation.selector];
	MANMethodDefinition *method = map.method;
	MANInterpreter *inter = map.inter;
	
	MANScopeChain *classScope = [MANScopeChain scopeChainWithNext:inter.topScope];
	classScope.instance = assignSlf;
	
	NSMutableArray<MANValue *> *args = [NSMutableArray array];
	[args addObject:[MANValue valueInstanceWithObject:assignSlf]];
	[args addObject:[MANValue valueInstanceWithSEL:invocation.selector]];
	NSMethodSignature *methodSignature = [invocation methodSignature];
	NSUInteger numberOfArguments = [methodSignature numberOfArguments];
	for (NSUInteger i = 2; i < numberOfArguments; i++) {
		const char *typeEncoding = [methodSignature getArgumentTypeAtIndex:i];
		size_t size = mango_size_with_encoding(typeEncoding);
		void *ptr = malloc(size);
		[invocation getArgument:ptr atIndex:i];
		MANValue *argValue = [[MANValue alloc] initWithCValuePointer:ptr typeEncoding:typeEncoding];
		[args addObject:argValue];
	}
	
	MANValue *retValue = mango_call_mango_function(inter, classScope, method.functionDefinition, args);
	if (retValue.type.typeKind != MAN_TYPE_VOID) {
		size_t retLen = [methodSignature methodReturnLength];
		void *retPtr = malloc(retLen);
		const char *retTypeEncoding = [methodSignature methodReturnType];
		[retValue assign2CValuePointer:retPtr typeEncoding:retTypeEncoding];
		[invocation setReturnValue:retPtr];
	}
	
}

static void replace_method(MANInterpreter *interpreter,Class clazz, MANMethodDefinition *method){
	if (method.annotationIfConditionExpr) {
		MANValue *conValue = ane_eval_expression(interpreter, interpreter.topScope, method.annotationIfConditionExpr);
		if (![conValue isSubtantial]) {
			return;
		}
	}
	MANFunctionDefinition *func = method.functionDefinition;
	SEL sel = NSSelectorFromString(func.name);
	
	MANMethodMapTableItem *item = [[MANMethodMapTableItem alloc] initWithClass:clazz inter:interpreter method:method];
	[[ANANASMethodMapTable shareInstance] addMethodMapTableItem:item];
	
	
	
	const char *typeEncoding;
	Method ocMethod;
	if (method.classMethod) {
		ocMethod = class_getClassMethod(clazz, sel);
	}else{
		ocMethod = class_getInstanceMethod(clazz, sel);
	}
	
	if (ocMethod) {
		typeEncoding = method_getTypeEncoding(ocMethod);
	}else{
		typeEncoding =[func.returnTypeSpecifier typeEncoding];
		
		for (MANParameter *param in func.params) {
			const char *paramTypeEncoding = [param.type typeEncoding];
			typeEncoding = mango_str_append(typeEncoding, paramTypeEncoding);
		}
	}
	Class c2 = method.classMethod ? objc_getMetaClass(class_getName(clazz)) : clazz;
	class_replaceMethod(c2, @selector(forwardInvocation:), (IMP)mango_forward_invocation,"v@:@");
	class_replaceMethod(c2, sel, _objc_msgForward, typeEncoding);
}


static void fix_class(MANInterpreter *interpreter,MANClassDefinition *classDefinition){
	Class clazz = NSClassFromString(classDefinition.name);
	for (MANPropertyDefinition *prop in classDefinition.properties) {
		
		replace_prop(interpreter,clazz, prop);
	}
	
	for (MANMethodDefinition *classMethod in classDefinition.classMethods) {
		replace_method(interpreter, clazz, classMethod);
	}
	
	for (MANMethodDefinition *instanceMethod in classDefinition.instanceMethods) {
		replace_method(interpreter, clazz, instanceMethod);
	}
	
}


void add_struct_declare(MANInterpreter *interpreter, MANStructDeclare *structDeclaer){
	if (structDeclaer.annotationIfConditionExpr) {
		MANValue *conValue = ane_eval_expression(interpreter, interpreter.topScope, structDeclaer.annotationIfConditionExpr);
		if (![conValue isSubtantial]) {
			return;
		}
	}
	ANANASStructDeclareTable *table = [ANANASStructDeclareTable shareInstance];
	[table addStructDeclare:structDeclaer];
}




void ane_interpret(MANInterpreter *interpreter){
	mango_add_built_in(interpreter);
	for (__kindof NSObject *top in interpreter.topList) {
		if ([top isKindOfClass:[MANStatement class]]) {
			execute_statement(interpreter, interpreter.topScope, top);
		}else if ([top isKindOfClass:[MANStructDeclare class]]){
			add_struct_declare(interpreter,top);
		}else if ([top isKindOfClass:[MANClassDefinition class]]){
			define_class(interpreter, top);
			fix_class(interpreter,top);
		}
	}
}
