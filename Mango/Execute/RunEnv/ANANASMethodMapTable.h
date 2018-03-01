//
//  ANANASMethodMapTable.h
//  ananasExample
//
//  Created by jerry.yong on 2018/2/23.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "man_ast.h"

@interface MANMethodMapTableItem:NSObject

@property (strong, nonatomic) Class clazz;
@property (strong, nonatomic) MANInterpreter *inter;
@property (strong, nonatomic) MANMethodDefinition *method;

- (instancetype)initWithClass:(Class)clazz inter:(MANInterpreter *)inter method:(MANMethodDefinition *)method;

@end

@interface ANANASMethodMapTable : NSObject

+ (instancetype)shareInstance;

- (void)addMethodMapTableItem:(MANMethodMapTableItem *)methodMapTableItem;
- (MANMethodMapTableItem *)getMethodMapTableItemWith:(Class)clazz classMethod:(BOOL)classMethod sel:(SEL)sel;

@end
