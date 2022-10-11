//
//  util.m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/16.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//


#import "util.h"
#import "mf_ast.h"
#import "runenv.h"


static ffi_type *_ffi_type_with_type_encoding(NSString *typeEncoding){
	char *code = (char *)typeEncoding.UTF8String;
	switch (code[0]) {
        case 'r':
        case 'R':
        case 'n':
        case 'N':
        case 'o':
        case 'O':
        case 'V':
            return _ffi_type_with_type_encoding(@(&code[1]));
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
        case '*':
            return &ffi_type_pointer;
		case '^':
			return &ffi_type_pointer;
		case '@':
			return &ffi_type_pointer;
		case '#':
			return &ffi_type_pointer;
        case ':':
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
				type->elements = realloc((void*)(type->elements),sizeof(ffi_type *) * (subCount + 1));
				type->elements[subCount] = subFfiType;
				subCount++;
			}

			type->elements = realloc((void*)(type->elements), sizeof(ffi_type *) * (subCount + 1));
			type->elements[subCount] = NULL;
			return type;

		}
	}
	return NULL;
}

ffi_type *mf_ffi_type_with_type_encoding(const char *typeEncoding){
    return _ffi_type_with_type_encoding([NSString stringWithUTF8String:typeEncoding]);
}

size_t mf_size_with_encoding(const char *typeEncoding){
    NSUInteger size;
    NSUInteger alignp;
    NSGetSizeAndAlignment(typeEncoding, &size, &alignp);
    return size;
}


void mf_struct_data_with_dic(void *structData,NSDictionary *dic, MFStructDeclare *declare){
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
				size_t size = mf_size_with_encoding(subTypeEncoding.UTF8String);
				NSString *subStructName = mf_struct_name_with_encoding(subTypeEncoding.UTF8String);
				MFStructDeclare *subStructDeclare = [[MFStructDeclareTable shareInstance] getStructDeclareWithName:subStructName];
				id subStruct = dic[key];
				if ([subStruct isKindOfClass:[NSDictionary class]]) {
					mf_struct_data_with_dic(structData + postion, dic[key],subStructDeclare);
				}else{
					memcpy(structData+postion, [(MFValue *)subStruct pointerValue], size);
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


NSString *mf_struct_name_with_encoding(const char *typeEncoding){
	return _struct_name_with_encoding([NSString stringWithUTF8String:typeEncoding]);
	
}

objc_AssociationPolicy mf_AssociationPolicy_with_PropertyModifier(MFPropertyModifier modifier){
    objc_AssociationPolicy associationPolicy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
    switch (modifier & MFPropertyModifierMemMask) {
        case MFPropertyModifierMemStrong:
        case MFPropertyModifierMemWeak:
        case MFPropertyModifierMemAssign:
            switch (modifier & MFPropertyModifierAtomicMask) {
                case MFPropertyModifierAtomic:
                    associationPolicy = OBJC_ASSOCIATION_RETAIN;
                    break;
                case MFPropertyModifierNonatomic:
                    associationPolicy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
                    break;
                default:
                    break;
            }
            break;
        case MFPropertyModifierMemCopy:
            switch (modifier & MFPropertyModifierAtomicMask) {
                case MFPropertyModifierAtomic:
                    associationPolicy = OBJC_ASSOCIATION_COPY;
                    break;
                case MFPropertyModifierNonatomic:
                    associationPolicy = OBJC_ASSOCIATION_COPY_NONATOMIC;
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return associationPolicy;
}

