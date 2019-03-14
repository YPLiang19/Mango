//
//  NSCTypeSpecifier.m
//  mangoExample
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MANTypeSpecifier.h"
#import "MANInterpreter.h"
#import "MANStructDeclareTable.h"
#import "util.h"


@implementation MANTypeSpecifier{
	const char * _typeEncoding;
	size_t _structSize;
}

- (size_t)structSize{
	if (self.typeKind == MAN_TYPE_STRUCT) {
		if (!_structSize) {
			_structSize =  mango_size_with_encoding([self typeEncoding]);
		}
		return _structSize;;
	}
	return 0;
}

- (const char *)typeEncoding{
	if (_typeEncoding) {
		return _typeEncoding;
	}
	if (self.typeKind == MAN_TYPE_STRUCT || self.typeKind == MAN_TYPE_STRUCT_LITERAL) {
		MANStructDeclareTable *table = [MANStructDeclareTable shareInstance];
		_typeEncoding = [table getStructDeclareWithName:self.structName].typeEncoding;
		return _typeEncoding;
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
	_typeEncoding = [_dic[@(self.typeKind)] UTF8String];
	return _typeEncoding;
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


- (void)setStructName:(NSString *)structName{
	if ([structName isEqualToString:@"NSRange"]) {
		structName = @"_NSRange";
	}
	_structName = structName;
}





@end
