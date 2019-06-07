//
//  MFPropertyMapTable.h
//  MangoFix
//
//  Created by yongpengliang on 2019/4/26.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mf_ast.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFPropertyMapTableItem:NSObject

@property (strong, nonatomic) Class clazz;
@property (strong, nonatomic) MFPropertyDefinition *property;

- (instancetype)initWithClass:(Class)clazz  property:(MFPropertyDefinition *)property;

@end

@interface MFPropertyMapTable : NSObject

+ (instancetype)shareInstance;

- (void)addPropertyMapTableItem:(MFPropertyMapTableItem *)propertyMapTableItem;
- (nullable MFPropertyMapTableItem *)getPropertyMapTableItemWith:(Class)clazz name:(NSString *)name;


@end

NS_ASSUME_NONNULL_END
