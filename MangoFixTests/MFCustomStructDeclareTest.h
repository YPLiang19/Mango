//
//  MFCustomStructDeclareTest.h
//  MangoFixTests
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef struct {
    CGFloat x;
    CGFloat y;
}MFCustomStruct;

@interface MFCustomStructDeclareTest : NSObject

- (MFCustomStruct)testCustomStructDeclareWithCGRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
