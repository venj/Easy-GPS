//
//  DeviceGeometry.m
//  iGolf
//
//  Created by venj on 12-9-28.
//  Copyright (c) 2012年 com.emobilesoft. All rights reserved.
//

#import "DeviceGeometry.h"
#import "UIDevice+Golfamily.h"

#define UI_TAB_BAR_HEIGHT 49
#define UI_STATUS_BAR_HEIGHT 20

@implementation DeviceGeometry
- (NSInteger)mapAreaWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

- (NSInteger)mapAreaHeight {
    NSInteger screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if ([[UIDevice currentDevice] deviceSystemMajorVersion] < 7)
        return screenHeight - UI_TAB_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT;
    else
        return screenHeight;
}

- (NSInteger)mapCenterX {
    return [self mapAreaWidth] / 2;
}

- (NSInteger)mapCenterY {
    return [self mapAreaHeight] / 2;
}
@end
