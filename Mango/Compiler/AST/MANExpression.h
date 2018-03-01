//
//  MANExpression.h
//  ananasExample
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MANTypeSpecifier.h"
@class MANFunctionDefinition;
@class MANBlock;


typedef NS_ENUM(NSInteger, MANExpressionKind) {
	MAN_BOOLEAN_EXPRESSION = 1,
	MAN_INT_EXPRESSION,
	MAN_U_INT_EXPRESSION,
	MAN_FLOAT_EXPRESSION,
	MAN_DOUBLE_EXPRESSION,
	MAN_STRING_EXPRESSION,
	MAN_SELECTOR_EXPRESSION,
	MAN_BLOCK_EXPRESSION,
	MAN_IDENTIFIER_EXPRESSION,
	MAN_TERNARY_EXPRESSION,
	MAN_ASSIGN_EXPRESSION,
	MAN_ADD_EXPRESSION,
	MAN_SUB_EXPRESSION,
	MAN_MUL_EXPRESSION,
	MAN_DIV_EXPRESSION,
	MAN_MOD_EXPRESSION,
	MAN_EQ_EXPRESSION,
	MAN_NE_EXPRESSION,
	MAN_GT_EXPRESSION,
	MAN_GE_EXPRESSION,
	MAN_LT_EXPRESSION,
	MAN_LE_EXPRESSION,
	MAN_LOGICAL_AND_EXPRESSION,
	MAN_LOGICAL_OR_EXPRESSION,
	MAN_LOGICAL_NOT_EXPRESSION,
	NSC_NEGATIVE_EXPRESSION,
	MAN_FUNCTION_CALL_EXPRESSION,
	MAN_MEMBER_EXPRESSION,
	MAN_NIL_EXPRESSION,
	MAN_SELF_EXPRESSION,
	MAN_SUPER_EXPRESSION,
	MAN_ARRAY_LITERAL_EXPRESSION,
	MAN_DIC_LITERAL_EXPRESSION,
	MAN_STRUCT_LITERAL_EXPRESSION,
	MAN_INDEX_EXPRESSION,
	MAN_INCREMENT_EXPRESSION,
	MAN_DECREMENT_EXPRESSION,
	MAN_AT_EXPRESSION
};




@interface MANExpression : NSObject
@property (assign, nonatomic) NSUInteger lineNumber;
@property (assign, nonatomic) MANExpressionKind expressionKind;
@property (assign, nonatomic) BOOL boolValue;
@property (assign, nonatomic) long long int integerValue;
@property (assign, nonatomic) unsigned long long  uintValue;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) const char *cstringValue;
@property (copy, nonatomic) NSString *selectorName;
- (instancetype)initWithExpressionKind:(MANExpressionKind)expressionKind;
@end

@interface MANIdentifierExpression: MANExpression
@property (copy, nonatomic) NSString *identifier;
@end


typedef NS_ENUM(NSInteger, MANAssignKind) {
	MAN_NORMAL_ASSIGN,
	MAN_SUB_ASSIGN,
	MAN_ADD_ASSIGN,
	MAN_MUL_ASSIGN,
	MAN_DIV_ASSIGN,
	MAN_MOD_ASSIGN
};


@interface MANAssignExpression: MANExpression
@property (assign, nonatomic) MANAssignKind assignKind;
@property (strong, nonatomic) MANExpression *left;
@property (strong, nonatomic) MANExpression *right;
@end

@interface MANBinaryExpression: MANExpression

@property (strong, nonatomic) MANExpression *left;
@property (strong, nonatomic) MANExpression *right;

@end


@interface MANTernaryExpression: MANExpression
@property (strong, nonatomic) MANExpression *condition;
@property (strong, nonatomic) MANExpression *trueExpr;
@property (strong, nonatomic) MANExpression *falseExpr;

@end

@interface MANUnaryExpression: MANExpression

@property (strong, nonatomic) MANExpression *expr;

@end

@interface MANMemberExpression: MANExpression

@property (strong, nonatomic) MANExpression *expr;
@property (copy, nonatomic) NSString *memberName;
@property (assign, nonatomic) BOOL c2methodName;

@end


@interface MANFunctonCallExpression: MANExpression

@property (strong, nonatomic) MANExpression *expr;
@property (strong, nonatomic) NSArray<MANExpression *> *args;

@end


@interface MANIndexExpression: MANExpression

@property (strong, nonatomic) MANExpression *arrayExpression;
@property (strong, nonatomic) MANExpression *indexExpression;

@end




@interface MANStructpression: MANExpression
@property (strong, nonatomic) NSArray<NSString *> *keys;
@property (strong, nonatomic) NSArray<MANExpression *> *valueExpressions;

@end



@interface MANDicEntry: NSObject
@property (strong, nonatomic) MANExpression *keyExpr;
@property (strong, nonatomic) MANExpression *valueExpr;

@end

@interface MANDictionaryExpression: MANExpression

@property (strong, nonatomic) NSArray<MANDicEntry *> *entriesExpr;

@end


@interface MANArrayExpression: MANExpression

@property (strong, nonatomic) NSArray<MANExpression *> *itemExpressions;

@end


@interface MANBlockExpression: MANExpression
@property (strong, nonatomic) MANFunctionDefinition *func;

@end






















