/**
demo.mg
*/



// 修复MangoFixSwfitDemo模块中的ViewController类
@SwiftModule("MangoFixSwfitDemo")
class ViewController : UIViewController {


- (void)createAndOpenNewViewControllerExample{
    SubMyController *vc = SubMyController.alloc().init();
    self.navigationController.pushViewController:animated:(vc,YES);
}

}


// 新定义一个全局SubMyController类， 继承MangoFixSwiftDylibTest模块中的SuperMyController
class SubMyController : @SwiftModule("MangoFixSwiftDylibTest") SuperMyController {

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

- (void)btnDidClicked:(id)btn {
    NSLog(btn);
}

}
