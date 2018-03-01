//
//  MANStatement.h
//  ananasExample
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MANExpression.h"
#import "MANDeclaration.h"
@class MANBlockBody;

typedef NS_ENUM(NSInteger, MANStatementKind) {
	MANStatementKindExpression = 1,
	MANStatementKindDeclaration,
	MANStatementKindIf,
	MANStatementKindSwitch,
	MANStatementKindFor,
	MANStatementKindForEach,
	MANStatementKindWhile,
	MANStatementKindDoWhile,
	MANStatementKindBreak,
	MANStatementKindContinue,
	MANStatementKindReturn
};

@interface MANStatement : NSObject
@property (assign, nonatomic) MANStatementKind kind;
@end



@interface MANExpressionStatement: MANStatement

@property (strong, nonatomic) MANExpression *expr;

@end




@interface MANDeclarationStatement: MANStatement
@property (strong, nonatomic) MANDeclaration *declaration;
@end


@interface MANElseIf: MANStatement

@property (strong, nonatomic) MANExpression *condition;
@property (strong, nonatomic) MANBlockBody *thenBlock;

@end

@interface MANIfStatement: MANStatement

@property (strong, nonatomic) MANExpression *condition;
@property (strong, nonatomic) MANBlockBody *thenBlock;
@property (strong, nonatomic) MANBlockBody *elseBlocl;
@property (strong, nonatomic) NSArray<MANElseIf *> *elseIfList;

@end


@interface MANCase: MANStatement
@property (strong, nonatomic) MANExpression *expr;
@property (strong, nonatomic) MANBlockBody *block;
@end

@interface MANSwitchStatement: MANStatement
@property (strong, nonatomic) MANExpression *expr;
@property (strong, nonatomic) NSArray<MANCase *> *caseList;
@property (strong, nonatomic) MANBlockBody *defaultBlock;
@end

@interface MANForStatement: MANStatement
@property (strong, nonatomic) MANExpression *initializerExpr;
@property (strong, nonatomic) MANDeclaration *declaration;
@property (strong, nonatomic) MANExpression *condition;
@property (strong, nonatomic) MANExpression *post;
@property (strong, nonatomic) MANBlockBody *block;
@end

@interface MANForEachStatement: MANStatement
@property (strong, nonatomic) MANDeclaration *declaration;
@property (strong, nonatomic) MANIdentifierExpression *identifierExpr;
@property (strong, nonatomic) MANExpression *arrayExpr;
@property (strong, nonatomic) MANBlockBody *block;
@end

@interface MANWhileStatement: MANStatement
@property (strong, nonatomic) MANExpression *condition;
@property (strong, nonatomic) MANBlockBody *block;
@end


@interface MANDoWhileStatement: MANStatement
@property (strong, nonatomic) MANBlockBody *block;
@property (strong, nonatomic) MANExpression *condition;
@end

@interface MANContinueStatement: MANStatement
@end


@interface MANBreakStatement: MANStatement
@end


@interface MANReturnStatement: MANStatement
@property (strong, nonatomic) MANExpression *retValExpr;
@end














