
class MFObjectPropertyTest : NSObject{

@property(nonatomic,copy)NSString *strTypeProperty;
    
- (void)otherMethod{
    self.strTypeProperty = @"Mango";
}

- (NSString *)testObjectPropertyTest{
    self.otherMethod();
    return self.strTypeProperty;
}

}
