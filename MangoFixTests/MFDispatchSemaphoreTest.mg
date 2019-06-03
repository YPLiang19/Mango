
class MFDispatchSemaphoreTest : NSObject{

- (BOOL)testDispatchSemaphore{
    BOO retValue = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(0, 0), ^{
        retValue = YES;
        dispatch_semaphore_signal(semaphore);
    });

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return retValue;
}

}


