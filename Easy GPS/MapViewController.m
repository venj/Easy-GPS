//
//  MapViewController.m
//  Easy GPS
//
//  Created by Venj Chu on 13-11-18.
//  Copyright (c) 2013年 Venj Chu. All rights reserved.
//

#import "MapViewController.h"
#import "GFPoint.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Map";
    if ([self.mapView.annotations count] <= 1) {
        [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
            [self.mapView addAnnotations:@[self.currentPoint]];
            self.mapView.centerCoordinate = self.currentPoint.coordinate;
        } repeats:NO];
    }
    
    if ([[UIDevice currentDevice] deviceSystemMajorVersion] >= 7) {
        CGRect frame = self.mapView.frame;
        self.mapView.frame = CGRectMake(frame.origin.x, frame.origin.y + 64., frame.size.width, frame.size.height - 64.);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return [mapView viewForAnnotation:mapView.userLocation];
    }
    NSString *AnnotationIdentifier = @"StationPin";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        if ([annotation isKindOfClass:[GFPoint class]]) {
            GFPoint *p = (GFPoint *)annotation;
            p.title = [NSString stringWithFormat:@"%8f,%8f", p.coordinate.latitude, p.coordinate.longitude];
        }
    }
    return pinView;
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    [UIView animateWithDuration:2 animations:^{
//        self.mapView.centerCoordinate = userLocation.coordinate;
//    }];
//}

@end
