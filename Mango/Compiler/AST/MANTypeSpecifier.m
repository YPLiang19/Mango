//
//  NSCTypeSpecifier.m
//  ananasExample
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MANTypeSpecifier.h"
#import "MANInterpreter.h"
#import "ANANASStructDeclareTable.h"


@implementation MANTypeSpecifier
- (const char *)typeEncoding{
	if (self.typeKind == MAN_TYPE_STRUCT || self.typeKind == MAN_TYPE_STRUCT_LITERAL) {
		ANANASStructDeclareTable *table = [ANANASStructDeclareTable shareInstance];
		return [table getStructDeclareWithName:self.structName].typeEncoding;
	}
	static NSDictionary *_dic;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_dic = @{
				  @(MAN_TYPE_VOID):@"v",
				  @(MAN_TYPE_BOOL):@"B",
				  @(MAN_TYPE_INT):@"q",
				  @(MAN_TYPE_U_INT):@"Q",
				  @(MAN_TYPE_DOUBLE):@"d",
				  @(MAN_TYPE_C_STRING):@"*",
				  @(MAN_TYPE_POINTER):@"^v",
				  @(MAN_TYPE_CLASS):@"#",
				  @(MAN_TYPE_SEL):@":",
				  @(MAN_TYPE_OBJECT):@"@",
				  @(MAN_TYPE_BLOCK):@"@?"
				 };
	});
	return [_dic[@(self.typeKind)] UTF8String];
}

- (NSString *)typeName{
	if (self.typeKind == MAN_TYPE_STRUCT || self.typeKind == MAN_TYPE_STRUCT_LITERAL) {
		return _structName;
	}
	static NSDictionary *_dic;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_dic = @{
				 @(MAN_TYPE_VOID):@"void",
				 @(MAN_TYPE_BOOL):@"BOOL",
				 @(MAN_TYPE_INT):@"int(long long int)",
				 @(MAN_TYPE_U_INT):@"uint(unsigned long long int)",
				 @(MAN_TYPE_DOUBLE):@"double",
				 @(MAN_TYPE_C_STRING):@"cstring(char *)",
				 @(MAN_TYPE_POINTER):@"pointer(char *)",
				 @(MAN_TYPE_CLASS):@"Class",
				 @(MAN_TYPE_SEL):@"SEL",
				 @(MAN_TYPE_OBJECT):@"id",
				 @(MAN_TYPE_BLOCK):@"NSBlock"
				 };
	});
	return _dic[@(self.typeKind)];
}







@end
