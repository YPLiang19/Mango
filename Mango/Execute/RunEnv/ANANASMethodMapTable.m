//
//  ANANASMethodMapTable.m
//  ananasExample
//
//  Created by jerry.yong on 2018/2/23.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "ANANASMethodMapTable.h"

@implementation MANMethodMapTableItem
- (instancetype)initWithClass:(Class)clazz inter:(MANInterpreter *)inter method:(MANMethodDefinition *)method; {
	if (self = [super init]) {
		_clazz = clazz;
		_inter = inter;
		_method = method;
	}
	return self;
}
@end

@implementation ANANASMethodMapTable{
	NSMutableDictionary<NSString *, MANMethodMapTableItem *> *_dic;
}

+ (instancetype)shareInstance{
	static id _instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[ANANASMethodMapTable alloc] init];
	});
	return _instance;
}

- (instancetype)init{
	if (self = [super init]) {
		_dic = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)addMethodMapTableItem:(MANMethodMapTableItem *)methodMapTableItem{
	NSString *index = [NSString stringWithFormat:@"%d_%@_%@,",methodMapTableItem.method.classMethod,NSStringFromClass(methodMapTableItem.clazz),methodMapTableItem.method.functionDefinition.name];
	_dic[index] = methodMapTableItem;
}

- (MANMethodMapTableItem *)getMethodMapTableItemWith:(Class)clazz classMethod:(BOOL)classMethod sel:(SEL)sel{
	NSString *index = [NSString stringWithFormat:@"%d_%@_%@,",classMethod,NSStringFromClass(clazz),NSStringFromSelector(sel)];
	return _dic[index];
}

@end
