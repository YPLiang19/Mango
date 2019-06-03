//
//  MFCallSuperNoArgTest.h
//  MangoFixTests
//
//  Created by yongpengliang on 2019/6/3.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFCallSuperNoArgTestSupserTest : NSObject

- (BOOL)testCallSuperNoArgTestSupser;

@end

@interface MFCallSuperNoArgTest : MFCallSuperNoArgTestSupserTest

- (BOOL)testCallSuperNoArgTestSupser;

@end

NS_ASSUME_NONNULL_END
