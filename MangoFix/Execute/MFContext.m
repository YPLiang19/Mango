//
//  MFContext.m
//  MangoFix
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MFContext.h"
#import "create.h"
#import "execute.h"

@interface MFContext()
@property(nonatomic, strong) MFInterpreter *interpreter;
@end

@implementation MFContext


- (instancetype)init{
	if (self = [super init]) {
		_interpreter = [[MFInterpreter alloc] init];
	}
	return self;
}

- (void)evalMangoScriptWithURL:(NSURL *)url{
	mf_set_current_compile_util(self.interpreter);
	[self.interpreter compileSoruceWithURL:url];
    mf_set_current_compile_util(nil);
	mf_interpret(self.interpreter);
	
	
}

- (void)evalMangoScriptWithSourceString:(NSString *)sourceString{
	mf_set_current_compile_util(self.interpreter);
	[self.interpreter compileSoruceWithString:sourceString];
    mf_set_current_compile_util(nil);
	mf_interpret(self.interpreter);
}

- (MFValue *)objectForKeyedSubscript:(id)key{
	return [_interpreter.topScope getValueWithIdentifier:key];
}

- (void)setObject:(MFValue *)value forKeyedSubscript:(NSString *)key{
    if (!value) {
        return;
    }
	[_interpreter.topScope setValue:value withIndentifier:key];
}


@end
