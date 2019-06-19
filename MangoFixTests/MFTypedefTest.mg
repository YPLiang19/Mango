typedef long alias_long;

class MFTypedefTest : NSObject{

- (Pointer)testTypedef{
    static alias_long i;
    Pointer i_ptr = &i;
    return i_ptr;
}

}
