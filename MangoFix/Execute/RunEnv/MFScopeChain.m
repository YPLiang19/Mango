//
//  ANEScopeChain.m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MFScopeChain.h"
#import "MFValue.h"
#import <objc/runtime.h>
#import "MFBlock.h"
#import "MFValue+Private.h"
@interface MFScopeChain()
@property (strong, nonatomic) NSMutableDictionary<NSString *,MFValue *> *vars;
@property (strong,nonatomic)NSLock *lock;
@end

@implementation MFScopeChain

+ (instancetype)scopeChainWithNext:(MFScopeChain *)next{
	MFScopeChain *scope = [MFScopeChain new];
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


- (void)setValue:(MFValue *)value withIndentifier:(NSString *)identier{
    [self.lock lock];
    self.vars[identier] = value;
    [self.lock unlock];
}

- (MFValue *)getValueWithIdentifier:(NSString *)identifer{
    [self.lock lock];
	MFValue *value = self.vars[identifer];
    [self.lock unlock];
	return value;
}


- (void)assignWithIdentifer:(NSString *)identifier value:(MFValue *)value{
	for (MFScopeChain *pos = self; pos; pos = pos.next) {
		if (pos.instance) {
			Ivar ivar	= class_getInstanceVariable([pos instance],identifier.UTF8String);
			if (ivar) {
				const char *ivarEncoding = ivar_getTypeEncoding(ivar);
				void *ptr = (__bridge void *)(pos.instance) +  ivar_getOffset(ivar);
				[value assign2CValuePointer:ptr typeEncoding:ivarEncoding];
				return;
			}
			
		}else{
			MFValue *srcValue = [pos getValueWithIdentifier:identifier];
			if (srcValue) {
				[srcValue assignFrom:value];
				return;
			}
		}
		
	}
}

- (MFValue *)getValueWithIdentifierInChain:(NSString *)identifier{
	for (MFScopeChain *pos = self; pos; pos = pos.next) {
		if (pos.instance) {
			Ivar ivar = class_getInstanceVariable([pos.instance class], identifier.UTF8String);
			if (ivar) {
				const char *ivarEncoding = ivar_getTypeEncoding(ivar);
				void *ptr = (__bridge void *)(pos.instance) +  ivar_getOffset(ivar);
				MFValue *value = [[MFValue alloc] initWithCValuePointer:ptr typeEncoding:ivarEncoding bridgeTransfer:NO];
				return value;
			}
		}else{
			 MFValue *value = [pos getValueWithIdentifier:identifier];
			if (value) {
				return value;
			}
			
		}
	}
	return nil;
}

- (void)setMangoBlockVarNil{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.lock lock];
        NSArray *allValues = [self.vars allValues];
        for (MFValue *value in allValues) {
            if ([value isObject]) {
                Class ocBlockClass = NSClassFromString(@"NSBlock");
                if ([[value c2objectValue] isKindOfClass:ocBlockClass]) {
                    struct MFSimulateBlock *blockStructPtr = (__bridge void *)value.objectValue;
                    if (blockStructPtr->flags & BLOCK_CREATED_FROM_MFGO) {
                        value.objectValue = nil;
                    }
                }
                
            }
        }
        [self.lock unlock];
    });
    
}

@end

