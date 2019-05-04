//
//  NSCTypeSpecifier.h
//  MangoFix
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MFInterpreter;
typedef NS_ENUM(NSUInteger, ANATypeSpecifierKind) {
	MF_TYPE_VOID,
	MF_TYPE_BOOL,
	MF_TYPE_INT,
	MF_TYPE_U_INT,
	MF_TYPE_DOUBLE,
	MF_TYPE_C_STRING,
	MF_TYPE_CLASS,
	MF_TYPE_SEL,
	MF_TYPE_OBJECT,
	MF_TYPE_BLOCK,
	MF_TYPE_STRUCT,
	MF_TYPE_STRUCT_LITERAL,
	MF_TYPE_POINTER,
	MF_TYPE_UNKNOWN
};
@interface MFTypeSpecifier : NSObject
@property (copy, nonatomic) NSString *structName;
@property (assign, nonatomic, readonly) size_t structSize;
@property (copy, nonatomic) NSString *typeName;
@property (assign, nonatomic) ANATypeSpecifierKind typeKind;
@property (assign, nonatomic, readonly) const char * typeEncoding;

@end
