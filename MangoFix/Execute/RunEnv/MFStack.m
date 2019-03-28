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
	[_arr addObject:value];
}

- (MFValue *)pop{
	MFValue *value = [_arr  lastObject];
	[_arr removeLastObject];
	return value;
}

- (MFValue *)peekStack:(NSUInteger)index{
	MFValue *value = _arr[_arr.count - 1 - index];
	return value;
}

- (void)shrinkStack:(NSUInteger)shrinkSize{
	[_arr removeObjectsInRange:NSMakeRange(_arr.count - shrinkSize, shrinkSize)];
}
- (NSUInteger)size{
	return _arr.count;
}
@end

