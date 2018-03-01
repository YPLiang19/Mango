//
//  ANEScopeChain.m
//  ananasExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MANScopeChain.h"
#import "MANValue.h"
#import <objc/runtime.h>


@implementation MANScopeChain
- (NSMutableDictionary<NSString *,MANValue *> *)vars{
	if (_vars == nil) {
		_vars = [NSMutableDictionary dictionary];
	}
	return _vars;
}

+ (instancetype)scopeChainWithNext:(MANScopeChain *)next{
	MANScopeChain *scope = [MANScopeChain new];
	scope.next = next;
	return scope;
}

- (MANValue *)getValueWithIdentifier:(NSString *)identifier{
	for (MANScopeChain *pos = self; pos; pos = pos.next) {
		if (pos.instance) {
			Ivar ivar = class_getInstanceVariable([pos.instance class], identifier.UTF8String);
			if (ivar) {
				const char *ivarEncoding = ivar_getTypeEncoding(ivar);
				void *ptr = (__bridge void *)(pos.instance) +  ivar_getOffset(ivar);
				MANValue *value = [[MANValue alloc] initWithCValuePointer:ptr typeEncoding:ivarEncoding];
				return value;
			}
		}else{
			__block MANValue *value;
			[pos.vars enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, MANValue * _Nonnull obj, BOOL * _Nonnull stop) {
				if ([key isEqualToString:identifier]) {
					value = obj;
					*stop = YES;
				}
			}];
			if (value) {
				return value;
			}
			
		}
	}
	return nil;
}

@end

