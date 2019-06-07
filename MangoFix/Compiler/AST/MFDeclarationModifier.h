//
//  test.h
//  MangoFix
//
//  Created by yongpengliang on 2019/5/2.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#ifndef MFDeclarationModifier_h
#define MFDeclarationModifier_h

typedef NS_OPTIONS(NSUInteger,MFDeclarationModifier) {
    MFDeclarationModifierNone       = 1,
    MFDeclarationModifierStrong     = 1 << 1,
    MFDeclarationModifierWeak       = 1 << 2,
    MFDeclarationModifierStatic     = 1 << 3,
};
#endif /* MFDeclarationModifier_h */
