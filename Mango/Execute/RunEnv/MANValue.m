//
//  MANValue .m
//  mangoExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MANValue.h"
#import "MANTypeSpecifier.h"
#import "MANStructDeclareTable.h"
#import "create.h"
#import "util.h"

@implementation MANValue

- (instancetype)init{
	if (self = [super init]) {
	}
	return self;
}
- (BOOL)isSubtantial{
	switch (_type.typeKind) {
		case MAN_TYPE_BOOL:
		case MAN_TYPE_U_INT:
			return _uintValue ? YES : NO;
		case MAN_TYPE_INT:
			return _integerValue ? YES : NO;
		case MAN_TYPE_DOUBLE:
			return _doubleValue ? YES : NO;
		case MAN_TYPE_C_STRING:
			return _cstringValue ? YES : NO;
		case MAN_TYPE_CLASS:
			return _classValue ? YES : NO;
		case MAN_TYPE_SEL:
			return _selValue ? YES : NO;
		case MAN_TYPE_OBJECT:
		case MAN_TYPE_STRUCT_LITERAL:
		case MAN_TYPE_BLOCK:
			return _objectValue ? YES : NO;
		case MAN_TYPE_STRUCT:
		case MAN_TYPE_POINTER:
			return _pointerValue ? YES : NO;
		case MAN_TYPE_VOID:
			return NO;
		default:
			break;
	}
	return NO;
	
}
- (BOOL)isMember{
	ANATypeSpecifierKind kind = _type.typeKind;
	switch (kind) {
		case MAN_TYPE_BOOL:
		case MAN_TYPE_INT:
		case MAN_TYPE_U_INT:
		case MAN_TYPE_DOUBLE:
			return YES;
		default:
			return NO;
	}
}

- (BOOL)isObject{
	switch (_type.typeKind) {
		case MAN_TYPE_OBJECT:
		case MAN_TYPE_CLASS:
		case MAN_TYPE_BLOCK:
			return YES;
		default:
			return NO;
	}
}


- (BOOL)isBaseValue{
	return ![self isObject];
}

- (void)assignFrom:(MANValue *)src{
	switch (_type.typeKind) {
		case MAN_TYPE_BOOL:
		case MAN_TYPE_U_INT:
			_uintValue = [src c2uintValue];
			break;
		case MAN_TYPE_INT:
			_integerValue = [src c2integerValue];
			break;
		case MAN_TYPE_DOUBLE:
			_doubleValue = [src c2doubleValue];
			break;
		case MAN_TYPE_SEL:
			_selValue = [src selValue];
			break;
		case MAN_TYPE_BLOCK:
		case MAN_TYPE_OBJECT:
			_objectValue = [src c2objectValue];
			break;
		case MAN_TYPE_CLASS:
			_classValue = [src c2objectValue];
			break;
		case MAN_TYPE_POINTER:
			_pointerValue = [src c2pointerValue];
			break;
		case MAN_TYPE_C_STRING:
			_cstringValue = [src c2pointerValue];
			break;
		case MAN_TYPE_STRUCT:
			if (src.type.typeKind == MAN_TYPE_STRUCT) {
				memcpy(_pointerValue, src.pointerValue, _type.structSize);
			}else if (src.type.typeKind == MAN_TYPE_STRUCT_LITERAL){
				MANStructDeclareTable *table = [MANStructDeclareTable shareInstance];
				MANStructDeclare *declare = [table getStructDeclareWithName:self.type.structName];
				mango_struct_data_with_dic(self.pointerValue, src.objectValue, declare);
			}
			break;
		default:
			NSCAssert(0, @"");
			break;
	}
	
}




- (unsigned long long)c2uintValue{
	switch (_type.typeKind) {
		case MAN_TYPE_BOOL:
			return _uintValue;
		case MAN_TYPE_INT:
			return _integerValue;
		case MAN_TYPE_U_INT:
			return _uintValue;
		case MAN_TYPE_DOUBLE:
			return _doubleValue;
		default:
			return 0;
	}
}

- (long long)c2integerValue{
	switch (_type.typeKind) {
		case MAN_TYPE_BOOL:
			return _uintValue;
		case MAN_TYPE_INT:
			return _integerValue;
		case MAN_TYPE_U_INT:
			return _uintValue;
		case MAN_TYPE_DOUBLE:
			return _doubleValue;
		default:
			return 0;
	}
}

- (double)c2doubleValue{
	switch (_type.typeKind) {
		case MAN_TYPE_BOOL:
			return _uintValue;
		case MAN_TYPE_INT:
			return _integerValue;
		case MAN_TYPE_U_INT:
			return _uintValue;
		case MAN_TYPE_DOUBLE:
			return _doubleValue;
		default:
			return 0.0;
	}
}

- (id)c2objectValue{
	switch (_type.typeKind) {
		case MAN_TYPE_CLASS:
			return _classValue;
		case MAN_TYPE_OBJECT:
		case MAN_TYPE_BLOCK:
			return _objectValue;
		case MAN_TYPE_POINTER:
			return (__bridge id)_pointerValue;
		default:
			return nil;
	}
	
}

- (void *)c2pointerValue{
	switch (_type.typeKind) {
		case MAN_TYPE_C_STRING:
			return (void *)_cstringValue;
		case MAN_TYPE_POINTER:
			return _pointerValue;
		case MAN_TYPE_CLASS:
			return (__bridge void*)_classValue;
		case MAN_TYPE_OBJECT:
		case MAN_TYPE_BLOCK:
			return (__bridge void*)_objectValue;
		default:
			return NULL;
	}
}




- (void)assign2CValuePointer:(void *)cvaluePointer typeEncoding:(const char *)typeEncoding{
	typeEncoding = removeTypeEncodingPrefix((char *)typeEncoding);
#define mango_ASSIGN_2_C_VALUE_POINTER_CASE(_encode, _type, _sel)\
case _encode:{\
_type *ptr = (_type *)cvaluePointer;\
*ptr = (_type)[self _sel];\
break;\
}
	
	switch (*typeEncoding) {
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('c', char, c2integerValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('i', int, c2integerValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('s', short, c2integerValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('l', long, c2integerValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('q', long long, c2integerValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('C', unsigned char, c2uintValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('I', unsigned int, c2uintValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('S', unsigned short, c2uintValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('L', unsigned long, c2uintValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('Q', unsigned long long, c2uintValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('f', float, c2doubleValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('d', double, c2doubleValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('B', BOOL, c2uintValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('*', char *, c2pointerValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE('^', void *, c2pointerValue)
			mango_ASSIGN_2_C_VALUE_POINTER_CASE(':', SEL, selValue)
		case '@':{
			void  **ptr =cvaluePointer;
			*ptr = (__bridge_retained void *)[self c2objectValue];
			break;
		}
		case '#':{
			Class *ptr = (Class  *)cvaluePointer;
			*ptr = [self c2objectValue];
			break;
		}
		case '{':{
			if (_type.typeKind == MAN_TYPE_STRUCT) {
				size_t structSize = mango_struct_size_with_encoding(typeEncoding);
				memcpy(cvaluePointer, self.pointerValue, structSize);
			}else if (_type.typeKind == MAN_TYPE_STRUCT_LITERAL){
				NSString *structName = mango_struct_name_with_encoding(typeEncoding);
				MANStructDeclareTable *table = [MANStructDeclareTable shareInstance];
				mango_struct_data_with_dic(cvaluePointer, _objectValue, [table getStructDeclareWithName:structName]);
			}
			break;
		}
		case 'v':{
			break;
		}
		default:
			NSCAssert(0, @"");
			break;
	}
}


- (instancetype)initWithCValuePointer:(void *)cValuePointer typeEncoding:(const char *)typeEncoding{
	typeEncoding = removeTypeEncodingPrefix((char *)typeEncoding);
	MANValue *retValue = [[MANValue alloc] init];
	
#define MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE(_code,_kind, _type,_sel)\
case _code:{\
retValue.type = man_create_type_specifier(_kind);\
retValue._sel = *(_type *)cValuePointer;\
break;\
}
	
	switch (*typeEncoding) {
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('c',MAN_TYPE_INT, char, integerValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('i',MAN_TYPE_INT, int,integerValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('s',MAN_TYPE_INT, short,integerValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('l',MAN_TYPE_INT, long,integerValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('q',MAN_TYPE_INT, long long,integerValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('C',MAN_TYPE_U_INT, unsigned char, uintValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('I',MAN_TYPE_U_INT,  unsigned int, uintValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('S',MAN_TYPE_U_INT, unsigned short, uintValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('L',MAN_TYPE_U_INT,  unsigned long, uintValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('Q',MAN_TYPE_U_INT, unsigned long long,uintValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('B',MAN_TYPE_BOOL, BOOL, uintValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('f',MAN_TYPE_DOUBLE, float, doubleValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('d',MAN_TYPE_DOUBLE, double,doubleValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE(':',MAN_TYPE_SEL, SEL, selValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('^',MAN_TYPE_POINTER,void *, pointerValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('*',MAN_TYPE_C_STRING, char *,cstringValue)
			MANGO_C_VALUE_CONVER_TO_mango_VALUE_CASE('#',MAN_TYPE_CLASS, Class,classValue)
		case '@':{
			retValue.type = man_create_type_specifier(MAN_TYPE_OBJECT);
			retValue.objectValue = (__bridge id)(*(void **)cValuePointer);
			break;
		}
		case '{':{
			NSString *structName = mango_struct_name_with_encoding(typeEncoding);
			retValue.type= man_create_struct_type_specifier(structName);
			size_t size = mango_size_with_encoding(typeEncoding);
			retValue.pointerValue = malloc(size);
			memcpy(retValue.pointerValue, cValuePointer, size);
			break;
		}
			
		default:
			NSCAssert(0, @"not suppoert %s", typeEncoding);
			break;
	}
	
	return retValue;
}

+ (instancetype)defaultValueWithTypeEncoding:(const char *)typeEncoding{
	typeEncoding = removeTypeEncodingPrefix((char *)typeEncoding);
	MANValue *value = [[MANValue alloc] init];
	switch (*typeEncoding) {
		case 'c':
			value.type = man_create_type_specifier(MAN_TYPE_INT);
			break;
		case 'i':
			value.type = man_create_type_specifier(MAN_TYPE_INT);
			break;
		case 's':
			value.type = man_create_type_specifier(MAN_TYPE_INT);
			break;
		case 'l':
			value.type = man_create_type_specifier(MAN_TYPE_INT);
			break;
		case 'q':
			value.type = man_create_type_specifier(MAN_TYPE_INT);
			break;
		case 'C':
			value.type = man_create_type_specifier(MAN_TYPE_U_INT);
			break;
		case 'I':
			value.type = man_create_type_specifier(MAN_TYPE_U_INT);
			break;
		case 'S':
			value.type = man_create_type_specifier(MAN_TYPE_U_INT);
			break;
		case 'L':
			value.type = man_create_type_specifier(MAN_TYPE_U_INT);
			break;
		case 'Q':
			value.type = man_create_type_specifier(MAN_TYPE_U_INT);
			break;
		case 'B':
			value.type = man_create_type_specifier(MAN_TYPE_BOOL);
			break;
		case 'f':
			value.type = man_create_type_specifier(MAN_TYPE_DOUBLE);
			break;
		case 'd':
			value.type = man_create_type_specifier(MAN_TYPE_DOUBLE);
			break;
		case ':':
			value.type = man_create_type_specifier(MAN_TYPE_SEL);
			break;
		case '^':
			value.type = man_create_type_specifier(MAN_TYPE_POINTER);
			break;
		case '*':
			value.type = man_create_type_specifier(MAN_TYPE_C_STRING);
			break;
		case '#':
			value.type = man_create_type_specifier(MAN_TYPE_CLASS);
			break;
		case '@':
			value.type = man_create_type_specifier(MAN_TYPE_OBJECT);
			break;
		case '{':
			value.type = man_create_struct_type_specifier(mango_struct_name_with_encoding(typeEncoding));
			break;
		case 'v':
			value.type = man_create_type_specifier(MAN_TYPE_VOID);
			break;
		default:
			NSCAssert(0, @"");
			break;
	}
	return value;
}

+ (instancetype)voidValueInstance{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_VOID);
	return value;
}


+ (instancetype)valueInstanceWithBOOL:(BOOL)boolValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_BOOL);
	value.uintValue = boolValue;
	return value;
}
+ (instancetype)valueInstanceWithUint:(unsigned long long int)uintValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_U_INT);
	value.uintValue = uintValue;
	return value;
}
+ (instancetype)valueInstanceWithInt:(long long int)intValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_INT);
	value.integerValue = intValue;
	return value;
}
+ (instancetype)valueInstanceWithDouble:(double)doubleValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_DOUBLE);
	value.doubleValue = doubleValue;
	return value;
}
+ (instancetype)valueInstanceWithObject:(id)objValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_OBJECT);
	value.objectValue = objValue;
	return value;
}
+ (instancetype)valueInstanceWithBlock:(id)blockValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_BLOCK);
	value.objectValue = blockValue;
	return value;
}
+ (instancetype)valueInstanceWithClass:(Class)clazzValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_CLASS);
	value.classValue = clazzValue;
	return value;
}
+ (instancetype)valueInstanceWithSEL:(SEL)selValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_SEL);
	value.selValue = selValue;
	return value;
}
+ (instancetype)valueInstanceWithCstring:(const char *)cstringValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_C_STRING);
	value.cstringValue = cstringValue;
	return value;
}

+ (instancetype)valueInstanceWithPointer:(void *)pointerValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_POINTER);
	value.pointerValue = pointerValue;
	return value;
}

+ (instancetype)valueInstanceWithStruct:(void *)structValue typeEncoding:(const char *)typeEncoding{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_SEL);
	value.type.structName = mango_struct_name_with_encoding(typeEncoding);
	size_t size = mango_struct_size_with_encoding(typeEncoding);
	value.pointerValue = malloc(size);
	memcpy(value.pointerValue, structValue, size);
	return value;
}

- (instancetype)nsStringValue{
	MANValue *value = [[MANValue alloc] init];
	value.type = man_create_type_specifier(MAN_TYPE_OBJECT);
	switch (_type.typeKind) {
		case MAN_TYPE_BOOL:
		case MAN_TYPE_U_INT:
			value.objectValue = [NSString stringWithFormat:@"%llu",_uintValue];
			break;
		case MAN_TYPE_INT:
			value.objectValue = [NSString stringWithFormat:@"%lld",_integerValue];
			break;
		case MAN_TYPE_DOUBLE:
			value.objectValue = [NSString stringWithFormat:@"%lf",_doubleValue];
			break;
		case MAN_TYPE_CLASS:
		case MAN_TYPE_BLOCK:
		case MAN_TYPE_OBJECT:
			value.objectValue = [NSString stringWithFormat:@"%@",self.c2objectValue];
			break;
		case MAN_TYPE_SEL:
			value.objectValue = [NSString stringWithFormat:@"%@",NSStringFromSelector(_selValue)];
			break;
		case MAN_TYPE_STRUCT:
		case MAN_TYPE_POINTER:
			value.objectValue = [NSString stringWithFormat:@"%p",_pointerValue];
			break;
		case MAN_TYPE_STRUCT_LITERAL:
			value.objectValue = [NSString stringWithFormat:@"%@",_objectValue];
			break;
		case MAN_TYPE_C_STRING:
			value.objectValue = [NSString stringWithFormat:@"%s",_cstringValue];
			break;
		default:
			NSCAssert(0, @"");
			break;
	}
	return value;
}

- (void)dealloc{
	if (_type.typeKind == MAN_TYPE_STRUCT) {
		free(_pointerValue);
	}
}



@end

