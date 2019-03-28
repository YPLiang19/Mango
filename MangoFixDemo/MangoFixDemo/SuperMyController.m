//
//  SuperRotateAnimationExampleController.m
//  MangoDemo
//
//  Created by jerry.yong on 2018/3/9.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "SuperMyController.h"

@interface SuperMyController ()

@end

@implementation SuperMyController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
	NSLog(@"SuperMyController::%@", NSStringFromSelector(_cmd));
}

@end
