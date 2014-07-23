//
//  TrendingCollegesViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TrendingCollegesViewController.h"
#import "SimpleTableCell.h"
#import "College.h"


@implementation TrendingCollegesViewController

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    [self setList:self.dataController.trendingColleges];
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *feedLabel = @"Trending Colleges";
    [self.currentFeedLabel setText:feedLabel];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
    [self.toolbarSeparator removeFromSuperview];
    [self.feedButton removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // get the college and display in this cell
    College *collegeAtIndex = (College *)[self.list objectAtIndex:indexPath.row];
    [cell assignCollege:collegeAtIndex withRankNumber:(indexPath.row + 1)];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should not be hardcoded; revist
    
    return 56;
}

- (void)refresh
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
