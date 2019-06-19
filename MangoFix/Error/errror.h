//
//  errror.h
//  MangoFix
//
//  Created by yongpengliang on 2019/6/17.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#ifndef errror_h
#define errror_h

#include <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString  * const MFParseError;

FOUNDATION_EXTERN NSString  * const  MFSemanticErrorStructDeclareLackFieldEncoding;
FOUNDATION_EXTERN NSString  * const  MFSemanticErrorStructDeclareLackFieldKeys;
FOUNDATION_EXTERN NSString  * const  MFSemanticErrorNotSupportCFunctionTypeDeclare;
FOUNDATION_EXTERN NSString  * const  MFSemanticErrorStructNoDeclare;
FOUNDATION_EXTERN NSString  * const  MFSemanticErrorTypedefWithUnknownExistingType;

FOUNDATION_EXTERN NSString  * const  MFRuntimeErrorIllegalParameterType;
FOUNDATION_EXTERN NSString  * const  MFRuntimeErrorNotFoundCFunction;
FOUNDATION_EXTERN NSString  * const  MFRuntimeErrorCallCanNotBeCalleeValue;
FOUNDATION_EXTERN NSString  * const  MFRuntimeErrorNullPointer;
FOUNDATION_EXTERN NSString  * const  MFRuntimeErrorParameterListCountNoMatch;
FOUNDATION_EXTERN NSString  * const MFRuntimeErrorCallCFunctionFailure;
FOUNDATION_EXTERN NSString  * const MFRuntimeErrorSuperClassNoMatch;
FOUNDATION_EXTERN NSString  * const MFRuntimeErrorNotFoundSuperClass;
FOUNDATION_EXTERN NSString  * const MFRuntimeErrorNotSupportNumberFormat;
FOUNDATION_EXTERN NSString  * const MFErrorNotSupportType;


void mf_throw_error(NSUInteger lineNumber,NSString *errorName, NSString *reasonForamt, ...);

#endif /* errror_h */
