//
//  MapViewController.h
//  Easy GPS
//
//  Created by Venj Chu on 13-11-18.
//  Copyright (c) 2013年 Venj Chu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFPoint;
@interface MapViewController : UIViewController
@property (nonatomic, strong) GFPoint *currentPoint;
@end
