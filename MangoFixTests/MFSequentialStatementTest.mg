
class MFSequentialStatementTest : NSObject {

- (id)testSequentialStatement{
    NSMutableArray *arr  = NSMutableArray.arrayWithCapacity:(10);
    NSObject *o = NSObject.alloc().init();
    arr.addObject:(o);

    NSMutableDictionary *dic = NSMutableDictionary.dictionary();
    dic[@"key"] = arr;

    return dic;
}

}
