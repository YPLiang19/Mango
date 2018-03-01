//
//  ANEStack.h
//  ananasExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>



@class MANValue;

@interface MANStack : NSObject

- (void)push:(MANValue *)value;
- (MANValue *)pop;
- (MANValue *)peekStack:(NSUInteger)index;
- (void)shrinkStack:(NSUInteger)shrinkSize;
- (NSUInteger)size;
@end

