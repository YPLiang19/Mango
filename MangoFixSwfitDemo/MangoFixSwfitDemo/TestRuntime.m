//
//  TestRuntime.m
//  MangoFixSwfitDemo
//
//  Created by Tianyu Xia on 2022/3/8.
//

#import <Foundation/Foundation.h>
#import "TestRuntime.h"
#import <objc/objc.h>
#import <objc/runtime.h>



void testRuntie(void) {
    Class vcClazz = objc_getClass("MangoFixSwiftDylibTest.SuperMyController");
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(vcClazz, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method m = methods[i];
        NSString *name = NSStringFromSelector(method_getName(m));
        printf("Method: %s, imp: %p\n", name.UTF8String, method_getImplementation(m));
    }

    
}
