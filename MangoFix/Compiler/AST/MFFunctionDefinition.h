//
//  MFFunctionDefinition.h
//  MangoFix
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFTypeSpecifier.h"
#import "MFExpression.h"
#import "MFStatement.h"
@class MFBlockBody;
@class MFMethodDefinition;

@interface MFParameter:NSObject

@property (strong, nonatomic) MFTypeSpecifier *type;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger lineNumber;

@end

typedef NS_ENUM(NSUInteger,MFFunctionDefinitionKind) {
	MFFunctionDefinitionKindMethod,
	MFFunctionDefinitionKindBlock,
	MFFunctionDefinitionKindFunction
};

@interface MFFunctionDefinition: NSObject
@property (assign, nonatomic) NSUInteger lineNumber;
@property (strong, nonatomic) MFTypeSpecifier *returnTypeSpecifier;
@property (assign, nonatomic) MFFunctionDefinitionKind kind;
@property (copy, nonatomic) NSString *name;//or selecor
@property (strong, nonatomic) NSArray<MFParameter *> *params;
@property (strong, nonatomic) MFBlockBody *block;

@end
