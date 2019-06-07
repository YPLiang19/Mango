//
//  ANEStack.m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MFStack.h"

@implementation MFStack{
	NSMutableArray<MFValue *> *_arr;
}

- (instancetype)init{
	if (self = [super init]) {
		_arr = [NSMutableArray array];
	}
	return self;
}

- (void)push:(MFValue *)value{
    NSAssert(value, @"value can not be nil");
	[_arr addObject:value];
}

- (MFValue *)pop{
	MFValue *value = [_arr  lastObject];
    NSAssert(value, @"stack is empty");
	[_arr removeLastObject];
	return value;
}

- (MFValue *)peekStack:(NSUInteger)index{
    NSAssert(_arr.count - 1 >= index, @"index out of bounds");
	MFValue *value = _arr[_arr.count - 1 - index];
	return value;
}

- (void)shrinkStack:(NSUInteger)shrinkSize{
    NSAssert(shrinkSize <= _arr.count, @"shrinkSize out of stack size");
	[_arr removeObjectsInRange:NSMakeRange(_arr.count - shrinkSize, shrinkSize)];
}

- (NSUInteger)size{
	return _arr.count;
}
@end

