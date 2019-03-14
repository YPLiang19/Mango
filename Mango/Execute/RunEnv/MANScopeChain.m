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
#import "MANBlock.h"
@interface MANScopeChain()
@property (strong, nonatomic) NSMutableDictionary<NSString *,MANValue *> *vars;
@property (strong,nonatomic)NSLock *lock;
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
        _lock = [[NSLock alloc] init];
	}
	return self;
}


- (void)setValue:(MANValue *)value withIndentifier:(NSString *)identier{
    [self.lock lock];
    self.vars[identier] = value;
    [self.lock unlock];
}

- (MANValue *)getValueWithIdentifier:(NSString *)identifer{
    [self.lock lock];
	MANValue *value = self.vars[identifer];
    [self.lock unlock];
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
				[srcValue assignFrom:value];
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

- (void)setMangoBlockVarNil{
//    [self.lock lock];
//    NSArray *allValues = [self.vars allValues];
//    for (MANValue *value in allValues) {
//        if ([value isObject]) {
//            Class ocBlockClass = NSClassFromString(@"NSBlock");
//            if ([[value c2objectValue] isKindOfClass:ocBlockClass]) {
//                struct MANSimulateBlock *blockStructPtr = (__bridge void *)value.objectValue;
//                if (blockStructPtr->flags & BLOCK_CREATED_FROM_MANGO) {
//                    value.objectValue = nil;
//                }
//            }
//            
//        }
//    }
//    [self.lock unlock];
}

@end

