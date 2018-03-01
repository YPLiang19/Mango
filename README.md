# Mango
Mango is a DSL which syntax is very like to Objective-C，Mango is also an iOS  App hotfix SDK. You can use Mango method replace any Objective-C method.

#Example

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mg"];
	NSURL *scriptUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",path]];
	MMANontext *context = [[MMANontext alloc] init];
	[context evalAnanasScriptWithURL:scriptUrl];
	return YES;
}


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

class ViewController:UIViewController{

- (UIView *)genView{
	UIView *view = UIView.alloc().initWithFrame:(CGRectMake(50, 100, 150, 200));
	view.backgroundColor = UIColor.redColor();
	return view;
}

}

