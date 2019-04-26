//
//  MFWeakPropertyBox.m
//  MangoFix
//
//  Created by yongpengliang on 2019/4/26.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFWeakPropertyBox.h"

@implementation MFWeakPropertyBox

- (instancetype)initWithTarget:(id)target{
    if (self) {
        _target = target;
    }
    return self;
}

@end
