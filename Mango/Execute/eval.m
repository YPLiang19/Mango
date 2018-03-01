//
//  eval.m
//  ananasExample
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "man_ast.h"
#import <objc/message.h>
#import "ffi.h"
#import "util.h"
#import "man_ast.h"
#import "execute.h"
#import "create.h"

static void eval_expression(MANInterpreter *inter, MANScopeChain *scope, __kindof MANExpression *expr);

static void eval_bool_exprseeion(MANInterpreter *inter, MANExpression *expr){
	MANValue *value = [MANValue new];
	value.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	value.uintValue = expr.boolValue;
	[inter.stack push:value];
}

static void eval_interger_expression(MANInterpreter *inter, MANExpression *expr){
	MANValue *value = [MANValue new];
	value.type = anc_create_type_specifier(MAN_TYPE_INT);
	value.integerValue = expr.integerValue;
	[inter.stack push:value];
}

static void eval_double_expression(MANInterpreter *inter, MANExpression *expr){
	MANValue *value = [MANValue new];
	value.type = anc_create_type_specifier(MAN_TYPE_DOUBLE);
	value.doubleValue = expr.doubleValue;
	[inter.stack push:value];
}

static void eval_string_expression(MANInterpreter *inter, MANExpression *expr){
	MANValue *value = [MANValue new];
	value.type = anc_create_type_specifier(MAN_TYPE_C_STRING);
	value.cstringValue = expr.cstringValue;
	[inter.stack push:value];
}

static void eval_sel_expression(MANInterpreter *inter, MANExpression *expr){
	MANValue *value = [MANValue new];
	value.type = anc_create_type_specifier(MAN_TYPE_SEL);
	value.selValue = NSSelectorFromString(expr.selectorName);
	[inter.stack push:value];
}




static void eval_block_expression(MANInterpreter *inter, MANScopeChain *outScope, MANBlockExpression *expr){
	MANValue *value = [MANValue new];
	value.type = anc_create_type_specifier(MAN_TYPE_BLOCK);
	MANBlock *manBlock = [[MANBlock alloc] init];
	manBlock.func = expr.func;
	
	MANScopeChain *scope = [MANScopeChain scopeChainWithNext:outScope];
	manBlock.scope = scope;
	
	manBlock.inter = inter;
	
	const char *typeEncoding = [manBlock.func.returnTypeSpecifier typeEncoding];
	typeEncoding = mango_str_append(typeEncoding, "@?");
	for (MANParameter *param in manBlock.func.params) {
		const char *paramTypeEncoding = [param.type typeEncoding];
		typeEncoding = mango_str_append(typeEncoding, paramTypeEncoding);
	}
	manBlock.typeEncoding = typeEncoding;
	value.objectValue = [manBlock ocBlock];
	[inter.stack push:value];
}

static void eval_nil_expr(MANInterpreter *inter){
	MANValue *value = [MANValue new];
	value.type = anc_create_type_specifier(MAN_TYPE_OBJECT);
	value.objectValue = nil;
	[inter.stack push:value];
}


static void eval_identifer_expression(MANInterpreter *inter, MANScopeChain *scope ,MANIdentifierExpression *expr){
	NSString *identifier = expr.identifier;
	MANValue *value = [scope getValueWithIdentifier:identifier];
	if (!value) {
		Class clazz = NSClassFromString(identifier);
		if (clazz) {
			value = [MANValue valueInstanceWithClass:clazz];
		}
	}
	NSCAssert(value, @"not found var %@", identifier);
	[inter.stack push:value];
}


static void eval_ternary_expression(MANInterpreter *inter, MANScopeChain *scope, MANTernaryExpression *expr){
	eval_expression(inter, scope, expr.condition);
	MANValue *conValue = [inter.stack pop];
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
static void eval_function_call_expression(MANInterpreter *inter, MANScopeChain *scope, MANFunctonCallExpression *expr);


void mango_assign_value_to_identifer_expr(MANInterpreter *inter, MANScopeChain *scope, NSString *identifier,MANValue *operValue){
	for (MANScopeChain *pos = scope; pos; pos = pos.next) {
		if (pos.instance) {
			Ivar ivar	= class_getInstanceVariable([pos instance],identifier.UTF8String);
			if (ivar) {
				const char *ivarEncoding = ivar_getTypeEncoding(ivar);
				void *ptr = (__bridge void *)(pos.instance) +  ivar_getOffset(ivar);
				[operValue assign2CValuePointer:ptr typeEncoding:ivarEncoding];
				return;
			}
			
		}else{
			__block BOOL finish = NO;;
			[pos.vars enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, MANValue * _Nonnull obj, BOOL * _Nonnull stop) {
				if ([key isEqualToString:identifier]) {
					[obj assignFrom:operValue];
					*stop = YES;
					finish = YES;
				}
			}];
			if (finish) {
				return;
			}
		}
		
	}
}

static void eval_assign_expression(MANInterpreter *inter, MANScopeChain *scope, MANAssignExpression *expr){
	MANAssignKind assignKind = expr.assignKind;
	MANExpression *leftExpr = expr.left;
	MANExpression *rightExpr = expr.right;
	
	switch (leftExpr.expressionKind) {
		case MAN_MEMBER_EXPRESSION:{
			MANMemberExpression *memberExpr = (MANMemberExpression *)leftExpr;
			if (!memberExpr.c2methodName) {
				NSString *first = [[memberExpr.memberName substringToIndex:1] uppercaseString];
				NSString *other = memberExpr.memberName.length > 1 ? [memberExpr.memberName substringFromIndex:1] : nil;
				memberExpr.memberName = [NSString stringWithFormat:@"set%@%@:",first,other];
				memberExpr.c2methodName = YES;
			}
			MANFunctonCallExpression *callExpr = [[MANFunctonCallExpression alloc] init];
			callExpr.expressionKind = MAN_FUNCTION_CALL_EXPRESSION;
			callExpr.expr = memberExpr;
			
			if (assignKind == MAN_NORMAL_ASSIGN) {
				callExpr.args = @[rightExpr];
			}else{
				MANBinaryExpression *binExpr = [[MANBinaryExpression alloc] init];
				binExpr.left = leftExpr;
				binExpr.right = rightExpr;
				callExpr.args = @[binExpr];
				
				switch (assignKind) {
					case MAN_ADD_ASSIGN:{
						binExpr.expressionKind = MAN_ADD_EXPRESSION;
						break;
					}
					case MAN_SUB_ASSIGN:{
						binExpr.expressionKind = MAN_SUB_EXPRESSION;
						break;
					}
					case MAN_MUL_ASSIGN:{
						binExpr.expressionKind = MAN_MUL_EXPRESSION;
						break;
					}
					case MAN_DIV_ASSIGN:{
						binExpr.expressionKind = MAN_DIV_EXPRESSION;
						break;
					}
					case MAN_MOD_ASSIGN:{
						binExpr.expressionKind = MAN_MOD_EXPRESSION;
						break;
					}
						
					default:
						break;
				}
				
			}
			
			
			eval_function_call_expression(inter, scope, callExpr);
			break;
		}
			
		case MAN_SELF_EXPRESSION:{
			NSCAssert(assignKind == MAN_NORMAL_ASSIGN, @"");
			eval_expression(inter, scope, rightExpr);
			MANValue *rightValue = [inter.stack pop];
			mango_assign_value_to_identifer_expr(inter, scope,@"self", rightValue);
			[inter.stack push:rightValue];
			break;
		}
			
		case MAN_IDENTIFIER_EXPRESSION:{
			MANIdentifierExpression *identiferExpr = (MANIdentifierExpression *)leftExpr;
			MANExpression *optrExpr;
			if (assignKind == MAN_NORMAL_ASSIGN) {
				optrExpr = rightExpr;
			}else{
				MANBinaryExpression *binExpr = [[MANBinaryExpression alloc] init];
				binExpr.left = leftExpr;
				binExpr.right = rightExpr;
				optrExpr = binExpr;
				
				switch (assignKind) {
					case MAN_ADD_ASSIGN:{
						binExpr.expressionKind = MAN_ADD_EXPRESSION;
						break;
					}
					case MAN_SUB_ASSIGN:{
						binExpr.expressionKind = MAN_SUB_EXPRESSION;
						break;
					}
					case MAN_MUL_ASSIGN:{
						binExpr.expressionKind = MAN_MUL_EXPRESSION;
						break;
					}
					case MAN_DIV_ASSIGN:{
						binExpr.expressionKind = MAN_DIV_EXPRESSION;
						break;
					}
					case MAN_MOD_ASSIGN:{
						binExpr.expressionKind = MAN_MOD_EXPRESSION;
						break;
					}
						
					default:
						break;
				}
				
			}
			
			eval_expression(inter, scope, optrExpr);
			MANValue *operValue = [inter.stack pop];

			mango_assign_value_to_identifer_expr(inter, scope, identiferExpr.identifier, operValue);
			[inter.stack push:operValue];
			break;
		}
		case MAN_INDEX_EXPRESSION:{
			MANIndexExpression *indexExpr = (MANIndexExpression *)leftExpr;
			eval_expression(inter, scope, rightExpr);
			MANValue *rightValue = [inter.stack pop];
			eval_expression(inter, scope, indexExpr.arrayExpression);
			MANValue *arrValue =  [inter.stack pop];
			eval_expression(inter, scope, indexExpr.indexExpression);
			MANValue *indexValue = [inter.stack pop];
			arrValue.objectValue[indexValue.c2uintValue] = rightValue.objectValue;
			[inter.stack push:rightValue];
			break;
		}
			
		default:
			NSCAssert(0, @"");
			break;
	}

}


#define arithmeticalOperation(operation,operationName) \
if (leftValue.type.typeKind == MAN_TYPE_DOUBLE || rightValue.type.typeKind == MAN_TYPE_DOUBLE) {\
resultValue.type = anc_create_type_specifier(MAN_TYPE_DOUBLE);\
if (leftValue.type.typeKind == MAN_TYPE_DOUBLE) {\
switch (rightValue.type.typeKind) {\
case MAN_TYPE_DOUBLE:\
resultValue.doubleValue = leftValue.doubleValue operation rightValue.doubleValue;\
break;\
case MAN_TYPE_INT:\
resultValue.doubleValue = leftValue.doubleValue operation rightValue.integerValue;\
break;\
case MAN_TYPE_U_INT:\
resultValue.doubleValue = leftValue.doubleValue operation rightValue.uintValue;\
break;\
default:\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);\
break;\
}\
}else{\
switch (leftValue.type.typeKind) {\
case MAN_TYPE_INT:\
resultValue.doubleValue = leftValue.integerValue operation rightValue.doubleValue;\
break;\
case MAN_TYPE_U_INT:\
resultValue.doubleValue = leftValue.uintValue operation rightValue.doubleValue;\
break;\
default:\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.left.lineNumber ,leftValue.type.typeName);\
break;\
}\
}\
}else if (leftValue.type.typeKind == MAN_TYPE_INT || rightValue.type.typeKind == MAN_TYPE_INT){\
resultValue.type = anc_create_type_specifier(MAN_TYPE_INT);\
if (leftValue.type.typeKind == MAN_TYPE_INT) {\
switch (rightValue.type.typeKind) {\
case MAN_TYPE_INT:\
resultValue.integerValue = leftValue.integerValue operation rightValue.integerValue;\
break;\
case MAN_TYPE_U_INT:\
resultValue.integerValue = leftValue.integerValue operation rightValue.uintValue;\
break;\
default:\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);\
break;\
}\
}else{\
switch (leftValue.type.typeKind) {\
case MAN_TYPE_U_INT:\
resultValue.integerValue = leftValue.uintValue operation rightValue.integerValue;\
break;\
default:\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.left.lineNumber ,leftValue.type.typeName);\
break;\
}\
}\
}else if (leftValue.type.typeKind == MAN_TYPE_U_INT && rightValue.type.typeKind == MAN_TYPE_U_INT){\
resultValue.type = anc_create_type_specifier(MAN_TYPE_U_INT);\
resultValue.uintValue = leftValue.uintValue operation rightValue.uintValue;\
}else{\
NSCAssert(0, @"line:%zd, " #operationName  " operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);\
}


static void eval_add_expression(MANInterpreter *inter, MANScopeChain *scope,MANBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	MANValue *resultValue = [MANValue new];
	
	if (![leftValue isMember] || ![rightValue isMember]){
		resultValue.type = anc_create_type_specifier(MAN_TYPE_OBJECT);\
		NSString *str = [NSString stringWithFormat:@"%@%@",[leftValue nsStringValue].objectValue,[rightValue nsStringValue].objectValue];\
		resultValue.objectValue = str;\
	}else arithmeticalOperation(+,add);
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_sub_expression(MANInterpreter *inter, MANScopeChain *scope,MANBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	MANValue *resultValue = [MANValue new];\
	arithmeticalOperation(-,sub);
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_mul_expression(MANInterpreter *inter, MANScopeChain *scope,MANBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	MANValue *resultValue = [MANValue new];
	arithmeticalOperation(*,mul);
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_div_expression(MANInterpreter *inter, MANScopeChain *scope,MANBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	switch (rightValue.type.typeKind) {
		case MAN_TYPE_DOUBLE:
			if (rightValue.doubleValue == 0) {
				NSCAssert(0, @"line:%zd,divisor cannot be zero!",expr.right.lineNumber);
			}
			break;
		case MAN_TYPE_INT:
			if (rightValue.integerValue == 0) {
				NSCAssert(0, @"line:%zd,divisor cannot be zero!",expr.right.lineNumber);
			}
			break;
		case MAN_TYPE_U_INT:
			if (rightValue.uintValue == 0) {
				NSCAssert(0, @"line:%zd,divisor cannot be zero!",expr.right.lineNumber);
			}
			break;
			
		default:
			NSCAssert(0, @"line:%zd, div operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);
			break;
	}
	MANValue *resultValue = [MANValue new];\
	arithmeticalOperation(/,div);
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}



static void eval_mod_expression(MANInterpreter *inter, MANScopeChain *scope,MANBinaryExpression  *expr){
	eval_expression(inter, scope, expr.left);
	MANValue *leftValue = [inter.stack peekStack:0];
	if (leftValue.type.typeKind != MAN_TYPE_INT && leftValue.type.typeKind != MAN_TYPE_U_INT) {
		NSCAssert(0, @"line:%zd, mod operation not support type: %@",expr.left.lineNumber ,leftValue.type.typeName);
	}
	eval_expression(inter, scope, expr.right);
	MANValue *rightValue = [inter.stack peekStack:0];
	if (rightValue.type.typeKind != MAN_TYPE_INT && rightValue.type.typeKind != MAN_TYPE_U_INT) {
		NSCAssert(0, @"line:%zd, mod operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);
	}
	switch (rightValue.type.typeKind) {
		case MAN_TYPE_INT:
			if (rightValue.integerValue == 0) {
				NSCAssert(0, @"line:%zd,mod cannot be zero!",expr.right.lineNumber);
			}
			break;
		case MAN_TYPE_U_INT:
			if (rightValue.uintValue == 0) {
				NSCAssert(0, @"line:%zd,mod cannot be zero!",expr.right.lineNumber);
			}
			break;
			
		default:
			NSCAssert(0, @"line:%zd, mod operation not support type: %@",expr.right.lineNumber ,rightValue.type.typeName);
			break;
	}
	MANValue *resultValue = [MANValue new];
	if (leftValue.type.typeKind == MAN_TYPE_INT || leftValue.type.typeKind == MAN_TYPE_INT) {
		resultValue.type = anc_create_type_specifier(MAN_TYPE_INT);
		if (leftValue.type.typeKind == MAN_TYPE_INT) {
			if (rightValue.type.typeKind == MAN_TYPE_INT) {
				resultValue.integerValue = leftValue.integerValue % rightValue.integerValue;
			}else{
				resultValue.integerValue = leftValue.integerValue % rightValue.uintValue;
			}
		}else{
			resultValue.integerValue = leftValue.uintValue % rightValue.integerValue;
		}
	}else{
		resultValue.type = anc_create_type_specifier(MAN_TYPE_U_INT);
		resultValue.uintValue = leftValue.uintValue % rightValue.uintValue;
	}
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}
#define number_value_compare(sel,oper)\
switch (value2.type.typeKind) {\
case MAN_TYPE_BOOL:\
return value1.sel oper value2.uintValue;\
case MAN_TYPE_U_INT:\
return value1.sel oper value2.uintValue;\
case MAN_TYPE_INT:\
return value1.sel oper value2.integerValue;\
case MAN_TYPE_DOUBLE:\
return value1.sel oper value2.doubleValue;\
default:\
NSCAssert(0, @"line:%zd == 、 != 、 < 、 <= 、 > 、 >= can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);\
break;\
}
BOOL mango_equal_value(NSUInteger lineNumber,MANValue *value1, MANValue *value2){

	
#define object_value_equal(sel)\
switch (value2.type.typeKind) {\
case MAN_TYPE_CLASS:\
	return value1.sel == value2.classValue;\
case MAN_TYPE_OBJECT:\
case MAN_TYPE_BLOCK:\
	return value1.sel == value2.objectValue;\
case MAN_TYPE_POINTER:\
	return value1.sel == value2.pointerValue;\
default:\
	NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);\
	break;\
}\

	switch (value1.type.typeKind) {
		case MAN_TYPE_BOOL:
		case MAN_TYPE_U_INT:{
			number_value_compare(uintValue, ==);
		}
		case MAN_TYPE_INT:{
			number_value_compare(integerValue, ==);
		}
		case MAN_TYPE_DOUBLE:{
			number_value_compare(doubleValue, ==);
		}
		case MAN_TYPE_C_STRING:{
			switch (value2.type.typeKind) {
				case MAN_TYPE_C_STRING:
					 return value1.cstringValue == value2.cstringValue;
					break;
				case MAN_TYPE_POINTER:
					return value1.cstringValue == value2.pointerValue;
					break;
				default:
					NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
					break;
			}
		}
		case MAN_TYPE_SEL:{
			if (value2.type.typeKind == MAN_TYPE_SEL) {
				return value1.selValue == value2.selValue;
			} else {
				NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
			}
		}
		case MAN_TYPE_CLASS:{
			object_value_equal(classValue);
		}
		case MAN_TYPE_OBJECT:
		case MAN_TYPE_BLOCK:{
			object_value_equal(objectValue);
		}
		case MAN_TYPE_POINTER:{
			switch (value2.type.typeKind) {
				case MAN_TYPE_CLASS:
					return value2.classValue == value1.pointerValue;
				case MAN_TYPE_OBJECT:
					return value2.objectValue == value1.pointerValue;
				case MAN_TYPE_BLOCK:
					return value2.objectValue == value1.pointerValue;
				case MAN_TYPE_POINTER:
					return value2.pointerValue == value1.pointerValue;
				default:
					NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
					break;
			}
		}
		case MAN_TYPE_STRUCT:{
			if (value2.type.typeKind == MAN_TYPE_STRUCT) {
				if ([value1.type.structName isEqualToString:value2.type.structName]) {
					const char *typeEncoding  = [value1.type typeEncoding];
					size_t size = mango_size_with_encoding(typeEncoding);
					return memcmp(value1.pointerValue, value2.pointerValue, size) == 0;
				}else{
					return NO;
				}
			}else{
				NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
				break;
			}
		}
		case MAN_TYPE_STRUCT_LITERAL:{
			return NO;
		}
			
		default:NSCAssert(0, @"line:%zd == and != can not use between %@ and %@",lineNumber, value1.type.typeName, value2.type.typeName);
			break;
	}
#undef object_value_equal
	return NO;
}

static void eval_eq_expression(MANInterpreter *inter, MANScopeChain *scope, MANBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	BOOL equal =  mango_equal_value(expr.left.lineNumber, leftValue, rightValue);
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	resultValue.uintValue = equal;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_ne_expression(MANInterpreter *inter, MANScopeChain *scope, MANBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	BOOL equal =  mango_equal_value(expr.left.lineNumber, leftValue, rightValue);
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	resultValue.uintValue = !equal;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}



#define compare_number_func(prefix, oper)\
static BOOL prefix##_value(NSUInteger lineNumber,MANValue  *value1, MANValue  *value2){\
switch (value1.type.typeKind) {\
	case MAN_TYPE_BOOL:\
	case MAN_TYPE_U_INT:\
		number_value_compare(uintValue, oper);\
	case MAN_TYPE_INT:\
		number_value_compare(integerValue, oper);\
	case MAN_TYPE_DOUBLE:\
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

static void eval_lt_expression(MANInterpreter *inter, MANScopeChain *scope, MANBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	BOOL lt = lt_value(expr.left.lineNumber, leftValue, rightValue);
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	resultValue.uintValue = lt;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_le_expression(MANInterpreter *inter, MANScopeChain *scope, MANBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	BOOL le = le_value(expr.left.lineNumber, leftValue, rightValue);
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	resultValue.uintValue = le;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_ge_expression(MANInterpreter *inter, MANScopeChain *scope, MANBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	BOOL ge = ge_value(expr.left.lineNumber, leftValue, rightValue);
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	resultValue.uintValue = ge;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}


static void eval_gt_expression(MANInterpreter *inter, MANScopeChain *scope, MANBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	eval_expression(inter, scope, expr.right);
	MANValue *leftValue = [inter.stack peekStack:1];
	MANValue *rightValue = [inter.stack peekStack:0];
	BOOL gt = gt_value(expr.left.lineNumber, leftValue, rightValue);
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	resultValue.uintValue = gt;
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_logic_and_expression(MANInterpreter *inter, MANScopeChain *scope, MANBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	MANValue *leftValue = [inter.stack peekStack:0];
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	if (!leftValue.isSubtantial) {
		resultValue.uintValue = NO;
		[inter.stack pop];
	}else{
		eval_expression(inter, scope, expr.right);
		MANValue *rightValue = [inter.stack peekStack:0];
		if (!rightValue.isSubtantial) {
			resultValue.uintValue = NO;
		}else{
			resultValue.uintValue = YES;
		}
		[inter.stack pop];
	}
	[inter.stack push:resultValue];
}

static void eval_logic_or_expression(MANInterpreter *inter, MANScopeChain *scope, MANBinaryExpression *expr){
	eval_expression(inter, scope, expr.left);
	MANValue *leftValue = [inter.stack peekStack:0];
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	if (leftValue.isSubtantial) {
		resultValue.uintValue = YES;
		[inter.stack pop];
	}else{
		eval_expression(inter, scope, expr.right);
		MANValue *rightValue = [inter.stack peekStack:0];
		if (rightValue.isSubtantial) {
			resultValue.uintValue = YES;
		}else{
			resultValue.uintValue = NO;
		}
		[inter.stack pop];
	}
	[inter.stack push:resultValue];
}

static void eval_logic_not_expression(MANInterpreter *inter, MANScopeChain *scope,MANUnaryExpression *expr){
	eval_expression(inter, scope, expr.expr);
	MANValue *value = [inter.stack peekStack:0];
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_BOOL);
	resultValue.uintValue = !value.isSubtantial;
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_increment_expression(MANInterpreter *inter, MANScopeChain *scope,MANUnaryExpression *expr){
	MANExpression *oneValueExpr = anc_create_expression(MAN_INT_EXPRESSION);
	oneValueExpr.integerValue = 1;
	MANBinaryExpression *addExpr = [[MANBinaryExpression alloc] initWithExpressionKind:MAN_ADD_EXPRESSION];
	addExpr.left = expr.expr;
	addExpr.right = oneValueExpr;
	MANAssignExpression *assignExpression = (MANAssignExpression *)anc_create_expression(MAN_ASSIGN_EXPRESSION);
	assignExpression.assignKind = MAN_NORMAL_ASSIGN;
	assignExpression.left = expr.expr;
	assignExpression.right = addExpr;
	eval_expression(inter, scope, assignExpression);
}

static void eval_decrement_expression(MANInterpreter *inter, MANScopeChain *scope,MANUnaryExpression *expr){
	
	MANExpression *oneValueExpr = anc_create_expression(MAN_INT_EXPRESSION);
	oneValueExpr.integerValue = -1;
	MANBinaryExpression *addExpr = [[MANBinaryExpression alloc] initWithExpressionKind:MAN_SUB_EXPRESSION];
	addExpr.left = expr.expr;
	addExpr.right = oneValueExpr;
	MANAssignExpression *assignExpression = (MANAssignExpression *)anc_create_expression(MAN_ASSIGN_EXPRESSION);
	assignExpression.assignKind = MAN_NORMAL_ASSIGN;
	assignExpression.left = expr.expr;
	assignExpression.right = addExpr;
	eval_expression(inter, scope, assignExpression);
	
	
}
static void eval_negative_expression(MANInterpreter *inter, MANScopeChain *scope,MANUnaryExpression *expr){
	eval_expression(inter, scope, expr.expr);
	MANValue *value = [inter.stack pop];
	MANValue *resultValue = [MANValue new];
	switch (value.type.typeKind) {
		case MAN_TYPE_INT:
			resultValue.type = anc_create_type_specifier(MAN_TYPE_INT);
			resultValue.integerValue = -value.integerValue;
			break;
		case MAN_TYPE_BOOL:
		case MAN_TYPE_U_INT:
			resultValue.type = anc_create_type_specifier(MAN_TYPE_U_INT);
			resultValue.integerValue = - value.uintValue;
			break;
		case MAN_TYPE_DOUBLE:
			resultValue.type = anc_create_type_specifier(MAN_TYPE_DOUBLE);
			resultValue.doubleValue = - value.doubleValue;
			break;
			
		default:
			NSCAssert(0, @"line:%zd operator ‘-’ can not use type: %@",expr.expr.lineNumber, value.type.typeName);
			break;
	}
}


static void eval_index_expression(MANInterpreter *inter, MANScopeChain *scope,MANIndexExpression *expr){
	eval_expression(inter, scope, expr.indexExpression);
	MANValue *indexValue = [inter.stack peekStack:0];
	ANATypeSpecifierKind kind = indexValue.type.typeKind;
	
	eval_expression(inter, scope, expr.arrayExpression);
	MANValue *arrValue = [inter.stack peekStack:0];
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_OBJECT);
	switch (kind) {
		case MAN_TYPE_BOOL:
		case MAN_TYPE_U_INT:
			resultValue.objectValue = arrValue.objectValue[indexValue.uintValue];
			break;
		case MAN_TYPE_INT:
			resultValue.objectValue = arrValue.objectValue[indexValue.integerValue];
			break;
		default:
			NSCAssert(0, @"line:%zd, index operator can not use type: %@",expr.indexExpression.lineNumber, indexValue.type.typeName);
			break;
	}
	[inter.stack pop];
	[inter.stack pop];
	[inter.stack push:resultValue];
}

static void eval_at_expression(MANInterpreter *inter, MANScopeChain *scope,MANUnaryExpression *expr){
	eval_expression(inter, scope, expr.expr);
	MANValue *value = [inter.stack pop];
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_OBJECT);
	switch (value.type.typeKind) {
		case MAN_TYPE_BOOL:
		case MAN_TYPE_U_INT:
			resultValue.objectValue = @(value.uintValue);
			break;
		case MAN_TYPE_INT:
			resultValue.objectValue = @(value.integerValue);
			break;
		case MAN_TYPE_DOUBLE:
			resultValue.objectValue = @(value.doubleValue);
			break;
		case MAN_TYPE_C_STRING:
			resultValue.objectValue = @(value.cstringValue);
			break;
			
		default:
			NSCAssert(0, @"line:%zd operator ‘@’ can not use type: %@",expr.expr.lineNumber, value.type.typeName);
			break;
	}
	[inter.stack push:resultValue];
}


static void eval_struct_expression(MANInterpreter *inter, MANScopeChain *scope, MANStructpression *expr){
	NSMutableDictionary *structDic = [NSMutableDictionary dictionary];
	NSUInteger count = expr.keys.count;
	for (NSUInteger i = 0; i < count; i++) {
		NSString *key = expr.keys[i];
		MANExpression *itemExpr = expr.valueExpressions[i];
		eval_expression(inter, scope, itemExpr);
		MANValue *value = [inter.stack peekStack:0];
		if (value.isObject) {
			NSCAssert(0, @"line:%zd, struct can not support object type %@", itemExpr.lineNumber, value.type.typeName );
		}
		switch (value.type.typeKind) {
			case MAN_TYPE_BOOL:
			case MAN_TYPE_U_INT:
				structDic[key] = @(value.uintValue);
				break;
			case MAN_TYPE_INT:
				structDic[key] = @(value.integerValue);
				break;
			case MAN_TYPE_DOUBLE:
				structDic[key] = @(value.doubleValue);
				break;
			case MAN_TYPE_C_STRING:
				structDic[key] = [NSValue valueWithPointer:value.cstringValue];
				break;
			case MAN_TYPE_SEL:
				structDic[key] = [NSValue valueWithPointer:value.selValue];
				break;
			case MAN_TYPE_STRUCT:
				structDic[key] = value;
				break;
			case MAN_TYPE_STRUCT_LITERAL:
				structDic[key] = value.objectValue;
				break;
			case MAN_TYPE_POINTER:
				structDic[key] = [NSValue valueWithPointer:value.pointerValue];
				break;
				
			default:
				NSCAssert(0, @"");
				break;
		}
		
		[inter.stack pop];
		
	}
	
	MANValue *result = [[MANValue alloc] init];
	result.type = anc_create_type_specifier(MAN_TYPE_STRUCT_LITERAL);
	result.objectValue = [structDic copy];
	[inter.stack push:result];
}




static void eval_dic_expression(MANInterpreter *inter, MANScopeChain *scope, MANDictionaryExpression *expr){
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	for (MANDicEntry *entry in expr.entriesExpr) {
		eval_expression(inter, scope, entry.keyExpr);
		MANValue *keyValue = [inter.stack peekStack:0];
		if (!keyValue.isObject) {
			NSCAssert(0, @"line:%zd key can not bee type:%@",entry.keyExpr.lineNumber, keyValue.type.typeName);
		}
		
		
		
		eval_expression(inter, scope, entry.valueExpr);
		MANValue *valueValue = [inter.stack peekStack:0];
		if (!valueValue.isObject) {
			NSCAssert(0, @"line:%zd value can not bee type:%@",entry.keyExpr.lineNumber, valueValue.type.typeName);
		}

		dic[keyValue.c2objectValue] = valueValue.c2objectValue;
		
		[inter.stack pop];
		[inter.stack pop];
	}
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_OBJECT);
	resultValue.objectValue = dic.copy;
	[inter.stack push:resultValue];
	
}


static void eval_array_expression(MANInterpreter *inter, MANScopeChain *scope, MANArrayExpression *expr){
	NSMutableArray *array = [NSMutableArray array];
	for (MANExpression *elementExpr in expr.itemExpressions) {
		eval_expression(inter, scope, elementExpr);
		MANValue *elementValue = [inter.stack peekStack:0];
		if (elementValue.isObject) {
			[array addObject:elementValue.c2objectValue];
		}else{
			NSCAssert(0, @"line:%zd array element type  can not bee type:%@",elementExpr.lineNumber, elementValue.type.typeName);
		}
		
		[inter.stack pop];
	}
	MANValue *resultValue = [MANValue new];
	resultValue.type = anc_create_type_specifier(MAN_TYPE_OBJECT);
	resultValue.objectValue = array.copy;
	[inter.stack push:resultValue];
}






static MANValue *get_struct_field_value(void *structData,MANStructDeclare *declare,NSString *key){
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
	MANValue *retValue = [[MANValue alloc] init];
	NSUInteger i = 0;
	for (size_t j = 0; j < declare.keys.count; j++) {
#define mango_GET_STRUCT_FIELD_VALUE_CASE(_code,_type,_kind,_sel)\
case _code:{\
if (j == index) {\
_type value = *(_type *)(structData + postion);\
retValue.type = anc_create_type_specifier(_kind);\
retValue._sel = value;\
return retValue;\
}\
postion += sizeof(_type);\
break;\
}
		switch (encoding[i]) {
				mango_GET_STRUCT_FIELD_VALUE_CASE('c',char,MAN_TYPE_INT,integerValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('i',int,MAN_TYPE_INT,integerValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('s',short,MAN_TYPE_INT,integerValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('l',long,MAN_TYPE_INT,integerValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('q',long long,MAN_TYPE_INT,integerValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('C',unsigned char,MAN_TYPE_U_INT,uintValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('I',unsigned int,MAN_TYPE_U_INT,uintValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('S',unsigned short,MAN_TYPE_U_INT,uintValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('L',unsigned long,MAN_TYPE_U_INT,uintValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('Q',unsigned long long,MAN_TYPE_U_INT,uintValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('f',float,MAN_TYPE_DOUBLE,doubleValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('d',double,MAN_TYPE_DOUBLE,doubleValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('B',BOOL,MAN_TYPE_U_INT,uintValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('^',void *,MAN_TYPE_POINTER,pointerValue);
				mango_GET_STRUCT_FIELD_VALUE_CASE('*',char *,MAN_TYPE_C_STRING,cstringValue);
			
		
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
				size_t size = mango_struct_size_with_encoding(subTypeEncoding.UTF8String);
				if(j == index){
					void *value = structData + postion;
					MANValue *retValue = [[MANValue alloc] init];
					NSString *subStruct = mango_struct_name_with_encoding(subTypeEncoding.UTF8String);
					retValue.type = anc_create_struct_type_specifier(subStruct);
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

static void eval_self_super_expression(MANInterpreter *inter, MANScopeChain *scope){
	MANValue *value = [scope getValueWithIdentifier:@"self"];
	NSCAssert(value, @"not found var %@", @"self");
	[inter.stack push:value];
}

static void eval_member_expression(MANInterpreter *inter, MANScopeChain *scope, MANMemberExpression *expr){
	eval_expression(inter, scope, expr.expr);
	MANValue *obj = [inter.stack peekStack:0];
	if (obj.type.typeKind == MAN_TYPE_STRUCT) {
		ANANASStructDeclareTable *table = [ANANASStructDeclareTable shareInstance];
		MANValue *value =  get_struct_field_value(obj.pointerValue, [table getStructDeclareWithName:obj.type.structName], expr.memberName);
		[inter.stack pop];
		[inter.stack push:value];
		return;
		
	}
	
	if (obj.type.typeKind != MAN_TYPE_OBJECT && obj.type.typeKind != MAN_TYPE_CLASS) {
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
	
	MANValue *retValue;
	if (*returnTypeEncoding != 'v') {
		void *returnData = malloc([sig methodReturnLength]);
		[invocation getReturnValue:returnData];
		retValue = [[MANValue alloc] initWithCValuePointer:returnData typeEncoding:returnTypeEncoding];
		free(returnData);
	}else{
		retValue = [MANValue voidValueInstance];
	}
		
	[inter.stack pop];
	[inter.stack push:retValue];
		
}




static MANValue *invoke(NSUInteger line, MANInterpreter *inter, MANScopeChain *scope, id instance, SEL sel, NSArray<MANExpression *> *argExprs){
	
	NSMethodSignature *sig = [instance methodSignatureForSelector:sel];
	if (!instance) {
		//todo
		const char *returnType = [sig methodReturnType];
		for (MANExpression *argExpr in argExprs) {
			eval_expression(inter, scope, argExpr);
			[inter.stack pop];
		}
		return [MANValue defaultValueWithTypeEncoding:returnType];
	}
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
	invocation.target = instance;
	invocation.selector = sel;
	NSUInteger argCount = [sig numberOfArguments];
	for (NSUInteger i = 2; i < argCount; i++) {
		const char *typeEncoding = [sig getArgumentTypeAtIndex:i];
		void *ptr = malloc(mango_size_with_encoding(typeEncoding));
		eval_expression(inter, scope, argExprs[i - 2]);
		MANValue *argValue = [inter.stack pop];
		[argValue assign2CValuePointer:ptr typeEncoding:typeEncoding];
		[invocation setArgument:ptr atIndex:i];
		free(ptr);
	}
	[invocation invoke];
	
	char *returnType = (char *)[sig methodReturnType];
	returnType = removeTypeEncodingPrefix(returnType);
	MANValue *retValue;
	if (*returnType != 'v') {
		void *retValuePointer = malloc([sig methodReturnLength]);
		[invocation getReturnValue:retValuePointer];
		retValue = [[MANValue alloc] initWithCValuePointer:retValuePointer typeEncoding:returnType];
		free(retValuePointer);
	}else{
		retValue = [MANValue voidValueInstance];
	}
	
	return retValue;
}



static void eval_function_call_expression(MANInterpreter *inter, MANScopeChain *scope, MANFunctonCallExpression *expr){
	MANExpressionKind exprKind = expr.expr.expressionKind;
	switch (exprKind) {
		case MAN_MEMBER_EXPRESSION:{
			MANMemberExpression *memberExpr = (MANMemberExpression *)expr.expr;
			MANExpression *memberObjExpr = memberExpr.expr;
			SEL sel = NSSelectorFromString(memberExpr.memberName);
			switch (memberObjExpr.expressionKind) {
				case MAN_SELF_EXPRESSION:{
					id _self = [[scope getValueWithIdentifier:@"self"] objectValue];
					MANValue *retValue = invoke(expr.lineNumber, inter, scope,_self, sel, expr.args);
					[inter.stack push:retValue];
					break;
				}
				case MAN_SUPER_EXPRESSION:{
					id _self = [[scope getValueWithIdentifier:@"self"] objectValue];
					Class superClass = class_getSuperclass([_self class]);
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
						MANExpression *argExpr = expr.args[i - 2];
						eval_expression(inter, scope, argExpr);
						MANValue *argValue = [inter.stack pop];
						char *argTypeEncoding = (char *)[sig getArgumentTypeAtIndex:i];
						argTypeEncoding = removeTypeEncodingPrefix(argTypeEncoding);
						
						
#define mango_SET_FFI_TYPE_AND_ARG_CASE(_code, _type, _ffi_type_value, _sel)\
case _code:{\
argTypes[i] = &_ffi_type_value;\
_type value = (_type)argValue._sel;\
args[i] = &value;\
break;\
}
						
						switch (*argTypeEncoding) {
							mango_SET_FFI_TYPE_AND_ARG_CASE('c', char, ffi_type_schar, c2integerValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('i', int, ffi_type_sint, c2integerValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('s', short, ffi_type_sshort, c2integerValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('l', long, ffi_type_slong, c2integerValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('q', long long, ffi_type_sint64, c2integerValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('C', unsigned char, ffi_type_uchar, c2uintValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('I', unsigned int, ffi_type_uint, c2uintValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('S', unsigned short, ffi_type_ushort, c2uintValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('L', unsigned long, ffi_type_ulong, c2uintValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('Q', unsigned long long, ffi_type_uint64, c2uintValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('B', BOOL, ffi_type_sint8, c2uintValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('f', float, ffi_type_float, c2doubleValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('d', double, ffi_type_double, c2doubleValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('@', id, ffi_type_pointer, c2objectValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('#', Class, ffi_type_pointer, c2objectValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE(':', SEL, ffi_type_pointer, selValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('*', char *, ffi_type_pointer, c2pointerValue)
							mango_SET_FFI_TYPE_AND_ARG_CASE('^', id, ffi_type_pointer, c2pointerValue)

							case '{':{
								argTypes[i] = mango_ffi_type_with_type_encoding(argTypeEncoding);
								args[i] = argValue.pointerValue;
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
#define mango_FFI_RETURN_TYPE_CASE(_code, _ffi_type)\
case _code:{\
rtype = &_ffi_type;\
rvalue = alloca(rtype->size);\
break;\
}
					
					switch (*returnTypeEncoding) {
						mango_FFI_RETURN_TYPE_CASE('c', ffi_type_schar)
						mango_FFI_RETURN_TYPE_CASE('i', ffi_type_sint)
						mango_FFI_RETURN_TYPE_CASE('s', ffi_type_sshort)
						mango_FFI_RETURN_TYPE_CASE('l', ffi_type_slong)
						mango_FFI_RETURN_TYPE_CASE('q', ffi_type_sint64)
						mango_FFI_RETURN_TYPE_CASE('C', ffi_type_uchar)
						mango_FFI_RETURN_TYPE_CASE('I', ffi_type_uint)
						mango_FFI_RETURN_TYPE_CASE('S', ffi_type_ushort)
						mango_FFI_RETURN_TYPE_CASE('L', ffi_type_ulong)
						mango_FFI_RETURN_TYPE_CASE('Q', ffi_type_uint64)
						mango_FFI_RETURN_TYPE_CASE('B', ffi_type_sint8)
						mango_FFI_RETURN_TYPE_CASE('f', ffi_type_float)
						mango_FFI_RETURN_TYPE_CASE('d', ffi_type_double)
						mango_FFI_RETURN_TYPE_CASE('@', ffi_type_pointer)
						mango_FFI_RETURN_TYPE_CASE('#', ffi_type_pointer)
						mango_FFI_RETURN_TYPE_CASE(':', ffi_type_pointer)
						mango_FFI_RETURN_TYPE_CASE('^', ffi_type_pointer)
						mango_FFI_RETURN_TYPE_CASE('*', ffi_type_pointer)
						mango_FFI_RETURN_TYPE_CASE('v', ffi_type_void)
						case '{':{
							rtype =mango_ffi_type_with_type_encoding(returnTypeEncoding);
							rvalue = alloca(rtype->size);
						}
							
						default:
							NSCAssert(0, @"not support type  %s", returnTypeEncoding);
							break;
					}
					
		
					ffi_cif cif;
					ffi_prep_cif(&cif, FFI_DEFAULT_ABI, (unsigned int)argCount, rtype, argTypes);
					ffi_call(&cif, objc_msgSendSuper, rvalue, args);
					MANValue *retValue;
					if (*returnTypeEncoding != 'v') {
						 retValue = [[MANValue alloc] initWithCValuePointer:rvalue typeEncoding:returnTypeEncoding];
					}else{
						retValue = [MANValue voidValueInstance];
					}
					[inter.stack push:retValue];
					break;
				}
				default:{
					eval_expression(inter, scope, memberObjExpr);
					MANValue *memberObj = [inter.stack pop];
					MANValue *retValue = invoke(expr.lineNumber, inter, scope, [memberObj c2objectValue], sel, expr.args);
					[inter.stack push:retValue];
					break;
					
					
					
				}
			}
			
			
			break;
		}
		case MAN_IDENTIFIER_EXPRESSION:
		case MAN_FUNCTION_CALL_EXPRESSION:{
			eval_expression(inter, scope, expr.expr);
			MANValue *blockValue = [inter.stack pop];
			
			
			const char *blockTypeEncoding = [MANBlock typeEncodingForBlock:blockValue.c2objectValue];
			NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:blockTypeEncoding];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
			[invocation setTarget:blockValue.objectValue];
			
			NSUInteger numberOfArguments = [sig numberOfArguments];
			if (numberOfArguments - 1 != expr.args.count) {
				NSCAssert(0, @"");
			}
			for (NSUInteger i = 1; i < numberOfArguments; i++) {
				const char *typeEncoding = [sig getArgumentTypeAtIndex:i];
				void *ptr = malloc(mango_size_with_encoding(typeEncoding));
				eval_expression(inter, scope, expr.args[i -1]);
				MANValue *argValue = [inter.stack pop];
				[argValue assign2CValuePointer:ptr typeEncoding:typeEncoding];
				[invocation setArgument:ptr atIndex:i];
			}
			[invocation invoke];
			const char *retType = [sig methodReturnType];
			retType = removeTypeEncodingPrefix((char *)retType);
			MANValue *retValue;
			if (*retType != 'v') {
				void *retValuePtr = malloc(mango_size_with_encoding(retType));
				[invocation getReturnValue:retValuePtr];
				retValue = [[MANValue alloc] initWithCValuePointer:retValuePtr typeEncoding:retType];
				free(retValuePtr);
			}else{
				retValue = [MANValue voidValueInstance];
			}
			
			[inter.stack push:retValue];
			break;
		}
			
		default:
			break;
	}
	
	
	
	
}







static void eval_expression(MANInterpreter *inter, MANScopeChain *scope, __kindof MANExpression *expr){
	switch (expr.expressionKind) {
		case MAN_BOOLEAN_EXPRESSION:
			eval_bool_exprseeion(inter, expr);
			break;
		case MAN_INT_EXPRESSION:
			eval_interger_expression(inter, expr);
			break;
		case MAN_DOUBLE_EXPRESSION:
			eval_double_expression(inter, expr);
			break;
		case MAN_STRING_EXPRESSION:
			eval_string_expression(inter, expr);
			break;
		case MAN_SELECTOR_EXPRESSION:
			eval_sel_expression(inter, expr);
			break;
		case MAN_BLOCK_EXPRESSION:
			eval_block_expression(inter, scope, expr);
			break;
		case MAN_NIL_EXPRESSION:
			eval_nil_expr(inter);
			break;
		case MAN_SELF_EXPRESSION:
		case MAN_SUPER_EXPRESSION:
			eval_self_super_expression(inter, scope);
			break;
		case MAN_IDENTIFIER_EXPRESSION:
			eval_identifer_expression(inter, scope, expr);
			break;
		case MAN_ASSIGN_EXPRESSION:
			eval_assign_expression(inter, scope, expr);
			break;
		case MAN_ADD_EXPRESSION:
			eval_add_expression(inter, scope, expr);
			break;
		case MAN_SUB_EXPRESSION:
			eval_sub_expression(inter, scope, expr);
			break;
		case MAN_MUL_EXPRESSION:
			eval_mul_expression(inter, scope, expr);
			break;
		case MAN_DIV_EXPRESSION:
			eval_div_expression(inter, scope, expr);
			break;
		case MAN_MOD_EXPRESSION:
			eval_mod_expression(inter, scope, expr);
			break;
		case MAN_EQ_EXPRESSION:
			eval_eq_expression(inter, scope, expr);
			break;
		case MAN_NE_EXPRESSION:
			eval_ne_expression(inter, scope, expr);
			break;
		case MAN_LT_EXPRESSION:
			eval_lt_expression(inter, scope, expr);
			break;
		case MAN_LE_EXPRESSION:
			eval_le_expression(inter, scope, expr);
			break;
		case MAN_GE_EXPRESSION:
			eval_ge_expression(inter, scope, expr);
			break;
		case MAN_GT_EXPRESSION:
			eval_gt_expression(inter, scope, expr);
			break;
		case MAN_LOGICAL_AND_EXPRESSION:
			eval_logic_and_expression(inter, scope, expr);
			break;
		case MAN_LOGICAL_OR_EXPRESSION:
			eval_logic_or_expression(inter, scope, expr);
			break;
		case MAN_LOGICAL_NOT_EXPRESSION:
			eval_logic_not_expression(inter, scope, expr);
			break;
		case MAN_TERNARY_EXPRESSION:
			eval_ternary_expression(inter, scope, expr);
			break;
		case MAN_INDEX_EXPRESSION:
			eval_index_expression(inter, scope, expr);
			break;
		case MAN_AT_EXPRESSION:
			eval_at_expression(inter, scope, expr);
			break;
		case NSC_NEGATIVE_EXPRESSION:
			eval_negative_expression(inter, scope, expr);
			break;
		case MAN_MEMBER_EXPRESSION:
			eval_member_expression(inter, scope, expr);
			break;
		case MAN_DIC_LITERAL_EXPRESSION:
			eval_dic_expression(inter, scope, expr);
			break;
		case MAN_ARRAY_LITERAL_EXPRESSION:
			eval_array_expression(inter, scope, expr);
			break;
		case MAN_INCREMENT_EXPRESSION:
			eval_increment_expression(inter, scope, expr);
			break;
		case MAN_DECREMENT_EXPRESSION:
			eval_decrement_expression(inter, scope, expr);
			break;
		case MAN_STRUCT_LITERAL_EXPRESSION:
			eval_struct_expression(inter, scope, expr);
			break;
		case MAN_FUNCTION_CALL_EXPRESSION:
			eval_function_call_expression(inter, scope, expr);
			break;
		default:
			break;
	}
	
}

MANValue *ane_eval_expression(MANInterpreter *inter, MANScopeChain *scope,MANExpression *expr){
	eval_expression(inter, scope, expr);
	return [inter.stack pop];
}

