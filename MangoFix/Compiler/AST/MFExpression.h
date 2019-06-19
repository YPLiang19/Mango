//
//  MFExpression.h
//  MangoFix
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTypeSpecifier.h"
@class MFFunctionDefinition;
@class MFBlock;


typedef NS_ENUM(NSInteger, MFExpressionKind) {
	MF_BOOLEAN_EXPRESSION = 1,
	MF_INT_EXPRESSION,
	MF_U_INT_EXPRESSION,
	MF_DOUBLE_EXPRESSION,
	MF_STRING_EXPRESSION,
	MF_SELECTOR_EXPRESSION,
	MF_BLOCK_EXPRESSION,
	MF_IDENTIFIER_EXPRESSION,
	MF_TERNARY_EXPRESSION,
	MF_ASSIGN_EXPRESSION,
	MF_ADD_EXPRESSION,
	MF_SUB_EXPRESSION,
	MF_MUL_EXPRESSION,
	MF_DIV_EXPRESSION,
	MF_MOD_EXPRESSION,
	MF_EQ_EXPRESSION,
	MF_NE_EXPRESSION,
	MF_GT_EXPRESSION,
	MF_GE_EXPRESSION,
	MF_LT_EXPRESSION,
	MF_LE_EXPRESSION,
	MF_LOGICAL_AND_EXPRESSION,
	MF_LOGICAL_OR_EXPRESSION,
	MF_LOGICAL_NOT_EXPRESSION,
	NSC_NEGATIVE_EXPRESSION,
	MF_FUNCTION_CALL_EXPRESSION,
	MF_MEMBER_EXPRESSION,
	MF_NIL_EXPRESSION,
	MF_NULL_EXPRESSION,
	MF_SELF_EXPRESSION,
	MF_SUPER_EXPRESSION,
	MF_ARRAY_LITERAL_EXPRESSION,
	MF_DIC_LITERAL_EXPRESSION,
	MF_STRUCT_LITERAL_EXPRESSION,
	MF_SUB_SCRIPT_EXPRESSION,
	MF_INCREMENT_EXPRESSION,
	MF_DECREMENT_EXPRESSION,
	MF_AT_EXPRESSION,
    MF_C_FUNCTION_EXPRESSION,
    MF_GET_ADDRESS_EXPRESSION
};




@interface MFExpression : NSObject

@property (assign, nonatomic) NSUInteger lineNumber;
@property (assign, nonatomic) MFExpressionKind expressionKind;
@property (assign, nonatomic) BOOL boolValue;
@property (assign, nonatomic) int64_t integerValue;
@property (assign, nonatomic) uint64_t  uintValue;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) const char *cstringValue;
@property (copy, nonatomic) NSString *selectorName;
@property (strong, nonatomic) NSString *currentClassName;
@property (copy, nonatomic) NSString *debugString;

- (instancetype)initWithExpressionKind:(MFExpressionKind)expressionKind;

@end

@interface MFIdentifierExpression: MFExpression

@property (copy, nonatomic) NSString *identifier;

@end


typedef NS_ENUM(NSInteger, MFAssignKind) {
	MF_NORMAL_ASSIGN,
	MF_SUB_ASSIGN,
	MF_ADD_ASSIGN,
	MF_MUL_ASSIGN,
	MF_DIV_ASSIGN,
	MF_MOD_ASSIGN
};


@interface MFAssignExpression: MFExpression

@property (assign, nonatomic) MFAssignKind assignKind;
@property (strong, nonatomic) MFExpression *left;
@property (strong, nonatomic) MFExpression *right;

@end

@interface MFBinaryExpression: MFExpression

@property (strong, nonatomic) MFExpression *left;
@property (strong, nonatomic) MFExpression *right;

@end


@interface MFTernaryExpression: MFExpression

@property (strong, nonatomic) MFExpression *condition;
@property (strong, nonatomic) MFExpression *trueExpr;
@property (strong, nonatomic) MFExpression *falseExpr;

@end


@interface MFUnaryExpression: MFExpression

@property (strong, nonatomic) MFExpression *expr;

@end


@interface MFMemberExpression: MFExpression

@property (strong, nonatomic) MFExpression *expr;
@property (copy, nonatomic) NSString *memberName;
@property (assign, nonatomic) BOOL c2methodName;

@end


@interface MFFunctonCallExpression: MFExpression

@property (strong, nonatomic) MFExpression *expr;
@property (strong, nonatomic) NSArray<MFExpression *> *args;

@end


@interface MFSubScriptExpression: MFExpression

@property (strong, nonatomic) MFExpression *aboveExpr;
@property (strong, nonatomic) MFExpression *bottomExpr;

@end


@interface MFStructEntry:NSObject

@property (copy, nonatomic) NSString *key;
@property (strong, nonatomic) MFExpression *valueExpr;

@end

@interface MFStructpression: MFExpression

@property (strong, nonatomic) NSArray<MFStructEntry *> *entriesExpr;

@end


@interface MFDicEntry: NSObject

@property (strong, nonatomic) MFExpression *keyExpr;
@property (strong, nonatomic) MFExpression *valueExpr;

@end


@interface MFDictionaryExpression: MFExpression

@property (strong, nonatomic) NSArray<MFDicEntry *> *entriesExpr;

@end


@interface MFArrayExpression: MFExpression

@property (strong, nonatomic) NSArray<MFExpression *> *itemExpressions;

@end


@interface MFBlockExpression: MFExpression

@property (strong, nonatomic) MFFunctionDefinition *func;

@end




@interface MFCFuntionExpression : MFExpression

@property (strong, nonatomic) MFExpression *cfunNameOrPointerExpr;

@end






















