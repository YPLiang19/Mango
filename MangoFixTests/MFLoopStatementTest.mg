
class MFLoopStatementTest : NSObject{
    
- (BOOL)testLoopStatementTest{
    int i = 0;
    for (int j = 0; j < 10; j++) {
        i++;
    }//i = 10
    
    if (i != 10) {
        return NO;
    }
    
    
    do {
        i++;// i = 11
    }while(NO);
    
    if (i != 11) {
        return NO;
    }
    
    
    do {
        i++;
    }while(i < 20);//i = 20
    
    if (i != 20) {
        return NO;
    }
    
    
    while (i < 30) {
        i++;
    }
    if (i != 30) {
        return NO;
    }
    NSArray *arr = @[@"1", @"2", @"3", @"4", @"5"];
    for(id e in arr){
        i += e.intValue();
    }
    return i == 45;
}
    
}
