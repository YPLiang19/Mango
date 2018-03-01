//
//  MANClassDefinition.h
//  ananasExample
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MANFunctionDefinition.h"

@class MANClassDefinition;

typedef NS_ENUM(NSInteger, AnnotationIfExprResult) {
	AnnotationIfExprResultNoComputed,
	AnnotationIfExprResultTrue,
	AnnotationIfExprResultFalse
};


typedef NS_ENUM(NSUInteger, MANPropertyModifier) {
	MANPropertyModifierMemStrong = 0x00,
	MANPropertyModifierMemWeak = 0x01,
	MANPropertyModifierMemCopy = 0x2,
	MANPropertyModifierMemAssign = 0x03,
	MANPropertyModifierMemMask = 0x0F,
	
	MANPropertyModifierAtomic = 0x00,
	MANPropertyModifierNonatomic =  0x10,
	MANPropertyModifierAtomicMask = 0xF0,
};




@interface MANMemberDefinition: NSObject
@property (strong, nonatomic) MANExpression *annotationIfConditionExpr;
@property (weak, nonatomic) MANClassDefinition *classDefinition;
@end

@interface MANPropertyDefinition: MANMemberDefinition
@property (assign, nonatomic) NSUInteger lineNumber;
@property (assign, nonatomic) MANPropertyModifier modifier;
@property (strong, nonatomic) MANTypeSpecifier *typeSpecifier;
@property (copy, nonatomic) NSString *name;

@end


@interface MANMethodNameItem: NSObject
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) MANParameter *param;

@end


@interface MANMethodDefinition: MANMemberDefinition
@property (assign, nonatomic) BOOL classMethod;
@property (strong, nonatomic) MANFunctionDefinition *functionDefinition;
@end


@interface MANClassDefinition : NSObject
@property (assign, nonatomic) NSUInteger lineNumber;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *superNmae;
@property (strong, nonatomic) NSArray<NSString *> *protocolNames;
@property (strong, nonatomic) NSArray<MANPropertyDefinition *> *properties;
@property (strong, nonatomic) NSArray<MANMethodDefinition *> *classMethods;
@property (strong, nonatomic) NSArray<MANMethodDefinition *> *instanceMethods;
@property (strong, nonatomic) MANExpression *annotationIfConditionExpr;
@property (assign, nonatomic) AnnotationIfExprResult annotationIfExprResult;

@end
















