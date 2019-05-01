//
//  MFVarDeclareChain.m
//  MangoFix
//
//  Created by yongpengliang on 2019/5/1.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFVarDeclareChain.h"

@implementation MFVarDeclareChain{
    NSMutableArray *_indentiferArr;
}

- (instancetype)init{
    if (self = [super init]) {
        _indentiferArr = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)varDeclareChainWithNext:(MFVarDeclareChain *)next{
    MFVarDeclareChain *chain = [[MFVarDeclareChain alloc] init];
    chain.next = next;
    return chain;
}

- (BOOL)isInThisNote:(NSString *)indentifer{
    return [_indentiferArr indexOfObject:indentifer] != NSNotFound;
}

- (BOOL)isInChain:(NSString *)indentifer{
    MFVarDeclareChain *chain = self;
    while (chain) {
        if ([chain isInThisNote:indentifer]) {
            return YES;
        }
        chain = chain.next;
    }
    return NO;
}

- (void)addIndentifer:(NSString *)indentifer{
    if (!indentifer.length) {
        return;
    }
    [_indentiferArr addObject:indentifer];
}

@end
