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
    void *ptr = NSSearchPathForDirectoriesInDomains;
    NSLog(@"%p", ptr);
    

    
}
