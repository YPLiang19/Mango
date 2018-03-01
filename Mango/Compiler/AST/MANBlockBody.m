//
//  MANBlock.m
//  ananasExample
//
//  Created by jerry.yong on 2017/11/28.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MANBlockBody.h"

@implementation MANBlockBody
//
- (NSMutableArray<MANDeclaration *> *)declarations{
	if (_declarations == nil) {
		_declarations = [NSMutableArray array];
	}
	return _declarations;
}

@end
