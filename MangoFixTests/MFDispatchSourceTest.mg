class MFDispatchSourceTest : NSObject{

- (NSInteger)testDispatchSource{
    NSInteger count = 0;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        count++;
        if (count == 10) {
            dispatch_suspend(timer);
            dispatch_semaphore_signal(semaphore);
        }
    });
    dispatch_resume(timer);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return count;
}

}

