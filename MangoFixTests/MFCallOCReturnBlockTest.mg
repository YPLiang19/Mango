class MFCallOCReturnBlockTest : NSObject{
- (id)testCallOCReturnBlock{
    id ret = self.returnBlockMethod()(@"a",@"b");
    return ret;
}
}
