//
//  eval.m
//  MangoFix
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mf_ast.h"
#import <objc/message.h>
#import "ffi.h"
#import "util.h"
#import "mf_ast.h"
#import "execute.h"
#import "create.h"
#import "MFValue+Private.h"

static void eval_expression(MFInterpreter *inter, MFScopeChain *scope, __kindof MFExpression *expr);

static void eval_bool_exprseeion(MFInterpreter *inter, MFExpression *expr){
	MFValue *value = [MFValue new];
	value.type = mf_create_type_specifier(MF_TYPE_BOOL);
	value.uintValue = expr.boolValue;
	[inter.stack push:value];
}

static void eval_interger_expression(MFInterpreter *inter, MFExpression *expr){
	MFValue *value = [MFValue new];
	value.type = mf_create_type_specifier(MF_TYPE_INT);
	value.integerValue = expr.integerValue;
	[inter.stack push:value];
}

static void eval_double_expression(MFInterpreter *inter, MFExpression *expr){
	MFValue *value = [MFValue new];
	value.type = mf_create_type_specifier(MF_TYPE_DOUBLE);
	value.doubleValue = expr.doubleValue;
	[inter.stack push:value];
}

static void eval_string_expression(MFInterpreter *inter, MFExpression *expr){
	MFValue *value = [MFValue new];
	value.type = mf_create_type_specifier(MF_TYPE_C_STRING);
	value.cstringValue = expr.cstringValue;
	[inter.stack push:value];
}

static void eval_sel_expression(MFInterpreter *inter, MFExpression *expr){
	MFValue *value = [MFValue new];
	value.type = mf_create_type_specifier(MF_TYPE_SEL);
	value.selValue = NSSelectorFromString(expr.selectorName);
	[inter.stack push:value];
}




static void eval_block_expression(MFInterpreter *inter, MFScopeChain *outScope, MFBlockExpression *expr){
	MFValue *value = [MFValue new];
	value.type = mf_create_type_specifier(MF_TYPE_BLOCK);
	MFBlock *manBlock = [[MFBlock alloc] init];
	manBlock.func = expr.func;
	
	MFScopeChain *scope = [MFScopeChain scopeChainWithNext:outScope];
	manBlock.scope = scope;
	
	manBlock.inter = inter;
	
	const char *typeEncoding = [manBlock.func.returnTypeSpecifier typeEncoding];
	typeEncoding = mf_str_append(typeEncoding, "@?");
	for (MFParameter *param in manBlock.func.params) {
		const char *paramTypeEncoding = [param.type typeEncoding];
		typeEncoding = mf_str_append(typeEncoding, paramTypeEncoding);
	}
	manBlock.typeEncoding = typeEncoding;
	__autoreleasing id ocBlock = [manBlock ocBlock];
	value.objectValue = ocBlock;
    CFRelease((__bridge void *)ocBlock);
	[inter.stack push:value];
}

static void eval_nil_expr(MFInterpreter *inter){
	MFValue *value = [MFValue new];
	value.type = mf_create_type_specifier(MF_TYPE_OBJECT);
	value.objectValue = nil;
	[inter.stack push:value];
}
static void eval_null_expr(MFInterpreter *inter){
	MFValue *value = [MFValue new];
	value.type = mf_create_type_specifier(MF_TYPE_POINTER);
	value.pointerValue = NULL;
	[inter.stack push:value];
}

static void eval_identifer_expression(MFInterpreter *inter, MFScopeChain *scope ,MFIdentifierExpression *expr){
	NSString *identifier = expr.identifier;
	MFValue *value = [scope getValueWithIdentifierInChain:identifier];
	if (!value) {
		Class clazz = NSClassFromString(identifier);
		if (clazz) {
			value = [MFValue valueInstanceWithClass:clazz];
		}
	}
	NSCAssert(value, @"not found var %@", identifier);
	[inter.stack push:value];
}


static void eval_ternary_expression(MFInterpreter *inter, MFScopeChain *scope, MFTernaryExpression *expr){
	eval_expression(inter, scope, expr.condition);
	MFValue *conValue = [inter.stack pop];
	if (conValue.isSubtantial) {
		if (expr.trueExpr) {
			eval_expression(inter, scope, expr.trueExpr);
		}else{
			[inter.stack push:conValue];
		}
	}else{
		eval_expression(inter, scope, expr.falseExpr);
	}
	
}
static void eval_function_call_expression(MFInterpreter *inter, MFScopeChain *scope, MFFunctonCallExpression *expr);


static void eval_assign_expression(MFInterpreter *inter, MFScopeChain *scope, MFAssignExpression *expr){
	MFAssignKind assignKind = expr.assignKind;
	MFExpression *leftExpr = expr.left;
	MFExpression *rightExpr = expr.right;
	
	switch (leftExpr.expressionKind) {
		case MF_MEMBER_EXPRESSION:{
			MFMemberExpression *memberExpr = (MFMemberExpression *)leftExpr;
			if (!memberExpr.c2methodName) {
				NSString *first = [[memberExpr.memberName substringToIndex:1] uppercaseString];
				NSString *other = memberExpr.memberName.length > 1 ? [memberExpr.memberName substringFromIndex:1] : nil;
				memberExpr.memberName = [NSString stringWithFormat:@"set%@%@:",first,other];
				memberExpr.c2methodName = YES;
			}
			MFFunctonCallExpression *callExpr = [[MFFunctonCallExpression alloc] init];
			callExpr.expressionKind = MF_FUNCTION_CALL_EXPRESSION;
			callExpr.expr = memberExpr;
			
			if (assignKind == MF_NORMAL_ASSIGN) {
				callExpr.args = @[rightExpr];
			}else{
				MFBinaryExpression *binExpr = [[MFBinaryExpression alloc] init];
				binExpr.left = leftExpr;
				binExpr.right = rightExpr;
				callExpr.args = @[binExpr];
				
				switch (assignKind) {
					case MF_ADD_ASSIGN:{
						binExpr.expressionKind = MF_ADD_EXPRESSION;
						break;
					}
					case MF_SUB_ASSIGN:{
						binExpr.expressionKind = MF_SUB_EXPRESSION;
						break;
					}
					case MF_MUL_ASSIGN:{
						binExpr.expressionKind = MF_MUL_EXPRESSION;
						break;
					}
					case MF_DIV_ASSIGN:{
						binExpr.expressionKind = MF_DIV_EXPRESSION;
						break;
					}
					case MF_MOD_ASSIGN:{
						binExpr.expressionKind = MF_MOD_EXPRESSION;
						break;
					}
						
					default:
						break;
				}
				
			}
			eval_function_call_expression(inter, scope, callExpr);
			break;
		}
			
		case MF_SELF_EXPRESSION:{
			NSCAssert(assignKind == MF_NORMAL_ASSIGN, @"");
			eval_expression(inter, scope, rightExpr);
			MFValue *rightValue = [inter.stack pop];
			[scope assignWithIdentifer:@"self" value:rightValue];
			[inter.stack push:rightValue];
			break;
		}
			
		case MF_IDENTIFIER_EXPRESSION:{
			MFIdentifierExpression *identiferExpr = (MFIdentifierExpression *)leftExpr;
			MFExpression *optrExpr;
			if (assignKind == MF_NORMAL_ASSIGN) {
				optrExpr = rightExpr;
			}else{
				MFBinaryExpression *binExpr = [[MFBinaryExpression alloc] init];
				binExpr.left = leftExpr;
				binExpr.right = rightExpr;
				optrExpr = binExpr;
				
				switch (assignKind) {
					case MF_ADD_ASSIGN:{
						binExpr.expressionKind = MF_ADD_EXPRESSION;
						break;
					}
					case MF_SUB_ASSIGN:{
						binExpr.expressionKind = MF_SUB_EXPRESSION;
						break;
					}
					case MF_MUL_ASSIGN:{
						binExpr.expressionKind = MF_MUL_EXPRESSION;
						break;
					}
					case MF_DIV_ASSIGN:{
						binExpr.expressionKind = MF_DIV_EXPRESSION;
						break;
					}
					case MF_MOD_ASSIGN:{
						binExpr.expressionKind = MF_MOD_EXPRESSION;
						break;
					}
						
					default:
						break;
				}
				
			}
			
			eval_expression(inter, scope, optrExpr);
			MFValue *operValue = [inter.stack pop];
			[scope assignWithIdentifer:identiferExpr.identifier value:operValue];
			[inter.stack push:operValue];
			break;
		}
		case MF_SUB_SCRIPT_EXPRESSION:{
			MFSubScriptExpression *subScriptExpr = (MFSubScriptExpression *)leftExpr;
			eval_expression(inter, scope, rightExpr);
			MFValue *rightValue = [inter.stack pop];
			eval_expression(inter, scope, subScriptExpr.aboveExpr);
			MFValue *aboveValue =  [inter.stack pop];
			eval_expression(inter, scope, subScriptExpr.bottomExpr);
			MFValue *bottomValue = [inter.stack pop];
			switch (bottomValue.type.typeKind) {
				case MF_TYPE_BOOL:
				case MF_TYPE_INT:
				case MF_TYPE_U_INT:
					aboveValue.objectValue[bottomValue.c2integerValue] = rightValue.objectValue;
					break;
				case MF_TYPE_CLASS:
					aboveValue.objectValue[(id<NSCopying>)bottomValue.classValue] = rightValue.objectValue;
					break;
				case MF_TYPE_OBJECT:
				case MF_TYPE_BLOCK:
					aboveValue.objectValue[bottomValue.objectValue] = rightValue.objectValue;
					break;
				default:
					NSCAssert(0, @"");
					break;
			}
			
			[inter.stack push:rightValue];
			break;
		}
			
		default:
			NSCAssert(0, @"");
			break;
	}

}


#define arithmeticalOperation(operation,operationName) \
if (leftValue.type.typeKind == MF_TYPE_DOUBLE || rightValue.type.typeKind == MF_TYPE_DOUBLE) {\
resultValue.type = mf_create_type_specifier(MF_TYPE_DOUBLE);\
if (leftValue.type.typeKind == MF_TYPE_DOUBLE) {\
switch (rightValue.type.typeKind) {\
case MF_TYPE_DOUBLE:\
resultValue.doubleValue = leftValue.doubleValue operation rightValue.doubleValue;\
break;\
case MF_TYPE_INT:\
resultValue.doubleValue = leftValue.doubleValue operation rightValue.integerValue;\
break;\
case MF_TYPE_U_INT:\
resultValue.doubleValue = leftValue.doubleValue operation rightValue.uintValue;\
break;\
default:\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);\
break;\
}\
}else{\
switch (leftValue.type.typeKind) {\
case MF_TYPE_INT:\
resultValue.doubleValue = leftValue.integerValue operation rightValue.doubleValue;\
break;\
case MF_TYPE_U_INT:\
resultValue.doubleValue = leftValue.uintValue operation rightValue.doubleValue;\
break;\
default:\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.left.lineNumber ,leftValue.type.typeName);\
break;\
}\
}\
}else if (leftValue.type.typeKind == MF_TYPE_INT || rightValue.type.typeKind == MF_TYPE_INT){\
resultValue.type = mf_create_type_specifier(MF_TYPE_INT);\
if (leftValue.type.typeKind == MF_TYPE_INT) {\
switch (rightValue.type.typeKind) {\
case MF_TYPE_INT:\
resultValue.integerValue = leftValue.integerValue operation rightValue.integerValue;\
break;\
case MF_TYPE_U_INT:\
resultValue.integerValue = leftValue.integerValue operation rightValue.uintValue;\
break;\
default:\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);\
break;\
}\
}else{\
switch (leftValue.type.typeKind) {\
case MF_TYPE_U_INT:\
resultValue.integerValue = leftValue.uintValue operation rightValue.integerValue;\
break;\
default:\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.left.lineNumber ,leftValue.type.typeName);\
break;\
}\
}\
}else if (leftValue.type.typeKind == MF_TYPE_U_INT && rightValue.type.typeKind == MF_TYPE_U_INT){\
resultValue.type = mf_create_type_specifier(MF_TYPE_U_INT);\
resultValue.uintValue = leftValue.uintValue operation rightValue.uintValue;\
}else{\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);\
}


static void eval_add_expression(MFInterpreter *inter, MFScopeChain *scope,MFBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	MFValue *resultValue = [MFValue new];
	
	if (![leftValue isMember] || ![rightValue isMember]){
		resultValue.type = mf_create_type_specifier(MF_TYPE_OBJECT);
		NSString *str = [NSString stringWithFormat:@"%@%@",[leftValue nsStringValue].objectValue,[rightValue nsStringValue].objectValue];
		resultValue.objectValue = str;
	}else arithmeticalOperation(+,add);
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_sub_expression(MFInterpreter *inter, MFScopeChain *scope,MFBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	MFValue *resultValue = [MFValue new];
	arithmeticalOperation(-,sub);
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_mul_expression(MFInterpreter *inter, MFScopeChain *scope,MFBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	MFValue *resultValue = [MFValue new];
	arithmeticalOperation(*,mul);
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_div_expression(MFInterpreter *inter, MFScopeChain *scope,MFBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	switch (rightValue.type.typeKind) {
		case MF_TYPE_DOUBLE:
			if (rightValue.doubleValue == 0) {
				NSCAssert(0, @"line:%zd,divisor cannot be zero!",expr.right.lineNumber);
			}
			break;
		case MF_TYPE_INT:
			if (rightValue.integerValue == 0) {
				NSCAssert(0, @"line:%zd,divisor cannot be zero!",expr.right.lineNumber);
			}
			break;
		case MF_TYPE_U_INT:
			if (rightValue.uintValue == 0) {
				NSCAssert(0, @"line:%zd,divisor cannot be zero!",expr.right.lineNumber);
			}
			break;
			
		default:
			NSCAssert(0, @"line:%zd, div operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);
			break;
	}
	MFValue *resultValue = [MFValue new];\
	arithmeticalOperation(/,div);
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}



static void eval_mod_expression(MFInterpreter *inter, MFScopeChain *scope,MFBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	MFValue *leftValue = [inter.stack peekStack:0];
	if (leftValue.type.typeKind != MF_TYPE_INT && leftValue.type.typeKind != MF_TYPE_U_INT) {
		NSCAssert(0, @"line:%zd, mod operation not support type: %@",expr.left.lineNumber ,leftValue.type.typeName);
	}
	eval_expression(inter, scope, expr.right);
	MFValue *rightValue = [inter.stack peekStack:0];
	if (rightValue.type.typeKind != MF_TYPE_INT && rightValue.type.typeKind != MF_TYPE_U_INT) {
		NSCAssert(0, @"line:%zd, mod operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);
	}
	switch (rightValue.type.typeKind) {
		case MF_TYPE_INT:
			if (rightValue.integerValue == 0) {
				NSCAssert(0, @"line:%zd,mod cannot be zero!",expr.right.lineNumber);
			}
			break;
		case MF_TYPE_U_INT:
			if (rightValue.uintValue == 0) {
				NSCAssert(0, @"line:%zd,mod cannot be zero!",expr.right.lineNumber);
			}
			break;
			
		default:
			NSCAssert(0, @"line:%zd, mod operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);
			break;
	}
	MFValue *resultValue = [MFValue new];
	if (leftValue.type.typeKind == MF_TYPE_INT || leftValue.type.typeKind == MF_TYPE_INT) {
		resultValue.type = mf_create_type_specifier(MF_TYPE_INT);
		if (leftValue.type.typeKind == MF_TYPE_INT) {
			if (rightValue.type.typeKind == MF_TYPE_INT) {
				resultValue.integerValue = leftValue.integerValue % rightValue.integerValue;
			}else{
				resultValue.integerValue = leftValue.integerValue % rightValue.uintValue;
			}
		}else{
			resultValue.integerValue = leftValue.uintValue % rightValue.integerValue;
		}
	}else{
		resultValue.type = mf_create_type_specifier(MF_TYPE_U_INT);
		resultValue.uintValue = leftValue.uintValue % rightValue.uintValue;
	}
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}
#define number_value_compare(sel,oper)\
switch (value2.type.typeKind) {\
case MF_TYPE_BOOL:\
return value1.sel oper value2.uintValue;\
case MF_TYPE_U_INT:\
return value1.sel oper value2.uintValue;\
case MF_TYPE_INT:\
return value1.sel oper value2.integerValue;\
case MF_TYPE_DOUBLE:\
return value1.sel oper value2.doubleValue;\
default:\
NSCAssert(0, @"line:%zd == 、 != 、 < 、 <= 、 > 、 >= can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);\
break;\
}
BOOL mf_equal_value(NSUInteger lineNumber,MFValue *value1, MFValue *value2){

	
#define object_value_equal(sel)\
switch (value2.type.typeKind) {\
case MF_TYPE_CLASS:\
	return value1.sel == value2.classValue;\
case MF_TYPE_OBJECT:\
case MF_TYPE_BLOCK:\
	return value1.sel == value2.objectValue;\
case MF_TYPE_POINTER:\
	return value1.sel == value2.pointerValue;\
default:\
	NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);\
	break;\
}\

	switch (value1.type.typeKind) {
		case MF_TYPE_BOOL:
		case MF_TYPE_U_INT:{
			number_value_compare(uintValue, ==);
		}
		case MF_TYPE_INT:{
			number_value_compare(integerValue, ==);
		}
		case MF_TYPE_DOUBLE:{
			number_value_compare(doubleValue, ==);
		}
		case MF_TYPE_C_STRING:{
			switch (value2.type.typeKind) {
				case MF_TYPE_C_STRING:
					 return value1.cstringValue == value2.cstringValue;
					break;
				case MF_TYPE_POINTER:
					return value1.cstringValue == value2.pointerValue;
					break;
				default:
					NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
					break;
			}
		}
		case MF_TYPE_SEL:{
			if (value2.type.typeKind == MF_TYPE_SEL) {
				return value1.selValue == value2.selValue;
			} else {
				NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
			}
		}
		case MF_TYPE_CLASS:{
			object_value_equal(classValue);
		}
		case MF_TYPE_OBJECT:
		case MF_TYPE_BLOCK:{
			object_value_equal(objectValue);
		}
		case MF_TYPE_POINTER:{
			switch (value2.type.typeKind) {
				case MF_TYPE_CLASS:
					return value2.classValue == value1.pointerValue;
				case MF_TYPE_OBJECT:
					return value2.objectValue == value1.pointerValue;
				case MF_TYPE_BLOCK:
					return value2.objectValue == value1.pointerValue;
				case MF_TYPE_POINTER:
					return value2.pointerValue == value1.pointerValue;
				default:
					NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
					break;
			}
		}
		case MF_TYPE_STRUCT:{
			if (value2.type.typeKind == MF_TYPE_STRUCT) {
				if ([value1.type.structName isEqualToString:value2.type.structName]) {
					const char *typeEncoding  = [value1.type typeEncoding];
					size_t size = mf_size_with_encoding(typeEncoding);
					return memcmp(value1.pointerValue, value2.pointerValue, size) == 0;
				}else{
					return NO;
				}
			}else{
				NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
				break;
			}
		}
		case MF_TYPE_STRUCT_LITERAL:{
			return NO;
		}
			
		default:NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
			break;
	}
#undef object_value_equal
	return NO;
}

static void eval_eq_expression(MFInterpreter *inter, MFScopeChain *scope, MFBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	BOOL equal =  mf_equal_value(expr.left.lineNumber, leftValue, rightValue);
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	resultValue.uintValue = equal;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_ne_expression(MFInterpreter *inter, MFScopeChain *scope, MFBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	BOOL equal =  mf_equal_value(expr.left.lineNumber, leftValue, rightValue);
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	resultValue.uintValue = !equal;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}



#define compare_number_func(prefix, oper)\
static BOOL prefix##_value(NSUInteger lineNumber,MFValue  *value1, MFValue  *value2){\
switch (value1.type.typeKind) {\
	case MF_TYPE_BOOL:\
	case MF_TYPE_U_INT:\
		number_value_compare(uintValue, oper);\
	case MF_TYPE_INT:\
		number_value_compare(integerValue, oper);\
	case MF_TYPE_DOUBLE:\
		number_value_compare(doubleValue, oper);\
	default:\
		NSCAssert(0, @"line:%zd == 、 != 、 < 、 <= 、 > 、 >= can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);\
		break;\
}\
return NO;\
}

compare_number_func(lt, <)
compare_number_func(le, <=)
compare_number_func(ge, >=)
compare_number_func(gt, >)

static void eval_lt_expression(MFInterpreter *inter, MFScopeChain *scope, MFBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	BOOL lt = lt_value(expr.left.lineNumber, leftValue, rightValue);
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	resultValue.uintValue = lt;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_le_expression(MFInterpreter *inter, MFScopeChain *scope, MFBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	BOOL le = le_value(expr.left.lineNumber, leftValue, rightValue);
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	resultValue.uintValue = le;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_ge_expression(MFInterpreter *inter, MFScopeChain *scope, MFBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	BOOL ge = ge_value(expr.left.lineNumber, leftValue, rightValue);
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	resultValue.uintValue = ge;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_gt_expression(MFInterpreter *inter, MFScopeChain *scope, MFBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MFValue *leftValue = [inter.stack peekStack:1];
	MFValue *rightValue = [inter.stack peekStack:0];
	BOOL gt = gt_value(expr.left.lineNumber, leftValue, rightValue);
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	resultValue.uintValue = gt;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_logic_and_expression(MFInterpreter *inter, MFScopeChain *scope, MFBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	MFValue *leftValue = [inter.stack peekStack:0];
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	if (!leftValue.isSubtantial) {
		resultValue.uintValue = NO;
		[inter.stack pop];
	}else{
		eval_expression(inter, scope, expr.right);
		MFValue *rightValue = [inter.stack peekStack:0];
		if (!rightValue.isSubtantial) {
			resultValue.uintValue = NO;
		}else{
			resultValue.uintValue = YES;
		}
		[inter.stack pop];
	}
	[inter.stack push:resultValue];
}

static void eval_logic_or_expression(MFInterpreter *inter, MFScopeChain *scope, MFBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	MFValue *leftValue = [inter.stack peekStack:0];
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	if (leftValue.isSubtantial) {
		resultValue.uintValue = YES;
		[inter.stack pop];
	}else{
		eval_expression(inter, scope, expr.right);
		MFValue *rightValue = [inter.stack peekStack:0];
		if (rightValue.isSubtantial) {
			resultValue.uintValue = YES;
		}else{
			resultValue.uintValue = NO;
		}
		[inter.stack pop];
	}
	[inter.stack push:resultValue];
}

static void eval_logic_not_expression(MFInterpreter *inter, MFScopeChain *scope,MFUnaryExpression *expr){
	eval_expression(inter, scope, expr.expr);
	MFValue *value = [inter.stack peekStack:0];
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_BOOL);
	resultValue.uintValue = !value.isSubtantial;
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_increment_expression(MFInterpreter *inter, MFScopeChain *scope,MFUnaryExpression *expr){
	MFExpression *oneValueExpr = mf_create_expression(MF_INT_EXPRESSION);
	oneValueExpr.integerValue = 1;
	MFBinaryExpression *addExpr = [[MFBinaryExpression alloc] initWithExpressionKind:MF_ADD_EXPRESSION];
	addExpr.left = expr.expr;
	addExpr.right = oneValueExpr;
	MFAssignExpression *assignExpression = (MFAssignExpression *)mf_create_expression(MF_ASSIGN_EXPRESSION);
	assignExpression.assignKind = MF_NORMAL_ASSIGN;
	assignExpression.left = expr.expr;
	assignExpression.right = addExpr;
	eval_expression(inter, scope, assignExpression);
}

static void eval_decrement_expression(MFInterpreter *inter, MFScopeChain *scope,MFUnaryExpression *expr){
	
	MFExpression *oneValueExpr = mf_create_expression(MF_INT_EXPRESSION);
	oneValueExpr.integerValue = 1;
	MFBinaryExpression *addExpr = [[MFBinaryExpression alloc] initWithExpressionKind:MF_SUB_EXPRESSION];
	addExpr.left = expr.expr;
	addExpr.right = oneValueExpr;
	MFAssignExpression *assignExpression = (MFAssignExpression *)mf_create_expression(MF_ASSIGN_EXPRESSION);
	assignExpression.assignKind = MF_NORMAL_ASSIGN;
	assignExpression.left = expr.expr;
	assignExpression.right = addExpr;
	eval_expression(inter, scope, assignExpression);
	
	
}
static void eval_negative_expression(MFInterpreter *inter, MFScopeChain *scope,MFUnaryExpression *expr){
	eval_expression(inter, scope, expr.expr);
	MFValue *value = [inter.stack pop];
	MFValue *resultValue = [MFValue new];
	switch (value.type.typeKind) {
		case MF_TYPE_INT:
			resultValue.type = mf_create_type_specifier(MF_TYPE_INT);
			resultValue.integerValue = -value.integerValue;
			break;
		case MF_TYPE_BOOL:
		case MF_TYPE_U_INT:
			resultValue.type = mf_create_type_specifier(MF_TYPE_U_INT);
			resultValue.integerValue = - value.uintValue;
			break;
		case MF_TYPE_DOUBLE:
			resultValue.type = mf_create_type_specifier(MF_TYPE_DOUBLE);
			resultValue.doubleValue = - value.doubleValue;
			break;
			
		default:
			NSCAssert(0, @"line:%zd operator ‘-’ can not use type: %@",expr.expr.lineNumber, value.type.typeName);
			break;
	}
}


static void eval_sub_script_expression(MFInterpreter *inter, MFScopeChain *scope,MFSubScriptExpression *expr){
	eval_expression(inter, scope, expr.bottomExpr);
	MFValue *bottomValue = [inter.stack peekStack:0];
	ANATypeSpecifierKind kind = bottomValue.type.typeKind;
	
	eval_expression(inter, scope, expr.aboveExpr);
	MFValue *arrValue = [inter.stack peekStack:0];
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_OBJECT);
	switch (kind) {
		case MF_TYPE_BOOL:
		case MF_TYPE_U_INT:
		case MF_TYPE_INT:
			resultValue.objectValue = arrValue.objectValue[bottomValue.c2integerValue];
			break;
		case MF_TYPE_BLOCK:
		case MF_TYPE_OBJECT:
			resultValue.objectValue = arrValue.objectValue[bottomValue.objectValue];
			break;
		case MF_TYPE_CLASS:
			resultValue.objectValue = arrValue.objectValue[bottomValue.classValue];
			break;
		default:
			NSCAssert(0, @"line:%zd, index operator can not use type: %@",expr.bottomExpr.lineNumber, bottomValue.type.typeName);
			break;
	}
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_at_expression(MFInterpreter *inter, MFScopeChain *scope,MFUnaryExpression *expr){
	eval_expression(inter, scope, expr.expr);
	MFValue *value = [inter.stack pop];
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_OBJECT);
	switch (value.type.typeKind) {
		case MF_TYPE_BOOL:
		case MF_TYPE_U_INT:
			resultValue.objectValue = @(value.uintValue);
			break;
		case MF_TYPE_INT:
			resultValue.objectValue = @(value.integerValue);
			break;
		case MF_TYPE_DOUBLE:
			resultValue.objectValue = @(value.doubleValue);
			break;
		case MF_TYPE_C_STRING:
			resultValue.objectValue = @(value.cstringValue);
			break;
			
		default:
			NSCAssert(0, @"line:%zd operator ‘@’ can not use type: %@",expr.expr.lineNumber, value.type.typeName);
			break;
	}
	[inter.stack push:resultValue];
}


static void eval_struct_expression(MFInterpreter *inter, MFScopeChain *scope, MFStructpression *expr){
	NSMutableDictionary *structDic = [NSMutableDictionary dictionary];
	NSArray *entriesExpr =  expr.entriesExpr;
	for (MFStructEntry *entryExpr in entriesExpr) {
		NSString *key = entryExpr.key;
		MFExpression *itemExpr =  entryExpr.valueExpr;
		eval_expression(inter, scope, itemExpr);
		MFValue *value = [inter.stack peekStack:0];
		if (value.isObject) {
			NSCAssert(0, @"line:%zd, struct can not support object type %@", itemExpr.lineNumber, value.type.typeName );
		}
		switch (value.type.typeKind) {
			case MF_TYPE_BOOL:
			case MF_TYPE_U_INT:
				structDic[key] = @(value.uintValue);
				break;
			case MF_TYPE_INT:
				structDic[key] = @(value.integerValue);
				break;
			case MF_TYPE_DOUBLE:
				structDic[key] = @(value.doubleValue);
				break;
			case MF_TYPE_C_STRING:
				structDic[key] = [NSValue valueWithPointer:value.cstringValue];
				break;
			case MF_TYPE_SEL:
				structDic[key] = [NSValue valueWithPointer:value.selValue];
				break;
			case MF_TYPE_STRUCT:
				structDic[key] = value;
				break;
			case MF_TYPE_STRUCT_LITERAL:
				structDic[key] = value.objectValue;
				break;
			case MF_TYPE_POINTER:
				structDic[key] = [NSValue valueWithPointer:value.pointerValue];
				break;
				
			default:
				NSCAssert(0, @"");
				break;
		}
		
		[inter.stack pop];
	}

	MFValue *result = [[MFValue alloc] init];
	result.type = mf_create_type_specifier(MF_TYPE_STRUCT_LITERAL);
	result.objectValue = [structDic copy];
	[inter.stack push:result];
}




static void eval_dic_expression(MFInterpreter *inter, MFScopeChain *scope, MFDictionaryExpression *expr){
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	for (MFDicEntry *entry in expr.entriesExpr) {
		eval_expression(inter, scope, entry.keyExpr);
		MFValue *keyValue = [inter.stack peekStack:0];
		if (!keyValue.isObject) {
			NSCAssert(0, @"line:%zd key can not bee type:%@",entry.keyExpr.lineNumber, keyValue.type.typeName);
		}
		
		
		
		eval_expression(inter, scope, entry.valueExpr);
		MFValue *valueValue = [inter.stack peekStack:0];
		if (!valueValue.isObject) {
			NSCAssert(0, @"line:%zd value can not bee type:%@",entry.keyExpr.lineNumber, valueValue.type.typeName);
		}

		dic[keyValue.c2objectValue] = valueValue.c2objectValue;
		
		[inter.stack pop];
		[inter.stack pop];
	}
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_OBJECT);
	resultValue.objectValue = dic.copy;
	[inter.stack push:resultValue];
	
}


static void eval_array_expression(MFInterpreter *inter, MFScopeChain *scope, MFArrayExpression *expr){
	NSMutableArray *array = [NSMutableArray array];
	for (MFExpression *elementExpr in expr.itemExpressions) {
		eval_expression(inter, scope, elementExpr);
		MFValue *elementValue = [inter.stack peekStack:0];
		if (elementValue.isObject) {
			[array addObject:elementValue.c2objectValue];
		}else{
			NSCAssert(0, @"line:%zd array element type  can not bee type:%@",elementExpr.lineNumber, elementValue.type.typeName);
		}
		
		[inter.stack pop];
	}
	MFValue *resultValue = [MFValue new];
	resultValue.type = mf_create_type_specifier(MF_TYPE_OBJECT);
	resultValue.objectValue = array.copy;
	[inter.stack push:resultValue];
}






static MFValue *get_struct_field_value(void *structData,MFStructDeclare *declare,NSString *key){
	NSString *typeEncoding = [NSString stringWithUTF8String:declare.typeEncoding];
	NSString *types = [typeEncoding substringToIndex:typeEncoding.length-1];
	NSUInteger location = [types rangeOfString:@"="].location+1;
	types = [types substringFromIndex:location];
	const char *encoding = types.UTF8String;
	size_t postion = 0;
	NSUInteger index = [declare.keys indexOfObject:key];
	if (index == NSNotFound) {
		NSCAssert(0, @"key %@ not found of struct %@", key, declare.name);
	}
	MFValue *retValue = [[MFValue alloc] init];
	NSUInteger i = 0;
	for (size_t j = 0; j < declare.keys.count; j++) {
#define mf_GET_STRUCT_FIELD_VALUE_CASE(_code,_type,_kind,_sel)\
case _code:{\
if (j == index) {\
_type value = *(_type *)(structData + postion);\
retValue.type = mf_create_type_specifier(_kind);\
retValue._sel = value;\
return retValue;\
}\
postion += sizeof(_type);\
break;\
}
		switch (encoding[i]) {
				mf_GET_STRUCT_FIELD_VALUE_CASE('c',char,MF_TYPE_INT,integerValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('i',int,MF_TYPE_INT,integerValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('s',short,MF_TYPE_INT,integerValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('l',long,MF_TYPE_INT,integerValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('q',long long,MF_TYPE_INT,integerValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('C',unsigned char,MF_TYPE_U_INT,uintValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('I',unsigned int,MF_TYPE_U_INT,uintValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('S',unsigned short,MF_TYPE_U_INT,uintValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('L',unsigned long,MF_TYPE_U_INT,uintValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('Q',unsigned long long,MF_TYPE_U_INT,uintValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('f',float,MF_TYPE_DOUBLE,doubleValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('d',double,MF_TYPE_DOUBLE,doubleValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('B',BOOL,MF_TYPE_U_INT,uintValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('^',void *,MF_TYPE_POINTER,pointerValue);
				mf_GET_STRUCT_FIELD_VALUE_CASE('*',char *,MF_TYPE_C_STRING,cstringValue);
			
		
			case '{':{
				size_t stackSize = 1;
				size_t end = i + 1;
				for (char c = encoding[end]; c ; end++, c = encoding[end]) {
					if (c == '{') {
						stackSize++;
					}else if (c == '}') {
						stackSize--;
						if (stackSize == 0) {
							break;
						}
					}
				}
				
				NSString *subTypeEncoding = [types substringWithRange:NSMakeRange(i, end - i + 1)];
				size_t size = mf_struct_size_with_encoding(subTypeEncoding.UTF8String);
				if(j == index){
					void *value = structData + postion;
					MFValue *retValue = [[MFValue alloc] init];
					NSString *subStruct = mf_struct_name_with_encoding(subTypeEncoding.UTF8String);
					retValue.type = mf_create_struct_type_specifier(subStruct);
					retValue.pointerValue = malloc(size);
					memcpy(retValue.pointerValue, value, size);
					return retValue;
				}
				
				
				postion += size;
				i = end;
				break;
			}
			default:
				break;
		}
		i++;
	}
	NSCAssert(0, @"struct %@ typeEncoding error %@", declare.name, typeEncoding);
	return nil;
}

static void eval_self_super_expression(MFInterpreter *inter, MFScopeChain *scope){
	MFValue *value = [scope getValueWithIdentifierInChain:@"self"];
	NSCAssert(value, @"not found var %@", @"self");
	[inter.stack push:value];
}

static void eval_member_expression(MFInterpreter *inter, MFScopeChain *scope, MFMemberExpression *expr){
	eval_expression(inter, scope, expr.expr);
	MFValue *obj = [inter.stack peekStack:0];
	if (obj.type.typeKind == MF_TYPE_STRUCT) {
		MFStructDeclareTable *table = [MFStructDeclareTable shareInstance];
		MFValue *value =  get_struct_field_value(obj.pointerValue, [table getStructDeclareWithName:obj.type.structName], expr.memberName);
		[inter.stack pop];
		[inter.stack push:value];
		return;
		
	}
	
	if (obj.type.typeKind != MF_TYPE_OBJECT && obj.type.typeKind != MF_TYPE_CLASS) {
		NSCAssert(0, @"line:%zd, %@ is not object",expr.expr.lineNumber, obj.type.typeName);
	}
	SEL sel = NSSelectorFromString(expr.memberName);
	NSMethodSignature *sig =[obj.c2objectValue methodSignatureForSelector:NSSelectorFromString(expr.memberName)];
	
	char *returnTypeEncoding = (char *)[sig methodReturnType];
	returnTypeEncoding = removeTypeEncodingPrefix(returnTypeEncoding);
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
	[invocation setTarget:obj.c2objectValue];
	[invocation setSelector:sel];
	[invocation invoke];
	
	MFValue *retValue;
	if (*returnTypeEncoding != 'v') {
		void *returnData = malloc([sig methodReturnLength]);
		[invocation getReturnValue:returnData];
		retValue = [[MFValue alloc] initWithCValuePointer:returnData typeEncoding:returnTypeEncoding bridgeTransfer:NO];
		free(returnData);
	}else{
		retValue = [MFValue voidValueInstance];
	}
		
	[inter.stack pop];
	[inter.stack push:retValue];
		
}




static MFValue *invoke(NSUInteger line, MFInterpreter *inter, MFScopeChain *scope, id instance, SEL sel, NSArray<MFExpression *> *argExprs){
	if (!instance) {
		for (MFExpression *argExpr in argExprs) {
			eval_expression(inter, scope, argExpr);
			[inter.stack pop];
		}
		return [MFValue valueInstanceWithInt:0];
	}
	NSMethodSignature *sig = [instance methodSignatureForSelector:sel];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
	invocation.target = instance;
	invocation.selector = sel;
	NSUInteger argCount = [sig numberOfArguments];
	for (NSUInteger i = 2; i < argCount; i++) {
		const char *typeEncoding = [sig getArgumentTypeAtIndex:i];
		void *ptr = malloc(mf_size_with_encoding(typeEncoding));
		eval_expression(inter, scope, argExprs[i - 2]);
		MFValue *argValue = [inter.stack pop];
		[argValue assign2CValuePointer:ptr typeEncoding:typeEncoding];
		[invocation setArgument:ptr atIndex:i];
		free(ptr);
	}
	[invocation invoke];
	
	char *returnType = (char *)[sig methodReturnType];
	returnType = removeTypeEncodingPrefix(returnType);
	MFValue *retValue;
	if (*returnType != 'v') {
		void *retValuePointer = malloc([sig methodReturnLength]);
		[invocation getReturnValue:retValuePointer];
		NSString *selectorName = NSStringFromSelector(sel);
		if ([selectorName isEqualToString:@"alloc"] || [selectorName isEqualToString:@"new"] ||
			[selectorName isEqualToString:@"copy"] || [selectorName isEqualToString:@"mutableCopy"]) {
			retValue = [[MFValue alloc] initWithCValuePointer:retValuePointer typeEncoding:returnType bridgeTransfer:YES];
		}else{
			retValue = [[MFValue alloc] initWithCValuePointer:retValuePointer typeEncoding:returnType bridgeTransfer:NO];
		}
		
		free(retValuePointer);
	}else{
		retValue = [MFValue voidValueInstance];
	}
	
	return retValue;
}



static void eval_function_call_expression(MFInterpreter *inter, MFScopeChain *scope, MFFunctonCallExpression *expr){
	MFExpressionKind exprKind = expr.expr.expressionKind;
	switch (exprKind) {
		case MF_MEMBER_EXPRESSION:{
			MFMemberExpression *memberExpr = (MFMemberExpression *)expr.expr;
			MFExpression *memberObjExpr = memberExpr.expr;
			SEL sel = NSSelectorFromString(memberExpr.memberName);
			switch (memberObjExpr.expressionKind) {
				case MF_SELF_EXPRESSION:{
					id _self = [[scope getValueWithIdentifierInChain:@"self"] objectValue];
					MFValue *retValue = invoke(expr.lineNumber, inter, scope,_self, sel, expr.args);
					[inter.stack push:retValue];
					break;
				}
				case MF_SUPER_EXPRESSION:{
					id _self = [[scope getValueWithIdentifierInChain:@"self"] objectValue];
                    Class currentClass = objc_getClass(memberObjExpr.currentClassName.UTF8String);
					Class superClass = class_getSuperclass(currentClass);
					struct objc_super *superPtr = &(struct objc_super){_self,superClass};
					NSMethodSignature *sig = [_self methodSignatureForSelector:sel];
					NSUInteger argCount = sig.numberOfArguments;
					
					void **args = alloca(sizeof(void *) * argCount);
					ffi_type **argTypes = alloca(sizeof(ffi_type *) * argCount);
					
					argTypes[0] = &ffi_type_pointer;
					args[0] = &superPtr;
					
					argTypes[1] = &ffi_type_pointer;
					args[1] = &sel;
				
					for (NSUInteger i = 2; i < argCount; i++) {
						MFExpression *argExpr = expr.args[i - 2];
						eval_expression(inter, scope, argExpr);
						MFValue *argValue = [inter.stack pop];
						char *argTypeEncoding = (char *)[sig getArgumentTypeAtIndex:i];
						argTypeEncoding = removeTypeEncodingPrefix(argTypeEncoding);
						
						
#define mf_SET_FFI_TYPE_AND_ARG_CASE(_code, _type, _ffi_type_value, _sel)\
case _code:{\
argTypes[i] = &_ffi_type_value;\
_type value = (_type)argValue._sel;\
args[i] = &value;\
break;\
}
						
						switch (*argTypeEncoding) {
							mf_SET_FFI_TYPE_AND_ARG_CASE('c', char, ffi_type_schar, c2integerValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('i', int, ffi_type_sint, c2integerValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('s', short, ffi_type_sshort, c2integerValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('l', long, ffi_type_slong, c2integerValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('q', long long, ffi_type_sint64, c2integerValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('C', unsigned char, ffi_type_uchar, c2uintValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('I', unsigned int, ffi_type_uint, c2uintValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('S', unsigned short, ffi_type_ushort, c2uintValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('L', unsigned long, ffi_type_ulong, c2uintValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('Q', unsigned long long, ffi_type_uint64, c2uintValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('B', BOOL, ffi_type_sint8, c2uintValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('f', float, ffi_type_float, c2doubleValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('d', double, ffi_type_double, c2doubleValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('@', id, ffi_type_pointer, c2objectValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('#', Class, ffi_type_pointer, c2objectValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE(':', SEL, ffi_type_pointer, selValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('*', char *, ffi_type_pointer, c2pointerValue)
							mf_SET_FFI_TYPE_AND_ARG_CASE('^', id, ffi_type_pointer, c2pointerValue)

							case '{':{
								argTypes[i] = mf_ffi_type_with_type_encoding(argTypeEncoding);
								if (argValue.type.typeKind == MF_TYPE_STRUCT_LITERAL) {
									size_t structSize = mf_size_with_encoding(argTypeEncoding);
									void * structPtr = alloca(structSize);
									MFStructDeclareTable *table = [MFStructDeclareTable shareInstance];
									NSString *structName = mf_struct_name_with_encoding(argTypeEncoding);
									MFStructDeclare *declare = [table getStructDeclareWithName:structName];
									mf_struct_data_with_dic(structPtr, argValue.objectValue, declare);
									args[i] = structPtr;
								}else if (argValue.type.typeKind == MF_TYPE_STRUCT){
									args[i] = argValue.pointerValue;
								}else{
									NSCAssert(0, @"");
								}
								break;
							}
							
							
							default:
								NSCAssert(0, @"not support type  %s", argTypeEncoding);
								break;
						}
						
					}
					
					char *returnTypeEncoding = (char *)[sig methodReturnType];
					returnTypeEncoding = removeTypeEncodingPrefix(returnTypeEncoding);
					ffi_type *rtype = NULL;
					void *rvalue = NULL;
#define mf_FFI_RETURN_TYPE_CASE(_code, _ffi_type)\
case _code:{\
rtype = &_ffi_type;\
rvalue = alloca(rtype->size);\
break;\
}
					
					switch (*returnTypeEncoding) {
						mf_FFI_RETURN_TYPE_CASE('c', ffi_type_schar)
						mf_FFI_RETURN_TYPE_CASE('i', ffi_type_sint)
						mf_FFI_RETURN_TYPE_CASE('s', ffi_type_sshort)
						mf_FFI_RETURN_TYPE_CASE('l', ffi_type_slong)
						mf_FFI_RETURN_TYPE_CASE('q', ffi_type_sint64)
						mf_FFI_RETURN_TYPE_CASE('C', ffi_type_uchar)
						mf_FFI_RETURN_TYPE_CASE('I', ffi_type_uint)
						mf_FFI_RETURN_TYPE_CASE('S', ffi_type_ushort)
						mf_FFI_RETURN_TYPE_CASE('L', ffi_type_ulong)
						mf_FFI_RETURN_TYPE_CASE('Q', ffi_type_uint64)
						mf_FFI_RETURN_TYPE_CASE('B', ffi_type_sint8)
						mf_FFI_RETURN_TYPE_CASE('f', ffi_type_float)
						mf_FFI_RETURN_TYPE_CASE('d', ffi_type_double)
						mf_FFI_RETURN_TYPE_CASE('@', ffi_type_pointer)
						mf_FFI_RETURN_TYPE_CASE('#', ffi_type_pointer)
						mf_FFI_RETURN_TYPE_CASE(':', ffi_type_pointer)
						mf_FFI_RETURN_TYPE_CASE('^', ffi_type_pointer)
						mf_FFI_RETURN_TYPE_CASE('*', ffi_type_pointer)
						mf_FFI_RETURN_TYPE_CASE('v', ffi_type_void)
						case '{':{
							rtype = mf_ffi_type_with_type_encoding(returnTypeEncoding);
							rvalue = alloca(rtype->size);
						}
							
						default:
							NSCAssert(0, @"not support type  %s", returnTypeEncoding);
							break;
					}
					
		
					ffi_cif cif;
					ffi_prep_cif(&cif, FFI_DEFAULT_ABI, (unsigned int)argCount, rtype, argTypes);
					ffi_call(&cif, objc_msgSendSuper, rvalue, args);
					MFValue *retValue;
					if (*returnTypeEncoding != 'v') {
						 retValue = [[MFValue alloc] initWithCValuePointer:rvalue typeEncoding:returnTypeEncoding bridgeTransfer:NO];
					}else{
						retValue = [MFValue voidValueInstance];
					}
					[inter.stack push:retValue];
					break;
				}
				default:{
					eval_expression(inter, scope, memberObjExpr);
					MFValue *memberObj = [inter.stack pop];
					MFValue *retValue = invoke(expr.lineNumber, inter, scope, [memberObj c2objectValue], sel, expr.args);
					[inter.stack push:retValue];
					break;
					
					
					
				}
			}
			
			
			break;
		}
		case MF_IDENTIFIER_EXPRESSION:
		case MF_FUNCTION_CALL_EXPRESSION:{
			eval_expression(inter, scope, expr.expr);
			MFValue *blockValue = [inter.stack pop];
			
			
			const char *blockTypeEncoding = [MFBlock typeEncodingForBlock:blockValue.c2objectValue];
			NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:blockTypeEncoding];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
			[invocation setTarget:blockValue.objectValue];
			
			NSUInteger numberOfArguments = [sig numberOfArguments];
			if (numberOfArguments - 1 != expr.args.count) {
				NSCAssert(0, @"");
			}
			for (NSUInteger i = 1; i < numberOfArguments; i++) {
				const char *typeEncoding = [sig getArgumentTypeAtIndex:i];
				void *ptr = alloca(mf_size_with_encoding(typeEncoding));
				eval_expression(inter, scope, expr.args[i -1]);
				MFValue *argValue = [inter.stack pop];
				[argValue assign2CValuePointer:ptr typeEncoding:typeEncoding];
				[invocation setArgument:ptr atIndex:i];
			}
			[invocation invoke];
			const char *retType = [sig methodReturnType];
			retType = removeTypeEncodingPrefix((char *)retType);
			MFValue *retValue;
			if (*retType != 'v') {
				void *retValuePtr = alloca(mf_size_with_encoding(retType));
				[invocation getReturnValue:retValuePtr];
				retValue = [[MFValue alloc] initWithCValuePointer:retValuePtr typeEncoding:retType bridgeTransfer:NO];
			}else{
				retValue = [MFValue voidValueInstance];
			}
			[inter.stack push:retValue];
			break;
		}
			
		default:
			break;
	}
	
	
	
	
}







static void eval_expression(MFInterpreter *inter, MFScopeChain *scope, __kindof MFExpression *expr){
	switch (expr.expressionKind) {
		case MF_BOOLEAN_EXPRESSION:
			eval_bool_exprseeion(inter, expr);
			break;
		case MF_INT_EXPRESSION:
			eval_interger_expression(inter, expr);
			break;
		case MF_DOUBLE_EXPRESSION:
			eval_double_expression(inter, expr);
			break;
		case MF_STRING_EXPRESSION:
			eval_string_expression(inter, expr);
			break;
		case MF_SELECTOR_EXPRESSION:
			eval_sel_expression(inter, expr);
			break;
		case MF_BLOCK_EXPRESSION:
			eval_block_expression(inter, scope, expr);
			break;
		case MF_NIL_EXPRESSION:
			eval_nil_expr(inter);
			break;
		case MF_NULL_EXPRESSION:
			eval_null_expr(inter);
			break;
		case MF_SELF_EXPRESSION:
		case MF_SUPER_EXPRESSION:
			eval_self_super_expression(inter, scope);
			break;
		case MF_IDENTIFIER_EXPRESSION:
			eval_identifer_expression(inter, scope, expr);
			break;
		case MF_ASSIGN_EXPRESSION:
			eval_assign_expression(inter, scope, expr);
			break;
		case MF_ADD_EXPRESSION:
			eval_add_expression(inter, scope, expr);
			break;
		case MF_SUB_EXPRESSION:
			eval_sub_expression(inter, scope, expr);
			break;
		case MF_MUL_EXPRESSION:
			eval_mul_expression(inter, scope, expr);
			break;
		case MF_DIV_EXPRESSION:
			eval_div_expression(inter, scope, expr);
			break;
		case MF_MOD_EXPRESSION:
			eval_mod_expression(inter, scope, expr);
			break;
		case MF_EQ_EXPRESSION:
			eval_eq_expression(inter, scope, expr);
			break;
		case MF_NE_EXPRESSION:
			eval_ne_expression(inter, scope, expr);
			break;
		case MF_LT_EXPRESSION:
			eval_lt_expression(inter, scope, expr);
			break;
		case MF_LE_EXPRESSION:
			eval_le_expression(inter, scope, expr);
			break;
		case MF_GE_EXPRESSION:
			eval_ge_expression(inter, scope, expr);
			break;
		case MF_GT_EXPRESSION:
			eval_gt_expression(inter, scope, expr);
			break;
		case MF_LOGICAL_AND_EXPRESSION:
			eval_logic_and_expression(inter, scope, expr);
			break;
		case MF_LOGICAL_OR_EXPRESSION:
			eval_logic_or_expression(inter, scope, expr);
			break;
		case MF_LOGICAL_NOT_EXPRESSION:
			eval_logic_not_expression(inter, scope, expr);
			break;
		case MF_TERNARY_EXPRESSION:
			eval_ternary_expression(inter, scope, expr);
			break;
		case MF_SUB_SCRIPT_EXPRESSION:
			eval_sub_script_expression(inter, scope, expr);
			break;
		case MF_AT_EXPRESSION:
			eval_at_expression(inter, scope, expr);
			break;
		case NSC_NEGATIVE_EXPRESSION:
			eval_negative_expression(inter, scope, expr);
			break;
		case MF_MEMBER_EXPRESSION:
			eval_member_expression(inter, scope, expr);
			break;
		case MF_DIC_LITERAL_EXPRESSION:
			eval_dic_expression(inter, scope, expr);
			break;
		case MF_ARRAY_LITERAL_EXPRESSION:
			eval_array_expression(inter, scope, expr);
			break;
		case MF_INCREMENT_EXPRESSION:
			eval_increment_expression(inter, scope, expr);
			break;
		case MF_DECREMENT_EXPRESSION:
			eval_decrement_expression(inter, scope, expr);
			break;
		case MF_STRUCT_LITERAL_EXPRESSION:
			eval_struct_expression(inter, scope, expr);
			break;
		case MF_FUNCTION_CALL_EXPRESSION:
			eval_function_call_expression(inter, scope, expr);
			break;
		default:
			break;
	}
	
}

MFValue *mf_eval_expression(MFInterpreter *inter, MFScopeChain *scope,MFExpression *expr){
	eval_expression(inter, scope, expr);
	return [inter.stack pop];
}
