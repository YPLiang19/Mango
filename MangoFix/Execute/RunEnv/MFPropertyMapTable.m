//
//  MFPropertyMapTable.m
//  MangoFix
//
//  Created by yongpengliang on 2019/4/26.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import "MFPropertyMapTable.h"

@implementation MFPropertyMapTableItem

- (instancetype)initWithClass:(Class)clazz property:(MFPropertyDefinition *)property{
    if (self = [super init]) {
        _clazz = clazz;
        _property = property;
    }
    return self;
}

@end

@implementation MFPropertyMapTable{
    NSMutableDictionary<NSString *, MFPropertyMapTableItem *> *_dic;
    NSLock *_lock;
}

+ (instancetype)shareInstance{
    static id st_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        st_instance = [[MFPropertyMapTable alloc] init];
    });
    return st_instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _dic = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)addPropertyMapTableItem:(MFPropertyMapTableItem *)propertyMapTableItem{
    NSString *propertyName = propertyMapTableItem.property.name;
    if (!propertyName.length) {
        return;
    }
    NSString *index = [NSString stringWithFormat:@"%@_%@",NSStringFromClass(propertyMapTableItem.clazz),propertyName];
    [_lock lock];
    _dic[index] = propertyMapTableItem;
    [_lock unlock];
}

- (MFPropertyMapTableItem *)getPropertyMapTableItemWith:(Class)clazz name:(NSString *)name{
    NSString *index = [NSString stringWithFormat:@"%@_%@",NSStringFromClass(clazz),name];
    [_lock lock];
    MFPropertyMapTableItem *propertyMapTableItem = _dic[index];
    [_lock unlock];
    return propertyMapTableItem;
}


@end
