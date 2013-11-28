//
//  GFPoint.m
//  iGolf
//
//  Created by venj on 13-8-28.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#import "GFPoint.h"

@implementation GFPoint

- (instancetype)init {
    return [self initWithCoordinateString:@"0,0"];
}

- (instancetype)initWithCGPoint:(CGPoint)p {
    return self;
}

- (instancetype)initWithCoordinateString:(NSString *)str {
    return [self initWithCoordinateString:str separate:@","];
}

- (instancetype)initWithCoordinateString:(NSString *)str separate:(NSString *)separate {
    return [self initWithCoordinationArray:[str componentsSeparatedByString:separate]];
}

- (instancetype)initWithCoordinationArray:(NSMutableArray *)array {
    double lat, lng;
    if ([array isKindOfClass:[NSArray class]] && array.count >= 2) {
        lat = [array[0] doubleValue];
        lng = [array[1] doubleValue];
    }
    else {
        lat = 0;
        lng = 0;
    }
    return [self initWithLatitude:lat longitude:lng];
}

- (instancetype)initWithLatitude:(double)lat longitude:(double)lng {
    self = [super init];
    if (self) {
        _x = lat;
        _y = lng;
    }
    return self;
}

+ (NSMutableArray *)arrayWithDictionaryArray:(NSArray *)array {
    if ([array isKindOfClass:[NSArray class]]) {
        if ([array count] > 0) {
            NSMutableArray *returnObject = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSArray *arr_i in array) {
                NSMutableArray *returnObject1 = [[NSMutableArray alloc] initWithCapacity:0];
                
                for (id arr_y in arr_i) {
                    if ([arr_y isKindOfClass:[NSArray class]]) {
                        id point = [[[self class] alloc] initWithCoordinationArray:(NSArray *)arr_y];
                        [returnObject1 addObject:point];
                    }
                    else if ([arr_y isKindOfClass:[NSString class]]) {
                        [returnObject1 addObject:arr_y];
                    }
                }
                
                id first = returnObject1[0];
                [returnObject1 addObject:first];
                [returnObject addObject:returnObject1];
            }
            return returnObject;
        }
    }
    return nil;
}

- (CGPoint)cGPoint {
    if (self.x && self.y) {
        return CGPointMake(self.x, self.y);
    }
    else {
        return CGPointMake(0, 0);
    }
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.x, self.y);
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:NSLocalizedString(@"(Lat: %f, Lng: %f)", @"(Lat: %f, Lng: %f)"), self.x, self.y];
}

@end
