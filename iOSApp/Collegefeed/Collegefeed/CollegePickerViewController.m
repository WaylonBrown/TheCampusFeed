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
        [self setList:self.appData.collegeDataController.list];
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
        [self setList:self.appData.collegeDataController.list];
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
        return nil;
    }
    UILabel *headerLabel = [[UILabel alloc] init];

    if ([self.appData isNearCollege] && section == 1)
    {   // section of colleges 'near you'
        [headerLabel setText:@"Near You"];
    }
    else
    {   // section of all colleges
        [headerLabel setText:@"Other Colleges"];
    }

    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setFont:[UIFont systemFontOfSize:12]];
    [headerLabel setBackgroundColor:[Shared getCustomUIColor:cf_lightgray]];
    
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
    else
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
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {   // if the table is filtered by a search
        College *college = (College *)[self.searchResults objectAtIndex:indexPath.row];
        [cell.textLabel setText:college.name];
    }
    else
    {   // if searching all colleges
        College *college;
        if (indexPath.section == 0)
        {
            [cell.textLabel setText:@"All Colleges"];
        }
        else if (indexPath.section == 1 && [self.appData isNearCollege])
        {   // section of colleges 'near you'
            college = [self.appData.nearbyColleges objectAtIndex:indexPath.row];
            [cell.textLabel setText:college.name];
        }
        
        else
        {   // last section is of all colleges
            college = (College *)[self.list objectAtIndex:indexPath.row];
            [cell.textLabel setText:college.name];
        }
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
