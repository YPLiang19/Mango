//
//  MFSwfitClassNameAlisTable.h
//  MangoFix
//
//  Created by Pengliang Yong on 2022/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFSwfitClassNameAlisTable : NSObject

+ (instancetype)shareInstance;

- (void)addSwiftClassNmae:(NSString *)swiftClassName alias:(NSString *)aliasClassName;

- (nullable NSString *)swiftClassNameByAlias:(NSString *)aliasName;

@end

NS_ASSUME_NONNULL_END
