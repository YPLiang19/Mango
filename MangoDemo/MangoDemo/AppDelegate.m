//
//  AppDelegate.m
//  mangoExample
//
//  Created by jerry.yong on 2017/10/31.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "AppDelegate.h"
#import <MangoFix/mango.h>



@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mg"];
	NSURL *scriptUrl = [NSURL fileURLWithPath:path];
	MMANontext *context = [[MMANontext alloc] init];
	[context evalMangoScriptWithURL:scriptUrl];
	return YES;
}





@end
