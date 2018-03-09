//
//  ANEScopeChain.m
//  mangoExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MANScopeChain.h"
#import "MANValue.h"
#import <objc/runtime.h>
@interface MANScopeChain()
@property (strong, nonatomic) NSMutableDictionary<NSString *,MANValue *> *vars;
@end

@implementation MANScopeChain

+ (instancetype)scopeChainWithNext:(MANScopeChain *)next{
	MANScopeChain *scope = [MANScopeChain new];
	scope.next = next;
	return scope;
}

- (instancetype)init{
	if (self = [super init]) {
		_vars = [NSMutableDictionary dictionary];
		_queue = dispatch_queue_create("com.mango.scopeChain", DISPATCH_QUEUE_CONCURRENT);
	}
	return self;
}


- (void)setValue:(MANValue *)value withIndentifier:(NSString *)identier{
	dispatch_barrier_async(_queue, ^{
		_vars[identier] = value;
	});
}

- (MANValue *)getValueWithIdentifier:(NSString *)identifer{
	__block MANValue *value;
	dispatch_sync(_queue, ^{
		value = _vars[identifer];
	});
	return value;
}


- (void)assignWithIdentifer:(NSString *)identifier value:(MANValue *)value{
	for (MANScopeChain *pos = self; pos; pos = pos.next) {
		if (pos.instance) {
			Ivar ivar	= class_getInstanceVariable([pos instance],identifier.UTF8String);
			if (ivar) {
				const char *ivarEncoding = ivar_getTypeEncoding(ivar);
				void *ptr = (__bridge void *)(pos.instance) +  ivar_getOffset(ivar);
				[value assign2CValuePointer:ptr typeEncoding:ivarEncoding];
				return;
			}
			
		}else{
			MANValue *srcValue = [pos getValueWithIdentifier:identifier];
			if (srcValue) {
				dispatch_barrier_async(pos.queue, ^{
					[srcValue assignFrom:value];
				});
				return;
			}
		}
		
	}
}

- (MANValue *)getValueWithIdentifierInChain:(NSString *)identifier{
	for (MANScopeChain *pos = self; pos; pos = pos.next) {
		if (pos.instance) {
			Ivar ivar = class_getInstanceVariable([pos.instance class], identifier.UTF8String);
			if (ivar) {
				const char *ivarEncoding = ivar_getTypeEncoding(ivar);
				void *ptr = (__bridge void *)(pos.instance) +  ivar_getOffset(ivar);
				MANValue *value = [[MANValue alloc] initWithCValuePointer:ptr typeEncoding:ivarEncoding bridgeTransfer:NO];
				return value;
			}
		}else{
			 MANValue *value = [pos getValueWithIdentifier:identifier];
			if (value) {
				return value;
			}
			
		}
	}
	return nil;
}

@end

