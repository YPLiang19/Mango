//
//  SomClass.m
//  MangoFixDemo
//
//  Created by Pengliang Yong on 2022/3/10.
//  Copyright © 2022 yongpengliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "SomClass.h"

@implementation SomClass1

-(instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
  
    NSLog(@"fraeX: %f, config:%@", frame.origin.x, configuration);
    return self;
}



@end

@implementation SomClass2

-(instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
  
    // go here crash
    abort();
    return self;
}

@end
