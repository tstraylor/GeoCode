//
//  SatelliteViewController.m
//  GeoCode
//
//  Created by Thomas Traylor on 8/25/13.
//  Copyright (c) 2013 Thomas Traylor. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <QuartzCore/QuartzCore.h>
#import "SatelliteViewController.h"
#import "NetworkActivityIndicator.h"

#if !defined(METERS_PER_MILE)
#define METERS_PER_MILE 1609.344
#endif

@interface SatelliteViewController ()

@property (strong, nonatomic) School *school;
@property (strong, nonatomic) NetworkActivityIndicator *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *satelliteView;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end

@implementation SatelliteViewController

@synthesize school = _school;
@synthesize networkActivityIndicator = _networkActivityIndicator;


#pragma mark - ViewController Lifecycle

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
    
    // setup the school uilabel
    
    NSDictionary *schoolAttr = @{NSFontAttributeName :[UIFont systemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    NSAttributedString *a1 = [[NSAttributedString alloc] initWithString:[self.school name] attributes:schoolAttr];
    self.schoolLabel.attributedText = a1;
    self.schoolLabel.adjustsFontSizeToFitWidth = YES;
    
    // setup the address uilabel
    
    NSDictionary *addressAttr = @{NSFontAttributeName :[UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    
    NSAttributedString *a2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@, %@ %@",
                                                                         [self.school address],
                                                                         [self.school city],
                                                                         [self.school state],
                                                                         [self.school zip]]
                                                             attributes:addressAttr];
    
    self.addressLabel.attributedText = a2;
    self.addressLabel.adjustsFontSizeToFitWidth = YES;
    
    // get the network indicator setup and running.
    self.networkActivityIndicator = [NetworkActivityIndicator getInstance];
    [self.networkActivityIndicator start];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.school location],
                                                               0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region  = region;
    options.mapType = MKMapTypeSatellite;
    //options.mapType = MKMapTypeHybrid;
    options.scale = 1.0;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        options.size = CGSizeMake(728.0, 436.0);
    else
        options.size = CGSizeMake(320.0, 240.0);
    
    options.showsPointsOfInterest = NO;
    
    MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapShotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        NSLog(@"[%@ %@] snap shotter", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        if(error)
            NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        self.satelliteView.image = snapshot.image;

        NSShadow *bg = [[NSShadow alloc] init];
        bg.shadowColor = [UIColor blackColor];
        bg.shadowOffset = CGSizeMake(1.5, 1.5);
        
        NSDictionary *locattr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0],
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSShadowAttributeName: bg};
        
        NSAttributedString *loctext = [[NSAttributedString alloc] initWithString:[self.school name]
                                                                      attributes:locattr];
        
        self.imageLabel.attributedText = loctext;
        self.imageLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.networkActivityIndicator stop];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// when the mapit button is pressed, we will start up the map application with
// the corrdinates of the school selected

- (IBAction)mapItButton:(UIButton *)sender
{
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [self.school.mapItem openInMapsWithLaunchOptions:launchOptions];
}

@end
