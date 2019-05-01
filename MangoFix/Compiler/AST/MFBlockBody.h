//
//  MFBlock.h
//  MangoFix
//
//  Created by jerry.yong on 2017/11/28.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFStatement.h"


@interface MFBlockBody: NSObject

@property (strong, nonatomic) NSArray<MFStatement *> *statementList;
//@property (strong, nonatomic) NSMutableArray<MFDeclaration *> *declarations;
@property (weak, nonatomic) MFBlockBody *outBlock;

@end
