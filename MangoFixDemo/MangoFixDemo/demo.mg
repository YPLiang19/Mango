/**
demo.mg
*/

//声明一个自定义结构体
declare struct MyStruct {
    typeEncoding:"{MyStruct=dd}",
    keys:x,y
}

class ViewController:UIViewController {

- (void)sequentialStatementExample{
//变量定义
    NSString *text = @"1";
    self.resultView.text = text;
}

- (void)ifStatementExample{
	int a = 2;
	int b = 2;

	NSString *text;
	if(a > b){
		text = @"执行结果: a > b";
	}else if (a == b){
		text = @"执行结果: a == b";
	}else{
		text = @"执行结果: a < b";
	}
	self.resultView.text = text;
}

- (void)switchStatementExample{
	int a = 2;
	NSString *text;
	switch(a){
		case 1:{
			text = @"match 1";
			break;
		}
		case 2:{} //case 后面的一对花括号不可以省略
		case 3:{
			text = @"match 2 or 3";
			break;
		}
		case 4:{
			text = @"match 4";
			break;
		}
		default:{
			text = @"match default";
		}
	}
	self.resultView.text = text;
}

- (void)forStatementExample{
	NSString *text = @"";
	for(int i = 0; i < 20; i++){
		text = text + i + @", ";
		if(i == 10){
			break;
		}
	}
	self.resultView.text = text;
}

- (void)forEachStatementExample{
	NSArray *arr = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"g", @"i", @"j",@"k"];
	NSString *text = @"";
	for(id element in arr){
		text = text + element + @", ";
		if(element.isEqualToString:(@"i")){
			break;
		}

	}
	self.resultView.text = text;
}

- (void)whileStatementExample{
	int a;
	while(a < 10){
		if(a == 5){
			break;
		}
		a++;
	}
	self.resultView.text = @""+a;
}

- (void)doWhileStatementExample{
	int a = 0;
	do{
		a++;
	}while(NO);
	self.resultView.text = @""+a;

}

- (void)blockStatementExample{
	Block catStringBlock = ^NSString *(NSString *str1, NSString *str2){
								NSString *result = str1.stringByAppendingString:(str2);
								return result;
							};
	NSString *result = catStringBlock(@"hello ", @"world!");
	self.resultView.text = result;
}


- (void)paramPassingExampleWithBOOLArg:(BOOL)BOOLArg intArg:(int) intArg uintArg:(NSUInteger)uintArg blockArg:(Block)blockArg  objArg:(id)objArg {
	NSString *text = @"";
	text += @"BOOLArg:" + BOOLArg + @",\n";
	text += @"intArg:" + intArg + @",\n";
    text += @"uintArg:" + uintArg + @",\n";
	text += @"Block执行结果:" + blockArg(@"hello", @"mango") + @"\n";
	text += @"objArg:" + objArg;
	self.resultView.text = text;
}


- (struct MyStruct)paramPassingExampleWithStrut:(struct CGRect)rect{
    struct MyStruct myStruct = {x:(rect.origin.x + 100), y:(rect.origin.x + 10)};
    return myStruct;
}

- (Block)returnBlockExample{
	NSString *prefix = @"mango: ";
	Block catStringBlock = ^NSString *(NSString *str1, NSString *str2){
		NSString *result = str1.stringByAppendingString:(str2);
		return prefix + result;
	};
	return catStringBlock;
}


- (void)callOriginalImp{
    self.ORGcallOriginalImp();
}

- (void)createAndOpenNewViewControllerExample{
	SubMyController *vc = SubMyController.alloc().init();
	self.navigationController.pushViewController:animated:(vc,YES);

}

//类方法替换示例
+ (void)classMethodExapleWithInstance:(ViewController *)vc{
	vc.resultView.text = @"here is Mango  Class Method " + self;
}

//条件注释示例
#If($systemVersion.doubleValue() > 12.0 )
- (void)conditionsAnnotationExample{
    self.resultView.text = @"here is Mango method";
}


//GCD示例
- (void)gcdExample{
	dispatch_queue_t queue = dispatch_queue_create("com.plliang19.mango", DISPATCH_QUEUE_CONCURRENT);
	dispatch_async(queue, ^{
		NSLog(@"mango dispatch_async");
	});
	dispatch_sync(queue, ^{
		NSLog(@"mango dispatch_sync");
	});
}



- (void)staticVarAndGetVarAddressOperExample{
    static int i = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        i++;
    });
    self.resultView.text = @""+i;
}

    - (void)cfuntionVarExample{
    int NSDocumentDirectory = 9;
    int NSUserDomainMask = 1;

    int  O_WRONLY = 0x0001;
    uint S_IRWXU  = 0000700;


    CFunction<id, int, int, BOOL> NSSearchPathForDirectoriesInDomains = CFunction("NSSearchPathForDirectoriesInDomains");
    CFunction<int, char *, int, int> open = CFunction("open");
    CFunction<size_t, int, void *, size_t> write = CFunction("write");
    CFunction<int, int> close = CFunction("close");


    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;

    NSString *path = doc.stringByAppendingPathComponent:(@"MangoFxi.html");
    NSFileManager *fileManager = NSFileManager.defaultManager();
    if (!fileManager.fileExistsAtPath:(path)) {
        BOOL ret = fileManager.createFileAtPath:contents:attributes:(path, nil, nil);
        if (!ret) {
            self.resultView.text = @"创建文件失败";
            return;
        }
    }
    int fd = open(path.UTF8String,O_WRONLY, S_IRWXU);
    if (fd < 0) {
        self.resultView.text = @"打开文件失败";
        return;
    }
    NSURL *url = NSURL.URLWithString:(@"https://github.com/YPLiang19/Mango");
    NSData *data = NSData.dataWithContentsOfURL:(url);
    write(fd, data.bytes, data.length);
    close(fd);
    self.resultView.text = @"文件写入成功:" + path;
}

- (void)typedefExaple{
    self.resultView.text = @"typedef long alias_long;";
}

}

int a = 1;

class SuperMyController:UIViewController{
/*
- (void)viewDidLoad {
    super.viewDidLoad();
    self.view.backgroundColor = UIColor.blueColor();
    self.testMasonry();
}
*/

- (void)testMasonry{
    UIView *superview = self.view;
    UIView *view1 = UIView.alloc().init();
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view1.backgroundColor = UIColor.greenColor();
    superview.addSubview:(view1);
    struct UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    view1.mas_makeConstraints:(^(MASConstraintMaker *make) {
        make.top.equalTo()(superview.mas_top).with.offset()(padding.top); //with is an optional semantic filler
        make.left.equalTo()(superview.mas_left).with.offset()(padding.left);
        make.bottom.equalTo()(superview.mas_bottom).with.offset()(-padding.bottom);
        make.right.equalTo()(superview.mas_right).with.offset()(-padding.right);
    });
}

}


class SubMyController:SuperMyController {

@property (strong, nonatomic) UIView *rotateView;

- (void)viewDidLoad {
    super.viewDidLoad();
    self.title = @"Magno 创建自定义ViewController";
    double width = 100;
    double height = 100;
    double x = self.view.frame.size.width/2 - width/2;
    double y = self.view.frame.size.height/2 - height/2;
    UIView *view = CustomView.alloc().initWithFrame:(CGRectMake(x, y, width, height));
    self.view.addSubview:(view);
    view.backgroundColor = UIColor.redColor();
    self.rotateView = view;
    
    
    UILabel *label = UILabel.alloc().initWithFrame:(CGRectMake(10, 80, 350, 600));
    label.numberOfLines = 100;
    label.text =@"  长文本测试 :   select()机制中提供一fd_set的数据结构，实际上是一long类型的数组，每一个数组元素都能与一打开的文件句柄（不管是socket句柄，还是其他文件或命名管道或设备句柄）建立联系，建立联系的工作由程序员完成，当调用select()时，由内核根据IO状态修改fd_set的内容，由此来通知执行了select()的进程哪一socket或文件发生了可读或可写事件。select()机制中提供一fd_set的数据结构，实际上是一long类型的数组，每一个数组元素都能与一打开的文件句柄（不管是socket句柄，还是其他文件或命名管道或设备句柄）建立联系，建立联系的工作由程序员完成，当调用select()时，由内核根据IO状态修改fd_set的内容，由此来通知执行了select()的进程哪一socket或文件发生了可读或可写事件。select()机制中提供一fd_set的数据结构，实际上是一long类型的数组，每一个数组元素都能与一打开的文件句柄（不管是socket句柄，还是其他文件或命名管道或设备句柄）建立联系，建立联系的工作由程序员完成，当调用select()时，由内核根据IO状态修改fd_set的内容，由此来通知执行了select()的进程哪一socket或文件发生了可读或可写事件。select()机制中提供一fd_set的数据结构，实际上是一long类型的数组，每一个数组元素都能与一打开的文件句柄（不管是socket句柄，还是其他文件或命名管道或设备句柄）建立联系，建立联系的工作由程序员完成，当调用select()时，由内核根据IO状态修改fd_set的内容，由此来通知执行了select()的进程哪一socket或文件发生了可读或可写事件。";
    self.view.addSubview:(label);
    


    __weak id weakSelf = self;
    self.block = ^{
        __strong ids strongSelf = weakSelf;
        NSLog(strongSelf.class());
    };

    UIButton *btn = UIButton.alloc().initWithFrame:(CGRectMake(100, 300, 200, 50));
    btn.setBackgroundColor:(UIColor.redColor());
    btn.setTitle:forState:(@"test btn click", UIControlStateNormal);
    btn.addTarget:action:forControlEvents:(self, @selector(btnDidClicked:), UIControlEventTouchUpInside);
    self.view.addSubview:(btn);

}

- (void)btnDidClicked:(id)btn{
    NSLog(btn);
}

}
