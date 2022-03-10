//
//  ANEScopeChain.m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <objc/runtime.h>
#import "MFScopeChain.h"
#import "MFValue.h"
#import "MFBlock.h"
#import "MFValue+Private.h"
#import "MFPropertyMapTable.h"
#import "MFWeakPropertyBox.h"
#import "util.h"
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

extern const void *mf_propKey(NSString *propName);

- (NSString *)propNameByIvarName:(NSString *)ivarName{
    if (ivarName.length < 2) {
        return nil;
    }
    
    if (![ivarName hasPrefix:@"_"]) {
        return nil;
    }
    
    return [ivarName substringFromIndex:1];
}

- (void)assignWithIdentifer:(NSString *)identifier value:(MFValue *)value{
	for (MFScopeChain *pos = self; pos; pos = pos.next) {
		if (pos.instance) {
            NSString *propName = [self propNameByIvarName:identifier];
            MFPropertyMapTable *table = [MFPropertyMapTable shareInstance];
            Class clazz = object_getClass(pos.instance);
            MFPropertyDefinition *propDef = [table getPropertyMapTableItemWith:clazz name:propName].property;
            Ivar ivar;
            if (propDef) {
                id associationValue = value;
                const char *type = [propDef.typeSpecifier typeEncoding];
                if (*type == '@') {
                    associationValue = [value objectValue];
                }
                MFPropertyModifier modifier = propDef.modifier;
                if ((modifier & MFPropertyModifierMemMask) == MFPropertyModifierMemWeak) {
                    associationValue = [[MFWeakPropertyBox alloc] initWithTarget:value];
                }
                objc_AssociationPolicy associationPolicy = mf_AssociationPolicy_with_PropertyModifier(modifier);
                objc_setAssociatedObject(pos.instance, mf_propKey(propName), associationValue, associationPolicy);
            }else if((ivar = class_getInstanceVariable(object_getClass(pos.instance),identifier.UTF8String))){
                const char *ivarEncoding = ivar_getTypeEncoding(ivar);
                if (*ivarEncoding == '@') {
                    object_setIvar(pos.instance, ivar, [value c2objectValue]);
                }else{
                    void *ptr = (__bridge void *)(pos.instance) +  ivar_getOffset(ivar);
                    [value assignToCValuePointer:ptr typeEncoding:ivarEncoding];
                }
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

- (MFValue *)getValueWithIdentifier:(NSString *)identifier endScope:(MFScopeChain *)endScope{
    for (MFScopeChain *pos = self; pos != endScope; pos = pos.next) {
        if (pos.instance) {
            NSString *propName = [self propNameByIvarName:identifier];
            MFPropertyMapTable *table = [MFPropertyMapTable shareInstance];
            Class clazz = object_getClass(pos.instance);
            MFPropertyDefinition *propDef = [table getPropertyMapTableItemWith:clazz name:propName].property;
            Ivar ivar;
            if (propDef) {
                id propValue = objc_getAssociatedObject(pos.instance, mf_propKey(propName));
                const char *type = [propDef.typeSpecifier typeEncoding];
                MFValue *value = propValue;
                if (!propValue) {
                    value = [MFValue defaultValueWithTypeEncoding:type];
                }else if(*type == '@'){
                    if ([propValue isKindOfClass:[MFWeakPropertyBox class]]) {
                        MFWeakPropertyBox *box = propValue;
                        value = [MFValue valueInstanceWithObject:box.target];
                    }else{
                        value = [MFValue valueInstanceWithObject:propValue];
                    }
                }
                return value;
                
            }else if((ivar = class_getInstanceVariable(object_getClass(pos.instance),identifier.UTF8String))){
                MFValue *value;
                const char *ivarEncoding = ivar_getTypeEncoding(ivar);
                if (*ivarEncoding == '@') {
                    id ivarValue = object_getIvar(pos.instance, ivar);
                    value = [MFValue valueInstanceWithObject:ivarValue];
                }else{
                    void *ptr = (__bridge void *)(pos.instance) +  ivar_getOffset(ivar);
                    value = [[MFValue alloc] initWithCValuePointer:ptr typeEncoding:ivarEncoding bridgeTransfer:NO];
                }
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

- (MFValue *)getValueWithIdentifierInChain:(NSString *)identifier{
    return [self getValueWithIdentifier:identifier endScope:nil];
}

- (MFClassDefinition *) getClassDefinition {
    for (MFScopeChain *pos = self; pos; pos = pos.next) {
        if (pos.classDefinition) {
            return pos.classDefinition;
        }
    }
    return nil;
}

- (void)setMangoBlockVarNil{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self.lock lock];
//        NSArray *allValues = [self.vars allValues];
//        for (MFValue *value in allValues) {
//            if ([value isObject]) {
//                Class ocBlockClass = NSClassFromString(@"NSBlock");
//                if ([[value c2objectValue] isKindOfClass:ocBlockClass]) {
//                    struct MFSimulateBlock *blockStructPtr = (__bridge void *)value.objectValue;
//                    if (blockStructPtr->flags & BLOCK_CREATED_FROM_MFGO) {
//                        value.objectValue = nil;
//                    }
//                }
//
//            }
//        }
//        [self.lock unlock];
//    });
    
}

@end

