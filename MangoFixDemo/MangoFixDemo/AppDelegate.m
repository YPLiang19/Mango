//
//  AppDelegate.m
//  mangoExample
//
//  Created by jerry.yong on 2017/10/31.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "AppDelegate.h"
#import <MangoFix/MangoFix.h>

static NSString * const aes128Key = @"123456";
static NSString * const aes128Iv = @"abcdef";


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)encryptPlainScirptToDocument {
    NSError *outErr = nil;
    BOOL writeResult = NO;
    
    NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *plainScriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&outErr];
    if (outErr) goto err;
    
    {
        NSData *scriptData = [plainScriptString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encryptedScriptData = [scriptData AES128ParmEncryptWithKey:aes128Key iv:aes128Iv];
        
        NSString * encryptedPath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"demo_encrypted.mg"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:encryptedPath]) {
            [fileManager createFileAtPath:encryptedPath contents:nil attributes:nil];
        }
        writeResult = [encryptedScriptData writeToFile:encryptedPath options:NSDataWritingAtomic error:&outErr];
    }
err:
    if (outErr) NSLog(@"%@",outErr);
    return writeResult;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL writeResult = [self encryptPlainScirptToDocument];
    if (!writeResult) {
        return NO;
    }
    
    MFContext *context = [[MFContext alloc] initWithAES128Key:aes128Key iv:aes128Iv];
    
    NSString * encryptedPath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"demo_encrypted.mg"];
    NSURL *scriptUrl = [NSURL fileURLWithPath:encryptedPath];
    [context evalMangoScriptWithURL:scriptUrl];
	return YES;
}

@end
