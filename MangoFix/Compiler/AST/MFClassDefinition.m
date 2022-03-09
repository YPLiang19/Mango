//
//  MFClassDefinition.m
//  MangoFix
//
//  Created by jerry.yong on 2017/11/16.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MFClassDefinition.h"

@implementation MFClassDefinition

- (instancetype)init{
	if (self = [super init]) {
		_annotationIfExprResult = AnnotationIfExprResultNoComputed;
	}
	return self;
}

- (MFAnnotation *)superAnnotationByName:(NSString *)annotationName {
    for (MFAnnotation *annotation in self.superAnnotationList) {
        if ([annotation.name isEqualToString:annotationName]) {
            return annotation;
        }
    }
    return nil;
}



- (MFAnnotation *)superSwiftModuleAnnotation {
    return [self superAnnotationByName:@"@SwiftModule"];
}


@end

@implementation MFMemberDefinition

@end

@implementation MFPropertyDefinition

@end

@implementation MFMethodNameItem

@end


@implementation MFMethodDefinition

@end
