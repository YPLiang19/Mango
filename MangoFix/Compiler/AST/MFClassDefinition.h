//
//  MFClassDefinition.h
//  MangoFix
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFFunctionDefinition.h"
#import "MFAnnotationableDefinition.h"

@class MFClassDefinition;

typedef NS_ENUM(NSInteger, AnnotationIfExprResult) {
	AnnotationIfExprResultNoComputed,
	AnnotationIfExprResultTrue,
	AnnotationIfExprResultFalse
};



typedef NS_ENUM(NSUInteger, MFPropertyModifier) {
	MFPropertyModifierMemStrong = 0x00,
	MFPropertyModifierMemWeak = 0x01,
	MFPropertyModifierMemCopy = 0x2,
	MFPropertyModifierMemAssign = 0x03,
	MFPropertyModifierMemMask = 0x0F,
	
	MFPropertyModifierAtomic = 0x00,
	MFPropertyModifierNonatomic =  0x10,
	MFPropertyModifierAtomicMask = 0xF0,
};


@interface MFMemberDefinition: MFAnnotationableDefinition

@property (weak, nonatomic) MFClassDefinition *classDefinition;

@end


@interface MFPropertyDefinition: MFMemberDefinition

@property (assign, nonatomic) NSUInteger lineNumber;
@property (assign, nonatomic) MFPropertyModifier modifier;
@property (strong, nonatomic) MFTypeSpecifier *typeSpecifier;
@property (copy, nonatomic) NSString *name;

@end


@interface MFMethodNameItem: NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) MFParameter *param;

@end


@interface MFMethodDefinition: MFMemberDefinition

@property (assign, nonatomic) BOOL classMethod;
@property (strong, nonatomic) MFFunctionDefinition *functionDefinition;

@end


@interface MFClassDefinition : MFAnnotationableDefinition

@property (assign, nonatomic) NSUInteger lineNumber;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<MFAnnotation *> *superAnnotationList;
@property (copy, nonatomic) NSString *superName;
@property (strong, nonatomic) NSArray<NSString *> *protocolNames;
@property (strong, nonatomic) NSArray<MFPropertyDefinition *> *properties;
@property (strong, nonatomic) NSArray<MFMethodDefinition *> *classMethods;
@property (strong, nonatomic) NSArray<MFMethodDefinition *> *instanceMethods;
@property (assign, nonatomic) AnnotationIfExprResult annotationIfExprResult;
@property (strong, nonatomic) Class clazz;


- (nullable MFAnnotation *)superSwiftModuleAnnotation;

@end
















