//
//  TextObject.m
//  MangoDemo
//
//  Created by jerry.yong on 2018/3/2.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "TextObject.h"

@implementation TextObject

- (instancetype)init{
	if (self = [super init]) {
		
	}
	return self;
}
- (void)dealloc{
	NSLog(@"%@",@"here is TextObject dealloc");
}

@end
