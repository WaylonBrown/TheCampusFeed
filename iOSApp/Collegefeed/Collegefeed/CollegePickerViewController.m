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

@implementation CollegePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCollegesList:(NSMutableArray *)collegeList
{
    self.list = [[NSMutableArray alloc] initWithArray:collegeList];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   //TODO: the code below is taken from PostViewController
    College *college;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        college = (College *)[self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        college = (College *)[self.list objectAtIndex:indexPath.row];
    }
    
    [self.delegate selectedCollege:college];

//    PostsViewController* controller = [[PostsViewController alloc] init];
//    [self.navigationController pushViewController:controller
//                                         animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        return self.list.count;
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
//    [cell setDelegate: self];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        College *college = (College *)[self.searchResults objectAtIndex:indexPath.row];
        [cell.textLabel setText:college.name];    }
    else
    {
        College *college = (College *)[self.list objectAtIndex:indexPath.row];
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
