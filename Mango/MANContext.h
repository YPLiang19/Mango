//
//  MANContext.h
//  ananasExample
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MANValue.h"
@interface MMANontext : NSObject
- (void)evalAnanasScriptWithURL:(NSURL *)url;
- (void)evalAnanasScriptWithSourceString:(NSString *)sourceString;
/*!
 @method
 @abstract Get a particular property on the global object.
 @result The MANValue  for the global object's property.
 */
- (MANValue *)objectForKeyedSubscript:(id)key;

/*!
 @method
 @abstract Set a particular property on the global object.
 */
- (void)setObject:(id)object forKeyedSubscript:(NSObject <NSCopying> *)key;
@end
