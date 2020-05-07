//
//  util.h
//  MangoFix
//
//  Created by jerry.yong on 2018/2/16.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#ifndef util_h
#define util_h
#import <Foundation/Foundation.h>
#include <objc/runtime.h>
#import "ffi.h"
#import "MFClassDefinition.h"
@class MFStructDeclare;

inline static  char *removeTypeEncodingPrefix(char *typeEncoding){
	while (*typeEncoding == 'r' || // const
		   *typeEncoding == 'n' || // in
		   *typeEncoding == 'N' || // inout
		   *typeEncoding == 'o' || // out
		   *typeEncoding == 'O' || // bycopy
		   *typeEncoding == 'R' || // byref
		   *typeEncoding == 'V') { // oneway
		typeEncoding++; // cutoff useless prefix
	}
	return typeEncoding;
}

ffi_type *mf_ffi_type_with_type_encoding(const char *typeEncoding);

size_t mf_size_with_encoding(const char *typeEncoding);

NSString * mf_struct_name_with_encoding(const char *typeEncoding);

void mf_struct_data_with_dic(void *structData, NSDictionary *dic, MFStructDeclare *declare);

objc_AssociationPolicy mf_AssociationPolicy_with_PropertyModifier(MFPropertyModifier);

#endif /* util_h */
