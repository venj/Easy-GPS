//
//  GFPoint.h
//  iGolf
//
//  Created by venj on 13-8-28.
//  Copyright (c) 2013年 Dong Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @class GFPoint
 @brief A point object which represent a real posion on earth (Geographical point).
 */
@interface GFPoint : NSObject <MKAnnotation>
/*!
 @property x
 @brief Latitude of the Geographic point.
 */
@property (nonatomic, assign) double x; // latitude
/*!
 @property y
 @brief Longitude of the Geographic point.
 */
@property (nonatomic, assign) double y; // longitude
/*!
 @brief Degault initializer for <code>GFPoint</code>.
 @return An point object of coordinate: (0,0).
 */
// MKAnnotation
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
- (instancetype)init;
/*!
 @brief Initializer for <code>GFPoint</code> using an <code>CGPoint</code> object.
 @param p A CGPoint object.
 @return An point object. If the string cannot separate into two parts, it will return a point (0,0).
 */
- (instancetype)initWithCGPoint:(CGPoint)p;
/*!
 @brief Initializer for <code>GFPoint</code> using an string object separated by a comma (,).
 @param str String object contains point coordinate, like "32.1, 121.5".
 @return An point object. If the string cannot separate into two parts, it will return a point (0,0).
 */
- (instancetype)initWithCoordinateString:(NSString *)str; // 从字符串@"12.22,33.22"
/*!
 @brief Initializer for <code>GFPoint</code> using an string object separated by a string.
 @param str String object contains point coordinate.
 @param separate String that separate latitude and longitude.
 @return An point object. If the string cannot separate into two parts, it will return a point (0,0).
 */
- (instancetype)initWithCoordinateString:(NSString *)str separate:(NSString *)separate;
/*!
 @brief Initializer for <code>GFPoint</code> using an array with two string members.
 @param array An array contains two string objects.
 @return An point object. If array is not contains two strings, it will return a point (0,0).
 */
- (instancetype)initWithCoordinationArray:(NSArray *)array;
/*!
 @brief Designated initializer for <code>GFPoint</code>, which returns an object represent a geographical coordinate.
 @param lat Latitude of the geo point.
 @param lng Longitude of the geo point.
 @return <code>GFPoint</code> object.
 */
- (instancetype)initWithLatitude:(double)lat longitude:(double)lng;
/*!
 @brief Class method that returns an array of GFPoints.
 @param array Coordinates array.
 @return An mutable array contains variable number of GFPoint objects.
 */
+ (NSMutableArray *)arrayWithDictionaryArray:(NSArray *)array;
/*!
 @brief This method returns an CGPoint representation of the GFPoint.
 @return A CGPoint representation.
 */
- (CGPoint)cGPoint;
/*!
 @brief This method returns an Core Location Coordinate representation for GFPoint. Also make the class conform to <code>MKAnnotation</code> protocal.
 @return A <code>CLLocationCoordinate2D</code> representation.
 */
- (CLLocationCoordinate2D)coordinate;
@end
