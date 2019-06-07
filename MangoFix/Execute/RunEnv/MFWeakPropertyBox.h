//
//  MFWeakPropertyBox.h
//  MangoFix
//
//  Created by yongpengliang on 2019/4/26.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFWeakPropertyBox : NSObject

@property (weak)id target;

- (instancetype)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
