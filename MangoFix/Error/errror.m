//
//  errrorc.c
//  MangoFix
//
//  Created by jerry.yong on 2017/11/30.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//


#import "create.h"

NSString  * const  MFParseError = @"MFParseError";

NSString  * const  MFSemanticErrorStructDeclareLackFieldEncoding = @"MFSemanticErrorStructDeclareLackFieldEncoding";
NSString  * const  MFSemanticErrorStructDeclareLackFieldKeys = @"MFSemanticErrorStructDeclareLackFieldKeys";
NSString  * const  MFSemanticErrorNotSupportCFunctionTypeDeclare = @"MFSemanticErrorNotSupportCFunctionTypeDeclare";
NSString  * const  MFSemanticErrorTypedefWithUnknownExistingType = @"MFSemanticErrorTypedefWithUnknownExistingType";



NSString  * const  MFSemanticErrorStructNoDeclare = @"MFRuntimeErrorStructNoDeclare";
NSString  * const MFRuntimeErrorIllegalParameterType = @"MFRuntimeErrorIllegalParameterType";
NSString  * const MFRuntimeErrorNotFoundCFunction = @"MFRuntimeErrorNotFoundCFunction";
NSString  * const MFRuntimeErrorCallCanNotBeCalleeValue = @"MFRuntimeErrorCallCanNotBeCalleeValue";
NSString  * const MFRuntimeErrorNullPointer = @"MFRuntimeErrorNullPointer";
NSString  * const MFRuntimeErrorParameterListCountNoMatch = @"MFRuntimeErrorParameterListCountNoMatch";
NSString  * const MFRuntimeErrorCallCFunctionFailure = @"MFRuntimeErrorCallCFunctionFailure";
NSString  * const MFRuntimeErrorSuperClassNoMatch = @"MFRuntimeErrorSuperClassNoMatch";
NSString  * const MFRuntimeErrorNotFoundSuperClass = @"MFRuntimeErrorNotFoundSuperClass";
NSString  * const MFRuntimeErrorNotSupportNumberFormat = @"MFRuntimeErrorNotSupportNumberFormat";
NSString  * const MFErrorNotSupportType = @"MFErrorNotSupportType";


void mf_throw_error(NSUInteger lineNumber,NSString *errorName, NSString *reasonForamt, ...){
    
    NSString *reason = nil;
    
    if (reasonForamt.length) {
        va_list list;
        va_start(list,reasonForamt);
        reason = [[NSString alloc] initWithFormat:reasonForamt arguments:list];
        va_end(list);
    }
    reason = [NSString stringWithFormat:@"error location line number: %@, %@",@(lineNumber),reason];
    @throw [NSException exceptionWithName:errorName reason:reason userInfo:nil];
}


int yyerror(char const *str){
    NSUInteger line = mf_get_current_compile_util().currentLineNumber;
    mf_throw_error(line, MFParseError, @(str));
    return 0;
}
