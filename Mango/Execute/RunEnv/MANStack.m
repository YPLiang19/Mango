//
//  ANEStack.m
//  ananasExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MANStack.h"

@implementation MANStack{
	NSMutableArray<MANValue *> *_arr;
}

- (instancetype)init{
	if (self = [super init]) {
		_arr = [NSMutableArray array];
	}
	return self;
}

- (void)push:(MANValue *)value{
	[_arr addObject:value];
}

- (MANValue *)pop{
	MANValue *value = [_arr  lastObject];
	[_arr removeLastObject];
	return value;
}

- (MANValue *)peekStack:(NSUInteger)index{
	MANValue *value = _arr[_arr.count - 1 - index];
	return value;
}

- (void)shrinkStack:(NSUInteger)shrinkSize{
	[_arr removeObjectsInRange:NSMakeRange(_arr.count - shrinkSize, shrinkSize)];
}
- (NSUInteger)size{
	return _arr.count;
}
@end

