//
//  TrendingCollegesViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TrendingCollegesViewController.h"
#import "SimpleTableCell.h"
#import "College.h"
#import "Shared.h"

@implementation TrendingCollegesViewController

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setList:self.dataController.trendingColleges];
    }
    return self;
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
    
    NSInteger row = indexPath.row;
    
    // get the college and display in this cell
    College *collegeAtIndex = (College *)[self.list objectAtIndex:row];
    
    NSString *text = [collegeAtIndex name];
    float height = [Shared getSmallCellMessageHeight:text WithFont:CF_FONT_LIGHT(18)];

    [cell assignCollege:collegeAtIndex withRankNumber:(row + 1) withMessageHeight:height];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    College *college = (College *)[self.list objectAtIndex:row];
    [self.dataController switchedToSpecificCollegeOrNil:college];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToTopPosts" object:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [[self.list objectAtIndex:indexPath.row] name];
    return [Shared getSmallCellHeightEstimateWithText:text WithFont:CF_FONT_LIGHT(18)];
}

- (void)refresh
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
