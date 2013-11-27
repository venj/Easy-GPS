//
//  GFMapRect.h
//  iGolf
//
//  Created by venj on 13-8-28.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GFPoint;
@interface GFMapRect : NSObject

@property (nonatomic, strong) GFPoint *p0; // 上左
@property (nonatomic, strong) GFPoint *p1; // 上右
@property (nonatomic, strong) GFPoint *p2; // 下左
@property (nonatomic, strong) GFPoint *p3; // 下右
- (instancetype)initWithArray:(NSArray *)arr;
- (instancetype)initWithArray:(NSArray *)arr separate:(NSString *)separate;

@end
