//
//  ANEStack.h
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MFValue;

@interface MFStack : NSObject

- (void)push:(MFValue *)value;
- (MFValue *)pop;
- (MFValue *)peekStack:(NSUInteger)index;
- (void)shrinkStack:(NSUInteger)shrinkSize;
- (NSUInteger)size;

@end

NS_ASSUME_NONNULL_END
