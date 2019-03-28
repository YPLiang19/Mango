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
 Evaluate Mango code from a  url.
 @param url The url of the  Mango code.
 */
- (void)evalMangoScriptWithURL:(NSURL *)url;


/**
 Evaluate a string of JavaScript code.

 @param sourceString Mango
 */
- (void)evalMangoScriptWithSourceString:(NSString *)sourceString;

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
@end
