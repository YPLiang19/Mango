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
	if (self = [self init]) {
		_expressionKind = expressionKind;
	}
	return self;
}

@end


@implementation MFIdentifierExpression

@end


@implementation MFAssignExpression

@end


@implementation MFBinaryExpression

@end


@implementation MFTernaryExpression

@end


@implementation MFUnaryExpression

@end


@implementation MFMemberExpression

@end


@implementation MFFunctonCallExpression

@end


@implementation MFSubScriptExpression

@end


@implementation MFStructEntry

@end


@implementation MFStructpression

@end

@implementation MFDicEntry

@end


@implementation MFDictionaryExpression

@end


@implementation MFArrayExpression

@end


@implementation MFBlockExpression

@end













