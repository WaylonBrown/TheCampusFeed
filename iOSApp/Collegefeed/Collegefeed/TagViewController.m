//
//  TagViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//


#import "College.h"
#import "Tag.h"
#import "TagViewController.h"
#import "PostsViewController.h"
#import "Shared.h"
#import "SimpleTableCell.h"
#import "ToastController.h"
#import "LoadingCell.h"

@implementation TagViewController

- (void)loadView
{
    [super loadView];
    
    // Place logo at the top of the navigation bar
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self.view setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.list count]];
    
    // Search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = searchBar;
    [searchBar setKeyboardType:UIKeyboardTypeAlphabet];
    [searchBar setText:@"#"];
    [searchBar setDelegate:self];
    self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    self.searchDisplay.delegate = self;
    self.searchDisplay.searchResultsDataSource = self;
    self.searchDisplay.searchResultsDelegate = self;
}


#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Post view of all posts with the selected tag
    
    if (indexPath.row >= self.list.count)
    {
        return;
    }
    
    self.selectedTag = nil;
    if (tableView == self.searchDisplay.searchResultsTableView)
    {
        self.selectedTag = (Tag *)[self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        self.selectedTag = (Tag *)[self.dataController.allTags objectAtIndex:indexPath.row];
    }
    
    if (self.selectedTag == nil)
    {
        return;
    }
    
    PostsViewController* controller = [[PostsViewController alloc] initAsType:TAG_VIEW
                                                           withDataController:self.dataController];
    [controller setTagMessage:self.selectedTag.name];
    
    UIBarButtonItem *backButton =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}
- (void)switchToAllColleges
{
    [self setList:self.dataController.allTags];
}
- (void)switchToSpecificCollege
{
    [self setList:self.dataController.allTagsInCollege];
}

#pragma mark - UITableView Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    if (tableView == self.searchDisplay.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else if (self.hasReachedEndOfList)
    {
        return self.list.count;
    }
    else
    {
        return self.list.count + 1;
    }
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
    if (tableView == self.searchDisplay.searchResultsTableView)
    {
        Tag *tagAtIndex = (Tag*)[self.searchResult objectAtIndex:indexPath.row];
        [cell assignTag:tagAtIndex];
    }
    else
    {
        if (indexPath.row == self.list.count)
        {
            static NSString *LoadingCellIdentifier = @"LoadingCell";
            LoadingCell *cell = (LoadingCell *)[tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:LoadingCellIdentifier
                                                             owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell showLoadingIndicator];
            
            if (!self.hasReachedEndOfList)
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSInteger oldCount = self.list.count;
                    self.hasReachedEndOfList = ![self loadMoreTags];
                    NSInteger newCount = self.list.count;
                    
                    if (oldCount != newCount)
                    {
                        [self addNewRows:oldCount through:newCount];
                    }
                });
            }
            
            return cell;
        }
        
        // get the tag and display in this cell
        Tag *tagAtIndex = (Tag *)[self.list objectAtIndex:indexPath.row];
        [cell assignTag:tagAtIndex];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

#pragma mark - Search Bar 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *tag  = searchBar.text;
    if ([Tag withMessageIsValid:tag])
    {
        [self.dataController fetchPostsWithTagMessage:tag];
        PostsViewController *postsView = [[PostsViewController alloc] initAsType:TAG_VIEW withDataController:self.dataController];
        [postsView setTagMessage:tag];
        [self.navigationController pushViewController:postsView animated:YES];
    }
    else
    {
        [self.toastController toastInvalidTagSearch];
    }
}

#pragma mark - Actions

- (BOOL)loadMoreTags
{
    BOOL success = [self.dataController fetchTags];
    return success;
}
- (void)addNewRows:(NSInteger)oldCount through:(NSInteger)newCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray* newRows = [NSMutableArray array];
        
        for (NSInteger i = oldCount; i < newCount; i++)
        {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [newRows addObject:newIndexPath];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [self.tableView reloadData];
        
    });
}


- (void)refresh
{   // refresh this tag view
    if (self.dataController.showingAllColleges)
    {
        [self.dataController fetchTags];
        [self switchToAllColleges];
    }
    else if (self.dataController.showingSingleCollege)
    {
        [self.dataController fetchTagsWithCollegeId:self.dataController.collegeInFocus.collegeID];
        [self switchToSpecificCollege];
    }
    [super refresh];
}

@end
