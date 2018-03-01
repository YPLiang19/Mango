//
//  util.h
//  ananasExample
//
//  Created by jerry.yong on 2018/2/16.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#ifndef util_h
#define util_h
#import <Foundation/Foundation.h>
#import "ffi.h"
@class MANStructDeclare;

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

const char * mango_str_append(const char *str1, const char *str2);
ffi_type *mango_ffi_type_with_type_encoding(const char *typeEncoding);
size_t mango_size_with_encoding(const char *typeEncoding);
size_t mango_struct_size_with_encoding(const char *typeEncoding);
NSString * mango_struct_name_with_encoding(const char *typeEncoding);
void mango_struct_data_with_dic(void *structData, NSDictionary *dic, MANStructDeclare *declare);

#endif /* util_h */
