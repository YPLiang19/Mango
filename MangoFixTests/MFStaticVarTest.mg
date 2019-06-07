
class MFStaticVarTest : NSObject{

- (NSInteger)testStaticVar{
    static int i = 0; //静态变量只初始化一次
    i++;
    return i;
}

}
