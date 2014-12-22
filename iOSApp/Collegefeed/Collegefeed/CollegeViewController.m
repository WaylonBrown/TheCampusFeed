//
//  CollegeViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CollegeViewController.h"

@implementation CollegeViewController

#pragma mark - Initialization and View Loading

- (id)initWithDataController:(DataController *)controller
{
    return [super initWithDataController:controller];
}
- (void)loadView
{
    [super loadView];
    
    [self.feedToolbar setHidden:YES];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [super viewWillAppear:animated];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    
    static NSString *CellIdentifier = @"SimpleTableCell";
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                              owner:self
                                            options:nil] objectAtIndex:0];
    }
    
    // get the college and display in this cell
    College *college = (College *)[self.list objectAtIndex:indexPath.row];
    
    [cell assignCollege:college withRankNumberOrNil:nil];
    
    return cell;
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    [super fetchContent];
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    [super finishedFetchRequest:notification];
    
    if (self.list.count == 0)
    {
        // TODO: Show "No Posts to display" or something
    }
}

@end
