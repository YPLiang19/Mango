//
//  execute.m
//  MangoFix
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//
//typedef <#existing#> <#new#>;
#import <UIKit/UIKit.h>
#include <string.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "create.h"
#import "execute.h"
#import "util.h"
#import "ffi.h"
#import "runenv.h"
#import "MFValue+Private.h"
#import "MFWeakPropertyBox.h"
#import "MFPropertyMapTable.h"
#import "MFStaticVarTable.h"
#import <symdl/symdl.h>

const void *mf_propKey(NSString *propName) {
    static NSMutableDictionary *_propKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _propKeys = [[NSMutableDictionary alloc] init];
    });
	id key = _propKeys[propName];
	if (!key) {
		key = [propName copy];
		[_propKeys setObject:key forKey:propName];
	}
	return (__bridge const void *)(key);
}


static MFValue *default_value_with_type_specifier( MFTypeSpecifier *typeSpecifier,MFDeclarationModifier modifier){
    MFValue *value = [[MFValue alloc] init];
    value.modifier = modifier;
    value.type = typeSpecifier;
    if (typeSpecifier.typeKind == MF_TYPE_STRUCT) {
        size_t size = mf_size_with_encoding([typeSpecifier typeEncoding]);
        value.pointerValue = malloc(size);
    }
    return value;
}



static void execute_declaration(MFInterpreter *inter, MFScopeChain *scope, MFDeclaration *declaration){
    BOOL staticVar = declaration.modifier & MFDeclarationModifierStatic;
    BOOL externNativeGlobalVariable = declaration.externNativeGlobalVariable;
    __block MFValue *value = nil;
    
    void (^initValueBlock)(void) = ^(){
        value = default_value_with_type_specifier(declaration.type, declaration.modifier);
        value.externNativeGlobalVariable = externNativeGlobalVariable;
        if (declaration.initializer) {
            MFValue *initValue = mf_eval_expression(inter, scope, declaration.initializer);
            [value assignFrom:initValue];
        }
    };
    
    if (staticVar) {
        NSString *key = [NSString stringWithFormat:@"%p",(void *)declaration];
        value = [[MFStaticVarTable shareInstance] getStaticVarValueWithKey:key];
        if (value) {
            [scope setValue:value withIndentifier:declaration.name];
        }else{
            initValueBlock();
            [scope setValue:value withIndentifier:declaration.name];
            [[MFStaticVarTable shareInstance] setStaticVarValue:value withKey:key];
        }
    } else if (externNativeGlobalVariable) {
        value = [inter.commonScope getValueWithIdentifier:declaration.name];
        if (!value) {
            initValueBlock();
            void *externNativeGlobalVariablePointer = symdl(declaration.name.UTF8String);
            if (!externNativeGlobalVariablePointer) {
                NSString *errMsg = [NSString stringWithFormat:@"extern %@ not find!", declaration.name];
                NSLog(@"[MangoFix] [ERROR] : %@", errMsg);
            }
            value.externNativeGlobalVariablePointer = externNativeGlobalVariablePointer;
            value.externNativeGlobalVariable = YES;
            [inter.commonScope setValue:value withIndentifier:declaration.name];
        }
    } else {
        initValueBlock();
        [scope setValue:value withIndentifier:declaration.name];
    }
	
}


static MFStatementResult *execute_else_if_list(MFInterpreter *inter, MFScopeChain *scope,NSArray<MFElseIf *> *elseIfList,BOOL *executed){
	MFStatementResult *res;
	*executed = NO;
	for (MFElseIf *elseIf in elseIfList) {
		MFValue *conValue = mf_eval_expression(inter, scope, elseIf.condition);
		if ([conValue isSubtantial]) {
			MFScopeChain *elseIfScope = [MFScopeChain scopeChainWithNext:scope];
			res = mf_execute_statement_list(inter, elseIfScope, elseIf.thenBlock.statementList);
			[elseIfScope setMangoBlockVarNil];
			*executed = YES;
			break;
		}
	}
	return res ?: [MFStatementResult normalResult];
}


static MFStatementResult *execute_if_statement(MFInterpreter *inter, MFScopeChain *scope, MFIfStatement *statement){
	MFStatementResult *res;
	MFValue *conValue = mf_eval_expression(inter, scope, statement.condition);
	if ([conValue isSubtantial]) {
		MFScopeChain *thenScope = [MFScopeChain scopeChainWithNext:scope];
		res = mf_execute_statement_list(inter, thenScope, statement.thenBlock.statementList);
		[thenScope setMangoBlockVarNil];
	}else{
		BOOL executed;
		res = execute_else_if_list(inter, scope, statement.elseIfList, &executed);
		if (!executed && statement.elseBlocl) {
			MFScopeChain *elseScope = [MFScopeChain scopeChainWithNext:scope];
			res = mf_execute_statement_list(inter, elseScope, statement.elseBlocl.statementList);
			[elseScope setMangoBlockVarNil];
		}
	}
	return res ?: [MFStatementResult normalResult];
	
}


static MFStatementResult *execute_switch_statement(MFInterpreter *inter, MFScopeChain *scope, MFSwitchStatement *statement){
	MFStatementResult *res;
	MFValue *value = mf_eval_expression(inter, scope, statement.expr);
	BOOL hasMatch = NO;
	for (MFCase *case_ in statement.caseList) {
		if (!hasMatch) {
			MFValue *caseValue = mf_eval_expression(inter, scope, case_.expr);
			BOOL equal = mf_equal_value(case_.expr.lineNumber, value, caseValue);
			if (equal) {
				hasMatch = YES;
			}else{
				continue;
			}
		}
		MFScopeChain *caseScope = [MFScopeChain scopeChainWithNext:scope];
		res = mf_execute_statement_list(inter, caseScope, case_.block.statementList);
		[caseScope setMangoBlockVarNil];
		if (res.type != MFStatementResultTypeNormal) {
			break;
		}
	}
	res = res ?: [MFStatementResult normalResult];
	if (res.type == MFStatementResultTypeNormal) {
		MFScopeChain *defaultCaseScope = [MFScopeChain scopeChainWithNext:scope];
		res = mf_execute_statement_list(inter, defaultCaseScope, statement.defaultBlock.statementList);
		[defaultCaseScope setMangoBlockVarNil];
	}
	
	if (res.type == MFStatementResultTypeBreak) {
		res.type = MFStatementResultTypeNormal;
	}
	
	return res;
}



static MFStatementResult *execute_for_statement(MFInterpreter *inter, MFScopeChain *scope, MFForStatement *statement){
	MFStatementResult *res;
	MFScopeChain *forScope = [MFScopeChain scopeChainWithNext:scope];
	if (statement.initializerExpr) {
		mf_eval_expression(inter, forScope, statement.initializerExpr);
	}else if (statement.declaration){
		execute_declaration(inter, forScope, statement.declaration);
	}
	
	for (;;) {
		MFValue *conValue = mf_eval_expression(inter, forScope, statement.condition);
		if (![conValue isSubtantial]) {
			break;
		}
		res = mf_execute_statement_list(inter, forScope, statement.block.statementList);
		if (res.type == MFStatementResultTypeReturn) {
			break;
		}else if (res.type == MFStatementResultTypeBreak) {
			res.type = MFStatementResultTypeNormal;
			break;
		}else if (res.type == MFStatementResultTypeContinue){
			res.type = MFStatementResultTypeNormal;
		}
		if (statement.post) {
			mf_eval_expression(inter, forScope, statement.post);
		}
		
	}
	
	[forScope setMangoBlockVarNil];
	
	return res ?: [MFStatementResult normalResult];
	
}


static MFStatementResult *execute_for_each_statement(MFInterpreter *inter, MFScopeChain *scope, MFForEachStatement *statement){
	MFStatementResult *res;
	MFScopeChain *forScope = [MFScopeChain scopeChainWithNext:scope];

	if (statement.declaration) {
		execute_declaration(inter, forScope, statement.declaration);
		MFIdentifierExpression *identifierExpr = [[MFIdentifierExpression alloc] init];
		identifierExpr.expressionKind = MF_IDENTIFIER_EXPRESSION;
		identifierExpr.identifier = statement.declaration.name;
		statement.identifierExpr = identifierExpr;
	}
	
	MFValue *arrValue = mf_eval_expression(inter, scope, statement.collectionExpr);
	if (arrValue.type.typeKind != MF_TYPE_OBJECT) {
		NSCAssert(0, @"");
	}
	
	for (id var in arrValue.objectValue) {
		MFValue *operValue = [[MFValue alloc] init];
		operValue.type = mf_create_type_specifier(MF_TYPE_OBJECT);
		operValue.objectValue = var;
		[forScope assignWithIdentifer:statement.identifierExpr.identifier value:operValue];
		
		res = mf_execute_statement_list(inter, forScope, statement.block.statementList);
		if (res.type == MFStatementResultTypeReturn) {
			break;
		}else if (res.type == MFStatementResultTypeBreak) {
			res.type = MFStatementResultTypeNormal;
			break;
		}else if (res.type == MFStatementResultTypeContinue){
			res.type = MFStatementResultTypeNormal;
		}
	}
	[forScope setMangoBlockVarNil];
	return res ?: [MFStatementResult normalResult];
}


static MFStatementResult *execute_while_statement(MFInterpreter *inter, MFScopeChain *scope,  MFWhileStatement *statement){
	MFStatementResult *res;
	MFScopeChain *whileScope = [MFScopeChain scopeChainWithNext:scope];
	for (;;) {
		MFValue *conValue = mf_eval_expression(inter, whileScope, statement.condition);
		if (![conValue isSubtantial]) {
			break;
		}
		res = mf_execute_statement_list(inter, whileScope, statement.block.statementList);
		if (res.type == MFStatementResultTypeReturn) {
			break;
		}else if (res.type == MFStatementResultTypeBreak) {
			res.type = MFStatementResultTypeNormal;
			break;
		}else if (res.type == MFStatementResultTypeContinue){
			res.type = MFStatementResultTypeNormal;
		}
	}
	[whileScope setMangoBlockVarNil];
	return res ?: [MFStatementResult normalResult];
}


static MFStatementResult *execute_do_while_statement(MFInterpreter *inter, MFScopeChain *scope,  MFDoWhileStatement *statement){
	MFStatementResult *res;
	MFScopeChain *whileScope = [MFScopeChain scopeChainWithNext:scope];
	for (;;) {
		res = mf_execute_statement_list(inter, whileScope, statement.block.statementList);
		if (res.type == MFStatementResultTypeReturn) {
			break;
		}else if (res.type == MFStatementResultTypeBreak) {
			res.type = MFStatementResultTypeNormal;
			break;
		}else if (res.type == MFStatementResultTypeContinue){
			res.type = MFStatementResultTypeNormal;
		}
		MFValue *conValue = mf_eval_expression(inter, whileScope, statement.condition);
		if (![conValue isSubtantial]) {
			break;
		}
	}
	[whileScope setMangoBlockVarNil];
	return res ?: [MFStatementResult normalResult];
}


static MFStatementResult *execute_return_statement(MFInterpreter *inter, MFScopeChain *scope,  MFReturnStatement *statement){
	MFStatementResult *res = [MFStatementResult returnResult];
	if (statement.retValExpr) {
		res.reutrnValue = mf_eval_expression(inter, scope, statement.retValExpr);
	}else{
		res.reutrnValue = [MFValue voidValueInstance];
	}
	return res;
}


static MFStatementResult *execute_break_statement(){
	return [MFStatementResult breakResult];
}


static MFStatementResult *execute_continue_statement(){
	return [MFStatementResult continueResult];
}


static  MFStatementResult *execute_statement(MFInterpreter *inter, MFScopeChain *scope, __kindof MFStatement *statement){
	MFStatementResult *res;
	switch (statement.kind) {
		case MFStatementKindExpression:
			mf_eval_expression(inter, scope, [(MFExpressionStatement *)statement expr]);
			res = [MFStatementResult normalResult];
			break;
		case MFStatementKindDeclaration:{
			execute_declaration(inter, scope, [(MFDeclarationStatement *)statement declaration]);
			res = [MFStatementResult normalResult];
			break;
		}
		case MFStatementKindIf:{
			res = execute_if_statement(inter, scope, statement);
			break;
		}
		case MFStatementKindSwitch:{
			res = execute_switch_statement(inter, scope, statement);
			break;
		}
		case MFStatementKindFor:{
			res = execute_for_statement(inter, scope, statement);
			break;
		}
		case MFStatementKindForEach:{
			res = execute_for_each_statement(inter, scope, statement);
			break;
		}
		case MFStatementKindWhile:{
			res = execute_while_statement(inter, scope, statement);
			break;
		}
		case MFStatementKindDoWhile:{
			res = execute_do_while_statement(inter, scope, statement);
			break;
		}
		case MFStatementKindReturn:{
			res = execute_return_statement(inter, scope, statement);
			break;
		}
		case MFStatementKindBreak:{
			res = execute_break_statement();
			break;
		}
		case MFStatementKindContinue:{
			res = execute_continue_statement();
			break;
		}
			
		default:
			break;
	}
	return res;
}


MFStatementResult *mf_execute_statement_list(MFInterpreter *inter, MFScopeChain *scope, NSArray<MFStatement *> *statementList){
	MFStatementResult *result;
	if (statementList.count) {
		for (MFStatement *statement in statementList) {
			result = execute_statement(inter, scope, statement);
			if (result.type != MFStatementResultTypeNormal) {
				break;
			}
		}
	}else{
		result = [MFStatementResult normalResult];
	}
	return result;
}


MFValue * mf_call_mf_function(MFInterpreter *inter, MFScopeChain *scope, MFFunctionDefinition *func, NSArray<MFValue *> *args){
	NSArray<MFParameter *> *params = func.params;
	if (params.count != args.count) {
        mf_throw_error(func.lineNumber, MFRuntimeErrorParameterListCountNoMatch, @"expect count: %zd, pass in cout:%zd",params.count, args.count);
        return nil;
	}
	MFScopeChain *funScope = [MFScopeChain scopeChainWithNext:scope];
	NSUInteger i = 0;
	for (MFParameter *param in params) {
		[funScope setValue:args[i] withIndentifier:param.name];
		i++;
	}
	
	MFStatementResult *res = mf_execute_statement_list(inter, funScope, func.block.statementList);
	[funScope setMangoBlockVarNil];
	if (res.type == MFStatementResultTypeReturn) {
		return res.reutrnValue;
	}else{
		return [MFValue voidValueInstance];
	}
}


static void define_class(MFInterpreter *interpreter, MFClassDefinition *classDefinition){
	if (classDefinition.annotationIfExprResult == AnnotationIfExprResultNoComputed) {
		MFExpression *annotationIfConditionExpr = classDefinition.ifAnnotation.expr;
		if (annotationIfConditionExpr) {
			MFValue *value = mf_eval_expression(interpreter, interpreter.topScope, annotationIfConditionExpr);
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
		NSString *superClassName = classDefinition.superName;
		Class superClass = NSClassFromString(superClassName);
        
        if (!superClass) {
            if (classDefinition.swiftModuleAnnotation && !classDefinition.superSwiftModuleAnnotation) {
                NSString *sueprClassFullName = [NSString stringWithFormat:@"%s.%@", classDefinition.swiftModuleAnnotation.expr.cstringValue, superClassName];
                superClass = NSClassFromString(sueprClassFullName);
                if (superClass) {
                    [[MFSwfitClassNameAlisTable shareInstance] addSwiftClassNmae:sueprClassFullName alias:superClassName];
                    classDefinition.superName = sueprClassFullName;
                }
            }
        }
        
		if (!superClass) {
			define_class(interpreter, interpreter.classDefinitionDic[superClassName]);
            superClass = NSClassFromString(superClassName);
		}
        
        if (!superClass && classDefinition.swiftModuleAnnotation && !classDefinition.superSwiftModuleAnnotation) {
            NSString *sueprClassFullName = [NSString stringWithFormat:@"%s.%@", classDefinition.swiftModuleAnnotation.expr.cstringValue, superClassName];
            define_class(interpreter, interpreter.classDefinitionDic[sueprClassFullName]);
            superClass = NSClassFromString(sueprClassFullName);
            if (superClass) {
                [[MFSwfitClassNameAlisTable shareInstance] addSwiftClassNmae:sueprClassFullName alias:superClassName];
                classDefinition.superName = sueprClassFullName;
            }
        }
		
		if (!superClass) {
            mf_throw_error(classDefinition.lineNumber, MFRuntimeErrorNotFoundSuperClass, @"not found super class: %@",superClassName);
			return;
		}
        clazz = objc_allocateClassPair(superClass, classDefinition.name.UTF8String, 0);
		objc_registerClassPair(clazz);
        
	}
    classDefinition.clazz = clazz;
    
}



void getterInter(ffi_cif *cif, void *ret, void **args, void *userdata){
	MFPropertyDefinition *propDef = (__bridge MFPropertyDefinition *)userdata;
	id _self = (__bridge id)(*(void **)args[0]);
	NSString *propName = propDef.name;
	id propValue = objc_getAssociatedObject(_self, mf_propKey(propName));
	const char *type = [propDef.typeSpecifier typeEncoding];
    __autoreleasing MFValue *value;
	if (!propValue) {
		value = [MFValue defaultValueWithTypeEncoding:type];
		[value assignToCValuePointer:ret typeEncoding:type];
	}else if(*type == '@'){
        if ([propValue isKindOfClass:[MFWeakPropertyBox class]]) {
            MFWeakPropertyBox *box = propValue;
            if (box.target) {
                *(void **)ret = (__bridge void *)box.target;
            }else{
                value = [MFValue defaultValueWithTypeEncoding:type];
                [value assignToCValuePointer:ret typeEncoding:type];
            }
        }else{
            *(void **)ret = (__bridge void *)propValue;
        }
	}else{
		value = propValue;
		[value assignToCValuePointer:ret typeEncoding:type];
	}
	
	
}


void setterInter(ffi_cif *cif, void *ret, void **args, void *userdata){
	MFPropertyDefinition *propDef = (__bridge MFPropertyDefinition *)userdata;
	id _self = (__bridge id)(*(void **)args[0]);
	const char *type = [propDef.typeSpecifier typeEncoding];
	id value;
	if (*type == '@') {
		value = (__bridge id)(*(void **)args[2]);
	}else{
		value = [[MFValue alloc] initWithCValuePointer:args[2] typeEncoding:type bridgeTransfer:NO];
	}
	NSString *propName = propDef.name;
	
    MFPropertyModifier modifier = propDef.modifier;
    if ((modifier & MFPropertyModifierMemMask) == MFPropertyModifierMemWeak) {
        value = [[MFWeakPropertyBox alloc] initWithTarget:value];
    }
	objc_AssociationPolicy associationPolicy = mf_AssociationPolicy_with_PropertyModifier(modifier);
	objc_setAssociatedObject(_self, mf_propKey(propName), value, associationPolicy);
    
}

static void replace_getter_method(NSUInteger lineNumber, MFInterpreter *inter ,Class clazz, MFPropertyDefinition *prop){
	SEL getterSEL = NSSelectorFromString(prop.name);
	const char *retTypeEncoding  = [prop.typeSpecifier typeEncoding];
	ffi_type *returnType = mf_ffi_type_with_type_encoding(retTypeEncoding);
	unsigned int argCount = 2;
	ffi_type **argTypes = malloc(sizeof(ffi_type *) * argCount);
	argTypes[0] = &ffi_type_pointer;
	argTypes[1] = &ffi_type_pointer;


	void *imp = NULL;
	ffi_cif *cifPtr = malloc(sizeof(ffi_cif));
	ffi_prep_cif(cifPtr, FFI_DEFAULT_ABI, argCount, returnType, argTypes);
	ffi_closure *closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&imp);
	ffi_prep_closure_loc(closure, cifPtr, getterInter, (__bridge void *)prop, imp);
	NSString * typeEncoding = [NSString stringWithFormat:@"%s%s",retTypeEncoding, "@:"];
	class_replaceMethod(clazz, getterSEL, (IMP)imp, typeEncoding.UTF8String);
}

static void replace_setter_method(NSUInteger lineNumber ,MFInterpreter *inter ,Class clazz, MFPropertyDefinition *prop){
	NSString *str1 = [[prop.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
	NSString *str2 = prop.name.length > 1 ? [prop.name substringFromIndex:1] : nil;
	SEL setterSEL = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",str1,str2]);
	const char *prtTypeEncoding  = [prop.typeSpecifier typeEncoding];
	ffi_type *returnType = &ffi_type_void;
	unsigned int argCount = 3;
	ffi_type **argTypes = malloc(sizeof(ffi_type *) * argCount);
	argTypes[0] = &ffi_type_pointer;
	argTypes[1] = &ffi_type_pointer;
	argTypes[2] = mf_ffi_type_with_type_encoding([prop.typeSpecifier typeEncoding]);
	if (argTypes[2] == NULL) {
        mf_throw_error(lineNumber, @"", @"");
	}

	void *imp = NULL;
	ffi_cif *cifPtr = malloc(sizeof(ffi_cif));
	ffi_prep_cif(cifPtr, FFI_DEFAULT_ABI, argCount, returnType, argTypes);
	ffi_closure *closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&imp);
	ffi_prep_closure_loc(closure, cifPtr, setterInter, (__bridge void *)prop, imp);
	NSString * typeEncoding = [NSString stringWithFormat:@"%s%s","v@:", prtTypeEncoding];
	class_replaceMethod(clazz, setterSEL, (IMP)imp, typeEncoding.UTF8String);
}



static void replace_prop(MFInterpreter *inter ,Class clazz, MFPropertyDefinition *prop){
	if (prop.ifAnnotation.expr) {
		MFValue *conValue = mf_eval_expression(inter, inter.topScope, prop.ifAnnotation.expr);
		if (![conValue isSubtantial]) {
			return;
		}
	}
	
	objc_property_attribute_t type = {"T", [prop.typeSpecifier typeEncoding]};
	objc_property_attribute_t memAttr = {"",""};
	switch (prop.modifier & MFPropertyModifierMemMask) {
		case MFPropertyModifierMemStrong:
			memAttr.name = "&";
			break;
		case MFPropertyModifierMemWeak:
			memAttr.name = "W";
			break;
		case MFPropertyModifierMemCopy:
			memAttr.name = "C";
			break;
		default:
			break;
	}
	
	objc_property_attribute_t atomicAttr = {"",""};
	switch (prop.modifier & MFPropertyModifierAtomicMask) {
		case MFPropertyModifierAtomic:
			break;
		case MFPropertyModifierNonatomic:
			atomicAttr.name = "N";
			break;
		default:
			break;
	}
	objc_property_attribute_t attrs[] = { type, memAttr, atomicAttr };
	class_replaceProperty(clazz, prop.name.UTF8String, attrs, 3);
    MFPropertyMapTableItem *propItem = [[MFPropertyMapTableItem alloc] initWithClass:clazz property:prop];
    [[MFPropertyMapTable shareInstance] addPropertyMapTableItem:propItem];
	replace_getter_method(prop.lineNumber, inter, clazz, prop);
	replace_setter_method(prop.lineNumber ,inter, clazz, prop);
	
}


static void replaceIMP(ffi_cif *cif, void *ret, void **args, void *userdata){
    
    NSDictionary * userInfo = (__bridge id)userdata;// 不可以进行释放
    Class class  = userInfo[@"class"];
    NSString *typeEncoding = userInfo[@"typeEncoding"];
    MFClassDefinition *classDefinition =userInfo[@"classDefinition"];
    id assignSlf = (__bridge  id)(*(void **)args[0]);
    SEL sel = *(void **)args[1];

    BOOL classMethod = object_isClass(assignSlf);
    MFMethodMapTableItem *map = [[MFMethodMapTable shareInstance] getMethodMapTableItemWith:class classMethod:classMethod sel:sel];
    MFMethodDefinition *method = map.method;
    MFInterpreter *inter = map.inter;

    MFScopeChain *classScope = [MFScopeChain scopeChainWithNext:inter.topScope];
    classScope.instance = assignSlf;
    classScope.classDefinition = classDefinition;

    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:typeEncoding.UTF8String];


    NSMutableArray<MFValue *> *argValues = [NSMutableArray array];
    NSUInteger numberOfArguments = [methodSignature numberOfArguments];
    for (NSUInteger i = 0; i < numberOfArguments; i++) {
        MFValue *argValue;
        const char *type = [methodSignature getArgumentTypeAtIndex:i];
        if (strcmp(type, "@?") == 0) {
            id block =  (__bridge id)(*(void **)args[i]);
            block = [block copy];
            argValue = [MFValue valueInstanceWithObject:block];
        }else{
            void *arg = args[i];
            argValue = [[MFValue alloc] initWithCValuePointer:arg typeEncoding:[methodSignature getArgumentTypeAtIndex:i] bridgeTransfer:NO];
        }
        
        [argValues addObject:argValue];
    }
    __autoreleasing MFValue *retValue = mf_call_mf_function(inter, classScope, method.functionDefinition, argValues);
    [retValue assignToCValuePointer:ret typeEncoding:[methodSignature methodReturnType]];
}


static void replace_method(MFInterpreter *interpreter, Class clazz, MFMethodDefinition *method){
	if (method.ifAnnotation.expr) {
		MFValue *conValue = mf_eval_expression(interpreter, interpreter.topScope, method.ifAnnotation.expr);
		if (![conValue isSubtantial]) {
			return;
		}
	}
    if (method.selectorNameAnnotation) {
        MFValue *v = mf_eval_expression(interpreter, interpreter.topScope, method.selectorNameAnnotation.expr);
        NSString * selName = v.objectValue;
        if (!selName && v.cstringValue) {
            selName = [NSString stringWithUTF8String:v.cstringValue];
        }
        if (selName) {
            method.functionDefinition.name = selName;
        }
    }
    
	MFFunctionDefinition *func = method.functionDefinition;
	SEL sel = NSSelectorFromString(func.name);
	
	MFMethodMapTableItem *item = [[MFMethodMapTableItem alloc] initWithClass:clazz inter:interpreter method:method];
	[[MFMethodMapTable shareInstance] addMethodMapTableItem:item];
	
	NSMutableString *typeEncoding = [NSMutableString string];
	Method ocMethod;
	if (method.classMethod) {
		ocMethod = class_getClassMethod(clazz, sel);
	}else{
		ocMethod = class_getInstanceMethod(clazz, sel);
	}
	
	if (ocMethod) {
		[typeEncoding appendString:@(method_getTypeEncoding(ocMethod))];
	}else{
		[typeEncoding appendString:@([func.returnTypeSpecifier typeEncoding])];
		
		for (MFParameter *param in func.params) {
			const char *paramTypeEncoding = [param.type typeEncoding];
            [typeEncoding appendString:@(paramTypeEncoding)];
		}
	}
	Class c2 = method.classMethod ? objc_getMetaClass(class_getName(clazz)) : clazz;
    if (class_respondsToSelector(c2, sel)) {
        NSString *orgSelName = [NSString stringWithFormat:@"ORG%@",func.name];
        SEL orgSel = NSSelectorFromString(orgSelName);
        if (!class_respondsToSelector(c2, orgSel)) {
            class_addMethod(c2, orgSel, method_getImplementation(ocMethod), typeEncoding.UTF8String);
        }
    }
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:typeEncoding.UTF8String];
    unsigned int argCount = (unsigned int)[sig numberOfArguments];
    void *imp = NULL;
    ffi_cif *cif = malloc(sizeof(ffi_cif));//不可以free
    ffi_closure *closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&imp);
    ffi_type *returnType = mf_ffi_type_with_type_encoding(sig.methodReturnType);
    ffi_type **args = malloc(sizeof(ffi_type *) * argCount);
    for (int  i = 0 ; i < argCount; i++) {
        args[i] = mf_ffi_type_with_type_encoding([sig getArgumentTypeAtIndex:i]);
    }

    if(ffi_prep_cif(cif, FFI_DEFAULT_ABI, argCount, returnType, args) == FFI_OK)
    {
        NSDictionary *userInfo = nil;
        if (method.classDefinition) {
            userInfo = @{@"class":c2, @"typeEncoding":[typeEncoding copy], @"classDefinition" : method.classDefinition};
        } else {
            userInfo = @{@"class":c2, @"typeEncoding":[typeEncoding copy]};
        }
        CFTypeRef cfuserInfo = (__bridge_retained CFTypeRef)userInfo;
        ffi_prep_closure_loc(closure, cif, replaceIMP, (void *)cfuserInfo, imp);
    }
    class_replaceMethod(c2, sel, imp, typeEncoding.UTF8String);
}


static void fix_class(MFInterpreter *interpreter, MFClassDefinition *classDefinition){
	Class clazz = classDefinition.clazz;
	for (MFPropertyDefinition *prop in classDefinition.properties) {
		replace_prop(interpreter,clazz, prop);
	}
	
	for (MFMethodDefinition *classMethod in classDefinition.classMethods) {
		replace_method(interpreter, clazz, classMethod);
	}
	
	for (MFMethodDefinition *instanceMethod in classDefinition.instanceMethods) {
		replace_method(interpreter, clazz, instanceMethod);
	}
}


void add_struct_declare(MFInterpreter *interpreter, MFStructDeclare *structDeclaer){
	if (structDeclaer.ifAnnotation.expr) {
		MFValue *conValue = mf_eval_expression(interpreter, interpreter.topScope, structDeclaer.ifAnnotation.expr);
		if (![conValue isSubtantial]) {
			return;
		}
	}
	MFStructDeclareTable *table = [MFStructDeclareTable shareInstance];
	[table addStructDeclare:structDeclaer];
}




void mf_interpret(MFInterpreter *interpreter){
	for (__kindof NSObject *top in interpreter.topList) {
		if ([top isKindOfClass:[MFStatement class]]) {
			execute_statement(interpreter, interpreter.topScope, top);
		}else if ([top isKindOfClass:[MFStructDeclare class]]){
			add_struct_declare(interpreter,top);
		}else if ([top isKindOfClass:[MFClassDefinition class]]){
			define_class(interpreter, top);
			fix_class(interpreter,top);
		}
	}
}
