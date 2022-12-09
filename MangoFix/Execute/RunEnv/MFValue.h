//
//  MFValue .h
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFDeclarationModifier.h"
@class MFTypeSpecifier;

NS_ASSUME_NONNULL_BEGIN

@interface MFValue : NSObject

@property (assign, nonatomic) BOOL externNativeGlobalVariable;
@property (assign, nonatomic) void *externNativeGlobalVariablePointer;

@property (assign, nonatomic) uint64_t uintValue;
@property (assign, nonatomic) int64_t integerValue;
@property (assign, nonatomic) double doubleValue;
@property (nonatomic,nullable) id objectValue;
@property (strong, nonatomic, nullable) Class classValue;
@property (assign, nonatomic, nullable) SEL selValue;
@property (assign, nonatomic, nullable) const char * cstringValue;
@property (assign, nonatomic, nullable) void *pointerValue;

@property (assign,nonatomic)MFDeclarationModifier modifier;

- (BOOL)isSubtantial;
- (BOOL)isObject;
- (BOOL)isNumber;
- (BOOL)isBaseValue;

- (uint64_t)c2uintValue;
- (int64_t)c2integerValue;
- (double)c2doubleValue;
- (nullable id)c2objectValue;
- (void *)c2pointerValue;


+ (instancetype)defaultValueWithTypeEncoding:(const char *)typeEncoding;
+ (instancetype)voidValueInstance;
+ (instancetype)valueInstanceWithBOOL:(BOOL)boolValue;
+ (instancetype)valueInstanceWithUint:(uint64_t)uintValue;
+ (instancetype)valueInstanceWithInt:(int64_t)intValue;
+ (instancetype)valueInstanceWithDouble:(double)doubleValue;
+ (instancetype)valueInstanceWithObject:(nullable id)objValue;
+ (instancetype)valueInstanceWithBlock:(nullable id)blockValue;
+ (instancetype)valueInstanceWithClass:(nullable Class)clazzValue;
+ (instancetype)valueInstanceWithSEL:(SEL)selValue;
+ (instancetype)valueInstanceWithCstring:(nullable const char *)cstringValue;
+ (instancetype)valueInstanceWithPointer:(nullable void *)pointerValue;
+ (instancetype)valueInstanceWithStruct:(void *)structValue typeEncoding:(const char *)typeEncoding copyData:(BOOL)copyData;

- (instancetype)nsStringValue;

@end
NS_ASSUME_NONNULL_END
