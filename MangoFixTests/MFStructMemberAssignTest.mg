
class MFStructMemberAssignTest : NSObject{

- (struct CGRect)testStructMemberAssign1{
    struct CGRect rect = CGRectMake(0, 0, 0, 0);
    rect.origin = CGPointMake(10, 11);
    rect.size.width = 100;
    rect.size.height = 101;
    return rect;
}

- (struct CGPoint)testStructMemberAssign2{
    struct CGPoint point = CGPointMake(0, 0);
    point.x = 10;
    point.y = 100;
    return point;
}

}
