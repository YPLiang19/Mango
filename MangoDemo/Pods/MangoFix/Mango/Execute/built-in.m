//
//  built-in.m
//  mangoExample
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "man_ast.h"
#import "runenv.h"

static void add_built_in_struct_declare(){
	MANStructDeclareTable *table = [MANStructDeclareTable shareInstance];
	
	MANStructDeclare *cgPoinerStructDeclare = [[MANStructDeclare alloc] initWithName:@"CGPoint" typeEncoding:"{CGPoint=dd}" keys:@[@"x",@"y"]];
	[table addStructDeclare:cgPoinerStructDeclare];
	
	MANStructDeclare *cgSizeStructDeclare = [[MANStructDeclare alloc] initWithName:@"CGSize" typeEncoding:"{CGSize=dd}" keys:@[@"width",@"height"]];
	[table addStructDeclare:cgSizeStructDeclare];
	
	MANStructDeclare *cgRectStructDeclare = [[MANStructDeclare alloc] initWithName:@"CGRect" typeEncoding:"{CGRect={CGPoint=dd}{CGSize=dd}}" keys:@[@"origin",@"size"]];
	[table addStructDeclare:cgRectStructDeclare];
	
	MANStructDeclare *cgAffineTransformStructDeclare = [[MANStructDeclare alloc] initWithName:@"CGAffineTransform" typeEncoding:"{CGAffineTransform=dddddd}" keys:@[@"a",@"b",@"c", @"d", @"tx", @"ty"]];
	[table addStructDeclare:cgAffineTransformStructDeclare];
	
	MANStructDeclare *cgVectorStructDeclare = [[MANStructDeclare alloc] initWithName:@"CGVector" typeEncoding:"{CGVector=dd}" keys:@[@"dx",@"dy"]];
	[table addStructDeclare:cgVectorStructDeclare];
	
	MANStructDeclare *nsRangeStructDeclare = [[MANStructDeclare alloc] initWithName:@"NSRange" typeEncoding:"{_NSRange=QQ}" keys:@[@"location",@"length"]];
	[table addStructDeclare:nsRangeStructDeclare];
	
	MANStructDeclare *uiOffsetStructDeclare = [[MANStructDeclare alloc] initWithName:@"UIOffset" typeEncoding:"{UIOffset=dd}" keys:@[@"horizontal",@"vertical"]];
	[table addStructDeclare:uiOffsetStructDeclare];
	
	MANStructDeclare *uiEdgeInsetsStructDeclare = [[MANStructDeclare alloc] initWithName:@"UIEdgeInsets" typeEncoding:"{UIEdgeInsets=dddd}" keys:@[@"top",@"left",@"bottom",@"right"]];
	[table addStructDeclare:uiEdgeInsetsStructDeclare];
	
	MANStructDeclare *caTransform3DStructDeclare = [[MANStructDeclare alloc] initWithName:@"CATransform3D" typeEncoding:"" keys:@[@"m11",@"m12",@"m13",@"m14",@"m21",@"m22",@"m23",@"m24",@"m31",@"m32",@"m33",@"m34",@"41",@"m42",@"m43",@"m44",]];
	[table addStructDeclare:caTransform3DStructDeclare];
	
}

static void add_gcd_build_in(MANInterpreter *inter){
	[inter.commonScope setValue:[MANValue valueInstanceWithInt:DISPATCH_QUEUE_PRIORITY_HIGH] withIndentifier:@"DISPATCH_QUEUE_PRIORITY_HIGH"];
	[inter.commonScope setValue:[MANValue valueInstanceWithInt:DISPATCH_QUEUE_PRIORITY_DEFAULT] withIndentifier:@"DISPATCH_QUEUE_PRIORITY_DEFAULT"];
	[inter.commonScope setValue:[MANValue valueInstanceWithInt:DISPATCH_QUEUE_PRIORITY_LOW] withIndentifier:@"DISPATCH_QUEUE_PRIORITY_LOW"];
	[inter.commonScope setValue:[MANValue valueInstanceWithInt:DISPATCH_QUEUE_PRIORITY_BACKGROUND] withIndentifier:@"DISPATCH_QUEUE_PRIORITY_BACKGROUND"];
	
	[inter.commonScope setValue:[MANValue valueInstanceWithUint:DISPATCH_TIME_FOREVER] withIndentifier:@"DISPATCH_TIME_FOREVER"];
	[inter.commonScope setValue:[MANValue valueInstanceWithInt:DISPATCH_TIME_NOW] withIndentifier:@"DISPATCH_TIME_NOW"];
	
	[inter.commonScope setValue:[MANValue valueInstanceWithObject:DISPATCH_QUEUE_CONCURRENT] withIndentifier:@"DISPATCH_QUEUE_CONCURRENT"];
	[inter.commonScope setValue:[MANValue valueInstanceWithPointer:NULL] withIndentifier:@"DISPATCH_QUEUE_SERIAL"];
	
	[inter.commonScope setValue:[MANValue valueInstanceWithUint:NSEC_PER_SEC] withIndentifier:@"NSEC_PER_SEC"];
	[inter.commonScope setValue:[MANValue valueInstanceWithUint:NSEC_PER_MSEC] withIndentifier:@"NSEC_PER_MSEC"];
	[inter.commonScope setValue:[MANValue valueInstanceWithUint:USEC_PER_SEC] withIndentifier:@"USEC_PER_SEC"];
	[inter.commonScope setValue:[MANValue valueInstanceWithUint:NSEC_PER_USEC] withIndentifier:@"NSEC_PER_USEC"];
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^dispatch_time_t (dispatch_time_t when, int64_t delta){
		 return dispatch_time(when, delta);
	}] withIndentifier:@"dispatch_time"];
	
	/* queue */
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^id(long identifier, unsigned long flags) {
		return dispatch_get_global_queue(identifier, flags);
	}]withIndentifier:@"dispatch_get_global_queue"];
	

	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^id() {
		return dispatch_get_main_queue();
	}]withIndentifier:@"dispatch_get_main_queue"];

	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^id(const char *queueName, dispatch_queue_attr_t attr) {
		dispatch_queue_t queue = dispatch_queue_create(queueName, attr);
		return queue;
	}] withIndentifier:@"dispatch_queue_create"];
	
	
	/* dispatch & dispatch_barrier */
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_queue_t queue, void (^block)(void)) {
		dispatch_async(queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_async"];
	
	
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_queue_t queue, void (^block)(void)) {
		dispatch_sync(queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_sync"];
	
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_queue_t queue, void (^block)(void)) {
		dispatch_barrier_async(queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_barrier_async"];
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_queue_t queue, void (^block)(void)) {
		dispatch_barrier_sync(queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_barrier_sync"];
	

	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(size_t iterations, dispatch_queue_t queue, void (^block)(size_t)) {
		dispatch_apply(iterations, queue, ^(size_t index) {
			block(index);
		});
	}] withIndentifier:@"dispatch_apply"];
	
	
	
	/* dispatch_group */
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^id() {
		dispatch_group_t group = dispatch_group_create();
		return group;
	}] withIndentifier:@"dispatch_group_create"];
	
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_group_t group, dispatch_queue_t queue, void (^block)(void)) {
		dispatch_group_async(group, queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_group_async"];
	
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_group_t group,  dispatch_time_t timeout) {
		dispatch_group_wait(group, timeout);
	}] withIndentifier:@"dispatch_group_wait"];
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_group_t group, dispatch_queue_t queue, void (^block)(void)) {
		dispatch_group_notify(group, queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_group_notify"];
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_group_t group) {
		dispatch_group_enter(group);
	}] withIndentifier:@"dispatch_group_enter"];
	
	[inter.commonScope setValue:[MANValue valueInstanceWithBlock:^void(dispatch_group_t group) {
		dispatch_group_leave(group);
	}] withIndentifier:@"dispatch_group_leave"];
}

static void add_build_in_function(MANInterpreter *interpreter){
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGPoint(CGFloat x, CGFloat y){
		return CGPointMake(x, y);
	}] withIndentifier:@"CGPointMake"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGSize(CGFloat width, CGFloat height){
		return CGSizeMake(width, height);
	}] withIndentifier:@"CGSizeMake"];
	
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGRect (CGFloat x, CGFloat y, CGFloat width, CGFloat height){
		return CGRectMake(x, y, width, height);
	}] withIndentifier:@"CGRectMake"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^NSRange(NSUInteger loc, NSUInteger len){
		return NSMakeRange(loc, len);
	}] withIndentifier:@"NSMakeRange"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^UIOffset(CGFloat horizontal, CGFloat vertical){
		return UIOffsetMake(horizontal, vertical);
	}] withIndentifier:@"UIOffsetMake"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^UIEdgeInsets(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
		return UIEdgeInsetsMake(top, left, bottom, right);
	}] withIndentifier:@"UIEdgeInsetsMake"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGVector(CGFloat dx, CGFloat dy){
		return CGVectorMake(dx, dy);
	}] withIndentifier:@"CGVectorMake"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^ CGAffineTransform(CGFloat a, CGFloat b, CGFloat c, CGFloat d, CGFloat tx, CGFloat ty){
		return CGAffineTransformMake(a, b, c, d, tx, ty);
	}] withIndentifier:@"CGAffineTransformMake"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGAffineTransform(CGFloat sx, CGFloat sy){
		return CGAffineTransformMakeScale(sx, sy);
	}] withIndentifier:@"CGAffineTransformMakeScale"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGAffineTransform(CGFloat angle){
		return CGAffineTransformMakeRotation(angle);
	}] withIndentifier:@"CGAffineTransformMakeRotation"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGAffineTransform(CGFloat tx, CGFloat ty){
		return CGAffineTransformMakeTranslation(tx, ty);
	}] withIndentifier:@"CGAffineTransformMakeTranslation"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGAffineTransform(CGAffineTransform t, CGFloat angle){
		return CGAffineTransformRotate(t, angle);
	}] withIndentifier:@"CGAffineTransformRotate"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGAffineTransform(CGAffineTransform t1, CGAffineTransform t2){
		return CGAffineTransformConcat(t1,t2);
	}] withIndentifier:@"CGAffineTransformConcat"];
	
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGAffineTransform(CGAffineTransform t, CGFloat sx, CGFloat sy){
		return CGAffineTransformScale(t, sx, sy);
	}] withIndentifier:@"CGAffineTransformScale"];
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGAffineTransform(CGAffineTransform t, CGFloat tx, CGFloat ty){
		return CGAffineTransformTranslate(t, tx, ty);
	}] withIndentifier:@"CGAffineTransformTranslate"];

	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CGAffineTransform(NSString * _Nonnull string){
		return CGAffineTransformFromString(string);
	}] withIndentifier:@"CGAffineTransformFromString"];

	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^CATransform3D(CGFloat sx, CGFloat sy, CGFloat sz){
		return CATransform3DMakeScale(sx, sy, sz);
	}] withIndentifier:@"CATransform3DMakeScale"];
	
	
	[interpreter.commonScope setValue:[MANValue valueInstanceWithBlock:^void (id obj){
		NSLog(@"%@",obj);
	}] withIndentifier:@"NSLog"];
	
}
static void add_build_in_var(MANInterpreter *inter){
	[inter.commonScope setValue:[MANValue valueInstanceWithObject:NSRunLoopCommonModes] withIndentifier:@"NSRunLoopCommonModes"];
	[inter.commonScope setValue:[MANValue valueInstanceWithObject:NSDefaultRunLoopMode] withIndentifier:@"NSDefaultRunLoopMode"];
	
	
	[inter.commonScope setValue:[MANValue valueInstanceWithDouble:M_PI] withIndentifier:@"M_PI"];
	[inter.commonScope setValue:[MANValue valueInstanceWithDouble:M_PI_2] withIndentifier:@"M_PI_2"];
	[inter.commonScope setValue:[MANValue valueInstanceWithDouble:M_PI_4] withIndentifier:@"M_PI_4"];
	[inter.commonScope setValue:[MANValue valueInstanceWithDouble:M_1_PI] withIndentifier:@"M_1_PI"];
	[inter.commonScope setValue:[MANValue valueInstanceWithDouble:M_2_PI] withIndentifier:@"M_2_PI"];
	
	UIDevice *device = [UIDevice currentDevice];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	[inter.commonScope setValue:[MANValue valueInstanceWithObject:device.systemVersion] withIndentifier:@"$systemVersion"];
	[inter.commonScope setValue:[MANValue valueInstanceWithObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"]] withIndentifier:@"$appVersion"];
	[inter.commonScope setValue:[MANValue valueInstanceWithObject:[infoDictionary objectForKey:@"CFBundleVersion"]] withIndentifier:@"$buildVersion"];
	
}

void mango_add_built_in(MANInterpreter *inter){
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		add_built_in_struct_declare();
		add_build_in_function(inter);
		add_build_in_var(inter);
		add_gcd_build_in(inter);
	});
	
}
