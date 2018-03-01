//
//  MANTranslationUtil.h
//  ananasExample
//
//  Created by jerry.yong on 2017/11/23.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MANClassDefinition.h"
#import "MANStructDeclare.h"
@class MANScopeChain;
@class MANStack;

@interface MANInterpreter : NSObject
@property (assign, nonatomic) NSUInteger currentLineNumber;
@property (strong, nonatomic) NSMutableDictionary<NSString *, MANStructDeclare *> *structDeclareDic;
@property (strong, nonatomic) NSMutableDictionary<NSString *, MANClassDefinition *> *classDefinitionDic;


@property (strong, nonatomic) NSMutableArray *topList;
@property (strong, nonatomic) MANClassDefinition *currentClassDefinition;
@property (strong, nonatomic) MANBlock *currentBlock;

@property (strong, nonatomic) MANScopeChain *topScope;
@property (strong, nonatomic) MANScopeChain *commonScope;




@property (strong, nonatomic) MANStack *stack;

- (void)compileSoruceWithURL:(NSURL *)url;
- (void)compileSoruceWithString:(NSString *)source;






@end
