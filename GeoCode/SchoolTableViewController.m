//
//  SchoolTableViewController.m
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

#import "SchoolTableViewController.h"
#import "SchoolMapViewController.h"
#import "School.h"

@interface SchoolTableViewController ()

// model
@property (nonatomic, strong) NSArray *schools;

@end

@implementation SchoolTableViewController

@synthesize schools = _schools;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get the list of school from the plist file.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Schools" ofType:@"plist"];
    NSDictionary* data = [NSDictionary dictionaryWithContentsOfFile:path];
    self.schools = [data objectForKey:@"Schools"];
    self.title = @"Schools";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.schools count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SchoolTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dict = [self.schools objectAtIndex:indexPath.item];
    cell.textLabel.text = [dict objectForKey:@"name"];
    return cell;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setSchool:)])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *data = [self.schools objectAtIndex:[indexPath row]];
        
        School *school = [[School alloc] init];
        school.name = [data objectForKey:@"name"];
        school.address = [data objectForKey:@"address"];
        school.city = [data objectForKey:@"city"];
        school.state = [data objectForKey:@"state"];
        school.zip = [data objectForKey:@"zip"];
        
        [segue.destinationViewController performSelector:@selector(setSchool:) withObject:school];
    }
}

@end
