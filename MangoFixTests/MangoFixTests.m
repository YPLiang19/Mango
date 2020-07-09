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
#import "MFOperatorTest.h"
#import "MFSequentialStatementTest.h"
#import "MFBranchStatementTest.h"
#import "MFLoopStatementTest.h"
#import "MFMethodParameterListAndReturnValueTest.h"
#import "MFBasePropertyTest.h"
#import "MFObjectPropertyTest.h"
#import "MFIvarTest.h"
#import "MFCustomStructDeclareTest.h"
#import "MFStructMemberAssignTest.h"
#import "MFGCDTest.h"
#import "MFCallOCReturnBlockTest.h"
#import "MFDispatchSemaphoreTest.h"
#import "MFDispatchSourceTest.h"
#import "MFCallSuperNoArgTest.h"
#import "MFFormatNumberTest.h"
#import "MFStaticVarTest.h"
#import "MFGetAddressOperatorTest.h"
#import "MFTypedefTest.h"
#import "MFFuncDeclareTest.h"

@interface MangoFixTest : XCTestCase

@property(nonatomic,strong)MFContext *context;

@end

@implementation MangoFixTest

- (void)loadMango:(NSString *)mangoName{
    NSURL *scriptUrl = [[NSBundle bundleForClass:[self class]] URLForResource:mangoName withExtension:@"mg"];
    [self.context evalMangoScriptWithDebugURL:scriptUrl];
}


- (void)setUp {
    self.context = [[MFContext alloc] initWithRSAPrivateKey:nil];
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

- (void)testOperator{
    [self loadMango:@"MFOperatorTest"];
    MFOperatorTest *operatorTest = [[MFOperatorTest alloc] init];
    XCTAssert([operatorTest testOperator],@"operatorTest");
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

- (void)testBaseProperty{
    [self loadMango:@"MFBasePropertyTest"];
    MFBasePropertyTest *basePropertyTest = [[MFBasePropertyTest alloc] init];
    NSInteger retVal = [basePropertyTest testBasePropertyTest];
    XCTAssertEqual(retVal, 100000,@"testBasePropertyTest");
    retVal= [basePropertyTest testIvar];
    XCTAssertEqual(retVal, 100001,@"testIvar");
}


- (void)testObjectProperty{
    [self loadMango:@"MFObjectPropertyTest"];
    MFObjectPropertyTest *objectPropertyTest = [[MFObjectPropertyTest alloc] init];
    XCTAssertEqualObjects([objectPropertyTest testObjectPropertyTest], @"Mango",@"testObjectPropertyTest");
    XCTAssertEqualObjects([objectPropertyTest testIvar], @"Mango-testIvar",@"testIvar");
    NSInteger num = [objectPropertyTest testProMathAdd];
    XCTAssertEqual(num, 10,@"testProMathAdd");
    
}

- (void)testIvar{
    [self loadMango:@"MFIvarTest"];
    MFIvarTest *ivarTest = [[MFIvarTest alloc] init];
    
    id retObj = [ivarTest testObjectIvar];
    XCTAssertNotNil(retObj,@"testObjectIvar");
    
    NSInteger retInt = [ivarTest testIntIvar];
    XCTAssertEqual(retInt, 10000001,@"testIntIvar");
    
    struct CGRect retStruct = [ivarTest testStructIvar];
    
    XCTAssertEqual(retStruct.origin.x, 1,@"retStruct.origin.x");
    XCTAssertEqual(retStruct.origin.y, 2,@"retStruct.origin.y");
    XCTAssertEqual(retStruct.size.width, 3,@"retStruct.size.width");
    XCTAssertEqual(retStruct.size.height, 4,@"retStruct.size.height");
    
}


- (void)testCustomStructDeclare{
    [self loadMango:@"MFCustomStructDeclareTest"];
    MFCustomStructDeclareTest *customStructDeclareTest = [[MFCustomStructDeclareTest alloc] init];
    MFCustomStruct customStruct = [customStructDeclareTest testCustomStructDeclareWithCGRect:CGRectMake(10, 20, 100, 200)];
    XCTAssertEqual(customStruct.x, 110,@"testCustomStructDeclareWithCGRect");
    XCTAssertEqual(customStruct.y, 220,@"testCustomStructDeclareWithCGRect");
}

- (void)testStructMemberAssign{
    [self loadMango:@"MFStructMemberAssignTest"];
    MFStructMemberAssignTest *structMemberAssignTest = [[MFStructMemberAssignTest alloc] init];
    struct CGRect rect = [structMemberAssignTest testStructMemberAssign1];
    XCTAssertEqual(rect.origin.x, 10,@"testStructMemberAssign1");
    XCTAssertEqual(rect.origin.y, 11,@"testStructMemberAssign1");
    XCTAssertEqual(rect.size.width, 100,@"testStructMemberAssign1");
    XCTAssertEqual(rect.size.height, 101,@"testStructMemberAssign1");
    CGPoint point = [structMemberAssignTest testStructMemberAssign2];
    XCTAssertEqual(point.x, 10,@"testStructMemberAssign2");
    XCTAssertEqual(point.y, 100,@"testStructMemberAssign2");
}

- (void)testCallOCReturnBlock{
    [self loadMango:@"MFCallOCReturnBlockTest"];
    MFCallOCReturnBlockTest *callOCReturnBlockTest = [[MFCallOCReturnBlockTest alloc] init];
    id retValue = [callOCReturnBlockTest testCallOCReturnBlock];
    XCTAssertEqualObjects(retValue, @"ab",@"testCallOCReturnBlock");
}


- (void)testDispatchSemaphore{
    [self loadMango:@"MFDispatchSemaphoreTest"];
    MFDispatchSemaphoreTest *dispatchSemaphoreTest = [[MFDispatchSemaphoreTest alloc] init];
    BOOL retValue = [dispatchSemaphoreTest testDispatchSemaphore];
    XCTAssert(retValue,@"testDispatchSemaphore");
}

- (void)testDispatchSource{
    [self loadMango:@"MFDispatchSourceTest"];
    MFDispatchSourceTest *dispatchSourceTest = [[MFDispatchSourceTest alloc] init];
    NSInteger count = [dispatchSourceTest testDispatchSource];
    XCTAssertEqual(count,10, @"testDispatchSource");
}

- (void)testCallSuperNoArgTestSupser{
    [self loadMango:@"MFCallSuperNoArgTest"];
    MFCallSuperNoArgTest *callSuperNoArgTest = [[MFCallSuperNoArgTest alloc] init];
    BOOL retVale = [callSuperNoArgTest testCallSuperNoArgTestSupser];
    XCTAssert(retVale,@"testCallSuperNoArgTestSupser");
}

- (void)testGCD{
    [self loadMango:@"MFGCDTest"];
    MFGCDTest *gcdTest = [[MFGCDTest alloc] init];
    XCTestExpectation *expection = [self expectationWithDescription:@"testGCD"];;
    [gcdTest testGCDAfterWithCompletionBlock:^(id  _Nonnull data) {
        XCTAssertEqualObjects(data, @"success",@"testGCDWithCompletionBlock");
        [expection fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

- (void)testFormat{
    [self loadMango:@"MFFormatNumberTest"];
    MFFormatNumberTest *formatNumberTest = [[MFFormatNumberTest alloc] init];
    NSString *retVale = [formatNumberTest testFormatNumber];
    XCTAssertEqualObjects(retVale, @"255-377-ff-FF-255-377-ff-FF-255-377-ff-FF-255.000000-255.000000-255.00-255.00",@"testFormatNumber");
}

- (void)testStaticVar{
    [self loadMango:@"MFStaticVarTest"];
    MFStaticVarTest *staticVarTest = [[MFStaticVarTest alloc] init];
    NSInteger i1 = [staticVarTest testStaticVar];
    NSInteger i2 = [staticVarTest testStaticVar];
    NSInteger i3 = [staticVarTest testStaticVar];
    XCTAssert(i1 == 1 && i2 == 2 && i3 == 3,@"testStaticVar");
}

- (void)testGetAddressOperator{
    [self loadMango:@"MFGetAddressOperatorTest"];
    MFGetAddressOperatorTest *getAddressOperatorTest = [[MFGetAddressOperatorTest alloc] init];
    NSInteger i1 = [getAddressOperatorTest testGetAddressOperator];
    NSInteger i2 = [getAddressOperatorTest testGetAddressOperator];
    NSInteger i3 = [getAddressOperatorTest testGetAddressOperator];
    XCTAssert(i1 == 1 && i2 == 1 && i3 == 1,@"testGetAddressOperator");
}

- (void)testTypedef{
    [self loadMango:@"MFTypedefTest"];
    MFTypedefTest *typedefTest = [[MFTypedefTest alloc] init];
    void *retPtr = [typedefTest testTypedef];
    XCTAssert((*(int64_t *)retPtr == 0),@"testTypedef");
}

- (void)testFuncDeclare{
    [self loadMango:@"MFFuncDeclareTest"];
    MFFuncDeclareTest *funcDeclareTest = [[MFFuncDeclareTest alloc] init];
    [funcDeclareTest testFuncDeclare];
}



@end
