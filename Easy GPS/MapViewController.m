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
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentControl;

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
    self.title = NSLocalizedString(@"Map", @"Map");
    [self.mapTypeSegmentControl setTitle:NSLocalizedString(@"Map", @"Map") forSegmentAtIndex:0];
    [self.mapTypeSegmentControl setTitle:NSLocalizedString(@"Satellite", @"Satellite") forSegmentAtIndex:1];
    [self.mapTypeSegmentControl setTitle:NSLocalizedString(@"Hybrid", @"Hybrid") forSegmentAtIndex:2];
    
    if ([self.mapView.annotations count] <= 1) {
        [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
            [self.mapView addAnnotations:@[self.currentPoint]];
        } repeats:NO];
        
        CGFloat height = 0.01;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.75 * height, height);
        CLLocationCoordinate2D centerCoord = self.currentPoint.coordinate;
        MKCoordinateRegion visibleRegion = MKCoordinateRegionMake(centerCoord, span);
        [self.mapView setRegion:visibleRegion animated:YES];
    }
    
    self.mapTypeSegmentControl.selectedSegmentIndex = 0;
    
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

- (IBAction)mapTypeChanged:(id)sender {
    NSInteger index = [sender selectedSegmentIndex];
    if (index == 2) {
        self.mapView.mapType = MKMapTypeHybrid;
    }
    else if (index == 1) {
        self.mapView.mapType = MKMapTypeSatellite;
    }
    else {
        self.mapView.mapType = MKMapTypeStandard;
    }
}

@end
