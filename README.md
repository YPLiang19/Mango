# Mango
Mango is a DSL which syntax is very like to Objective-C，Mango is also an iOS  App hotfix SDK. You can use Mango method replace any Objective-C method.


# Example
```objc
import "AppDelegate.h"
#import "mango.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mg"];
    NSURL *scriptUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",path]];
    MMANontext *context = [[MMANontext alloc] init];
    [context evalAnanasScriptWithURL:scriptUrl];
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

```java
class ViewController:UIViewController{

- (UIView *)genView{
    UIView *view = UIView.alloc().initWithFrame:(CGRectMake(50, 100, 150, 200));
    view.backgroundColor = UIColor.redColor();
    return view;
}

}

```

# Installation

# Usage
## Objective-C

1. #import "mango.h"
2. exec Mango Script by [context evalAnanasScriptWithSourceString:@""];

```objc
MMANontext *context = [[MMANontext alloc] init];
// exec mango file from network
[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://xxx/demo.mg"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [context evalAnanasScriptWithSourceString:script];
}];
	
// exec local mango file
NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
[context evalAnanasScriptWithSourceString:script];
```




