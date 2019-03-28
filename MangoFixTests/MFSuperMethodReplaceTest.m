//
//  MFSuperMethodReplaceTest.m
//  MangoFixTests
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFSuperMethodReplaceTest.h"

@implementation MFAnimal

- (NSString *)say{
    return @"Objective-C: MFAnimal::say";
}

@end


@implementation MFPerson

- (NSString *)say{
    return [NSString stringWithFormat:@"%@-%@",@"Objective-C: MFPerson::say",[super say]];
}

@end





@implementation MFSuperMethodReplaceTest

- (NSString *)testSuperMethodReplaceTest{
    MFPerson *person = [[MFPerson alloc] init];
    NSString *content = [person say];
    return content;
}

@end
