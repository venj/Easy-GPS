//
//  DeviceGeometry.h
//  iGolf
//
//  Created by venj on 12-9-28.
//  Copyright (c) 2012年 com.emobilesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFSharedObject.h"

@interface DeviceGeometry : GFSharedObject
@property (nonatomic, readonly, assign) NSInteger mapAreaWidth;
@property (nonatomic, readonly, assign) NSInteger mapAreaHeight;
@property (nonatomic, readonly, assign) NSInteger mapCenterX;
@property (nonatomic, readonly, assign) NSInteger mapCenterY;
@end
