//
//  CollegePickerViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/23/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CollegePickerViewController.h"
#import "College.h"
#import "Shared.h"
#import "PostsViewController.h"
#import "ChildCellDelegate.h"
#import "AppData.h"

@implementation CollegePickerViewController

#pragma mark - Initializations

- (id)initAsTopCollegesWithAppData:(AppData*)data
{
    self = [super init];
    if (self)
    {
        [self setTopColleges:YES];
        [self setAllColleges:NO];
        [self setAppData:data];
    }
    return self;
}
- (id)initAsAllCollegesWithAppData:(AppData*)data
{
    self = [super init];
    if (self)
    {
        [self setTopColleges:NO];
        [self setAllColleges:YES];
        [self setAppData:data];
    }
    return self;
}

#pragma mark - View Loading and Refreshing

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [self.navigationItem setTitleView:logoTitleView];

    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];

    [self.tableView reloadData];
}

#pragma mark - Data Access

- (void)setCollegesList:(NSMutableArray *)collegeList
{
    self.list = [[NSMutableArray alloc] initWithArray:collegeList];
}

#pragma mark - Search Bar

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.name contains[cd] %@",
                                    searchText];
    
    [self setSearchResults:(NSMutableArray*)[self.list filteredArrayUsingPredicate:resultPredicate]];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Table View Overrides

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.numberOfSections == 2 && section == 0)
    {
        UILabel *nearYouLabel = [[UILabel alloc] init];
        [nearYouLabel setText:@"Near You"];
        return nearYouLabel;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // When user is selecting a feed, display nearby colleges separately (if applicable)
    if (self.allColleges)
    {
        if (self.appData.nearbyColleges.count > 0)
            return 2;
    }
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // User selected a college from the list, call delegate's selectedCollege function
    College *college;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        college = (College *)[self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        if (tableView.numberOfSections == 2 && indexPath.section == 0)
        {
            college = [self.appData.nearbyColleges objectAtIndex:indexPath.row];
        }
        else
        {
            college = [self.list objectAtIndex:indexPath.row];
        }
    }

    [self.delegate selectedCollege:college from:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        if (tableView.numberOfSections == 2 && section == 0)
        {
            return self.appData.nearbyColleges.count;
        }
        else
        {
            return self.list.count;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // Display
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        College *college = (College *)[self.searchResults objectAtIndex:indexPath.row];
        [cell.textLabel setText:college.name];
    }
    else
    {
        College *college;
        if (tableView.numberOfSections == 2 && indexPath.section == 0)
        {
            college = [self.appData.nearbyColleges objectAtIndex:indexPath.row];
        }
        else
        {
            college = (College *)[self.list objectAtIndex:indexPath.row];
        }
        [cell.textLabel setText:college.name];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should probably not be hardcoded; revist
    
    // if not showing college name
    return 50;
    
    // if showing college name
    //    return 120;
}

@end
