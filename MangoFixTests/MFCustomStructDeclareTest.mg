
//声明一个自定义结构体
declare struct MFCustomStruct {
    typeEncoding:"{MFCustomStruct=dd}",
    keys:x,y
}

class MFCustomStructDeclareTest : NSObject{

- (struct MFCustomStruct)testCustomStructDeclareWithCGRect:(struct CGRect)rect{
    double x = rect.origin.x + rect.size.width;
    double y = rect.origin.y + rect.size.height;
    struct MFCustomStruct customStruct = {x:x,y:y};
    return customStruct;
}

}
