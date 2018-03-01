//
//  util.m
//  ananasExample
//
//  Created by jerry.yong on 2018/2/16.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//


#import "util.h"
#import "man_ast.h"
#import "runenv.h"


const char * mango_str_append(const char *str1, const char *str2){
	size_t len = strlen(str1) + strlen(str2);
	char *ret = malloc(sizeof(char) * (len + 1));
	strcpy(ret, str1);
	strcat(ret, str2);
	return ret;
}

static ffi_type *_ffi_type_with_type_encoding(NSString *typeEncoding){
	char *code = (char *)typeEncoding.UTF8String;
	switch (code[0]) {
		case 'v':
			return &ffi_type_void;
		case 'c':
			return &ffi_type_schar;
		case 'C':
			return &ffi_type_uchar;
		case 's':
			return &ffi_type_sshort;
		case 'S':
			return &ffi_type_ushort;
		case 'i':
			return &ffi_type_sint;
		case 'I':
			return &ffi_type_uint;
		case 'l':
			return &ffi_type_slong;
		case 'L':
			return &ffi_type_ulong;
		case 'q':
			return &ffi_type_sint64;
		case 'Q':
			return &ffi_type_uint64;
		case 'f':
			return &ffi_type_float;
		case 'd':
			return &ffi_type_double;
		case 'D':
			return &ffi_type_longdouble;
		case 'B':
			return &ffi_type_uint8;
		case '^':
			return &ffi_type_pointer;
		case '@':
			return &ffi_type_pointer;
		case '#':
			return &ffi_type_pointer;
		case '{':
		{
			ffi_type *type = malloc(sizeof(ffi_type));
			type->size = 0;
			type->alignment = 0;
			type->elements = NULL;
			type->type = FFI_TYPE_STRUCT;

			NSString *types = [typeEncoding substringToIndex:typeEncoding.length-1];
			NSUInteger location = [types rangeOfString:@"="].location+1;
			types = [types substringFromIndex:location];
			char *typesCode = (char *)[types UTF8String];


			size_t index = 0;
			size_t subCount = 0;
			NSString *subTypeEncoding;

			while (typesCode[index]) {
				if (typesCode[index] == '{') {
					size_t stackSize = 1;
					size_t end = index + 1;
					for (char c = typesCode[end]; c ; end++, c = typesCode[end]) {
						if (c == '{') {
							stackSize++;
						}else if (c == '}') {
							stackSize--;
							if (stackSize == 0) {
								break;
							}
						}
					}
					subTypeEncoding = [types substringWithRange:NSMakeRange(index, end - index + 1)];
					index = end + 1;
				}else{
					subTypeEncoding = [types substringWithRange:NSMakeRange(index, 1)];
					index++;
				}

				ffi_type *subFfiType = _ffi_type_with_type_encoding(subTypeEncoding);
				type->size += subFfiType->size;
				type->elements = realloc(type->elements, subCount + 1);
				type->elements[subCount] = subFfiType;
				subCount++;
			}

			type->elements = realloc(type->elements, subCount + 1);
			type->elements[subCount] = NULL;
			return type;

		}
	}
	return NULL;
}

static size_t _struct_size_with_encoding(NSString *typeEncoding){
	
	NSString *types = [typeEncoding substringToIndex:typeEncoding.length-1];
	NSUInteger location = [types rangeOfString:@"="].location+1;
	types = [types substringFromIndex:location];
	
	size_t size = 0;
	size_t index = 0;
	const char *encoding = types.UTF8String;
#define STRUCE_SZIE_CASE(_code,_type)\
case _code:\
size += sizeof(_type);\
break;
	while (encoding[index]) {
		switch (encoding[index]) {
				STRUCE_SZIE_CASE('c', char)
				STRUCE_SZIE_CASE('i', int)
				STRUCE_SZIE_CASE('s', short)
				STRUCE_SZIE_CASE('l', long)
				STRUCE_SZIE_CASE('q', long long)
				STRUCE_SZIE_CASE('C', unsigned char)
				STRUCE_SZIE_CASE('I', unsigned int)
				STRUCE_SZIE_CASE('S', unsigned short)
				STRUCE_SZIE_CASE('L', unsigned long)
				STRUCE_SZIE_CASE('Q', unsigned long long);
				STRUCE_SZIE_CASE('f', float);
				STRUCE_SZIE_CASE('d', double)
				STRUCE_SZIE_CASE('D', long double)
				STRUCE_SZIE_CASE('B', BOOL);
				STRUCE_SZIE_CASE('^', void *)
				STRUCE_SZIE_CASE('*', char *)
			case '{':{
				size_t stackSize = 1;
				size_t end = index + 1;
				for (char c = encoding[end]; c ; end++, c = encoding[end]) {
					if (c == '{') {
						stackSize++;
					}else if (c == '}') {
						stackSize--;
						if (stackSize == 0) {
							break;
						}
					}
				}
				
				NSString *subTypeEncoding = [types substringWithRange:NSMakeRange(index, end - index + 1)];
				size += _struct_size_with_encoding(subTypeEncoding);
				index += end - index;
				break;
			}
				
			default:
				break;
		}
		index++;
	}
	
#undef STRUCE_SZIE_CASE
	return size;
}

size_t mango_size_with_encoding(const char *typeEncoding){
	typeEncoding = removeTypeEncodingPrefix((char *)typeEncoding);
	switch (*typeEncoding) {
		case 'v':
			return sizeof(void);
		case 'c':
			return sizeof(char);
		case 'i':
			return sizeof(int);
		case 's':
			return sizeof(short);
		case 'l':
			return sizeof(long);
		case 'q':
			return sizeof(long long int);
		case 'C':
			return sizeof(unsigned char);
		case 'I':
			return sizeof(unsigned int);
		case 'S':
			return sizeof(unsigned short);
		case 'L':
			return sizeof(unsigned long);
		case 'Q':
			return sizeof(unsigned long long int);
		case 'f':
			return sizeof(float);
		case 'd':
			return sizeof(double);
		case 'D':
			return sizeof(long double);
		case 'B':
			return sizeof(BOOL);
		case '^':
			return sizeof(void *);
		case '*':
			return sizeof(char *);
		case '@':
			return sizeof(id);
		case '#':
			return sizeof(Class);
		case ':':
			return sizeof(SEL);
		case '{':
			return _struct_size_with_encoding([NSString stringWithUTF8String:typeEncoding]);
		default:
			NSCAssert(0, @"");
			break;
	}
	return 0;
}



void mango_struct_data_with_dic(void *structData,NSDictionary *dic, MANStructDeclare *declare){
	NSCAssert(declare, @"");
	NSArray<NSString *> *keys = declare.keys;
	NSString *typeEncoding = [NSString stringWithUTF8String:declare.typeEncoding];
	NSString *types = [typeEncoding substringToIndex:typeEncoding.length-1];
	NSUInteger location = [types rangeOfString:@"="].location+1;
	types = [types substringFromIndex:location];
	size_t index = 0;
	size_t postion = 0;
	const char *encoding = types.UTF8String;
#define STRUCT_SET_VALUE_CASE(_code, _type, _sel)\
case _code:{\
size_t size = sizeof(_type);\
_type value = [dic[key] _sel];\
memcpy(structData + postion, &value, size);\
postion += size;\
break;\
}
	for (NSString *key in keys) {
		switch (encoding[index]) {
				STRUCT_SET_VALUE_CASE('c', char, charValue)
				STRUCT_SET_VALUE_CASE('i', int, intValue)
				STRUCT_SET_VALUE_CASE('s', short, shortValue)
				STRUCT_SET_VALUE_CASE('l', long, longValue)
				STRUCT_SET_VALUE_CASE('q', long long, longLongValue)
				STRUCT_SET_VALUE_CASE('C', unsigned char, unsignedCharValue)
				STRUCT_SET_VALUE_CASE('I', unsigned int, unsignedIntValue)
				STRUCT_SET_VALUE_CASE('S', unsigned short, unsignedShortValue)
				STRUCT_SET_VALUE_CASE('L', unsigned long,unsignedLongLongValue)
				STRUCT_SET_VALUE_CASE('Q', unsigned long long, unsignedLongLongValue)
				STRUCT_SET_VALUE_CASE('f', float, floatValue);
				STRUCT_SET_VALUE_CASE('d', double, doubleValue);
				STRUCT_SET_VALUE_CASE('D', long double, doubleValue)
				STRUCT_SET_VALUE_CASE('B', BOOL, boolValue);
				STRUCT_SET_VALUE_CASE('^', void *, pointerValue)
				STRUCT_SET_VALUE_CASE('*', char *, pointerValue)
			case '{':{
				size_t stackSize = 1;
				size_t end = index + 1;
				for (char c = encoding[end]; c ; end++, c = encoding[end]) {
					if (c == '{') {
						stackSize++;
					}else if (c == '}') {
						stackSize--;
						if (stackSize == 0) {
							break;
						}
					}
				}
				
				NSString *subTypeEncoding = [types substringWithRange:NSMakeRange(index, end - index + 1)];
				size_t size = mango_struct_size_with_encoding(subTypeEncoding.UTF8String);
				NSString *subStructName = mango_struct_name_with_encoding(subTypeEncoding.UTF8String);
				MANStructDeclare *subStructDeclare = [[ANANASStructDeclareTable shareInstance] getStructDeclareWithName:subStructName];
				id subStruct = dic[key];
				if ([subStruct isKindOfClass:[NSDictionary class]]) {
					mango_struct_data_with_dic(structData + postion, dic[key],subStructDeclare);
				}else{
					memcpy(structData+postion, [(MANValue *)subStruct pointerValue], size);
				}
				
				postion += size;
				index += end - index;
				break;
			}
			default:
				break;
		}
		index++;
		
		
	}
#undef STRUCT_SET_VALUE_CASE
}



static NSString *_struct_name_with_encoding(NSString *typeEncoding){
	NSUInteger end = [typeEncoding rangeOfString:@"="].location;
	return [typeEncoding substringWithRange:NSMakeRange(1, end -1)];
}

ffi_type *mango_ffi_type_with_type_encoding(const char *typeEncoding){
	return _ffi_type_with_type_encoding([NSString stringWithUTF8String:typeEncoding]);
}

size_t mango_struct_size_with_encoding(const char *typeEncoding){
	return _struct_size_with_encoding([NSString stringWithUTF8String:typeEncoding]);
	
}


NSString *mango_struct_name_with_encoding(const char *typeEncoding){
	return _struct_name_with_encoding([NSString stringWithUTF8String:typeEncoding]);
	
}

