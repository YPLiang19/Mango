
class MFConditionalReplaceTest : NSObject{

#If($systemVersion.doubleValue() > 13.0 )
- (BOOL)testConditionalReplace{
    return NO;
}

}
