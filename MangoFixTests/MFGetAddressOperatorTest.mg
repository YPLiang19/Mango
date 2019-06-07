
int i = 0;

class MFGetAddressOperatorTest : NSObject{

- (NSInteger)testGetAddressOperator{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        i++;
    });
    return i;
}

}
