# Mango
Mango is a DSL which syntax is very similar to Objective-C，Mango is also an iOS  App hotfix SDK. You can use Mango method replace any Objective-C method.


## Example
```objc
import "AppDelegate.h"
#import "mango.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mg"];
    NSURL *scriptUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",path]];
    MMANontext *context = [[MMANontext alloc] init];
    [context evalMangoScriptWithURL:scriptUrl];
    return YES;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self genView]];
}

- (UIView *)genView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 150, 200)];
    return view;
}

@end

```

```objc
class ViewController:UIViewController{

- (UIView *)genView{
    UIView *view = UIView.alloc().initWithFrame:(CGRectMake(50, 100, 150, 200));
    view.backgroundColor = UIColor.redColor();
    return view;
}

}

```

## Installation

## Usage
### Objective-C

1. `#import "mango.h"`
2. `exec Mango Script by [context evalMangoScriptWithSourceString:@""];`

```objc
MMANontext *context = [[MMANontext alloc] init];
// exec mango file from network
[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://xxx/demo.mg"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [context evalMangoScriptWithSourceString:script];
}];
	
// exec local mango file
NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
[context evalMangoScriptWithSourceString:script];
```

### Mango
#### Quick start

```objc

class ViewController:UIViewController {

- (void)sequentialStatementExample{
    //变量定义
    NSString *text = @"";
    int a = 3.0;
    double b = 2.0;

    text +=  @"a = " + a + @"\n";
    text +=  @"b = " + b + @"\n";

    //加法运算
    double c = a + b;
    text += @"a + b = " + c + "\n";

    //减法运算
    double d = a - b;
    text += @"a - b = " + d + "\n";

    //乘法运算
    double e = a * b;
    text += @" a * b = " + e + "\n";

    //除法运算
    double f = a / b;
    text += @"f = " + f + "\n";

    //取模运算，只能操作整型变量
    int g = a % 2;
    text += @"a % 2 = " + g + "\n";

    //+=运算
    a += b;
    text +=  @"a += b = " + a + @"\n";

    //-=运算
    a -= b;
    text +=  @"a -= b = " + a + @"\n";

    //*=运算
    a *= b;
    text +=  @"a *= b = " + a + @"\n";

    // /=运算
    a /= b;
    text +=  @"a /= b = " + a + @"\n";

    //%=运算
    a %= 2;
    text +=  @"a %= 2 = " + a + @"\n";

    //三目运算
    double  h = a > b ? a : b;
    text += @"a > b ? a : b = " + h + "\n";

    //自增运算 不支持 ++a
    a++;
    text += @"a++ = " + a + "\n";
    //自减运算 不支持 --a
    a--;
    text += @"a-- = " + a + "\n";


    //数组操作，Mango对于泛型尚未支持
    NSArray *arr = @[@"zhao", @"qian", @"sun", @"li"];
    NSString *e2 = arr[2];
    text += @"e2 = " + e2 + @"\n";


    NSMutableArray *arrM = @[@"zhao", @"qian", @"sun", @"li"].mutableCopy();
    arrM[2] = @"sun2";
    e2 = arrM[2];
    text += @"e2 = " + e2 + @"\n";

    //字典操作
    NSDictionary *dic = @{@"zhang":@"san",@"li":@"si",@"wang":@"wu",@"zhao":@"liu"};
    NSString *liValue = dic[@"li"];
    text += @"liValue = " + liValue + @"\n";


    NSMutableDictionary *dicM =  @{@"zhang":@"san",@"li":@"si",@"wang":@"wu",@"zhao":@"liu"}.mutableCopy();
    dicM[@"li"] = @"si2";
    liValue = dicM[@"li"];
    text += @"liValue = " + liValue + @"\n";

    //结构体变量定义时要在前面加struct关键字
    struct CGRect rect = {origin:{x:50,y:100},size:{width:150,height:200}}; //等效于 CGRectMake(50, 100, 150, 200)
    text += @"rect = x:" + rect.origin.x + @", y:" + rect.origin.y + @", width" + rect.size.width + @", " + rect.size.height;


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
      if(i == 10){ //if后面即使是单行语句，花括号也不可以省略
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

//Block定示例
- (void)blockStatementExample{
    Block catStringBlock = ^NSString *(NSString *str1, NSString *str2){
      NSString *result = str1.stringByAppendingString:(str2);
      return result;
    };
    NSString *result = catStringBlock(@"hello ", @"world!");
    self.resultView.text = result;
}

//定义接受方法参数示例
- (void)paramPassingExampleWithBOOLArg:(BOOL)BOOLArg intArg:(int) intArg uintArg:(uint)uintArg structArg:(struct CGRect)structArg blockArg:(Block)blockArg objArg:(id)objArg {
    NSString *text = @"";
    text += @"BOOLArg:" + BOOLArg + @",\n";
    text += @"intArg:" + intArg + @",\n";
    text += @"uintArg:" + uintArg + @",\n";
    text += @"structArg:" + structArg + @",\n";
    text += @"Block执行结果:" + blockArg(@"hello", @"mango") + @"\n";
    text += @"objArg:" + objArg;
    self.resultView.text = text;
}

//返回值示例
- (Block)returnBlockExample{
    NSString *prefix = @"mango: ";
    Block catStringBlock = ^NSString *(NSString *str1, NSString *str2){
      NSString *result = str1.stringByAppendingString:(str2);
      return prefix + result;
    };
    return catStringBlock;
}


- (void)createAndOpenNewViewControllerExample{
  SubRotateAnimationExampleController *vc = SubRotateAnimationExampleController.alloc().init();
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
		NSLog(@"dispatch_async");
	});
	dispatch_sync(queue, ^{
		NSLog(@"dispatch_sync");
	});
}

}


class SubRotateAnimationExampleController:UIViewController {
@property (strong, nonatomic) UIView *rotateView;
- (void)viewDidLoad {
  super.viewDidLoad();
  self.title = @"Magno 创建自定义ViewController";
  self.view.backgroundColor = UIColor.whiteColor();
  double width = 100;
  double height = 100;
  double x = self.view.frame.size.width/2 - width/2;
  double y = self.view.frame.size.height/2 - height/2;
  UIView *view = UIView.alloc().initWithFrame:(CGRectMake(x, y, width, height));
  self.view.addSubview:(view);
  view.backgroundColor = UIColor.redColor();
  self.rotateView = view;
  Block block= ^(NSTimer *timer) {
    UIView.animateWithDuration:animations:(0.25,^(){
      self.rotateView.transform = CGAffineTransformRotate(self.rotateView.transform, M_PI);
    });
  };
  NSTimer *timer = NSTimer.timerWithTimeInterval:repeats:block:(0.25, YES, block);
  NSRunLoop.currentRunLoop().addTimer:forMode:(timer,NSRunLoopCommonModes);
}

}

```

#### Mango Type usage
 Mango support type as fllow: 
 
##### void
  	equivalent to Objective-C `void`.
	
#### BOOL
  	equivalent to Objective-C `BOOL`.
	
##### uint
	equivalent to Objective-C `unsigned char`、`unsigned short`、`unsigned int`、`unsigned long`、`unsigned long long`、`NSUInteger`. 
	  
#### int
  	equivalent to Objective-C `char`、`short`、`int`、`long`、`long long`、`NSInteger`. 
	
##### double
  	equivalent to Objective-C `double`、`float`、`CGFloat`. 
	
#### id
  	equivalent to Objective-C `id`.
	
#### OCClassName *
  	NSString *str = @"";
	
#### Block
  	Block blokc = ^id(id arg){};
	
#### Class
  	Class clazz = NSString.class();
	
#### struct
  	struct CGRect rect;// must add struct keyword  before structure variables defined.
	
#### Pointer
 	Pointer ptr; // C pointer. 
	
	
