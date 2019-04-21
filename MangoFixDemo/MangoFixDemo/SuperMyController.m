//
//  SuperRotateAnimationExampleController.m
//  MangoDemo
//
//  Created by jerry.yong on 2018/3/9.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "SuperMyController.h"
#import <Masonry/Masonry.h>

@interface SuperMyController ()

@end

@implementation SuperMyController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//- (void)testMasonry{
//    UIView *superview = self.view;
//    UIView *view1 = [[UIView alloc] init];
//    view1.translatesAutoresizingMaskIntoConstraints = NO;
//    view1.backgroundColor = [UIColor greenColor];
//    [superview addSubview:view1];
//    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
//    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(superview.mas_top).with.offset(padding.top); //with is an optional semantic filler
//        make.left.equalTo(superview.mas_left).with.offset(padding.left);
//        make.bottom.equalTo(superview.mas_bottom).with.offset(-padding.bottom);
//        make.right.equalTo(superview.mas_right).with.offset(-padding.right);
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
	NSLog(@"SuperMyController::%@", NSStringFromSelector(_cmd));
}

@end
