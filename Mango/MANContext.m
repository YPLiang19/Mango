//
//  MANContext.m
//  mangoExample
//
//  Created by jerry.yong on 2017/12/25.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MANContext.h"
#import "create.h"
#import "execute.h"

@interface MMANontext()
@property(nonatomic, strong) MANInterpreter *interpreter;
@end

@implementation MMANontext


- (instancetype)init{
	if (self = [super init]) {
		_interpreter = [[MANInterpreter alloc] init];
	}
	return self;
}

- (void)evalMangoScriptWithURL:(NSURL *)url{
	man_set_current_compile_util(self.interpreter);
	[self.interpreter compileSoruceWithURL:url];
	ane_interpret(self.interpreter);
	
	
}

- (void)evalMangoScriptWithSourceString:(NSString *)sourceString{
	man_set_current_compile_util(self.interpreter);
	[self.interpreter compileSoruceWithString:sourceString];
	ane_interpret(self.interpreter);
}

- (MANValue *)objectForKeyedSubscript:(id)key{
	return _interpreter.topScope.vars[key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSObject<NSCopying> *)key{
	_interpreter.topScope.vars[key] = [MANValue valueInstanceWithObject:object];
	
	
}


@end
