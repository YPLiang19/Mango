int NSDocumentDirectory = 9;
int NSUserDomainMask = 1;

int  O_WRONLY = 0x0001;
uint S_IRWXU  = 0000700;


CFunction<id, int, int, BOOL> NSSearchPathForDirectoriesInDomains = CFunction("NSSearchPathForDirectoriesInDomains");
CFunction<int, char *, int, int> open = CFunction("open");
CFunction<size_t, int, void *, size_t> write = CFunction("write");
CFunction<int, int> close = CFunction("close");



class  MFFuncDeclareTest : NSObject{

- (void)testFuncDeclare{
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;

    NSString *path = doc.stringByAppendingPathComponent:(@"MangoFxi.html");
    NSFileManager *fileManager = NSFileManager.defaultManager();
    if (!fileManager.fileExistsAtPath:(path)) {
        BOOL ret = fileManager.createFileAtPath:contents:attributes:(path, nil, nil);
        if (!ret) {
            NSLog(@"创建文件失败");
            return;
        }
    }
    NSLog(path);
    int fd = open(path.UTF8String,O_WRONLY, S_IRWXU);
    if (fd < 0) {
        NSLog(@"打开文件失败");
        return;
    }
    NSURL *url = NSURL.URLWithString:(@"https://github.com/YPLiang19/Mango");
    NSData *data = NSData.dataWithContentsOfURL:(url);
    write(fd, data.bytes, data.length);
    close(fd);
}

}
