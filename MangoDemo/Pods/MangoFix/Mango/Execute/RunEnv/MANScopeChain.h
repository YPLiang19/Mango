//
//  ANEScopeChain.h
//  mangoExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MANValue;

NS_ASSUME_NONNULL_BEGIN
@interface MANScopeChain: NSObject
@property (strong, nonatomic) id instance;
@property (strong, nonatomic) MANScopeChain *next;
@property (strong, nonatomic) dispatch_queue_t queue;

+ (instancetype)scopeChainWithNext:(MANScopeChain *)next;
- (MANValue *)getValueWithIdentifierInChain:(NSString *)identifier;
- (MANValue *)getValueWithIdentifier:(NSString *)identifer;
- (void)setValue:(MANValue *)value withIndentifier:(NSString *)identier;
- (void)assignWithIdentifer:(NSString *)identifier value:(MANValue *)value;
- (void)setMangoBlockVarNil;
@end
NS_ASSUME_NONNULL_END




