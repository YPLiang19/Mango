//
//  MFStructDeclareTable.h
//  MangoFix
//
//  Created by jerry.yong on 2018/2/24.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFStructDeclare.h"

@interface MFStructDeclareTable : NSObject
+ (instancetype)shareInstance;

- (void)addStructDeclare:(MFStructDeclare *)structDeclare;
- (MFStructDeclare *)getStructDeclareWithName:(NSString *)name;

@end
