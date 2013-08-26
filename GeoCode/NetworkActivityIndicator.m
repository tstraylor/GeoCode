//
//  NetworkActivityIndicator.m
//  GeoCode
//
//  Created by Thomas Traylor on 8/1/13.
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

#import "NetworkActivityIndicator.h"

@interface NetworkActivityIndicator ()

@property (nonatomic) NSInteger counter;

- (void)updateNetworkActivityIndicator;

@end

@implementation NetworkActivityIndicator

+ (NetworkActivityIndicator*)getInstance
{
    static dispatch_once_t once;
    static NetworkActivityIndicator *instance = nil;
    dispatch_once(&once, ^{
        instance = [[NetworkActivityIndicator alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.counter = 0;
    }
    
    return self;
}

- (void)start
{
    @synchronized(self)
    {
        self.counter++;
    }
    
    [self updateNetworkActivityIndicator];
}

- (void)stop
{
    @synchronized(self)
    {
        if(self.counter > 0)
            self.counter--;
    }
    
    [self updateNetworkActivityIndicator];
}

- (void)clear
{
    @synchronized(self)
    {
        self.counter = 0;
    }
    
    [self updateNetworkActivityIndicator];
}

- (void)updateNetworkActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(self.counter > 0)];
}

@end
