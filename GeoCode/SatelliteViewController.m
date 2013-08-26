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

@interface SatelliteViewController ()

@property (strong, nonatomic) School *school;
@property (strong, nonatomic) NetworkActivityIndicator *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapItButton;

@end

@implementation SatelliteViewController

@synthesize school = _school;
@synthesize networkActivityIndicator = _networkActivityIndicator;
@synthesize mapView = _mapView;
@synthesize schoolLabel = _schoolLabel;
@synthesize mapItButton = _mapItButton;

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
    self.schoolLabel.text = self.school.name;
    self.schoolLabel.textColor = [UIColor whiteColor];
    self.schoolLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20.0f];
    
    // setup the map it uibutton
    self.mapItButton.titleLabel.text = @"Map It";
    self.mapItButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20.0f];
    self.mapItButton.titleLabel.textColor = [UIColor yellowColor];
    self.mapItButton.backgroundColor = [UIColor clearColor];

    // get the network indicator setup and running.
    self.networkActivityIndicator = [NetworkActivityIndicator getInstance];
    [self.networkActivityIndicator start];

    // setup the map
    self.mapView.delegate = self;
    self.mapView.centerCoordinate = self.school.location;
    NSLog(@"[%@ %@] %f %f", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.school.location.latitude, self.school.location.longitude);
    self.mapView.mapType = MKMapTypeSatellite;
    MKCoordinateRegion region;
    region.center.latitude = self.school.location.latitude;
    region.center.longitude = self.school.location.longitude;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    [self.mapView setRegion:region animated:YES];
    
    [self.networkActivityIndicator stop];
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
