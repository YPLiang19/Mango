//
//  MANValue .h
//  ananasExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MANTypeSpecifier;


NS_ASSUME_NONNULL_BEGIN

@interface MANValue : NSObject

@property (strong, nonatomic) MANTypeSpecifier *type;
@property (assign, nonatomic) unsigned long long uintValue;
@property (assign, nonatomic) long long integerValue;
@property (assign, nonatomic) double doubleValue;
@property (strong, nonatomic, nullable) id objectValue;
@property (strong, nonatomic, nullable) Class classValue;
@property (assign, nonatomic) SEL selValue;
@property (assign, nonatomic) const char * cstringValue;
@property (assign, nonatomic) void *pointerValue;

- (BOOL)isSubtantial;
- (BOOL)isObject;
- (BOOL)isMember;
- (BOOL)isBaseValue;

- (void)assignFrom:(MANValue *)src;

- (unsigned long long)c2uintValue;
- (long long)c2integerValue;
- (double)c2doubleValue;
- (nullable id)c2objectValue;
- (void *)c2pointerValue;

- (void)assign2CValuePointer:(void *)cvaluePointer typeEncoding:(const char *)typeEncoding;
- (instancetype)initWithCValuePointer:(void *)cValuePointer typeEncoding:(const char *)typeEncoding;

+ (instancetype)defaultValueWithTypeEncoding:(const char *)typeEncoding;
+ (instancetype)voidValueInstance;
+ (instancetype)valueInstanceWithBOOL:(BOOL)boolValue;
+ (instancetype)valueInstanceWithUint:(unsigned long long int)uintValue;
+ (instancetype)valueInstanceWithInt:(long long int)intValue;
+ (instancetype)valueInstanceWithDouble:(double)doubleValue;
+ (instancetype)valueInstanceWithObject:(id)objValue;
+ (instancetype)valueInstanceWithBlock:(id)blockValue;
+ (instancetype)valueInstanceWithClass:(Class)clazzValue;
+ (instancetype)valueInstanceWithSEL:(SEL)selValue;
+ (instancetype)valueInstanceWithCstring:(const char *)cstringValue;
+ (instancetype)valueInstanceWithPointer:(void *)pointerValue;
+ (instancetype)valueInstanceWithStruct:(void *)structValue typeEncoding:(const char *)typeEncoding;

- (instancetype)nsStringValue;
@end
NS_ASSUME_NONNULL_END
