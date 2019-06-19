//
//  NSCTypeSpecifier.m
//  MangoFix
//
//  Created by jerry.yong on 2017/11/13.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MFTypeSpecifier.h"
#import "MFInterpreter.h"
#import "MFStructDeclareTable.h"
#import "util.h"


@implementation MFTypeSpecifier{
	const char * _typeEncoding;
	size_t _structSize;
}

- (size_t)structSize{
	if (self.typeKind == MF_TYPE_STRUCT) {
		if (!_structSize) {
			_structSize =  mf_size_with_encoding([self typeEncoding]);
		}
		return _structSize;;
	}
	return 0;
}

- (const char *)typeEncoding{
	if (_typeEncoding) {
		return _typeEncoding;
	}
	if (self.typeKind == MF_TYPE_STRUCT || self.typeKind == MF_TYPE_STRUCT_LITERAL) {
		MFStructDeclareTable *table = [MFStructDeclareTable shareInstance];
		_typeEncoding = [table getStructDeclareWithName:self.structName].typeEncoding;
		return _typeEncoding;
	}
	static NSDictionary *_dic;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_dic = @{
				  @(MF_TYPE_VOID):@"v",
				  @(MF_TYPE_BOOL):@"B",
				  @(MF_TYPE_INT):@"q",
				  @(MF_TYPE_U_INT):@"Q",
				  @(MF_TYPE_DOUBLE):@"d",
				  @(MF_TYPE_C_STRING):@"*",
				  @(MF_TYPE_POINTER):@"^v",
				  @(MF_TYPE_CLASS):@"#",
				  @(MF_TYPE_SEL):@":",
				  @(MF_TYPE_OBJECT):@"@",
				  @(MF_TYPE_BLOCK):@"@?",
                  @(MF_TYPE_C_FUNCTION): @"^v",
				 };
	});
	_typeEncoding = [_dic[@(self.typeKind)] UTF8String];
	return _typeEncoding;
}

- (NSString *)typeName{
	if (self.typeKind == MF_TYPE_STRUCT || self.typeKind == MF_TYPE_STRUCT_LITERAL) {
		return _structName;
	}
	static NSDictionary *st_dic;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		st_dic = @{
				 @(MF_TYPE_VOID):@"void",
				 @(MF_TYPE_BOOL):@"BOOL",
				 @(MF_TYPE_INT):@"int(int64_t)",
				 @(MF_TYPE_U_INT):@"uint(uint64_t)",
				 @(MF_TYPE_DOUBLE):@"double",
				 @(MF_TYPE_C_STRING):@"CString(char *)",
				 @(MF_TYPE_POINTER):@"Pointer(void *)",
				 @(MF_TYPE_CLASS):@"Class",
				 @(MF_TYPE_SEL):@"SEL",
				 @(MF_TYPE_OBJECT):@"id",
				 @(MF_TYPE_BLOCK):@"Block",
                 @(MF_TYPE_C_FUNCTION): @"CFunction",
				 };
	});
	return st_dic[@(self.typeKind)];
}


- (void)setStructName:(NSString *)structName{
	if ([structName isEqualToString:@"NSRange"]) {
		structName = @"_NSRange";
	}
	_structName = structName;
}





@end
