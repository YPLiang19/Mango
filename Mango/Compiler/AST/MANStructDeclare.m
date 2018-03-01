//
//  MANStructDeclare.m
//  ananasExample
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MANStructDeclare.h"

@implementation MANStructDeclare
- (instancetype)initWithName:(NSString *)name typeEncoding:(const char *)typeEncoding keys:(NSArray<NSString *> *)keys{
	if (self = [super init]) {
		_name = name;
		_typeEncoding = typeEncoding;
		_keys = keys;
	}
	return self;
}
@end
