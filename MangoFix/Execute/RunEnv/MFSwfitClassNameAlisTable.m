//
//  MFSwfitClassNameAlisTable.m
//  MangoFix
//
//  Created by Pengliang Yong on 2022/3/10.
//

#import "MFSwfitClassNameAlisTable.h"

@interface MFSwfitClassNameAlisTable ()

@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation MFSwfitClassNameAlisTable

+ (instancetype)shareInstance {
    static id st_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        st_instance = [[MFSwfitClassNameAlisTable alloc] init];
    });
    return st_instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _dic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addSwiftClassNmae:(NSString *)swiftClassName alias:(NSString *)aliasClassName {
    _dic[aliasClassName] = swiftClassName;
}


- (nullable NSString *)swiftClassNameByAlias:(NSString *)aliasName {
    return _dic[aliasName];
}

@end
