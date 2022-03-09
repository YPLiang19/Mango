//
//  MFContext.h
//  MangoFix
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MFValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFContext : NSObject

/**
 Initializes a MagnoFix context with specify a AES128(ECBMode) encryption key and iv
 
 @param key  AES128Key
 @param iv  iv
 @return MFContext instance
 */
- (instancetype)initWithAES128Key:(NSString *)key iv:(NSString *)iv NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/**
 Evaluate MangoFix code that encrypted by AES128(ECBMode) from a url.
 
 @param url The url of the MangoFix code that encrypted by AES128(ECBMode)
 */
- (void)evalMangoScriptWithURL:(NSURL *)url;

/**
 Evaluate a data of MangoFix code that encrypted by AES128.

 @param scriptData of MangoFix code that encrypted by AES128.
 */
- (void)evalMangoScriptWithAES128Data:(NSData *)scriptData;

/**
  Get a particular property on the global object.
 @result The MFValue  for the global object's property.
 */
- (MFValue *)objectForKeyedSubscript:(id)key;

/**
 @method
 Set a particular property on the global object.
 */
- (void)setObject:(MFValue *)value forKeyedSubscript:(NSObject <NSCopying> *)key;

/**
 Evaluate MangoFix code that is plain text from a url.
 
 @param url The url of the MangoFix code that is plain text
 */
- (void)evalMangoScriptWithDebugURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
