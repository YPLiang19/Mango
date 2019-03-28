//
//  MFGCDTest.m
//  MangoFixTests
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFGCDTest.h"

@implementation MFGCDTest

- (void)testGCDWithCompletionBlock:(void (^)(id _Nonnull))completion{
    dispatch_queue_t queue = dispatch_queue_create("com.plliang19.mango", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        completion(@"success");
    });
}

@end
