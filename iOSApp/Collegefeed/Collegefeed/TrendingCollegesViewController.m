//
//  TrendingCollegesViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "TrendingCollegesViewController.h"
#import "SimpleTableCell.h"
#import "College.h"
#import "Shared.h"

@implementation TrendingCollegesViewController

- (id)initWithDataController:(DataController *)controller
{
    return [super initWithDataController:controller];
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Setting tableview to be automatic in %@", [self class]);
    self.tableView.estimatedRowHeight = COLLEGE_CELL_HEIGHT_ESTIMATE;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table View

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
    
    [cell assignCollege:collegeAtIndex withRankNumberOrNil:[NSNumber numberWithLong:(row + 1)]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    College *college = (College *)[self.list objectAtIndex:row];
    [self.dataController switchedToSpecificCollegeOrNil:college];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToTopPosts" object:nil];
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    [super fetchContent];

    NSLog(@"Fetching Top colleges");
    [self.dataController fetchTopColleges];
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    if ([[[notification userInfo] valueForKey:@"feedName"] isEqualToString:@"topColleges"])
    {
        NSLog(@"Finished fetching Top Colleges");
        [super finishedFetchRequest:notification];
    }
}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    [self setList:self.dataController.trendingColleges];
}

@end