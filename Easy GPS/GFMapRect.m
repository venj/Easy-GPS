//
//  GFMapRect.m
//  iGolf
//
//  Created by venj on 13-8-28.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#import "GFMapRect.h"
#import "GFPoint.h"

@implementation GFMapRect

- (instancetype)initWithArray:(NSArray *)arr{
    return [self initWithArray:arr separate:@" "];
}

- (instancetype)initWithArray:(NSArray *)arr separate:(NSString *)separate{
    self = [super init];
    if (self) {
        if ([arr isKindOfClass:[NSArray class]] && arr.count >= 4) {
            _p0 = [[GFPoint alloc] initWithCoordinateString:arr[0] separate:separate];
            _p1 = [[GFPoint alloc] initWithCoordinateString:arr[1] separate:separate];
            _p2 = [[GFPoint alloc] initWithCoordinateString:arr[2] separate:separate];
            _p3 = [[GFPoint alloc] initWithCoordinateString:arr[3] separate:separate];
        }
        else {
            _p0 = nil;
            _p1 = nil;
            _p2 = nil;
            _p3 = nil;
        }
    }
    return self;
}

@end
