//
//  MFStructDeclareTable.m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/24.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MFStructDeclareTable.h"

@implementation MFStructDeclareTable{
	NSMutableDictionary<NSString *, MFStructDeclare *> *_dic;
    NSLock *_lock;
}

- (instancetype)init{
	if (self = [super init]) {
		_dic = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
	}
	return self;
}
+ (instancetype)shareInstance{
	static id st_instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		st_instance = [[MFStructDeclareTable alloc] init];
	});
	return st_instance;
}

- (void)addStructDeclare:(MFStructDeclare *)structDeclare{
    [_lock lock];
	_dic[structDeclare.name] = structDeclare;
    [_lock unlock];
}

- (MFStructDeclare *)getStructDeclareWithName:(NSString *)name{
    [_lock lock];
	MFStructDeclare *declare = _dic[name];
    [_lock unlock];
    return declare;
}
@end
