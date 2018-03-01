//
//  MANBlock.h
//  ananasExample
//
//  Created by jerry.yong on 2017/11/28.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MANStatement.h"



@interface MANBlockBody: NSObject
@property (strong, nonatomic) NSArray<MANStatement *> *statementList;
@property (strong, nonatomic) NSMutableArray<MANDeclaration *> *declarations;
@property (weak, nonatomic) MANBlock *outBlock;


@end
