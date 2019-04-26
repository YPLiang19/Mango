//
//  MFIvarTest.m
//  MangoFixTests
//
//  Created by yongpengliang on 2019/4/26.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFIvarTest.h"




@implementation MFIvarTest{
    NSObject *_var;
    int _i;
    CGRect _rect;
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (id)testObjectIvar{
    return nil;
}

- (NSInteger)testIntIvar{
    return 0;
}

- (CGRect)testStructIvar{
    return CGRectMake(0, 0, 0, 0);
}
@end
