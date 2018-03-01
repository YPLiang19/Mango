//
//  MANDeclaration.h
//  ananasExample
//
//  Created by jerry.yong on 2017/11/20.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MANTypeSpecifier;
@class MANExpression;

@interface MANDeclaration: NSObject
@property (assign, nonatomic) NSUInteger lineNumber;
@property (strong, nonatomic) MANTypeSpecifier *type;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) MANExpression *initializer;
//@property (assign, nonatomic,getter=isParam) BOOL param;
@end
