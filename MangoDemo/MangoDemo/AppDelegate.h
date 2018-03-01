//
//  AppDelegate.h
//  ananasExample
//
//  Created by jerry.yong on 2017/10/31.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//
#import <UIKit/UIKit.h>
#include <Foundation/Foundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
//OBJC_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
//OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object.
//										*   The association is not made atomically. */
//OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied.
//										*   The association is not made atomically. */
//OBJC_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
//										*   The association is made atomically. */
//OBJC_ASSOCIATION_COPY = 01403          /**<
@property (strong, nonatomic) UIWindow *window;//暂时只支持strong，weak, copy, assign/nonatomic,atomic


@end

