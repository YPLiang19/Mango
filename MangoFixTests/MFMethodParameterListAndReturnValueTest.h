//
//  MFMethodParameterListAndReturnValueTest.h
//  MangoFixTests
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFMethodParameterListAndReturnValueTest : NSObject

- (NSDictionary *(^)(void))testMethodParameterListAndReturnValueWithString:(NSString *)str block:(NSString *(^)(NSString *))block;

@end

NS_ASSUME_NONNULL_END
