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
#import "NSData+AESEncryption.h"

@interface MFContext()
@property(nonatomic, strong) MFInterpreter *interpreter;
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *iv;
@end

@implementation MFContext

- (instancetype)initWithAES128Key:(NSString *)key iv:(NSString *)iv{
    if (self = [super init]) {
        _interpreter = [[MFInterpreter alloc] init];
        _key = key;
        _iv = iv;
    }
    return self;
}

- (void)evalMangoScriptWithURL:(NSURL *)url{
    @autoreleasepool {
        NSError *error;
        NSData *encryptedData = [NSData dataWithContentsOfURL:url];
        if (error) {
            NSLog(@"[MangoFix] [ERROR] : %@",error);
            return;
        }
        [self evalMangoScriptWithAES128Data:encryptedData];
    }
}

- (void)evalMangoScriptWithAES128Data:(NSData *)scriptData {
    @autoreleasepool {
        NSData *mangoFixData = [scriptData AES128ParmDecryptWithKey:_key iv:_iv];
        NSString *mangoFixString = [[NSString alloc] initWithData:mangoFixData encoding:NSUTF8StringEncoding];
        if (!mangoFixString.length) {
            NSLog(@"[MangoFix] [ERROR] : AES128(ECBMode) decrypt error!");
            return;
        }
        mf_set_current_compile_util(self.interpreter);
        mf_add_built_in(self.interpreter);
        [self.interpreter compileSourceWithString:mangoFixString];
        mf_set_current_compile_util(nil);
        mf_interpret(self.interpreter);
    }
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


- (void)evalMangoScriptWithDebugURL:(NSURL *)url{
    @autoreleasepool {
        NSError *error;
        NSString *mangoFixString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        mf_set_current_compile_util(self.interpreter);
        mf_add_built_in(self.interpreter);
        [self.interpreter compileSourceWithString:mangoFixString];
        mf_set_current_compile_util(nil);
        mf_interpret(self.interpreter);
    }
}

@end
