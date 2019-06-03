
class MFObjectPropertyTest : NSObject{

@property(nonatomic,copy)NSString *strTypeProperty;
@property(nonatomic,weak)id weakObjectProperty;
 
- (void)otherMethod{
    self.strTypeProperty = @"Mango";
}

- (NSString *)testObjectPropertyTest{
    self.otherMethod();
    return self.strTypeProperty;
}

- (id)testWeakObjectProperty{
    self.weakObjectProperty = NSObject.alloc().init();//下一个运行时释放
    return self.weakObjectProperty;
}

- (id)testIvar{
    _strTypeProperty = @"Mango-testIvar";
    return _strTypeProperty;
}
- (NSInteger)testProMathAdd{
    self.num += 10;
    return self.num;

}

}
