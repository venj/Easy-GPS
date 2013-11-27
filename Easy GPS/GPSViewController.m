//
//  FirstViewController.m
//  Easy GPS
//
//  Created by Venj Chu on 13-11-18.
//  Copyright (c) 2013年 Venj Chu. All rights reserved.
//

#import "GPSViewController.h"
#import "MapViewController.h"
#import "GFPoint.h"

#define kLatestTimeStamp @"LatestTimeStampKey"

@interface GPSViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *vAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *theNewButton;
@property (weak, nonatomic) IBOutlet UIView *containingView;

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) NSMutableArray *coords;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) NSFileManager *fm;
@property (nonatomic, strong) NSFileHandle *fh;
@property (nonatomic, strong) NSString *path;
@end

@implementation GPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"GPS";
    
    if (!self.manager) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [self.manager startUpdatingLocation];
    if (!self.coords) {
        self.coords = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *latestFileName = [defaults objectForKey:kLatestTimeStamp];
    NSString *fileName;
    if (latestFileName) {
        fileName = (NSString *)latestFileName;
    }
    else {
        fileName = [NSString stringWithFormat:@"Default_%.0f.txt", [[NSDate date] timeIntervalSince1970]];
    }
    
    self.path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    self.fm = [NSFileManager defaultManager];
    if (![self.fm fileExistsAtPath:self.path]) {
        [self.fm createFileAtPath:self.path contents:nil attributes:@{}];
    }
    self.isRecording = NO;
    
    if ([[UIDevice currentDevice] deviceSystemMajorVersion] >= 7) {
        CGRect frame = self.containingView.frame;
        self.containingView.frame = CGRectMake(frame.origin.x, frame.origin.y + 64., frame.size.width, frame.size.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self.manager stopUpdatingLocation];
    [self writeCoordsCacheToFile];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.latitudeLabel.text = [NSString stringWithFormat:@"%.10f", newLocation.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%.10f", newLocation.coordinate.longitude];
    self.altitudeLabel.text = [NSString stringWithFormat:@"%.2f", newLocation.altitude];
    self.hAccuracyLabel.text = [NSString stringWithFormat:@"%.2f", newLocation.horizontalAccuracy];
    self.vAccuracyLabel.text = [NSString stringWithFormat:@"%.2f", newLocation.verticalAccuracy];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:cnLocale];
    self.timeLabel.text = [formatter stringFromDate:newLocation.timestamp];
    self.speedLabel.text = [NSString stringWithFormat:@"%.2f", newLocation.speed];
    self.currentLocation = newLocation;
    
    if (self.isRecording) {
        // Add anyway
        [self.coords addObject:[[NSString alloc] initWithFormat:@"%@,%@,%@,%@,%@,%.0f,%@\n", self.latitudeLabel.text, self.longitudeLabel.text, self.altitudeLabel.text, self.hAccuracyLabel.text, self.vAccuracyLabel.text, [newLocation.timestamp timeIntervalSince1970], self.speedLabel.text]];
        
        if (self.coords && self.coords.count >= 10) {
            [self writeCoordsCacheToFile];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"tomap"]) {
        GFPoint *p = [[GFPoint alloc] initWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
        [(MapViewController *)segue.destinationViewController setCurrentPoint:p];
    }
}

- (IBAction)startRecord:(id)sender {
    if (self.isRecording) { // Pause
        [self writeCoordsCacheToFile]; // Write back to file.
        self.theNewButton.enabled = YES;
        self.isRecording = NO; // Stop it
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    else {
        self.theNewButton.enabled = NO;
        self.isRecording = YES; // Start it
        [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)newFile:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File name" message:@"Please specify a filename for data file:"];
    __weak UIAlertView *weakAlert = alert;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"OK" handler:^{
        NSString *fileName = [NSString stringWithFormat:@"%@.txt", [weakAlert textFieldAtIndex:0].text];
        self.path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
        self.fm = [NSFileManager defaultManager];
        if ([self.fm fileExistsAtPath:self.path]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"File already exists with the same name!"];
            [alert setCancelButtonWithTitle:@"OK" handler:nil];
            [alert show];
        }
        else {
            [self writeCoordsCacheToFile];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:fileName forKey:kLatestTimeStamp];
            if (![self.fm fileExistsAtPath:self.path]) {
                [self.fm createFileAtPath:self.path contents:nil attributes:@{}];
            }
            [self startRecord:nil];
        }
    }];
    [alert setCancelButtonWithTitle:@"Cancel" handler:nil];
    [alert show];
    
}

- (void)writeCoordsCacheToFile {
    if ([self.coords count] == 0) {
        return;
    }
    if (![self.fm fileExistsAtPath:self.path]) {
        // Create file in case file was deleted by file list view controller.
        [self.fm createFileAtPath:self.path contents:nil attributes:@{}];
    }
    self.fh = [NSFileHandle fileHandleForWritingAtPath:self.path];
    [self.fh seekToEndOfFile];
    for (NSString *str in self.coords) {
        [self.fh writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [self.fh closeFile];
    
    [self.coords removeAllObjects];
}

@end
