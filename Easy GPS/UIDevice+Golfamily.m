//
//  UIDevice+Golfamily.m
//  iGolf
//
//  Created by venj on 13-8-27.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#import "UIDevice+Golfamily.h"

@implementation UIDevice (Golfamily)
- (NSUInteger)deviceSystemMajorVersion {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[self systemVersion] componentsSeparatedByString:@"."][0] intValue];
    });
    return _deviceSystemMajorVersion;
}
@end
