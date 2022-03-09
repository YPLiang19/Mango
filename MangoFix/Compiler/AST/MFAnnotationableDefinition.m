//
//  MFAnnotationDefinition.m
//  MangoFix
//
//  Created by 雍鹏亮 on 2022/3/9.
//

#import "MFAnnotationableDefinition.h"

@implementation MFAnnotationableDefinition

- (MFAnnotation *)annotationByName:(NSString *)annotationName {
    for (MFAnnotation *annotation in self.annotationList) {
        if ([annotation.name isEqualToString:annotationName]) {
            return annotation;
        }
    }
    return nil;
}

- (MFAnnotation *)ifAnnotation {
    MFAnnotation *annnotation = [self annotationByName:@"@If"];
    if (!annnotation) {
        annnotation = [self annotationByName:@"#If"];
    }
    return annnotation;
}

- (MFAnnotation *)swiftModuleAnnotation {
    return [self annotationByName:@"@SwiftModule"];
}

- (MFAnnotation *)selectorNameAnnotation {
    MFAnnotation *annnotation =  [self annotationByName:@"@MethodName"];
    if (!annnotation) {
        annnotation = [self annotationByName:@"@Selector"];
    }
    return annnotation;
}

@end
