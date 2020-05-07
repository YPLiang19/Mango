
class MFConditionalReplaceTest : NSObject{

#If($systemVersion.doubleValue() > 14.0 )
- (BOOL)testConditionalReplace{
    return NO;
}

}
