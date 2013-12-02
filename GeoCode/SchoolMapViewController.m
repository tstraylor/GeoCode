//
//  SchoolMapViewController.m
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

#import "SchoolMapViewController.h"
#import "NetworkActivityIndicator.h"


@interface SchoolMapViewController ()

@property (nonatomic, strong) School *school;
@property (nonatomic, strong) NetworkActivityIndicator *networkActivityIndicator;

@end

@implementation SchoolMapViewController

@synthesize school = _school;
@synthesize networkActivityIndicator = _networkActivityIndicator;

#pragma mark - Setters

-(void)setSchool:(School *)school
{
    _school = school;
}

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
    
    // set the title to the name of the school
    //self.title = self.school.name;
    
    // get the network indicator setup and running.
    self.networkActivityIndicator = [NetworkActivityIndicator getInstance];

    [self schoolAnnotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Map View School

- (void)schoolAnnotations
{
    // clear any pins that are on the map
    [self.mapView removeAnnotations:self.mapView.annotations];
 
    NSString *fullAddress = [self.school fullAddress];
    NSLog(@"[%@ %@] fullAddress: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), fullAddress);
    
    // start the network indicator
    [self.networkActivityIndicator start];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:fullAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSLog(@"[%@ %@] placemarks count: %d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [placemarks count]);
        
        for (CLPlacemark* clPlacemark in placemarks)
        {
            NSLog(@"[%@ %@] Postal Code: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [clPlacemark postalCode]);
            [self.school setLocation:[clPlacemark.location coordinate]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.mapView.centerCoordinate = self.school.location;
            self.mapView.zoomEnabled = YES;
            [self.mapView addAnnotation:(id<MKAnnotation>)self.school];
            [self updateRegion];
            // stop the network indicator
            [self.networkActivityIndicator stop];
            
        });

    }];

}

#pragma mark - Segue

// sent to the mapView's delegate (us) when any {left,right}CalloutAccessoryView

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"SchoolLocation" sender:view];
}

// prepares a view controller segued to via the setSchool: segue
//   by calling setSchool: with the photo associated with sender

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"SchoolLocation"])
    {
        if ([sender isKindOfClass:[MKAnnotationView class]])
        {
            MKAnnotationView *aView = sender;
            if ([aView.annotation isKindOfClass:[School class]])
            {
                School *school = aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setSchool:)])
                {
                    [segue.destinationViewController performSelector:@selector(setSchool:) withObject:school];
                }
            }
        }
    }    
}


@end
