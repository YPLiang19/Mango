//
//  MFStaticVarTable.m
//  MangoFix
//
//  Created by yongpengliang on 2019/6/7.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFStaticVarTable.h"

@implementation MFStaticVarTable{
    NSMutableDictionary *_dic;
    NSLock *_lock;
}

+ (instancetype)shareInstance{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _dic = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (MFValue *)getStaticVarValueWithKey:(NSString *)key{
    MFValue *value = nil;
    [_lock lock];
    value = _dic[key];
    [_lock unlock];
    return value;
}

- (void)setStaticVarValue:(MFValue *)value withKey:(NSString *)key{
    if (!value) {
        return;
    }
    [_lock lock];
    _dic[key] = value;
    [_lock unlock];
}

@end
