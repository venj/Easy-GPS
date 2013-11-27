//
//  SecondViewController.m
//  Easy GPS
//
//  Created by Venj Chu on 13-11-18.
//  Copyright (c) 2013年 Venj Chu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "DistanceCalculateViewController.h"
#import "GeoAlgorithm.h"
#import "common.h"
#import "GFPoint.h"
#import "MapViewController.h"

@interface DistanceCalculateViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *fromLatField;
@property (weak, nonatomic) IBOutlet UITextField *fromLngField;
@property (weak, nonatomic) IBOutlet UITextField *toLatField;
@property (weak, nonatomic) IBOutlet UITextField *toLngField;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation DistanceCalculateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Distance";
//    self.fromLatField.text = @"30.0000";
//    self.fromLngField.text = @"120.0000";
//    self.toLatField.text = @"31.0000";
//    self.toLngField.text = @"120.0000";
    [self.infoLabel adjustsFontSizeToFitWidth];
    [self.distanceLabel adjustsFontSizeToFitWidth];
    if (!self.manager) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [self.manager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.manager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.manager startUpdatingLocation];
}

- (IBAction)getCurrentLocation:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.toLatField.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.latitude];
        self.toLngField.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.longitude];
    });
}

- (IBAction)calculateDistance:(id)sender {
    CGFloat fromLat = [[self.fromLatField text] doubleValue];
    CGFloat fromLng = [[self.fromLngField text] doubleValue];
    CGFloat toLat = [[self.toLatField text] doubleValue];
    CGFloat toLng = [[self.toLngField text] doubleValue];
    [self.fromLatField resignFirstResponder];
    [self.fromLngField resignFirstResponder];
    [self.toLatField resignFirstResponder];
    [self.toLngField resignFirstResponder];
    if (fromLng == 0.0 || fromLng == 0.0 || toLat == 0.0 || toLng == 0.0) {
        return;
    }
    GFPoint *from = [[GFPoint alloc] initWithLatitude:fromLat longitude:fromLng];
    GFPoint *to = [[GFPoint alloc] initWithLatitude:toLat longitude:toLng];
    CGFloat distance = [GeoAlgorithm getDistanceFromPoint:from toPoint:to];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f yd / %.2f m", fabs(distance), fabs(distance) / YARDRATE];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:newLocation.timestamp];
    self.infoLabel.text = [[NSString alloc] initWithFormat:@"Alt: %.2f H-Acc: %.2f V-Acc: %.2f", newLocation.altitude, newLocation.horizontalAccuracy, newLocation.verticalAccuracy];
    self.infoLabel.adjustsFontSizeToFitWidth = YES;
    self.currentLocation = newLocation;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"from_to_map"]) {
        GFPoint *p = [[GFPoint alloc] initWithLatitude:[self.fromLatField.text doubleValue] longitude:[self.fromLngField.text doubleValue]];
        [(MapViewController *)segue.destinationViewController setCurrentPoint:p];
    }
    if ([[segue identifier] isEqualToString:@"to_to_map"]) {
        GFPoint *p = [[GFPoint alloc] initWithLatitude:[self.toLatField.text doubleValue] longitude:[self.toLngField.text doubleValue]];
        [(MapViewController *)segue.destinationViewController setCurrentPoint:p];
    }
}

@end
