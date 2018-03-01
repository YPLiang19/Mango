//
//  MANExpression.m
//  ananasExample
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MANExpression.h"
#import "MANBlock.h"

@implementation MANExpression

- (instancetype)initWithExpressionKind:(MANExpressionKind)expressionKind{
	if (self = [self init]) {
		_expressionKind = expressionKind;
	}
	return self;
}

@end

@implementation MANIdentifierExpression
@end

@implementation MANAssignExpression
@end

@implementation MANBinaryExpression
@end

@implementation MANTernaryExpression


@end

@implementation MANUnaryExpression

@end

@implementation MANMemberExpression
@end

@implementation MANFunctonCallExpression
@end

@implementation MANIndexExpression
@end

@implementation MANStructpression

@end

@implementation MANDicEntry

@end

@implementation MANDictionaryExpression

@end


@implementation MANArrayExpression

@end

@implementation MANBlockExpression

@end













