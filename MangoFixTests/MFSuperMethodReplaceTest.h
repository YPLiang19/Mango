//
//  MFSuperMethodReplaceTest.h
//  MangoFixTests
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFAnimal : NSObject

- (NSString *)say;

@end

@interface MFPerson : MFAnimal

- (NSString *)say;

@end


@interface MFSuperMethodReplaceTest : NSObject

- (NSString *)testSuperMethodReplaceTest;

@end

NS_ASSUME_NONNULL_END
