//
//  built-in.m
//  MangoFix
//
//  Created by jerry.yong on 2018/2/28.
//  Copyright © 2018年 yongpengliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mf_ast.h"
#import "runenv.h"

static void add_built_in_struct_declare(){
	MFStructDeclareTable *table = [MFStructDeclareTable shareInstance];
	
	MFStructDeclare *cgPoinerStructDeclare = [[MFStructDeclare alloc] initWithName:@"CGPoint" typeEncoding:"{CGPoint=dd}" keys:@[@"x",@"y"]];
	[table addStructDeclare:cgPoinerStructDeclare];
	
	MFStructDeclare *cgSizeStructDeclare = [[MFStructDeclare alloc] initWithName:@"CGSize" typeEncoding:"{CGSize=dd}" keys:@[@"width",@"height"]];
	[table addStructDeclare:cgSizeStructDeclare];
	
	MFStructDeclare *cgRectStructDeclare = [[MFStructDeclare alloc] initWithName:@"CGRect" typeEncoding:"{CGRect={CGPoint=dd}{CGSize=dd}}" keys:@[@"origin",@"size"]];
	[table addStructDeclare:cgRectStructDeclare];
	
	MFStructDeclare *cgAffineTransformStructDeclare = [[MFStructDeclare alloc] initWithName:@"CGAffineTransform" typeEncoding:"{CGAffineTransform=dddddd}" keys:@[@"a",@"b",@"c", @"d", @"tx", @"ty"]];
	[table addStructDeclare:cgAffineTransformStructDeclare];
	
	MFStructDeclare *cgVectorStructDeclare = [[MFStructDeclare alloc] initWithName:@"CGVector" typeEncoding:"{CGVector=dd}" keys:@[@"dx",@"dy"]];
	[table addStructDeclare:cgVectorStructDeclare];
	
	MFStructDeclare *nsRangeStructDeclare = [[MFStructDeclare alloc] initWithName:@"NSRange" typeEncoding:"{_NSRange=QQ}" keys:@[@"location",@"length"]];
	[table addStructDeclare:nsRangeStructDeclare];
	
	MFStructDeclare *uiOffsetStructDeclare = [[MFStructDeclare alloc] initWithName:@"UIOffset" typeEncoding:"{UIOffset=dd}" keys:@[@"horizontal",@"vertical"]];
	[table addStructDeclare:uiOffsetStructDeclare];
	
	MFStructDeclare *uiEdgeInsetsStructDeclare = [[MFStructDeclare alloc] initWithName:@"UIEdgeInsets" typeEncoding:"{UIEdgeInsets=dddd}" keys:@[@"top",@"left",@"bottom",@"right"]];
	[table addStructDeclare:uiEdgeInsetsStructDeclare];
	
	MFStructDeclare *caTransform3DStructDeclare = [[MFStructDeclare alloc] initWithName:@"CATransform3D" typeEncoding:"{CATransform3D=dddddddddddddddd}" keys:@[@"m11",@"m12",@"m13",@"m14",@"m21",@"m22",@"m23",@"m24",@"m31",@"m32",@"m33",@"m34",@"41",@"m42",@"m43",@"m44",]];
	[table addStructDeclare:caTransform3DStructDeclare];
	
}

static void add_gcd_build_in(MFInterpreter *inter){
	/* queue */
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_QUEUE_PRIORITY_HIGH] withIndentifier:@"DISPATCH_QUEUE_PRIORITY_HIGH"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_QUEUE_PRIORITY_DEFAULT] withIndentifier:@"DISPATCH_QUEUE_PRIORITY_DEFAULT"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_QUEUE_PRIORITY_LOW] withIndentifier:@"DISPATCH_QUEUE_PRIORITY_LOW"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_QUEUE_PRIORITY_BACKGROUND] withIndentifier:@"DISPATCH_QUEUE_PRIORITY_BACKGROUND"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithObject:DISPATCH_QUEUE_CONCURRENT] withIndentifier:@"DISPATCH_QUEUE_CONCURRENT"];
    [inter.commonScope setValue:[MFValue valueInstanceWithPointer:NULL] withIndentifier:@"DISPATCH_QUEUE_SERIAL"];
    
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^id(long identifier, unsigned long flags) {
		return dispatch_get_global_queue(identifier, flags);
	}]withIndentifier:@"dispatch_get_global_queue"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^id() {
		return dispatch_get_main_queue();
	}]withIndentifier:@"dispatch_get_main_queue"];

	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^id(const char *queueName, dispatch_queue_attr_t attr) {
		dispatch_queue_t queue = dispatch_queue_create(queueName, attr);
		return queue;
	}] withIndentifier:@"dispatch_queue_create"];
	
	
	/* dispatch & dispatch_barrier */
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^(dispatch_time_t when, dispatch_queue_t  _Nonnull queue, dispatch_block_t block){
        dispatch_after(when, queue, block);
    }] withIndentifier:@"dispatch_after"];
    
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_queue_t queue, void (^block)(void)) {
		dispatch_async(queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_async"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_queue_t queue, void (^block)(void)) {
		dispatch_sync(queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_sync"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_queue_t queue, void (^block)(void)) {
		dispatch_barrier_async(queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_barrier_async"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_queue_t queue, void (^block)(void)) {
		dispatch_barrier_sync(queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_barrier_sync"];

	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(size_t iterations, dispatch_queue_t queue, void (^block)(size_t)) {
		dispatch_apply(iterations, queue, ^(size_t index) {
			block(index);
		});
	}] withIndentifier:@"dispatch_apply"];
	
	
	
	/* dispatch_group */
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^id() {
		dispatch_group_t group = dispatch_group_create();
		return group;
	}] withIndentifier:@"dispatch_group_create"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_group_t group, dispatch_queue_t queue, void (^block)(void)) {
		dispatch_group_async(group, queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_group_async"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_group_t group,  dispatch_time_t timeout) {
		dispatch_group_wait(group, timeout);
	}] withIndentifier:@"dispatch_group_wait"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_group_t group, dispatch_queue_t queue, void (^block)(void)) {
		dispatch_group_notify(group, queue, ^{
			block();
		});
	}] withIndentifier:@"dispatch_group_notify"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_group_t group) {
		dispatch_group_enter(group);
	}] withIndentifier:@"dispatch_group_enter"];
	
	[inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_group_t group) {
		dispatch_group_leave(group);
	}] withIndentifier:@"dispatch_group_leave"];
    
    
    /*dispatch_block*/
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_BLOCK_BARRIER] withIndentifier:@"DISPATCH_BLOCK_BARRIER"];
     [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_BLOCK_DETACHED] withIndentifier:@"DISPATCH_BLOCK_DETACHED"];
     [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_BLOCK_ASSIGN_CURRENT] withIndentifier:@"DISPATCH_BLOCK_ASSIGN_CURRENT"];
     [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_BLOCK_NO_QOS_CLASS] withIndentifier:@"DISPATCH_BLOCK_NO_QOS_CLASS"];
     [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_BLOCK_INHERIT_QOS_CLASS] withIndentifier:@"DISPATCH_BLOCK_INHERIT_QOS_CLASS"];
     [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_BLOCK_ENFORCE_QOS_CLASS] withIndentifier:@"DISPATCH_BLOCK_ENFORCE_QOS_CLASS"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^dispatch_block_t(dispatch_block_flags_t flags, dispatch_block_t block){
       return dispatch_block_create(flags, block);
    }] withIndentifier:@"dispatch_block_create"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^dispatch_block_t(dispatch_block_flags_t flags,
                                                                                  dispatch_qos_class_t qos_class, int relative_priority,
                                                                                  dispatch_block_t block){
        return dispatch_block_create_with_qos_class(flags, qos_class, relative_priority, block);
    }] withIndentifier:@"dispatch_block_create_with_qos_class"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_block_flags_t flags,
                                                                                   dispatch_block_t block){
        dispatch_block_perform(flags, block);
    }] withIndentifier:@"dispatch_block_perform"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^long(dispatch_block_t block, dispatch_time_t timeout){
        return dispatch_block_wait(block, timeout);
    }] withIndentifier:@"dispatch_block_wait"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_block_t block, dispatch_queue_t queue,
                                                                       dispatch_block_t notification_block){
        dispatch_block_notify(block, queue, notification_block);
    }] withIndentifier:@"dispatch_block_notify"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^long(dispatch_block_t block){
        return dispatch_block_testcancel(block);
    }] withIndentifier:@"dispatch_block_testcancel"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_block_t block){
         dispatch_block_cancel(block);
    }] withIndentifier:@"dispatch_block_cancel"];
    
    
    /*dispatch_semaphore*/
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^id(long value){
        return dispatch_semaphore_create(value);
    }] withIndentifier:@"dispatch_semaphore_create"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^long(dispatch_semaphore_t dsema, dispatch_time_t timeout){
        return dispatch_semaphore_wait(dsema, timeout);
    }] withIndentifier:@"dispatch_semaphore_wait"];

    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^long(dispatch_semaphore_t dsema){
        return dispatch_semaphore_signal(dsema);
    }] withIndentifier:@"dispatch_semaphore_signal"];
    
    
    /*dispatch_time*/
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:NSEC_PER_SEC] withIndentifier:@"NSEC_PER_SEC"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:NSEC_PER_MSEC] withIndentifier:@"NSEC_PER_MSEC"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:USEC_PER_SEC] withIndentifier:@"USEC_PER_SEC"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:NSEC_PER_USEC] withIndentifier:@"NSEC_PER_USEC"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:DISPATCH_TIME_FOREVER] withIndentifier:@"DISPATCH_TIME_FOREVER"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:DISPATCH_TIME_NOW] withIndentifier:@"DISPATCH_TIME_NOW"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^dispatch_time_t (dispatch_time_t when, int64_t delta){
        return dispatch_time(when, delta);
    }] withIndentifier:@"dispatch_time"];

    
    /*dispatch_object*/
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_object_t object){
        dispatch_resume(object);
    }] withIndentifier:@"dispatch_resume"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_object_t object){
        dispatch_suspend(object);
    }] withIndentifier:@"dispatch_suspend"];
    
  
    /*dispatch_source*/
    [inter.commonScope setValue:[MFValue valueInstanceWithPointer:(void *)DISPATCH_SOURCE_TYPE_PROC] withIndentifier:@"DISPATCH_SOURCE_TYPE_PROC"];
    [inter.commonScope setValue:[MFValue valueInstanceWithPointer:(void *)DISPATCH_SOURCE_TYPE_READ] withIndentifier:@"DISPATCH_SOURCE_TYPE_READ"];
    [inter.commonScope setValue:[MFValue valueInstanceWithPointer:(void *)DISPATCH_SOURCE_TYPE_SIGNAL] withIndentifier:@"DISPATCH_SOURCE_TYPE_SIGNAL"];
    [inter.commonScope setValue:[MFValue valueInstanceWithPointer:(void *)DISPATCH_SOURCE_TYPE_TIMER] withIndentifier:@"DISPATCH_SOURCE_TYPE_TIMER"];
    [inter.commonScope setValue:[MFValue valueInstanceWithPointer:(void *)DISPATCH_SOURCE_TYPE_VNODE] withIndentifier:@"DISPATCH_SOURCE_TYPE_VNODE"];
    [inter.commonScope setValue:[MFValue valueInstanceWithPointer:(void *)DISPATCH_SOURCE_TYPE_WRITE] withIndentifier:@"DISPATCH_SOURCE_TYPE_WRITE"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^dispatch_source_t (dispatch_source_type_t type,
                                                                                  uintptr_t handle,
                                                                                  unsigned long mask,
                                                                                  dispatch_queue_t _Nullable queue){
        return dispatch_source_create(type, handle, mask, queue);
    }] withIndentifier:@"dispatch_source_create"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_source_t source,
                                                                                    dispatch_block_t handler){
        dispatch_source_set_event_handler(source, handler);
    }] withIndentifier:@"dispatch_source_set_event_handler"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_source_t source,
                                                                      dispatch_block_t handler){
        dispatch_source_set_cancel_handler(source, handler);
    }] withIndentifier:@"dispatch_source_set_cancel_handler"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_source_t source){
        dispatch_source_cancel(source);
    }] withIndentifier:@"dispatch_source_cancel"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^long(dispatch_source_t source){
        return dispatch_source_testcancel(source);
    }] withIndentifier:@"dispatch_source_testcancel"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^uintptr_t(dispatch_source_t source){
        return dispatch_source_get_handle(source);
    }] withIndentifier:@"dispatch_source_get_handle"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^unsigned long(dispatch_source_t source){
        return dispatch_source_get_mask(source);
    }] withIndentifier:@"dispatch_source_get_mask"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^unsigned long(dispatch_source_t source){
        return dispatch_source_get_data(source);
    }] withIndentifier:@"dispatch_source_get_data"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_source_t source, unsigned long value){
        dispatch_source_merge_data(source,value);
    }] withIndentifier:@"dispatch_source_merge_data"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_source_t source,
                                                                      dispatch_time_t start,
                                                                      uint64_t interval,
                                                                      uint64_t leeway){
        dispatch_source_set_timer(source, start, interval, leeway);
    }] withIndentifier:@"dispatch_source_set_timer"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_source_t source,
                                                                      dispatch_block_t _Nullable handler){
        dispatch_source_set_registration_handler(source, handler);
    }] withIndentifier:@"dispatch_source_set_registration_handler"];
    
    
    /*dispatch_once*/
    [inter.commonScope setValue:[MFValue valueInstanceWithBlock:^void(dispatch_once_t *onceTokenPtr,
                                                                      dispatch_block_t _Nullable handler){
        dispatch_once(onceTokenPtr,handler);
    }] withIndentifier:@"dispatch_once"];
    
    
    
    
}

static void add_build_in_function(MFInterpreter *interpreter){
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGPoint(CGFloat x, CGFloat y){
		return CGPointMake(x, y);
	}] withIndentifier:@"CGPointMake"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGSize(CGFloat width, CGFloat height){
		return CGSizeMake(width, height);
	}] withIndentifier:@"CGSizeMake"];
	
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGRect (CGFloat x, CGFloat y, CGFloat width, CGFloat height){
		return CGRectMake(x, y, width, height);
	}] withIndentifier:@"CGRectMake"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^NSRange(NSUInteger loc, NSUInteger len){
		return NSMakeRange(loc, len);
	}] withIndentifier:@"NSMakeRange"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^UIOffset(CGFloat horizontal, CGFloat vertical){
		return UIOffsetMake(horizontal, vertical);
	}] withIndentifier:@"UIOffsetMake"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^UIEdgeInsets(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
		return UIEdgeInsetsMake(top, left, bottom, right);
	}] withIndentifier:@"UIEdgeInsetsMake"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGVector(CGFloat dx, CGFloat dy){
		return CGVectorMake(dx, dy);
	}] withIndentifier:@"CGVectorMake"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^ CGAffineTransform(CGFloat a, CGFloat b, CGFloat c, CGFloat d, CGFloat tx, CGFloat ty){
		return CGAffineTransformMake(a, b, c, d, tx, ty);
	}] withIndentifier:@"CGAffineTransformMake"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGAffineTransform(CGFloat sx, CGFloat sy){
		return CGAffineTransformMakeScale(sx, sy);
	}] withIndentifier:@"CGAffineTransformMakeScale"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGAffineTransform(CGFloat angle){
		return CGAffineTransformMakeRotation(angle);
	}] withIndentifier:@"CGAffineTransformMakeRotation"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGAffineTransform(CGFloat tx, CGFloat ty){
		return CGAffineTransformMakeTranslation(tx, ty);
	}] withIndentifier:@"CGAffineTransformMakeTranslation"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGAffineTransform(CGAffineTransform t, CGFloat angle){
		return CGAffineTransformRotate(t, angle);
	}] withIndentifier:@"CGAffineTransformRotate"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGAffineTransform(CGAffineTransform t1, CGAffineTransform t2){
		return CGAffineTransformConcat(t1,t2);
	}] withIndentifier:@"CGAffineTransformConcat"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGAffineTransform(CGAffineTransform t, CGFloat sx, CGFloat sy){
		return CGAffineTransformScale(t, sx, sy);
	}] withIndentifier:@"CGAffineTransformScale"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGAffineTransform(CGAffineTransform t, CGFloat tx, CGFloat ty){
		return CGAffineTransformTranslate(t, tx, ty);
	}] withIndentifier:@"CGAffineTransformTranslate"];

	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGAffineTransform(NSString * _Nonnull string){
		return CGAffineTransformFromString(string);
	}] withIndentifier:@"CGAffineTransformFromString"];

	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CATransform3D(CGFloat sx, CGFloat sy, CGFloat sz){
		return CATransform3DMakeScale(sx, sy, sz);
	}] withIndentifier:@"CATransform3DMakeScale"];
    
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGFloat(CGRect rect){
        return CGRectGetWidth(rect);
    }] withIndentifier:@"CGRectGetWidth"];
    
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGFloat(CGRect rect){
        return CGRectGetHeight(rect);
    }] withIndentifier:@"CGRectGetHeight"];
    
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGFloat(CGRect rect){
        return CGRectGetMinX(rect);
    }] withIndentifier:@"CGRectGetMinX"];
    
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGFloat(CGRect rect){
        return CGRectGetMidX(rect);
    }] withIndentifier:@"CGRectGetMidX"];
    
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGFloat(CGRect rect){
        return CGRectGetMaxX(rect);
    }] withIndentifier:@"CGRectGetMaxX"];
    
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGFloat(CGRect rect){
        return CGRectGetMinY(rect);
    }] withIndentifier:@"CGRectGetMinY"];
    
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGFloat(CGRect rect){
        return CGRectGetMidY(rect);
    }] withIndentifier:@"CGRectGetMidY"];
    
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^CGFloat(CGRect rect){
        return CGRectGetMaxY(rect);
    }] withIndentifier:@"CGRectGetMaxY"];
	
	[interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^void (id obj){
		NSLog(@"%@",obj);
	}] withIndentifier:@"NSLog"];
    
    
    //Specifier: d, o, u, x, or X
    //Length modifier: l, ll
    [interpreter.commonScope setValue:[MFValue valueInstanceWithBlock:^NSString *(NSString * _Nonnull format, NSNumber *num){
        if (format.length < 2){
            goto err;
        }
        if (![format hasPrefix:@"%"]) {
            goto err;
        }
        if ([format hasSuffix:@"lld"]) {
            return [NSString stringWithFormat:format,num.longLongValue];
        }
        if ([format hasSuffix:@"llu"] || [format hasSuffix:@"llo"] || [format hasSuffix:@"llx"] || [format hasSuffix:@"llX"]) {
            return [NSString stringWithFormat:format,num.unsignedLongLongValue];
        }
        
        if ([format hasSuffix:@"ld"]) {
            return [NSString stringWithFormat:format,num.longValue];
        }
        if ([format hasSuffix:@"lu"] || [format hasSuffix:@"lo"] || [format hasSuffix:@"lx"] || [format hasSuffix:@"lX"]) {
            return [NSString stringWithFormat:format,num.unsignedLongValue];
        }
        
        if ([format hasSuffix:@"d"]) {
            return [NSString stringWithFormat:format,num.intValue];
        }
        
        if ([format hasSuffix:@"u"] || [format hasSuffix:@"o"] || [format hasSuffix:@"x"] || [format hasSuffix:@"X"]) {
            return [NSString stringWithFormat:format,num.unsignedIntValue];
        }
        
        if ([format hasSuffix:@"lf"]) {
            return [NSString stringWithFormat:format,num.doubleValue];
        }
        
        if ([format hasSuffix:@"f"]) {
            return [NSString stringWithFormat:format,num.floatValue];
        }
        err: mf_throw_error(0, MFRuntimeErrorNotSupportNumberFormat, @"not support format %@",format);
        return nil;
    }] withIndentifier:@"fmt_num"];
	
}
static void add_build_in_var(MFInterpreter *inter){
	[inter.commonScope setValue:[MFValue valueInstanceWithObject:NSRunLoopCommonModes] withIndentifier:@"NSRunLoopCommonModes"];
	[inter.commonScope setValue:[MFValue valueInstanceWithObject:NSDefaultRunLoopMode] withIndentifier:@"NSDefaultRunLoopMode"];

	[inter.commonScope setValue:[MFValue valueInstanceWithDouble:M_PI] withIndentifier:@"M_PI"];
	[inter.commonScope setValue:[MFValue valueInstanceWithDouble:M_PI_2] withIndentifier:@"M_PI_2"];
	[inter.commonScope setValue:[MFValue valueInstanceWithDouble:M_PI_4] withIndentifier:@"M_PI_4"];
	[inter.commonScope setValue:[MFValue valueInstanceWithDouble:M_1_PI] withIndentifier:@"M_1_PI"];
	[inter.commonScope setValue:[MFValue valueInstanceWithDouble:M_2_PI] withIndentifier:@"M_2_PI"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchDown] withIndentifier:@"UIControlEventTouchDown"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchDownRepeat] withIndentifier:@"UIControlEventTouchDownRepeat"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchDragInside] withIndentifier:@"UIControlEventTouchDragInside"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchDragOutside] withIndentifier:@"UIControlEventTouchDragOutside"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchDragEnter] withIndentifier:@"UIControlEventTouchDragEnter"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchDragExit] withIndentifier:@"UIControlEventTouchDragExit"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchUpInside] withIndentifier:@"UIControlEventTouchUpInside"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchUpOutside] withIndentifier:@"UIControlEventTouchUpOutside"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventTouchCancel] withIndentifier:@"UIControlEventTouchCancel"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventValueChanged] withIndentifier:@"UIControlEventValueChanged"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:1 << 13] withIndentifier:@"UIControlEventPrimaryActionTriggered"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventEditingDidBegin] withIndentifier:@"UIControlEventEditingDidBegin"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventEditingChanged] withIndentifier:@"UIControlEventEditingChanged"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventEditingDidEnd] withIndentifier:@"UIControlEventEditingDidEnd"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventEditingDidEndOnExit] withIndentifier:@"UIControlEventEditingDidEndOnExit"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventAllTouchEvents] withIndentifier:@"UIControlEventAllTouchEvents"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventAllEditingEvents] withIndentifier:@"UIControlEventAllEditingEvents"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventApplicationReserved] withIndentifier:@"UIControlEventApplicationReserved"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventSystemReserved] withIndentifier:@"UIControlEventSystemReserved"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlEventAllEvents] withIndentifier:@"UIControlEventAllEvents"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:UIControlContentVerticalAlignmentCenter] withIndentifier:@"UIControlContentVerticalAlignmentCenter"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:UIControlContentVerticalAlignmentTop] withIndentifier:@"UIControlContentVerticalAlignmentTop"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:UIControlContentVerticalAlignmentBottom] withIndentifier:@"UIControlContentVerticalAlignmentBottom"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:UIControlContentVerticalAlignmentFill] withIndentifier:@"UIControlContentVerticalAlignmentFill"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:UIControlContentHorizontalAlignmentCenter] withIndentifier:@"UIControlContentHorizontalAlignmentCenter"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:UIControlContentHorizontalAlignmentLeft] withIndentifier:@"UIControlContentHorizontalAlignmentLeft"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:UIControlContentHorizontalAlignmentRight] withIndentifier:@"UIControlContentHorizontalAlignmentRight"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:UIControlContentHorizontalAlignmentFill] withIndentifier:@"UIControlContentHorizontalAlignmentFill"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:4] withIndentifier:@"UIControlContentHorizontalAlignmentLeading"];
    [inter.commonScope setValue:[MFValue valueInstanceWithInt:5] withIndentifier:@"UIControlContentHorizontalAlignmentTrailing"];
    
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlStateNormal] withIndentifier:@"UIControlStateNormal"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlStateHighlighted] withIndentifier:@"UIControlStateHighlighted"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlStateDisabled] withIndentifier:@"UIControlStateDisabled"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlStateSelected] withIndentifier:@"UIControlStateSelected"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:1 << 3] withIndentifier:@"UIControlStateFocused"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlStateApplication] withIndentifier:@"UIControlStateApplication"];
    [inter.commonScope setValue:[MFValue valueInstanceWithUint:UIControlStateReserved] withIndentifier:@"UIControlStateReserved"];
	
	UIDevice *device = [UIDevice currentDevice];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	[inter.commonScope setValue:[MFValue valueInstanceWithObject:device.systemVersion] withIndentifier:@"$systemVersion"];
	[inter.commonScope setValue:[MFValue valueInstanceWithObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"]] withIndentifier:@"$appVersion"];
	[inter.commonScope setValue:[MFValue valueInstanceWithObject:[infoDictionary objectForKey:@"CFBundleVersion"]] withIndentifier:@"$buildVersion"];
    
#if defined(__LP64__) && __LP64__
    BOOL is32BitDevice = NO;
#else
    BOOL is32BitDevice = YES;
#endif
    [inter.commonScope setValue:[MFValue valueInstanceWithBOOL:is32BitDevice ] withIndentifier:@"$is32BitDevice"];;
    
	
}

void mf_add_built_in(MFInterpreter *inter){
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		add_built_in_struct_declare();
		add_build_in_function(inter);
		add_build_in_var(inter);
		add_gcd_build_in(inter);
	});
	
}
