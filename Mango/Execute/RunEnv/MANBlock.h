//
//  MANBlock.h
//  ananasExample
//
//  Created by jerry.yong on 2017/12/26.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "man_ast.h"
#import "MANInterpreter.h"

@interface MANBlock : NSObject
@property (strong, nonatomic) MANScopeChain *scope;
@property (strong, nonatomic) MANFunctionDefinition *func;
@property (weak, nonatomic) MANInterpreter *inter;
@property (assign, nonatomic) const char *typeEncoding;
- (id)ocBlock;
+ (const char *)typeEncodingForBlock:(id)block;
@end
