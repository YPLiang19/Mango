
class MFGCDTest : NSObject {

- (void)testGCDWithCompletionBlock:(Block)completion{
    dispatch_queue_t queue = dispatch_queue_create("com.plliang19.mango", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        completion(@"success");
    });
}

- (void)testGCDAfterWithCompletionBlock:(Block)completion{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        completion(@"success");
    });
}
    
}
