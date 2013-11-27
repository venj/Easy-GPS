//
//  GFSharedObject.h
//  iGolf
//
//  Created by venj on 13-8-27.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @class GFSharedObject
 @brief Thread-safe singleton with GCD (Grand Central Dispatch). This class meant for subclass to add more properties.
 */
@interface GFSharedObject : NSObject
/*!
 @brief This method used to return the singleton instance.
 @return Singleton object.
 */
+ (instancetype)sharedInstance;
@end
