//
//  GeometryGPS.h
//  iGolf
//
//  Created by 涛 傅 on 11-12-9.
//  Copyright (c) 2011年 com.ftkey. All rights reserved.
//


#import <Foundation/Foundation.h>

#define EARTH_RADIUS_L  6378.137f //地球长半径
#define EARTH_RADIUS_S 6356.755f //地球短半径
#define PI 3.141592653589793f //圆周率

#define MAP_BL 1 //地图实际大小与地图显示区域的比例

#pragma mark - GPS算法
@class GFPoint, GFMapRect;
/*!
 @class GeoAlgorithm
 @brief The class wraps common geographical algorithms.
 */
@interface GeoAlgorithm : NSObject
/*!
 @brief Get real distance with two geo points (geographical coordinate) in yards.
 @param p1 First geo point.
 @param p2 Second geo point.
 @return Distance in yards in double value.
 */
+ (double)getDistanceFromPoint:(GFPoint *)p1 toPoint:(GFPoint *)p2;
/*!
 @brief Another way to get yard distance for two geo points. Same to <code>+getDistanceFromPoint:toPoint:</code>
 @param lat1 Latitude for first geo point.
 @param lng1 Longitude for first geo point.
 @param lat2 Latitude for second geo point.
 @param lng2 Longitude for second geo point.
 @return Distance in yards in double value.
 */
+ (double)getDistanceFromLatitude:(double)lat1 andLongitude:(double)lng1 toLatitude:(double)lat2 andLongitude:(double)lng2;
/*!
 @brief Get real distance with two geo points (geographical coordinate) in kilometers.
 @param lat1 Latitude for first geo point.
 @param lng1 Longitude for first geo point.
 @param lat2 Latitude for second geo point.
 @param lng2 Longitude for second geo point.
 @return Distance in kilometers in double value.
 */
+ (double)getKiloMeterDistanceFromLatitude:(double)lat1 andLongitude:(double)lng1 toLatitude:(double)lat2 andLongitude:(double)lng2;
/*!
 @brief Detect if one point is inside a specific region.
 @param pt A geographical point
 @param regionPoints An array of points represent a specific region.
 @return Returns <code>YES</code> if the point is inside the region, otherwise <code>NO</code>.
 */
+ (BOOL)isPoint:(GFPoint *)pt inRegion:(NSArray *)regionPoints;
/*!
 @brief Detect if a golf car is in the course region.
 @param pt The geographical point represent a golf car.
 @param holeRect Coordinates array for hole map (4 corners of the map).
 @param holeDBC Coordinates array represent effective region for a golf hole.
 @return Returns <code>-1</code> if any error occurs; <code>1</code> if the car is in effective hole region; <code>2</code> if the car in the map but not in effective region; <code>3</code> if the car is outside of the map.
 */
+ (int)isCarPoint:(GFPoint *)pt inHoleMap:(NSArray *)holeRect andInHoleRegion:(NSArray *)holeDBC;
/*!
 @brief Detect whether a point is on the line links two other points.
 @param p The point to detect.
 @param p1 The first point
 @param p2 The second point
 @return Returns <code>YES</code> is p is on the line links p1 and p2, returns <code>NO</code> if otherwise.
 */
+ (BOOL)intersection:(GFPoint *)p withPoint1:(GFPoint *)p1 andPoint2:(GFPoint *)p2;
/*!
 @brief Convert geographical coordinate to device coordinate in pixels (points).
 @param p The geographical point.
 @param map A map (<code>GFMapRect</code>) object.
 @return Device coordinate represented by a CGPoint struct.
 */
+ (GFPoint *)convertToWindowsXY:(GFPoint *)p map:(GFMapRect *)map;
/*!
 @brief Used to calculate the scale of a map (yard/point). Actually <code>teePoint</code> and <code>greenPoint</code> can be any two geographical points.
 @param map A map (<code>GFMapRect</code>) object.
 @param teePoint Coordinate for any Tee.
 @param greenPoint Coordinate for Green Center.
 @return Scale of the map in yard/point.
 */
+ (double)yardPerPointOnMap:(GFMapRect *)map withTeePoint:(GFPoint *)teePoint andGreenPoint:(GFPoint *)greenPoint;

@end
