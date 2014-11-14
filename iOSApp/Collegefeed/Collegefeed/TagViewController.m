//
//  TagViewController.m
//  TheCampusFeed
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
    
    [self.view setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];

    // Search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = searchBar;
    [searchBar setKeyboardType:UIKeyboardTypeAlphabet];
    [searchBar setText:@"#"];
    [searchBar setDelegate:self];
    
    // ToDo: change to UISearchController
    self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    self.searchDisplay.delegate = self;
    self.searchDisplay.searchResultsDataSource = self;
    self.searchDisplay.searchResultsDelegate = self;
}
- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setList:[self.dataController getCurrentTagList]];
    [self.dataController fetchTagsWithReset:YES];
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Post view of all posts with the selected tag
    
    if (indexPath.row >= self.list.count)
    {
        return;
    }
    
    if (tableView == self.searchDisplay.searchResultsTableView)
    {
        [self.dataController setTagInFocus:[self.searchResult objectAtIndex:indexPath.row]];
    }
    else
    {
        [self.dataController setTagInFocus:[self.dataController.tagListForAllColleges objectAtIndex:indexPath.row]];
    }
    
    PostsViewController* controller = [[PostsViewController alloc] initAsType:TAG_VIEW
                                                           withDataController:self.dataController];
    
    UIBarButtonItem *backButton =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - UITableView Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    if (tableView == self.searchDisplay.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else if (self.hasFinishedFetchRequest)
    {
        return self.list.count;
    }
    
    return 0;
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
        Tag *tag = (Tag*)[self.searchResult objectAtIndex:indexPath.row];
        [cell assignTag:tag];
    }
    else
    {
        if (indexPath.row < self.list.count)
        {
            // get the tag and display in this cell
            Tag *tag = (Tag *)[self.list objectAtIndex:indexPath.row];
            [cell assignTag:tag];
        }
        else if (!self.hasFetchedAllContent)
        {   // reached end of visible list; load more tags
            [self.dataController fetchTagsWithReset:NO];
        }
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
        [self.dataController.toaster toastInvalidTagSearch];
    }
}

#pragma mark - Actions


#pragma mark - Vanishing Bottom Toolbar

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.bounces = (scrollView.contentOffset.y < 50);
    
    CGRect frame = self.feedToolbar.frame;
    CGFloat size = frame.size.height;
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    
    self.previousScrollViewYOffset = scrollOffset;
    
    if (scrollOffset < 5)
    {   // keep bar showing if at top of scrollView
        self.toolBarSpaceFromBottom.constant = 50;
    }
    else if (scrollDiff > 0 && (frame.origin.y < scrollHeight))
    {   // flick up / scroll down / hide bar
        self.toolBarSpaceFromBottom.constant -= 4;
    }
    else if (scrollDiff < 0 && (frame.origin.y + size > scrollHeight))
    {   // flick down / scroll up / show bar
        self.toolBarSpaceFromBottom.constant += 4;
        [self setList:[self.dataController getCurrentTagList]];
    }
    
    self.toolBarSpaceFromBottom.constant = MIN(self.toolBarSpaceFromBottom.constant, 50);
    [self.feedToolbar updateConstraintsIfNeeded];
}

#pragma mark - FeedSelectionProtocol Delegate Methods

- (void)switchToFeedForCollegeOrNil:(College *)college
{
    [super switchToFeedForCollegeOrNil:college];
    [self setList:[self.dataController getCurrentTagList]];
}

@end
