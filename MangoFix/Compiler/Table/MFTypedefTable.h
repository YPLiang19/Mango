//
//  MFTypedefTable.h
//  MangoFix
//
//  Created by yongpengliang on 2019/6/14.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFTypeSpecifier.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFTypedefTable : NSObject

+ (instancetype)shareInstance;

- (void)typedefType:(MFTypeSpecifierKind)type identifer:(NSString *)identifer;
- (MFTypeSpecifierKind)typeWtihIdentifer:(NSString *)identifer;

@end

NS_ASSUME_NONNULL_END
