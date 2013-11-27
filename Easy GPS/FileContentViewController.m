//
//  FileContentViewController.m
//  Easy GPS
//
//  Created by shulei on 13-11-21.
//  Copyright (c) 2013年 Venj Chu. All rights reserved.
//

#import "FileContentViewController.h"

@interface FileContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FileContentViewController

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
    self.title = [self.path lastPathComponent];
    self.textView.text = [self readFileContent];
}

- (NSString *)readFileContent {
    NSString *str = [NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:nil];
    return str;
}

- (IBAction)reloadFileContent:(id)sender {
    self.textView.text = [self readFileContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
