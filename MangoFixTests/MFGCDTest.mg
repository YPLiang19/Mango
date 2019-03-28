
class MFGCDTest : NSObject {

- (void)testGCDWithCompletionBlock:(Block)completion{
    dispatch_queue_t queue = dispatch_queue_create("com.plliang19.mango", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        completion(@"success");
    });
}
    
}
