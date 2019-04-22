
class MFBasePropertyTest : NSObject{
@property (assign, nonatomic) NSInteger count;

-(NSInteger)testBasePropertyTest{
    self.count = 10;
    return self.count;
}

}
