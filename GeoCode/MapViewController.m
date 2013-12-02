//
//  MapViewController.m
//  GeoCode
//
//  Created by Thomas Traylor on 8/2/13.
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

#import "MapViewController.h"
#import "School+MKAnnotation.h"

@interface MapViewController ()

@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic) BOOL needUpdateRegion;

@end

@implementation MapViewController

@synthesize currentLocation = _currentLocation;
@synthesize needUpdateRegion = _needUpdateRegion;

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

    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    self.needUpdateRegion = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.needUpdateRegion)
        [self updateRegion];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    MKAnnotationView *view = nil;
    static NSString *schoolId = @"SchoolPin";

    //if the annotation is a user location
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        // we don't want a pin dropped here.
        view = nil;
    }
    else
    {
        if([annotation isKindOfClass:[School class]])
        {
            NSLog(@"[%@ %@] its a SchoolPin", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:schoolId];
            NSLog(@"[%@ %@] annotation view: %p", NSStringFromClass([self class]), NSStringFromSelector(_cmd), view);
            if(!view)
            {
                MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:schoolId];
                pin.canShowCallout = YES;
                pin.enabled = YES;
                pin.draggable = NO;
                pin.pinColor = MKPinAnnotationColorGreen;

                if([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)])
                {
                    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                }

                view = pin;
            }
            else
            {
                view.annotation = annotation;
            }
        }
    }
    
    return view;
}

// zooms to a region that encloses the annotations
- (void)updateRegion
{
    self.needUpdateRegion = NO;
    CGRect boundingRect;
    BOOL started = NO;
    NSLog(@"[%@ %@] annotation count: %d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.mapView.annotations.count);
    
    // most likely there is just the one annotation in the map view, but this
    // will loop through all the annotations and union rect for each one
    for(id <MKAnnotation> annotation in self.mapView.annotations)
    {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if(!started)
        {
            started = YES;
            boundingRect = annotationRect;
        }
        else
        {
            boundingRect = CGRectUnion(boundingRect, annotationRect);
        }
    }
    
    if(started)
    {
        // this creates the region of all the annotation and then zooms into
        // that region.
        boundingRect = CGRectInset(boundingRect, -0.2, -0.2);
        if ((boundingRect.size.width < 20) && (boundingRect.size.height < 20))
        {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.mapView setRegion:region animated:YES];
        }
    }
    else
    {
        // there were no annotations found so we'll zoom into the location of
        // our current location.
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,
                                                                       1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE);

        [self.mapView setRegion:region animated:YES];
    }

}

#pragma mark - CLLocationManager callback

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
}

@end
