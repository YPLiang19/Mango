
class  MFIvarTest : NSObject {

- (id)testObjectIvar{
    _var = NSObject.alloc().init();
    return _var;
}

- (NSInteger)testIntIvar{
    _i = 10000001;
    return _i;
}

- (CGRect)testStructIvar{
    _rect = CGRectMake(1, 2, 3, 4);
    return _rect;
}



}
