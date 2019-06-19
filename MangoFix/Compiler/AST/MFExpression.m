//
//  MFExpression.m
//  MangoFix
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MFExpression.h"
#import "MFBlock.h"

@implementation MFExpression

- (instancetype)initWithExpressionKind:(MFExpressionKind)expressionKind{
	if (self = [super init]) {
		_expressionKind = expressionKind;
	}
	return self;
}

@end


@implementation MFIdentifierExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_IDENTIFIER_EXPRESSION];
}

@end


@implementation MFAssignExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_ASSIGN_EXPRESSION];
}

@end


@implementation MFBinaryExpression

@end


@implementation MFTernaryExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_TERNARY_EXPRESSION];
}

@end


@implementation MFUnaryExpression

@end


@implementation MFMemberExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_MEMBER_EXPRESSION];
}

@end


@implementation MFFunctonCallExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_FUNCTION_CALL_EXPRESSION];
}

@end


@implementation MFSubScriptExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_SUB_SCRIPT_EXPRESSION];
}

@end


@implementation MFStructEntry

@end


@implementation MFStructpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_STRUCT_LITERAL_EXPRESSION];
}

@end

@implementation MFDicEntry

@end


@implementation MFDictionaryExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_DIC_LITERAL_EXPRESSION];
}

@end


@implementation MFArrayExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_ARRAY_LITERAL_EXPRESSION];
}

@end


@implementation MFBlockExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_BLOCK_EXPRESSION];
}

@end

@implementation MFCFuntionExpression

- (instancetype)init{
    return [super initWithExpressionKind:MF_C_FUNCTION_EXPRESSION];
}

@end













