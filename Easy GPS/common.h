//
//  common.h
//  iGolf
//
//  Created by venj on 13-9-6.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#ifndef iGolf_common_h
#define iGolf_common_h

// Convenient Macros
#define ccp(__X__,__Y__) CGPointMake(__X__,__Y__)
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180.)
#define RADIANS_TO_DEGREES(r) (r * 180. / M_PI)
#define NullDIC2DIC(_VAL_,_TVAL_,_DEF_) [_VAL_ isKindOfClass:[NSNull class]] ? _DEF_ : _TVAL_
#define LOG_BOOL(VALUE) NSLog(@"%@", (VALUE) ? @"YES" : @"NO" )
#define YARDRATE 1.093613298

#endif
