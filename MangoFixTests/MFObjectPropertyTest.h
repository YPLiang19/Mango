//
//  MFObjectPropertyTest.h
//  MangoFixTests
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFObjectPropertyTest : NSObject

@property(nonatomic,copy)NSString *strTypeProperty;

- (NSString *)testObjectPropertyTest;
- (id)testWeakObjectProperty;
- (id)testIvar;

@end

NS_ASSUME_NONNULL_END
