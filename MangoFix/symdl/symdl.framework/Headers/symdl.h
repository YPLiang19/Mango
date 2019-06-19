//
//  symdl.h
//  symdl
//
//  Created by yongpengliang on 2019/5/30.
//  Copyright © 2019 yongpengliang. All rights reserved.
//

#ifndef symdl_h
#define symdl_h

#if !defined(SYMLD_EXPORT)
#define SYMLD_VISIBILITY __attribute__((visibility("hidden")))
#else
#define SYMLD_VISIBILITY __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif //__cplusplus
    SYMLD_VISIBILITY
    void * symdl(const char * symbol);
    
#ifdef __cplusplus
}
#endif //__cplusplus


#endif /* symdl_h */
