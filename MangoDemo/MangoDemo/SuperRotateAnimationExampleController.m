//
//  SuperRotateAnimationExampleController.m
//  MangoDemo
//
//  Created by jerry.yong on 2018/3/9.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "SuperRotateAnimationExampleController.h"

@interface SuperRotateAnimationExampleController ()

@end

@implementation SuperRotateAnimationExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
	NSLog(@"SuperRotateAnimationExampleController::%@", NSStringFromSelector(_cmd));
}

@end
