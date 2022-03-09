//
//  NSData+AESEncryption.h
//  MangoFix
//
//  Created by Tianyu Xia on 2022/3/8.
//  Copyright © 2022 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AESEncryption)

- (nullable NSData *)AES128ParmEncryptWithKey:(NSString *)key iv:(NSString *)iv;

- (nullable NSData *)AES128ParmDecryptWithKey:(NSString *)key iv:(NSString *)iv;

@end

NS_ASSUME_NONNULL_END
