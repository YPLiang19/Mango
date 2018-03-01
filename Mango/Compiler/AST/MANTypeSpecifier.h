//
//  NSCTypeSpecifier.h
//  ananasExample
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MANInterpreter;
typedef NS_ENUM(NSUInteger, ANATypeSpecifierKind) {
	MAN_TYPE_VOID,
	MAN_TYPE_BOOL,
	MAN_TYPE_INT,
	MAN_TYPE_U_INT,
	MAN_TYPE_DOUBLE,
	MAN_TYPE_C_STRING,
	MAN_TYPE_CLASS,
	MAN_TYPE_SEL,
	MAN_TYPE_OBJECT,
	MAN_TYPE_BLOCK,
	MAN_TYPE_mango_BLOCK,
	MAN_TYPE_STRUCT,
	MAN_TYPE_STRUCT_LITERAL,
	MAN_TYPE_POINTER
};
@interface MANTypeSpecifier : NSObject
@property (copy, nonatomic) NSString *structName;
@property (copy, nonatomic) NSString *typeName;
@property (assign, nonatomic) ANATypeSpecifierKind typeKind;
- (const char *)typeEncoding;


@end
