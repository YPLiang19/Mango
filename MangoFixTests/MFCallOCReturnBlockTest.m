//
//  MFCallOCReturnBlock.m
//  MangoFixTests
//
//  Created by yongpengliang on 2019/4/21.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFCallOCReturnBlockTest.h"

@implementation MFCallOCReturnBlockTest

- (instancetype)init{
    if (self = [super init]) {
        _propertyBlock = ^(id arg1,id arg2){
            return [NSString stringWithFormat:@"%@%@",arg1,arg2];
        };
    }
    return self;
}

- (id (^)(id,id))returnBlockMethod{
    id block = ^(id arg1,id arg2){
        return [NSString stringWithFormat:@"%@%@",arg1,arg2];
    };
    return block;
}

- (id)testCallOCReturnBlock{
    return nil;
}



@end
