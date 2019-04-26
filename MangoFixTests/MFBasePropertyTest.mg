
class MFBasePropertyTest : NSObject{
@property (assign, nonatomic) NSInteger count;

-(NSInteger)testBasePropertyTest{
    self.count = 100000;
    return self.count;
}
- (NSInteger)testIvar{
    _count  = 100001;
    return _count;
}

}
