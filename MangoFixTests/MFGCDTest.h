//
//  MFGCDTest.h
//  MangoFixTests
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFGCDTest : NSObject

- (void)testGCDWithCompletionBlock:(void(^)(id data))completion;


- (void)testGCDAfterWithCompletionBlock:(void(^)(id data))completion;

@end

NS_ASSUME_NONNULL_END
