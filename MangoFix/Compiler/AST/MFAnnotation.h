//
//  MFAnnotation.h
//  MangoFix
//
//  Created by 雍鹏亮 on 2022/3/9.
//

#import <Foundation/Foundation.h>
#import "MFExpression.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFAnnotation : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) MFExpression *expr;

@end

NS_ASSUME_NONNULL_END
