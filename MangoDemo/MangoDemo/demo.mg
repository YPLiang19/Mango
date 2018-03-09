/**
demo.mg
*/

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

+ (void)classMethodExapleWithInstance:(ViewController *)vc{
	vc.resultView.text = @"here is Mango  Class Method " + self;
}

#If($systemVersion.doubleValue() > 12.0 )
- (void)conditionsAnnotationExample{
self.resultView.text = @"here is Mango method";
}

- (void)testObjectDealloc{
	TextObject *obj = TextObject.alloc().init();
}

}



class SubRotateAnimationExampleController:SuperRotateAnimationExampleController {
@property (strong, nonatomic) UIView *rotateView;
- (void)viewDidLoad {
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
