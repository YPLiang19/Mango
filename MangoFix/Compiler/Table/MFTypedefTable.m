//
//  MFTypedefTable.m
//  MangoFix
//
//  Created by yongpengliang on 2019/6/14.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFTypedefTable.h"

@implementation MFTypedefTable{
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
        
        _dic[@"char"] = @(MF_TYPE_INT);
        
        _dic[@"int8_t"] = @(MF_TYPE_INT);
        _dic[@"int16_t"] = @(MF_TYPE_INT);
        _dic[@"int32_t"] = @(MF_TYPE_INT);
        _dic[@"int64_t"] = @(MF_TYPE_INT);
        _dic[@"NSInteger"] = @(MF_TYPE_INT);
        _dic[@"long"] = @(MF_TYPE_INT);
        _dic[@"dispatch_once_t"] = @(MF_TYPE_INT);
    
        _dic[@"uint8_t"] = @(MF_TYPE_U_INT);
        _dic[@"uint16_t"] = @(MF_TYPE_U_INT);
        _dic[@"uint32_t"] = @(MF_TYPE_U_INT);
        _dic[@"uint64_t"] = @(MF_TYPE_U_INT);
        _dic[@"NSUInteger"] = @(MF_TYPE_U_INT);
        _dic[@"size_t"]  = @(MF_TYPE_U_INT);
        
        _dic[@"float"] = @(MF_TYPE_DOUBLE);
        _dic[@"CGFloat"] = @(MF_TYPE_DOUBLE);
        
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)typedefType:(MFTypeSpecifierKind)type identifer:(NSString *)identifer{
    if (!identifer.length) {
        return;
    }
    [_lock lock];
    _dic[identifer] = @(type);
    [_lock unlock];
}

- (MFTypeSpecifierKind)typeWtihIdentifer:(NSString *)identifer{
    MFTypeSpecifierKind type = MF_TYPE_UNKNOWN;
    [_lock lock];
    NSNumber *temp = _dic[identifer];
    [_lock unlock];
    if (temp) {
        type = [temp unsignedIntegerValue];
    }
    return type;
}

@end
