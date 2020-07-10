//
//  AppDelegate.m
//  mangoExample
//
//  Created by jerry.yong on 2017/10/31.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "AppDelegate.h"
#import <MangoFix/MangoFix.h>



@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)encryptPlainScirptToDocument{
    NSError *outErr = nil;
    BOOL writeResult = NO;
    
    NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *plainScriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&outErr];
    if (outErr) goto err;
    
    {
        NSURL *publicKeyUrl = [[NSBundle mainBundle] URLForResource:@"public_key.txt" withExtension:nil];
        NSString *publicKey = [NSString stringWithContentsOfURL:publicKeyUrl encoding:NSUTF8StringEncoding error:&outErr];
        if (outErr) goto err;
        NSString *encryptedScriptString = [MFRSA encryptString:plainScriptString publicKey:publicKey];
        
        NSString * encryptedPath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"encrypted_demo.mg"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:encryptedPath]) {
            [fileManager createFileAtPath:encryptedPath contents:nil attributes:nil];
        }
        writeResult = [encryptedScriptString writeToFile:encryptedPath atomically:YES encoding:NSUTF8StringEncoding error:&outErr];
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
    
    NSURL *privateKeyUrl = [[NSBundle mainBundle] URLForResource:@"private_key.txt" withExtension:nil];
    NSString *privateKey = [NSString stringWithContentsOfURL:privateKeyUrl encoding:NSUTF8StringEncoding error:nil];
    
    MFContext *context = [[MFContext alloc] initWithRSAPrivateKey:privateKey];
    
    NSString * encryptedPath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"encrypted_demo.mg"];
    NSURL *scriptUrl = [NSURL fileURLWithPath:encryptedPath];
    [context evalMangoScriptWithURL:scriptUrl];
	return YES;
}

@end
