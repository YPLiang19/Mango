//
//  MyView.m
//  MangoDemo
//
//  Created by jerry.yong on 2018/3/9.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{
	NSLog(@"MyView::%@",NSStringFromSelector(_cmd));
}

@end
