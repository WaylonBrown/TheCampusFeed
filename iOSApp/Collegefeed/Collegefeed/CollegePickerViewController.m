//
//  CollegePickerViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/23/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CollegePickerViewController.h"
#import "Models/Models/College.h"
#import "Shared.h"
#import "PostsViewController.h"
#import "ChildCellDelegate.h"
#import "AppData.h"
#import "SimpleTableCell.h"

@implementation CollegePickerViewController

#pragma mark - Initializations

- (id)initAsTopCollegesWithAppData:(AppData*)data
{
    self = [super init];
    if (self)
    {
        [self setTopColleges:YES];
        [self setAllColleges:NO];
        [self setList:data.dataController.collegeList];
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
        [self setList:data.dataController.collegeList];
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
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    [self.navigationItem setTitleView:logoTitleView];

    [self.tableView reloadData];
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

#pragma mark - Table View

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   // return the section header titles when selecting a college
    if (section == 0)
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,20,1)];
    }
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];

    if ([self.appData isNearCollege] && section == 1)
    {   // section of colleges 'near you'
        [headerLabel setText:@"Near You"];
    }
    else
    {   // section of all colleges
        [headerLabel setText:@"Other Colleges"];
    }

    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setFont:[UIFont systemFontOfSize:14]];
    [headerLabel setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
    
    return headerLabel;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // When user is selecting a feed, display nearby colleges separately (if applicable)
    if (self.allColleges)
    {   // if user is selecting from all colleges, there are 2-3 different sections
        if ([self.appData isNearCollege])
            return 3;
        else
            return 2;
    }
    // if user is viewing 'top colleges' there's only one section
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // User selected a college from the list, call delegate's selectedCollege function
    College *college;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        college = (College *)[self.searchResults objectAtIndex:indexPath.row];
    }
    else if (self.allColleges)
    {
        if (indexPath.section == 0)
        {
            college = nil;
        }
        else if (indexPath.section == 1 && [self.appData isNearCollege])
        {   // section of colleges 'near you'
            college = [self.appData.nearbyColleges objectAtIndex:indexPath.row];
        }
        else
        {   // last section is of all colleges
            college = [self.list objectAtIndex:indexPath.row];
        }
    }
    else // if showing top colleges
    {
        college = [self.list objectAtIndex:indexPath.row];
    }

    [self.delegate selectedCollegeOrNil:college from:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of rows for each section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        if (self.allColleges)
        {
            if (section == 0)
            {   // first section is 'all colleges' feed
                return 1;
            }
            else if (section == 1 && [self.appData isNearCollege])
            {   // if colleges are nearby, they are in the second section
                return self.appData.nearbyColleges.count;
            }
        }
        // the last section is the list of all colleges
        return self.list.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // Display a cell representing a college that links to its feed
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {   // if the table is filtered by a search
        College *college = (College *)[self.searchResults objectAtIndex:indexPath.row];
        [cell assignCollege:college];
    }
    
    else if (self.allColleges)
    {   // if searching all colleges
        if (indexPath.section == 0)
        {
            [cell.messageLabel setText:@"All Colleges"];
            [cell.messageLabel setFont:[UIFont fontWithName:@"System" size:12]];
            [cell.messageLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.countLabel setText:@""];
        }
        else if (indexPath.section == 1 && [self.appData isNearCollege])
        {   // section of colleges 'near you'
            College *college = [self.appData.nearbyColleges objectAtIndex:indexPath.row];
            [cell assignCollege:college];
        }
        else
        {   // last section always is of all colleges
            College *college = (College *)[self.list objectAtIndex:indexPath.row];
            [cell assignCollege:college];
        }
    }
    else
    {   // last section always is of all colleges
        College *college = (College *)[self.list objectAtIndex:indexPath.row];
        [cell assignCollege:college];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should probably not be hardcoded; revist
    
    // if not showing college name
    return 56;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0;
    return 20;
}
@end
