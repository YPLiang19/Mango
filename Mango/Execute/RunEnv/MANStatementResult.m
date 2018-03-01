//
//  ANEStatementResult.m
//  ananasExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MANStatementResult.h"


@implementation MANStatementResult

+ (instancetype)normalResult{
	MANStatementResult *res = [MANStatementResult new];
	res.type = MANStatementResultTypeNormal;
	return res;
}

+ (instancetype)returnResult{
	MANStatementResult *res = [MANStatementResult new];
	res.type = MANStatementResultTypeReturn;
	return res;
}

+ (instancetype)breakResult{
	MANStatementResult *res = [MANStatementResult new];
	res.type = MANStatementResultTypeBreak;
	return res;
}

+ (instancetype)continueResult{
	MANStatementResult *res = [MANStatementResult new];
	res.type = MANStatementResultTypeContinue;
	return res;
}

@end

