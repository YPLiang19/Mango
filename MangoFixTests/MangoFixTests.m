//
//  MangoFixTests.m
//  MangoFixTests
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MangoFix/MangoFix.h>

#import "MFInstanceMethodReplaceTest.h"
#import "MFClassMethodReplaceTest.h"
#import "MFOriginalMethodTest.h"
#import "MFSuperMethodReplaceTest.h"
#import "MFAddGlobalVarTest.h"
#import "MFConditionalReplaceTest.h"
#import "MFSequentialStatementTest.h"
#import "MFBranchStatementTest.h"
#import "MFLoopStatementTest.h"
#import "MFMethodParameterListAndReturnValueTest.h"
#import "MFObjectPropertyTest.h"
#import "MFCustomStructDeclareTest.h"
#import "MFGCDTest.h"

@interface MangoFixTest : XCTestCase

@property(nonatomic,strong)MFContext *context;

@end

@implementation MangoFixTest

- (void)loadMango:(NSString *)mangoName
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:mangoName ofType:@"mg"];
    NSURL *scriptUrl = [NSURL fileURLWithPath:path];
    [self.context evalMangoScriptWithURL:scriptUrl];
}


- (void)setUp {
    self.context = [[MFContext alloc] init];
}


- (void)testInstanceMethodReplace{
    [self loadMango:@"MFInstanceMethodReplaceTest"];
    MFInstanceMethodReplaceTest *instanceMethodReplaceTest = [[MFInstanceMethodReplaceTest alloc] init];
    XCTAssert([instanceMethodReplaceTest testInstanceMethodReplace], @"testInstanceMethodReplace");
}


- (void)testClassMethodReplace{
    [self loadMango:@"MFClassMethodReplaceTest"];
    XCTAssert([MFClassMethodReplaceTest testClassMethodReplaceTest],@"testClassMethodReplaceTest");
}


- (void)testOriginalMethod{
    [self loadMango:@"MFOriginalMethodTest"];
    MFOriginalMethodTest *originalMethodTest = [[MFOriginalMethodTest alloc] init];
    XCTAssertEqualObjects([originalMethodTest testOriginalMethod], @"MangoMethod-OriginalMethod",@"testOriginalMethod");
}


- (void)testSuperMethodReplace{
    [self loadMango:@"MFSuperMethodReplaceTest"];
    MFSuperMethodReplaceTest *superMethodReplaceTest = [[MFSuperMethodReplaceTest alloc] init];
    XCTAssertEqualObjects([superMethodReplaceTest testSuperMethodReplaceTest], @"Mango: MFPerson::say-Mango: MFAnimal::say",@"testSuperMethodReplaceTest");
}


- (void)testAddGlobalVar{
    [self loadMango:@"MFAddGlobalVarTest"];
    self.context[@"globalVar"] = [MFValue valueInstanceWithBOOL:YES];
    MFAddGlobalVarTest *addGlobalVarTest = [[MFAddGlobalVarTest alloc] init];
    XCTAssert([addGlobalVarTest testAddGlobalVar],@"addGlobalVarTest");
}


- (void)testConditionalReplace{
    [self loadMango:@"MFConditionalReplaceTest"];
    MFConditionalReplaceTest *conditionalReplaceTest = [[MFConditionalReplaceTest alloc] init];
    XCTAssert([conditionalReplaceTest testConditionalReplace],@"conditionalReplaceTest");
}


- (void)testSequentialStatement{
    [self loadMango:@"MFSequentialStatementTest"];
    MFSequentialStatementTest *sequentialStatementTest = [[MFSequentialStatementTest alloc] init];
    NSDictionary *retValue = [sequentialStatementTest testSequentialStatement];
    XCTAssertNotNil(retValue,@"MFSequentialStatementTest");
}


- (void)testBranchStatementTest{
    [self loadMango:@"MFBranchStatementTest"];
    MFBranchStatementTest *branchStatementTest = [[MFBranchStatementTest alloc] init];
    XCTAssert([branchStatementTest tsetBranchStatement],@"tsetBranchStatement");
}


- (void)testLoopStatement{
    [self loadMango:@"MFLoopStatementTest"];
    MFLoopStatementTest *loopStatementTest = [[MFLoopStatementTest alloc] init];
    XCTAssert([loopStatementTest testLoopStatementTest],@"testLoopStatementTest");
}


- (void)testMethodParameterListAndReturnValue{
    [self loadMango:@"MFMethodParameterListAndReturnValueTest"];
    MFMethodParameterListAndReturnValueTest *methodParameterListAndReturnValue = [[MFMethodParameterListAndReturnValueTest alloc] init];
    NSDictionary *(^retBlock)(void) = [methodParameterListAndReturnValue testMethodParameterListAndReturnValueWithString:@"param1" block:^NSString * _Nonnull(NSString * _Nonnull str) {
        return [NSString stringWithFormat:@"param2%@",str];
    }];
    NSDictionary *retVal  = retBlock();
    XCTAssertEqualObjects(retVal[@"param1"], @"param1Mango",@"methodParameterListAndReturnValue");
    XCTAssertEqualObjects(retVal[@"param2"], @"param2Mango",@"methodParameterListAndReturnValue");
}


- (void)testObjectProperty{
    [self loadMango:@"MFObjectPropertyTest"];
    MFObjectPropertyTest *objectPropertyTest = [[MFObjectPropertyTest alloc] init];
    XCTAssertEqualObjects([objectPropertyTest testObjectPropertyTest], @"Mango",@"testObjectPropertyTest");
}


- (void)testCustomStructDeclare{
    [self loadMango:@"MFCustomStructDeclareTest"];
    MFCustomStructDeclareTest *customStructDeclareTest = [[MFCustomStructDeclareTest alloc] init];
    MFCustomStruct customStruct = [customStructDeclareTest testCustomStructDeclareWithCGRect:CGRectMake(10, 20, 100, 200)];
    XCTAssertEqual(customStruct.x, 110,@"testCustomStructDeclareWithCGRect");
    XCTAssertEqual(customStruct.y, 220,@"testCustomStructDeclareWithCGRect");
}


- (void)testGCD{
    [self loadMango:@"MFGCDTest"];
    MFGCDTest *gcdTest = [[MFGCDTest alloc] init];
    XCTestExpectation *expection = [self expectationWithDescription:@"testGCD"];;
    [gcdTest testGCDWithCompletionBlock:^(id  _Nonnull data) {
        XCTAssertEqualObjects(data, @"success",@"testGCDWithCompletionBlock");
        [expection fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

@end
