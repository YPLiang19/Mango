//
//  MFValue+Private.h
//  MangoFix
//
//  Created by yongpengliang on 2019/3/28.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#import <MangoFix/MangoFix.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFValue (Private)

@property (strong, nonatomic)MFTypeSpecifier *type;

- (instancetype)initWithCValuePointer:(void *)cValuePointer typeEncoding:(const char *)typeEncoding bridgeTransfer:(BOOL)bridgeTransfer;

- (void)assignFrom:(MFValue *)src;
- (void)assignToCValuePointer:(void *)cvaluePointer typeEncoding:(const char *)typeEncoding;
-(nullable void *)valuePointer;
@end

NS_ASSUME_NONNULL_END
