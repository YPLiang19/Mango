//
//  MFMethodMapTable.m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/23.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MFMethodMapTable.h"

@implementation MFMethodMapTableItem
- (instancetype)initWithClass:(Class)clazz inter:(MFInterpreter *)inter method:(MFMethodDefinition *)method; {
	if (self = [super init]) {
		_clazz = clazz;
		_inter = inter;
		_method = method;
	}
	return self;
}
@end

@implementation MFMethodMapTable{
	NSMutableDictionary<NSString *, MFMethodMapTableItem *> *_dic;
    NSLock *_lock;
}

+ (instancetype)shareInstance{
	static id st_instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		st_instance = [[MFMethodMapTable alloc] init];
	});
	return st_instance;
}

- (instancetype)init{
	if (self = [super init]) {
		_dic = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
	}
	return self;
}

- (void)addMethodMapTableItem:(MFMethodMapTableItem *)methodMapTableItem{
	NSString *index = [NSString stringWithFormat:@"%d_%@_%@,",methodMapTableItem.method.classMethod,NSStringFromClass(methodMapTableItem.clazz),methodMapTableItem.method.functionDefinition.name];
    [_lock lock];
	_dic[index] = methodMapTableItem;
    [_lock unlock];
}

- (MFMethodMapTableItem *)getMethodMapTableItemWith:(Class)clazz classMethod:(BOOL)classMethod sel:(SEL)sel{
    NSString *index = [NSString stringWithFormat:@"%d_%@_%@,",classMethod,NSStringFromClass(clazz),NSStringFromSelector(sel)];
    [_lock lock];
	MFMethodMapTableItem *item = _dic[index];
    [_lock unlock];
    return item;
}

@end
