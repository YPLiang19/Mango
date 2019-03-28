//
//  errrorc.c
//  MangoFix
//
//  Created by jerry.yong on 2017/11/30.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#include <Foundation/Foundation.h>
#import "create.h"

void mf_compile_err(NSUInteger lineNumber,MFCompileError error,...){
	NSLog(@"编译错误。。。。");
	exit(1);
}

