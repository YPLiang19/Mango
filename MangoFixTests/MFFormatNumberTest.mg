
class MFFormatNumberTest : NSObject{

- (NSString *)testFormatNumber{
NSString *f1 = fmt_num(@"%d",@(255));
NSString *f2 = fmt_num(@"%o",@(255));
NSString *f3 = fmt_num(@"%x",@(255));
NSString *f4 = fmt_num(@"%X",@(255));

NSString *f5 = fmt_num(@"%ld",@(255));
NSString *f6 = fmt_num(@"%lo",@(255));
NSString *f7 = fmt_num(@"%lx",@(255));
NSString *f8 = fmt_num(@"%lX",@(255));

NSString *f9 = fmt_num(@"%lld",@(255));
NSString *f10 = fmt_num(@"%llo",@(255));
NSString *f11 = fmt_num(@"%llx",@(255));
NSString *f12 = fmt_num(@"%llX",@(255));

NSString *f13 = fmt_num(@"%f",@(255));
NSString *f14 = fmt_num(@"%lf",@(255));

NSString *f15 = fmt_num(@"%.02f",@(255));
NSString *f16 = fmt_num(@"%.02lf",@(255));

return f1 + @"-" + f2 + @"-" + f3 + @"-" + f4 + @"-" + f5 + @"-" + f6 + @"-" + f7 + @"-" + f8 + @"-" + f9 + @"-" + f10 + @"-" + f11 + @"-" + f12 + @"-" + f13 + @"-" + f14 + @"-" + f15 + @"-" + f16;

}

}
