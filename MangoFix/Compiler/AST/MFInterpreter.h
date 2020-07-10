//
//  MFTranslationUtil.h
//  MangoFix
//
//  Created by jerry.yong on 2017/11/23.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFClassDefinition.h"
#import "MFStructDeclare.h"
@class MFScopeChain;
@class MFStack;

@interface MFInterpreter : NSObject

@property (assign, nonatomic) int currentLineNumber;
@property (strong, nonatomic) NSMutableDictionary<NSString *, MFStructDeclare *> *structDeclareDic;
@property (strong, nonatomic) NSMutableDictionary<NSString *, MFClassDefinition *> *classDefinitionDic;

@property (strong, nonatomic) NSMutableArray *topList;
@property (strong, nonatomic) MFClassDefinition *currentClassDefinition;
@property (strong, nonatomic) MFBlockBody *currentBlock;

@property (strong, nonatomic) MFScopeChain *topScope;
@property (strong, nonatomic) MFScopeChain *commonScope;

@property (strong, nonatomic) MFStack *stack;

- (void)compileSourceWithString:(NSString *)source;

@end
