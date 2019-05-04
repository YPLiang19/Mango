//
//  MFStatement.h
//  MangoFix
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFExpression.h"
#import "MFDeclaration.h"
@class MFBlockBody;

typedef NS_ENUM(NSInteger, MFStatementKind) {
	MFStatementKindExpression = 1,
	MFStatementKindDeclaration,
	MFStatementKindIf,
	MFStatementKindSwitch,
	MFStatementKindFor,
	MFStatementKindForEach,
	MFStatementKindWhile,
	MFStatementKindDoWhile,
	MFStatementKindBreak,
	MFStatementKindContinue,
	MFStatementKindReturn
};

@interface MFStatement : NSObject

@property (assign, nonatomic) MFStatementKind kind;

@end



@interface MFExpressionStatement: MFStatement

@property (strong, nonatomic) MFExpression *expr;

@end




@interface MFDeclarationStatement: MFStatement

@property (strong, nonatomic) MFDeclaration *declaration;

@end


@interface MFElseIf: MFStatement

@property (strong, nonatomic) MFExpression *condition;
@property (strong, nonatomic) MFBlockBody *thenBlock;

@end

@interface MFIfStatement: MFStatement

@property (strong, nonatomic) MFExpression *condition;
@property (strong, nonatomic) MFBlockBody *thenBlock;
@property (strong, nonatomic) MFBlockBody *elseBlocl;
@property (strong, nonatomic) NSArray<MFElseIf *> *elseIfList;

@end


@interface MFCase: MFStatement

@property (strong, nonatomic) MFExpression *expr;
@property (strong, nonatomic) MFBlockBody *block;

@end

@interface MFSwitchStatement: MFStatement

@property (strong, nonatomic) MFExpression *expr;
@property (strong, nonatomic) NSArray<MFCase *> *caseList;
@property (strong, nonatomic) MFBlockBody *defaultBlock;

@end

@interface MFForStatement: MFStatement

@property (strong, nonatomic) MFExpression *initializerExpr;
@property (strong, nonatomic) MFDeclaration *declaration;
@property (strong, nonatomic) MFExpression *condition;
@property (strong, nonatomic) MFExpression *post;
@property (strong, nonatomic) MFBlockBody *block;

@end

@interface MFForEachStatement: MFStatement

@property (strong, nonatomic) MFDeclaration *declaration;
@property (strong, nonatomic) MFIdentifierExpression *identifierExpr;
@property (strong, nonatomic) MFExpression *collectionExpr;
@property (strong, nonatomic) MFBlockBody *block;

@end

@interface MFWhileStatement: MFStatement

@property (strong, nonatomic) MFExpression *condition;
@property (strong, nonatomic) MFBlockBody *block;

@end


@interface MFDoWhileStatement: MFStatement

@property (strong, nonatomic) MFBlockBody *block;
@property (strong, nonatomic) MFExpression *condition;

@end

@interface MFContinueStatement: MFStatement

@end


@interface MFBreakStatement: MFStatement

@end


@interface MFReturnStatement: MFStatement

@property (strong, nonatomic) MFExpression *retValExpr;

@end














