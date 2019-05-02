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

@property (assign, nonatomic) unsigned long long uintValue;
@property (assign, nonatomic) long long integerValue;
@property (assign, nonatomic) double doubleValue;
@property (nonatomic,nullable) id objectValue;
@property (strong, nonatomic, nullable) Class classValue;
@property (assign, nonatomic, nullable) SEL selValue;
@property (assign, nonatomic, nullable) const char * cstringValue;
@property (assign, nonatomic, nullable) void *pointerValue;

@property (assign,nonatomic)MFDeclarationModifier modifier;

- (BOOL)isSubtantial;
- (BOOL)isObject;
- (BOOL)isMember;
- (BOOL)isBaseValue;

- (unsigned long long)c2uintValue;
- (long long)c2integerValue;
- (double)c2doubleValue;
- (nullable id)c2objectValue;
- (void *)c2pointerValue;


+ (instancetype)defaultValueWithTypeEncoding:(const char *)typeEncoding;
+ (instancetype)voidValueInstance;
+ (instancetype)valueInstanceWithBOOL:(BOOL)boolValue;
+ (instancetype)valueInstanceWithUint:(unsigned long long int)uintValue;
+ (instancetype)valueInstanceWithInt:(long long int)intValue;
+ (instancetype)valueInstanceWithDouble:(double)doubleValue;
+ (instancetype)valueInstanceWithObject:(nullable id)objValue;
+ (instancetype)valueInstanceWithBlock:(nullable id)blockValue;
+ (instancetype)valueInstanceWithClass:(nullable Class)clazzValue;
+ (instancetype)valueInstanceWithSEL:(SEL)selValue;
+ (instancetype)valueInstanceWithCstring:(nullable const char *)cstringValue;
+ (instancetype)valueInstanceWithPointer:(nullable void *)pointerValue;
+ (instancetype)valueInstanceWithStruct:(void *)structValue typeEncoding:(const char *)typeEncoding;

- (instancetype)nsStringValue;
@end
NS_ASSUME_NONNULL_END
