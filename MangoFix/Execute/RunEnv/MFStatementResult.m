//
//  ANEStatementResult.m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MFStatementResult.h"


@implementation MFStatementResult

+ (instancetype)normalResult{
	MFStatementResult *res = [MFStatementResult new];
	res.type = MFStatementResultTypeNormal;
	return res;
}

+ (instancetype)returnResult{
	MFStatementResult *res = [MFStatementResult new];
	res.type = MFStatementResultTypeReturn;
	return res;
}

+ (instancetype)breakResult{
	MFStatementResult *res = [MFStatementResult new];
	res.type = MFStatementResultTypeBreak;
	return res;
}

+ (instancetype)continueResult{
	MFStatementResult *res = [MFStatementResult new];
	res.type = MFStatementResultTypeContinue;
	return res;
}

@end

