//
//  MFStaticVarTable.h
//  MangoFix
//
//  Created by yongpengliang on 2019/6/7.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFStaticVarTable : NSObject

+ (instancetype)shareInstance;

- (nullable MFValue *)getStaticVarValueWithKey:(NSString *)key;
- (void)setStaticVarValue:(MFValue *)value withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
