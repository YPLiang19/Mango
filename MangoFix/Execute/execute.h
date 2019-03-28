//
//  execute.h
//  MangoFix
//
//  Created by jerry.yong on 2017/12/26.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#ifndef execute_h
#define execute_h
#import "runenv.h"

/*built-in.m*/
void mf_add_built_in(MFInterpreter *inter);


/* eval.m */
BOOL mf_equal_value(NSUInteger lineNumber,MFValue *value1, MFValue *value2);
MFValue *mf_eval_expression(MFInterpreter *inter, MFScopeChain *scope,MFExpression *expr);
void mf_interpret(MFInterpreter *inter);


/*execute.m*/
MFStatementResult *mf_execute_statement_list(MFInterpreter *inter, MFScopeChain *scope, NSArray<MFStatement *> *statementList);
MFValue * mf_call_mf_function(MFInterpreter *inter, MFScopeChain *scope, MFFunctionDefinition *func, NSArray<MFValue *> *args);

#endif /* execute_h */
