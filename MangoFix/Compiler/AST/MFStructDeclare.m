//
//  MFStructDeclare.m
//  MangoFix
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MFStructDeclare.h"

@implementation MFStructDeclare
- (instancetype)initWithName:(NSString *)name typeEncoding:(const char *)typeEncoding keys:(NSArray<NSString *> *)keys{
	if (self = [super init]) {
		if ([name isEqualToString:@"NSRange"]) {
			name = @"_NSRange";
		}
		_name = name;
		_typeEncoding = typeEncoding;
		_keys = keys;
	}
	return self;
}
@end
