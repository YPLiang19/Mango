//
//  MANFunctionDefinition.h
//  ananasExample
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MANTypeSpecifier.h"
#import "MANExpression.h"
#import "MANStatement.h"
@class MANBlockBody;
@class MANMethodDefinition;

@interface MANParameter:NSObject
@property (strong, nonatomic) MANTypeSpecifier *type;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger lineNumber;
@end

typedef NS_ENUM(NSUInteger,MANFunctionDefinitionKind) {
	MANFunctionDefinitionKindMethod,
	MANFunctionDefinitionKindBlock,
	MANFunctionDefinitionKindFunction
};

@interface MANFunctionDefinition: NSObject
@property (assign, nonatomic) NSUInteger lineNumber;
@property (strong, nonatomic) MANTypeSpecifier *returnTypeSpecifier;
@property (assign, nonatomic) MANFunctionDefinitionKind kind;
@property (copy, nonatomic) NSString *name;//or selecor
@property (strong, nonatomic) NSArray<MANParameter *> *params;
@property (strong, nonatomic) MANBlockBody *block;


@end
