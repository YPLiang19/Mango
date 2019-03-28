
class MFMethodParameterListAndReturnValueTest : NSObject{

- (Block)testMethodParameterListAndReturnValueWithString:(NSString *)str block:(Block)block{
    NSMutableDictionary *dic = @{}.mutableCopy();
    dic[@"param1"] = str + @"Mango";
    dic[@"param2"] = block(@"Mango");
    
    Block retBlock = ^NSDictionary *(/*不能加void*/){
        return dic;
    };
    return retBlock;
}

}
