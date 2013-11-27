//
//  UIDevice+Golfamily.h
//  iGolf
//
//  Created by venj on 13-8-27.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @class UIDevice+Golfamily
 @brief Extend native <code>UIDevice</code> class.
 */
@interface UIDevice (Golfamily)
/*!
 @brief This method is used for detect iOS major version number.
 @return The major version number for current iOS device.
 */
- (NSUInteger)deviceSystemMajorVersion;
@end
