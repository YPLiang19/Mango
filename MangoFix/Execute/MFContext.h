//
//  MFContext.h
//  MangoFix
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MFValue.h"
@interface MFContext : NSObject


/**
 Initializes a MagnoFix context with specify a RSA private key, the private key must be 1024 bits and PKCS #8.
 
 @param privateKey  RSA private key
 @return MFContext instance
 */
- (instancetype)initWithRSAPrivateKey:(NSString *)privateKey NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/**
 Evaluate MangoFix code that encrypted by RSA and base64 encode string from a url.
 
 @param url The url of the MangoFix code that encrypted by RSA and base64 encode string.
 */
- (void)evalMangoScriptWithURL:(NSURL *)url;

/**
 Evaluate a data of MangoFix code that encrypted by RSA.

 @param rsaEncryptedBase64String of MangoFix code that encrypted by RSA.
 */
- (void)evalMangoScriptWithRSAEncryptedBase64String:(NSString *)rsaEncryptedBase64String;

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



#ifdef DEBUG
- (void)evalMangoScriptWithDebugURL:(NSURL *)url;
#endif

@end
