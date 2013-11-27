//
//  GeometryGPS.m
//  iGolf
//
//  Created by 涛 傅 on 11-12-9.
//  Copyright (c) 2011年 com.ftkey. All rights reserved.
//

#import "GeoAlgorithm.h"
#import "GFPoint.h"
#import "GFMapRect.h"
#import "DeviceGeometry.h"
#import "common.h"

int max(int x, int y);
int min(int x, int y);

int max(int x, int y) {
	return x > y ? x : y;
}

int min(int x, int y) {
	return x < y ? x : y;
}

@implementation GeoAlgorithm

+ (double)getDistanceFromPoint:(GFPoint *)p1 toPoint:(GFPoint *)p2 {
    double randius = EARTH_RADIUS_S + (EARTH_RADIUS_L - EARTH_RADIUS_S) * ((p1.x + p2.x)/180);
    double radLat1 = DEGREES_TO_RADIANS(p1.x);
    double radLat2 = DEGREES_TO_RADIANS(p2.x);
    double a = radLat1 - radLat2;
    double b = DEGREES_TO_RADIANS(p1.y) - DEGREES_TO_RADIANS(p2.y);
    double s = 2 * asin(sqrt(pow(sin(a / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    s = s * randius;
    s = (s * 10000 + 0.5) / 10;
    s = s * 1.093613298f;
    return s;
}

+ (double)getDistanceFromLatitude:(double) lat1 andLongitude:(double)lng1 toLatitude:(double)lat2 andLongitude:(double)lng2 {
    double x = sin(lat1 * PI / 180) * sin(lat2 * PI / 180) + cos(lat1 * PI / 180 ) * cos(lat2 * PI / 180) * cos(fabs((lng2 * PI / 180) - (lng1 * PI / 180)));
    x = acos(x);
    return (1.852 * 60.0 * ((x / PI) * 180) ) / 1.609344;
}

+ (double)getKiloMeterDistanceFromLatitude:(double)lat1 andLongitude:(double)lng1 toLatitude:(double) lat2 andLongitude:(double)lng2 {
    if ((fabs(lat1 - lat2) < 0.000005) && (fabs(lng1 - lng2) < 0.000005)) {
        return 0.0;
    }
    else {
        float dist = [self getDistanceFromLatitude:lat1 andLongitude:lng1 toLatitude:lat2 andLongitude:lng2] * 1.609344;
        return dist;
    }
}

+ (BOOL)isPoint:(GFPoint *)pt inRegion:(NSArray *)regionPoints {
    int jd = 0;
    
    for (int i = 0; i < regionPoints.count; i++) {
        GFPoint *p1 = regionPoints[i];
        GFPoint *p2 = regionPoints[(i + 1) % regionPoints.count];
        
        if(p1.y - p2.y == 0) continue;
        if( p1.y > pt.y && p2.y >= pt.y) continue;
        if(p1.y < pt.y && p2.y <= pt.y) continue;
        if(p1.x < pt.x && p2.x < pt.x) continue;
        
        float lat_tmp = p1.x - (p1.x - p2.x) * (p1.y - pt.y) / (p1.y - p2.y);
        if (lat_tmp > pt.x) jd++;
    } 
    
    if (jd % 2 == 1)
        return YES;
    else
        return NO;
}

+ (int)isCarPoint:(GFPoint *)p inHoleMap:(NSArray *)holeRect andInHoleRegion:(NSArray *)holeDBC {
    GFPoint *p1 = nil, *p2 = nil;
    
    int ret = 0, i = 0, jd = 0;
    float lat_tmp = 0;
    
    for(i = 0; i < [holeRect count]; i++){
        if(i < ([holeRect count] - 1)){
            ret = [[self class] intersection:p withPoint1:holeRect[i] andPoint2:holeRect[i + 1]];
        }
        else{
            ret = [[self class] intersection:p withPoint1:holeRect[i] andPoint2:holeRect[0]];
        }
        if(ret > 0) jd++;
    }
    
    if((jd % 2) == 0) return 3;
    
    jd = 0;
    for(i = 0; i < [holeDBC count]; i++){
        p1 = holeDBC[i];
        if(i < ([holeDBC count] - 1)){
            p2 = holeDBC[i + 1];
        }
        else{
            p2 = holeDBC[0];
        }
        
        if((p1.y - p2.y) == 0) continue;
        if(p1.y > p.y && p2.y >= p.y) continue;
        if(p1.y < p.y && p2.y <= p.y) continue;
        if(p1.x < p.x && p2.x < p.x) continue;
        
        lat_tmp = p1.x - (p1.x - p2.x) * (p1.y - p.y) / (p1.y - p2.y);
        if(lat_tmp > p.x)
            jd++;
    }
    
    if((jd % 2) == 0) return 2;
    else return 1;
}

+ (BOOL)intersection:(GFPoint *)p withPoint1:(GFPoint *)p1 andPoint2:(GFPoint *)p2 {
    float lat_tmp;
    
    if(p1.y - p2.y == 0) return 0;
    if(p1.y > p.y && p2.y >= p.y) return 0;
    if(p1.y < p.y && p2.y <= p.y) return 0;
    if(p1.x < p.x && p2.x < p.x) return 0;
    
    lat_tmp = p1.x - ((p1.x - p2.x) * (p1.y - p.y)) / (p1.y - p2.y);
    
    if(lat_tmp > p.x)
        return YES;
    else
        return NO;
}

+ (GFPoint*)convertToWindowsXY:(GFPoint *)p map:(GFMapRect *)map {
    float x_tmp = 0, y_tmp = 0;
    float a = 0, b = 0, c = 0, d = 0, e = 0;
    
    GFPoint *mapP =[[GFPoint alloc] init];
    a = [[self class] getDistanceFromPoint:p toPoint:map.p3];
    c = [[self class] getDistanceFromPoint:p toPoint:map.p0];
    d = [[self class] getDistanceFromPoint:p toPoint:map.p1];
    b = [[self class] getDistanceFromPoint:map.p0 toPoint:map.p3];
    e = [[self class] getDistanceFromPoint:map.p0 toPoint:map.p1];
    
    //实际坐标
    y_tmp = (b * b + c * c - a * a) / (2 * b);
    x_tmp = (e * e + c * c - d * d) / (2 * e);
    //转换到地图中的坐标
    y_tmp = (y_tmp / b) * [[DeviceGeometry sharedInstance] mapAreaHeight];
    x_tmp = (x_tmp / e) * [[DeviceGeometry sharedInstance] mapAreaWidth];
    //转换到地图显示窗口坐标
    mapP.x = (float)((x_tmp - [[DeviceGeometry sharedInstance] mapCenterX]) / MAP_BL + [[DeviceGeometry sharedInstance] mapAreaWidth] / 2);
    mapP.y = (float)((y_tmp - [[DeviceGeometry sharedInstance] mapCenterY]) / MAP_BL + [[DeviceGeometry sharedInstance] mapAreaHeight] / 2);
    
    return mapP;
}

+ (double)yardPerPointOnMap:(GFMapRect *)map withTeePoint:(GFPoint *)teePoint andGreenPoint:(GFPoint *)greenPoint {
    double geoDistance = [self getDistanceFromPoint:teePoint toPoint:greenPoint];
    GFPoint *teeCoordOnImage = [self convertToWindowsXY:teePoint map:map];
    GFPoint *greenCoordOnImage = [self convertToWindowsXY:greenPoint map:map];
    double mapDistance = sqrt(pow((teeCoordOnImage.x - greenCoordOnImage.x), 2) + pow((teeCoordOnImage.y - greenCoordOnImage.y), 2));
    return geoDistance / mapDistance;
}

@end
