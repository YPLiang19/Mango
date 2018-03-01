//
//  ANEStatementResult.h
//  ananasExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MANValue;


typedef NS_ENUM(NSInteger, MANStatementResultType) {
	MANStatementResultTypeNormal,
	MANStatementResultTypeReturn,
	MANStatementResultTypeBreak,
	MANStatementResultTypeContinue,
};

@interface MANStatementResult : NSObject
@property (assign, nonatomic) MANStatementResultType type;
@property (strong, nonatomic) MANValue *reutrnValue;
+ (instancetype)normalResult;
+ (instancetype)returnResult;
+ (instancetype)breakResult;
+ (instancetype)continueResult;
@end
