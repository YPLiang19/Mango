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
#import "MFRSA.h"

@interface MFContext()
@property(nonatomic, strong) MFInterpreter *interpreter;
@property(nonatomic, copy) NSString *privateKey;
@end

@implementation MFContext

- (instancetype)initWithRASPrivateKey:(NSString *)privateKey{
    if (self = [super init]) {
        _interpreter = [[MFInterpreter alloc] init];
        _privateKey = privateKey;
    }
    return self;
}

- (void)evalMangoScriptWithURL:(NSURL *)url{
    NSError *error;
    NSString *rsaEncryptedBase64String = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"MangoFix: %@",error);
        return;
    }
    [self evalMangoScriptWithRASEncryptedBase64String:rsaEncryptedBase64String];
}

- (void)evalMangoScriptWithRASEncryptedBase64String:(NSString *)rsaEncryptedBase64String{
    NSString *mangoFixString = [MFRSA decryptString:rsaEncryptedBase64String privateKey:self.privateKey];
    if (!mangoFixString.length) {
        NSLog(@"MangoFix: RAS decrypt error!");
        return;
    }
    mf_set_current_compile_util(self.interpreter);
    mf_add_built_in(self.interpreter);
    [self.interpreter compileSoruceWithString:mangoFixString];
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


#ifdef DEBUG
- (void)evalMangoScriptWithDebugURL:(NSURL *)url{
    NSError *error;
    NSString *mangoFixString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    mf_set_current_compile_util(self.interpreter);
    mf_add_built_in(self.interpreter);
    [self.interpreter compileSoruceWithString:mangoFixString];
    mf_set_current_compile_util(nil);
    mf_interpret(self.interpreter);
}
#endif

@end
