//
//  MANStructDeclareTable.m
//  ananasExample
//
//  Created by jerry.yong on 2018/2/24.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MANStructDeclareTable.h"

@implementation MANStructDeclareTable{
	NSMutableDictionary<NSString *, MANStructDeclare *> *_dic;
}

- (instancetype)init{
	if (self = [super init]) {
		_dic = [NSMutableDictionary dictionary];
	}
	return self;
}
+ (instancetype)shareInstance{
	static id _instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[MANStructDeclareTable alloc] init];
	});
	return _instance;
}

- (void)addStructDeclare:(MANStructDeclare *)structDeclare{
	_dic[structDeclare.name] = structDeclare;
}

- (MANStructDeclare *)getStructDeclareWithName:(NSString *)name{
	return _dic[name];
}
@end
