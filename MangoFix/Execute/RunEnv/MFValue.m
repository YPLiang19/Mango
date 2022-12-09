//
//  MFValue .m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import "MFValue.h"
#import "MFValue+Private.h"
#import "MFTypeSpecifier.h"
#import "MFStructDeclareTable.h"
#import "create.h"
#import "util.h"

@interface MFValue()

@property (assign, nonatomic) BOOL structPointNoCopyData;

@end

@implementation MFValue{
    MFTypeSpecifier *_type;
    __strong id _strongObj;
    __weak id _weakObj;
    
}


- (instancetype)init{
	if (self = [super init]) {
        _structPointNoCopyData = NO;
	}
	return self;
}


- (BOOL)isSubtantial{
    if (self.externNativeGlobalVariable) {
        if (!self.externNativeGlobalVariablePointer) {
            return NO;
        }
        switch (_type.typeKind) {
            case MF_TYPE_BOOL:
                return  *(BOOL *)self.externNativeGlobalVariablePointer;
            case MF_TYPE_U_INT:
            case MF_TYPE_INT:
                return  *(NSInteger *)self.externNativeGlobalVariablePointer ? YES : NO;
            case MF_TYPE_DOUBLE:
                return  *(double *)self.externNativeGlobalVariablePointer ? YES : NO;
            default:
                return  *(void **)self.externNativeGlobalVariablePointer ? YES : NO;
                break;
        }
    }
	switch (_type.typeKind) {
		case MF_TYPE_BOOL:
		case MF_TYPE_U_INT:
			return _uintValue ? YES : NO;
		case MF_TYPE_INT:
			return _integerValue ? YES : NO;
		case MF_TYPE_DOUBLE:
			return _doubleValue ? YES : NO;
		case MF_TYPE_C_STRING:
			return _cstringValue ? YES : NO;
		case MF_TYPE_CLASS:
			return _classValue ? YES : NO;
		case MF_TYPE_SEL:
			return _selValue ? YES : NO;
		case MF_TYPE_OBJECT:
		case MF_TYPE_STRUCT_LITERAL:
		case MF_TYPE_BLOCK:
			return self.objectValue ? YES : NO;
		case MF_TYPE_STRUCT:
		case MF_TYPE_POINTER:
			return _pointerValue ? YES : NO;
		case MF_TYPE_VOID:
			return NO;
		default:
			break;
	}
	return NO;
}


- (BOOL)isNumber{
	MFTypeSpecifierKind kind = _type.typeKind;
	switch (kind) {
		case MF_TYPE_BOOL:
		case MF_TYPE_INT:
		case MF_TYPE_U_INT:
		case MF_TYPE_DOUBLE:
			return YES;
		default:
			return NO;
	}
}


- (BOOL)isObject{
	switch (_type.typeKind) {
		case MF_TYPE_OBJECT:
		case MF_TYPE_CLASS:
		case MF_TYPE_BLOCK:
			return YES;
		default:
			return NO;
	}
}


- (BOOL)isBaseValue{
	return ![self isObject];
}


- (void)assignFrom:(MFValue *)src{
	if (_type.typeKind == MF_TYPE_UNKNOWN) {
		_type = src.type;
	}
    
    if (self.externNativeGlobalVariable) {
        if (self.externNativeGlobalVariablePointer) {
            switch (_type.typeKind) {
                case MF_TYPE_BOOL:
                    *(BOOL *)self.externNativeGlobalVariablePointer = [src c2uintValue];
                    break;
                case MF_TYPE_INT: {
                    *(NSInteger *)self.externNativeGlobalVariablePointer = [src c2integerValue];
                    break;
                }
                case MF_TYPE_U_INT: {
                    *(NSUInteger *)self.externNativeGlobalVariablePointer = [src c2uintValue];
                    break;
                }
                case MF_DOUBLE_EXPRESSION: {
                    *(double *)self.externNativeGlobalVariablePointer = [src c2doubleValue];
                    break;
                }
                case MF_TYPE_POINTER: {
                    *(void **)self.externNativeGlobalVariablePointer = *(void **)[src valuePointer];
                    break;
                }
                default:
                    NSCAssert(0, @"extern native global variable as left value only can be int uint double and Pointer type!");
            }
            
        }
        return;
    }
    
    
	switch (_type.typeKind) {
		case MF_TYPE_BOOL:
		case MF_TYPE_U_INT:
			_uintValue = [src c2uintValue];
			break;
		case MF_TYPE_INT:
			_integerValue = [src c2integerValue];
			break;
		case MF_TYPE_DOUBLE:
			_doubleValue = [src c2doubleValue];
			break;
		case MF_TYPE_SEL:
			_selValue = [src selValue];
			break;
		case MF_TYPE_BLOCK:
		case MF_TYPE_OBJECT:
			self.objectValue = [src c2objectValue];
			break;
		case MF_TYPE_CLASS:
			_classValue = [src c2objectValue];
			break;
		case MF_TYPE_POINTER:
			_pointerValue = [src c2pointerValue];
			break;
		case MF_TYPE_C_STRING:
			_cstringValue = [src c2pointerValue];
			break;
        case MF_TYPE_C_FUNCTION:{
            _pointerValue = [src c2pointerValue];
            break;
        }
		case MF_TYPE_STRUCT:
			if (src.type.typeKind == MF_TYPE_STRUCT) {
                _pointerValue = malloc(_type.structSize);
				memcpy(_pointerValue, src.pointerValue, _type.structSize);
                _structPointNoCopyData = NO;
			}else if (src.type.typeKind == MF_TYPE_STRUCT_LITERAL){
				MFStructDeclareTable *table = [MFStructDeclareTable shareInstance];
				MFStructDeclare *declare = [table getStructDeclareWithName:self.type.structName];
				mf_struct_data_with_dic(self.pointerValue, src.objectValue, declare);
			}
			break;
		default:
			NSCAssert(0, @"");
			break;
	}
	
}


- (uint64_t)c2uintValue{
    
    if (self.externNativeGlobalVariable) {
        if (self.externNativeGlobalVariablePointer) {
            switch (_type.typeKind) {
                case MF_TYPE_BOOL:
                    return *(BOOL *)self.externNativeGlobalVariablePointer;
                case MF_TYPE_INT:
                    return *(NSInteger *)self.externNativeGlobalVariablePointer;
                case MF_TYPE_U_INT:
                    return *(NSUInteger *)self.externNativeGlobalVariablePointer;
                case MF_TYPE_DOUBLE:
                    return *(double *)self.externNativeGlobalVariablePointer;
                default:
                    return 0;
            }
        }
        return 0;
    }
    
	switch (_type.typeKind) {
		case MF_TYPE_BOOL:
			return _uintValue;
		case MF_TYPE_INT:
			return _integerValue;
		case MF_TYPE_U_INT:
			return _uintValue;
		case MF_TYPE_DOUBLE:
			return _doubleValue;
		default:
			return 0;
	}
}


- (int64_t)c2integerValue{
    return [self c2uintValue];
}


- (double)c2doubleValue{
    return [self c2uintValue];
}


- (id)c2objectValue{
    if (self.externNativeGlobalVariable) {
        if (self.externNativeGlobalVariablePointer) {
            switch (_type.typeKind) {
                case MF_TYPE_CLASS:
                case MF_TYPE_OBJECT:
                case MF_TYPE_BLOCK:
                case MF_TYPE_POINTER:
                    return  *(const id *)self.externNativeGlobalVariablePointer;
                default:
                    return nil;
            }
        }
        return nil;
    }
    
	switch (_type.typeKind) {
		case MF_TYPE_CLASS:
			return _classValue;
		case MF_TYPE_OBJECT:
		case MF_TYPE_BLOCK:
			return self.objectValue;
		case MF_TYPE_POINTER:
			return (__bridge id)_pointerValue;
		default:
			return nil;
	}
	
}


- (void *)c2pointerValue{

    if (self.externNativeGlobalVariable) {
        if (self.externNativeGlobalVariablePointer) {
            switch (_type.typeKind) {
                case MF_TYPE_C_STRING:
                case MF_TYPE_POINTER:
                case MF_TYPE_C_FUNCTION:
                case MF_TYPE_CLASS:
                case MF_TYPE_OBJECT:
                case MF_TYPE_BLOCK:
                    return *(void**)self.externNativeGlobalVariablePointer;
                default:
                    return NULL;
            }
        }
        return NULL;
    }
    
	switch (_type.typeKind) {
		case MF_TYPE_C_STRING:
			return (void *)_cstringValue;
		case MF_TYPE_POINTER:
        case MF_TYPE_C_FUNCTION:
			return _pointerValue;
		case MF_TYPE_CLASS:
			return (__bridge void*)_classValue;
		case MF_TYPE_OBJECT:
		case MF_TYPE_BLOCK:
			return (__bridge void*)self.objectValue;
		default:
			return NULL;
	}
}

- (void)assignToCValuePointer:(void *)cvaluePointer typeEncoding:(const char *)typeEncoding {
	typeEncoding = removeTypeEncodingPrefix((char *)typeEncoding);
#define mf_ASSIGN_2_C_VALUE_POINTER_CASE(_encode, _type, _sel)\
case _encode:{\
_type *ptr = (_type *)cvaluePointer;\
*ptr = (_type)[self _sel];\
break;\
}
	
	switch (*typeEncoding) {
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('c', char, c2integerValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('i', int, c2integerValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('s', short, c2integerValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('l', long, c2integerValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('q', long long, c2integerValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('C', unsigned char, c2uintValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('I', unsigned int, c2uintValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('S', unsigned short, c2uintValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('L', unsigned long, c2uintValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('Q', unsigned long long, c2uintValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('f', float, c2doubleValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('d', double, c2doubleValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('B', BOOL, c2uintValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('*', char *, c2pointerValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE('^', void *, c2pointerValue)
			mf_ASSIGN_2_C_VALUE_POINTER_CASE(':', SEL, selValue)
		case '@':{
			void  **ptr = cvaluePointer;
			*ptr = (__bridge void *)[self c2objectValue];
			break;
		}
		case '#':{
			Class *ptr = (Class  *)cvaluePointer;
			*ptr = [self c2objectValue];
			break;
		}
		case '{':{
			if (_type.typeKind == MF_TYPE_STRUCT) {
				size_t structSize = mf_size_with_encoding(typeEncoding);
				memcpy(cvaluePointer, self.pointerValue, structSize);
			}else if (_type.typeKind == MF_TYPE_STRUCT_LITERAL){
				NSString *structName = mf_struct_name_with_encoding(typeEncoding);
				MFStructDeclareTable *table = [MFStructDeclareTable shareInstance];
				mf_struct_data_with_dic(cvaluePointer, self.objectValue, [table getStructDeclareWithName:structName]);
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


- (instancetype)initWithCValuePointer:(void *)cValuePointer typeEncoding:(const char *)typeEncoding bridgeTransfer:(BOOL)bridgeTransfer  {
	typeEncoding = removeTypeEncodingPrefix((char *)typeEncoding);
	MFValue *retValue = [[MFValue alloc] init];
	
#define MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE(_code,_kind, _type,_sel)\
case _code:{\
retValue.type = mf_create_type_specifier(_kind);\
retValue._sel = *(_type *)cValuePointer;\
break;\
}
	
	switch (*typeEncoding) {
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('c',MF_TYPE_INT, char, integerValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('i',MF_TYPE_INT, int,integerValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('s',MF_TYPE_INT, short,integerValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('l',MF_TYPE_INT, long,integerValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('q',MF_TYPE_INT, long long,integerValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('C',MF_TYPE_U_INT, unsigned char, uintValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('I',MF_TYPE_U_INT,  unsigned int, uintValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('S',MF_TYPE_U_INT, unsigned short, uintValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('L',MF_TYPE_U_INT,  unsigned long, uintValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('Q',MF_TYPE_U_INT, unsigned long long,uintValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('B',MF_TYPE_BOOL, BOOL, uintValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('f',MF_TYPE_DOUBLE, float, doubleValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('d',MF_TYPE_DOUBLE, double,doubleValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE(':',MF_TYPE_SEL, SEL, selValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('^',MF_TYPE_POINTER,void *, pointerValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('*',MF_TYPE_C_STRING, char *,cstringValue)
			MFGO_C_VALUE_CONVER_TO_mf_VALUE_CASE('#',MF_TYPE_CLASS, Class,classValue)
		case '@':{
			retValue.type = mf_create_type_specifier(MF_TYPE_OBJECT);
			if (bridgeTransfer) {
                id objectValue = (__bridge_transfer id)(*(void **)cValuePointer);
                retValue.objectValue = objectValue;
			}else{
                id objectValue = (__bridge id)(*(void **)cValuePointer);
                retValue.objectValue = objectValue;
			}
			
			break;
		}
		case '{':{
			NSString *structName = mf_struct_name_with_encoding(typeEncoding);
			retValue.type= mf_create_struct_type_specifier(structName);
			size_t size = mf_size_with_encoding(typeEncoding);
			retValue.pointerValue = malloc(size);
			memcpy(retValue.pointerValue, cValuePointer, size);
			break;
		}
        case 'v': {
            retValue.type = mf_create_type_specifier(MF_TYPE_VOID);
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
	MFValue *value = [[MFValue alloc] init];
	switch (*typeEncoding) {
		case 'c':
			value.type = mf_create_type_specifier(MF_TYPE_INT);
			break;
		case 'i':
			value.type = mf_create_type_specifier(MF_TYPE_INT);
			break;
		case 's':
			value.type = mf_create_type_specifier(MF_TYPE_INT);
			break;
		case 'l':
			value.type = mf_create_type_specifier(MF_TYPE_INT);
			break;
		case 'q':
			value.type = mf_create_type_specifier(MF_TYPE_INT);
			break;
		case 'C':
			value.type = mf_create_type_specifier(MF_TYPE_U_INT);
			break;
		case 'I':
			value.type = mf_create_type_specifier(MF_TYPE_U_INT);
			break;
		case 'S':
			value.type = mf_create_type_specifier(MF_TYPE_U_INT);
			break;
		case 'L':
			value.type = mf_create_type_specifier(MF_TYPE_U_INT);
			break;
		case 'Q':
			value.type = mf_create_type_specifier(MF_TYPE_U_INT);
			break;
		case 'B':
			value.type = mf_create_type_specifier(MF_TYPE_BOOL);
			break;
		case 'f':
			value.type = mf_create_type_specifier(MF_TYPE_DOUBLE);
			break;
		case 'd':
			value.type = mf_create_type_specifier(MF_TYPE_DOUBLE);
			break;
		case ':':
			value.type = mf_create_type_specifier(MF_TYPE_SEL);
			break;
		case '^':
			value.type = mf_create_type_specifier(MF_TYPE_POINTER);
			break;
		case '*':
			value.type = mf_create_type_specifier(MF_TYPE_C_STRING);
			break;
		case '#':
			value.type = mf_create_type_specifier(MF_TYPE_CLASS);
			break;
		case '@':
			value.type = mf_create_type_specifier(MF_TYPE_OBJECT);
			break;
        case '{':{
			value.type = mf_create_struct_type_specifier(mf_struct_name_with_encoding(typeEncoding));
            value.type.structName =  mf_struct_name_with_encoding(typeEncoding);
            size_t size = mf_size_with_encoding(typeEncoding);
            value.pointerValue = malloc(size);
			break;
        }
		case 'v':
			value.type = mf_create_type_specifier(MF_TYPE_VOID);
			break;
		default:
			NSCAssert(0, @"");
			break;
	}
	return value;
}


+ (instancetype)voidValueInstance{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_VOID);
	return value;
}


+ (instancetype)valueInstanceWithBOOL:(BOOL)boolValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_BOOL);
	value.uintValue = boolValue;
	return value;
}


+ (instancetype)valueInstanceWithUint:(uint64_t)uintValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_U_INT);
	value.uintValue = uintValue;
	return value;
}


+ (instancetype)valueInstanceWithInt:(int64_t)intValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_INT);
	value.integerValue = intValue;
	return value;
}


+ (instancetype)valueInstanceWithDouble:(double)doubleValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_DOUBLE);
	value.doubleValue = doubleValue;
	return value;
}


+ (instancetype)valueInstanceWithObject:(id)objValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_OBJECT);
	value.objectValue = objValue;
	return value;
}


+ (instancetype)valueInstanceWithBlock:(id)blockValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_BLOCK);
	value.objectValue = blockValue;
	return value;
}


+ (instancetype)valueInstanceWithClass:(Class)clazzValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_CLASS);
	value.classValue = clazzValue;
	return value;
}


+ (instancetype)valueInstanceWithSEL:(SEL)selValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_SEL);
	value.selValue = selValue;
	return value;
}


+ (instancetype)valueInstanceWithCstring:(const char *)cstringValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_C_STRING);
	value.cstringValue = cstringValue;
	return value;
}


+ (instancetype)valueInstanceWithPointer:(void *)pointerValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_POINTER);
	value.pointerValue = pointerValue;
	return value;
}


+ (instancetype)valueInstanceWithStruct:(void *)structValue typeEncoding:(const char *)typeEncoding copyData:(BOOL)copyData{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_STRUCT);
	value.type.structName = mf_struct_name_with_encoding(typeEncoding);
	size_t size = mf_size_with_encoding(typeEncoding);
    if (copyData) {
        value.pointerValue = malloc(size);
        memcpy(value.pointerValue, structValue, size);
    }else{
        value.pointerValue = structValue;
        value.structPointNoCopyData = YES;
    }
	return value;
}


- (instancetype)nsStringValue{
	MFValue *value = [[MFValue alloc] init];
	value.type = mf_create_type_specifier(MF_TYPE_OBJECT);
    
    if (self.externNativeGlobalVariable) {
        if (self.externNativeGlobalVariablePointer) {
            switch (_type.typeKind) {
                case MF_TYPE_BOOL:
                    value.objectValue = [NSString stringWithFormat:@"%d",*(BOOL *)self.externNativeGlobalVariablePointer];
                case MF_TYPE_U_INT:
                    value.objectValue = [NSString stringWithFormat:@"%lu",(unsigned long)*(NSUInteger *)self.externNativeGlobalVariablePointer];
                    break;
                case MF_TYPE_INT:
                    value.objectValue = [NSString stringWithFormat:@"%ld",(long)*(NSInteger *)self.externNativeGlobalVariablePointer];
                    break;
                case MF_TYPE_DOUBLE:
                    value.objectValue = [NSString stringWithFormat:@"%lf", *(double *)self.externNativeGlobalVariablePointer];
                    break;
                case MF_TYPE_CLASS:
                case MF_TYPE_BLOCK:
                case MF_TYPE_OBJECT:
                    value.objectValue = [NSString stringWithFormat:@"%@",*(const id *)self.externNativeGlobalVariablePointer];
                    break;
                case MF_TYPE_C_FUNCTION:
                case MF_TYPE_POINTER:
                    value.objectValue = [NSString stringWithFormat:@"%p",*(void **)self.externNativeGlobalVariablePointer];
                    break;
                case MF_TYPE_C_STRING:
                    value.objectValue = [NSString stringWithFormat:@"%s",*(char **)self.externNativeGlobalVariablePointer];
                    break;
                default:
                    NSCAssert(0, @"");
                    break;
            }
        } else {
            value.objectValue = @"(null)";
        }
        return value;
    }
    
    
	switch (_type.typeKind) {
		case MF_TYPE_BOOL:
		case MF_TYPE_U_INT:
			value.objectValue = [NSString stringWithFormat:@"%llu",_uintValue];
			break;
		case MF_TYPE_INT:
			value.objectValue = [NSString stringWithFormat:@"%lld",_integerValue];
			break;
		case MF_TYPE_DOUBLE:
			value.objectValue = [NSString stringWithFormat:@"%lf",_doubleValue];
			break;
		case MF_TYPE_CLASS:
		case MF_TYPE_BLOCK:
		case MF_TYPE_OBJECT:
			value.objectValue = [NSString stringWithFormat:@"%@",self.c2objectValue];
			break;
		case MF_TYPE_SEL:
			value.objectValue = [NSString stringWithFormat:@"%@",NSStringFromSelector(_selValue)];
			break;
		case MF_TYPE_STRUCT:
		case MF_TYPE_POINTER:
			value.objectValue = [NSString stringWithFormat:@"%p",_pointerValue];
			break;
        case MF_TYPE_C_FUNCTION:{
            NSMutableString *signature = [NSMutableString stringWithString:_type.returnTypeEncode];
            for (NSString * paramEncode in _type.paramListTypeEncode) {
                [signature appendString:paramEncode];
            }
            value.objectValue = [NSString stringWithFormat:@"%@-%p",signature,_pointerValue];
            break;
        }
            
		case MF_TYPE_STRUCT_LITERAL:
			value.objectValue = [NSString stringWithFormat:@"%@",self.objectValue];
			break;
		case MF_TYPE_C_STRING:
			value.objectValue = [NSString stringWithFormat:@"%s",_cstringValue];
			break;
		default:
			NSCAssert(0, @"");
			break;
	}
	return value;
}


- (MFTypeSpecifier *)type{
    return _type;
}


- (void)setType:(MFTypeSpecifier *)type{
    _type = type;
}

-(void)setObjectValue:(id)objectValue{
    if (self.modifier & MFDeclarationModifierWeak) {
        _weakObj = objectValue;
    }else{
        _strongObj = objectValue;
    }
}


- (id)objectValue{
    if (self.modifier & MFDeclarationModifierWeak) {
        return _weakObj;
    }else{
        return _strongObj;
    }
}

-(void *)valuePointer{
    if (self.externNativeGlobalVariable) {
        return self.externNativeGlobalVariablePointer;
    }
    
    void *retPtr = NULL;
    switch (_type.typeKind) {
        case MF_TYPE_BOOL:
        case MF_TYPE_U_INT:
            retPtr = &_uintValue;
            break;
        case MF_TYPE_INT:
            retPtr = &_integerValue;
            break;
        case MF_TYPE_DOUBLE:
            retPtr = &_doubleValue;
            break;
        case MF_TYPE_CLASS:
            retPtr = &_classValue;
            break;
        case MF_TYPE_BLOCK:
        case MF_TYPE_STRUCT_LITERAL:
        case MF_TYPE_OBJECT:{
            if (self.modifier & MFDeclarationModifierWeak) {
                retPtr = &_weakObj;
            }else{
                retPtr = &_strongObj;
            }
            break;
        }
        case MF_TYPE_SEL:
            retPtr = &_selValue;
            break;
        case MF_TYPE_STRUCT:
        case MF_TYPE_POINTER:
            retPtr = &_pointerValue;
            break;
        case MF_TYPE_C_STRING:
            retPtr = &_cstringValue;
            break;
        default:
            NSCAssert(0, @"");
            break;
    }
    return retPtr;
}

- (void)dealloc{
    if (_type.typeKind == MF_TYPE_STRUCT && !_structPointNoCopyData) {
        free(_pointerValue);
    }
}

@end

