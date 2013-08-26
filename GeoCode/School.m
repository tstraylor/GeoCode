//
//  School.m
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

#import "School.h"

@interface School ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (nonatomic) CLLocationCoordinate2D location;

@end

@implementation School

@synthesize name = _name;
@synthesize address = _address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize location = _location;

- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    
    if (self)
    {
        self.location = coordinate;
    }
    
    return self;
}

- (NSString*)fullAddress
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@ %@", self.name, self.address, self.city, self.state, self.zip];
}

@end
