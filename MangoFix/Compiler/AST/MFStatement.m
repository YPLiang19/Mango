//
//  MFStatement.m
//  MangoFix
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MFStatement.h"

@implementation MFStatement

@end

@implementation MFExpressionStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindExpression;
    }
    return self;
}

@end


@implementation MFDeclarationStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindDeclaration;
    }
    return self;
}

@end


@implementation MFElseIf

@end

@implementation MFIfStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindIf;
    }
    return self;
}

@end


@implementation MFCase

@end

@implementation MFSwitchStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindSwitch;
    }
    return self;
}

@end

@implementation MFForStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindFor;
    }
    return self;
}

@end

@implementation MFForEachStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindForEach;
    }
    return self;
}

@end

@implementation MFWhileStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindWhile;
    }
    return self;
}

@end


@implementation MFDoWhileStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindDoWhile;
    }
    return self;
}

@end

@implementation MFContinueStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindContinue;
    }
    return self;
}

@end


@implementation MFBreakStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindBreak;
    }
    return self;
}

@end


@implementation MFReturnStatement

- (instancetype)init{
    if (self = [super init]) {
        self.kind = MFStatementKindReturn;;
    }
    return self;
}

@end















