//
//  SomClass.h
//  MangoFixDemo
//
//  Created by Pengliang Yong on 2022/3/10.
//  Copyright © 2022 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SomClass1 : NSObject

-(instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;

@end


@interface SomClass2 : SomClass1

@end


NS_ASSUME_NONNULL_END
