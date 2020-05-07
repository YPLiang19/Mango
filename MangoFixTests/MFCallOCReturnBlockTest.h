//
//  MFCallOCReturnBlock.h
//  MangoFixTests
//
//  Created by yongpengliang on 2019/4/21.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFCallOCReturnBlockTest : NSObject

@property(copy,nonatomic) id(^propertyBlock)(id,id);

- (id)testCallOCReturnBlock;

@end

NS_ASSUME_NONNULL_END
