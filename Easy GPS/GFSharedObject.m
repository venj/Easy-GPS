//
//  GFSharedObject.m
//  iGolf
//
//  Created by venj on 13-8-27.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#import "GFSharedObject.h"

@implementation GFSharedObject
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
@end
