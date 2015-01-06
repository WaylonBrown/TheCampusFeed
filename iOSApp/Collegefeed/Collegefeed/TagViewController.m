//
//  TagViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//


#import "College.h"
#import "Tag.h"
#import "TagViewController.h"
#import "PostsViewController.h"
#import "TagPostsViewController.h"
#import "Shared.h"
#import "SimpleTableCell.h"
#import "ToastController.h"

@implementation TagViewController

#pragma mark - View life cycle

- (void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];

    // Search bar
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    self.tableView.tableHeaderView = searchBar;
//    [searchBar setKeyboardType:UIKeyboardTypeAlphabet];
//    [searchBar setText:@"#"];
//    [searchBar setDelegate:self];
    
    // TODO: change to UISearchController
//    self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
//    self.searchDisplay.delegate = self;
//    self.searchDisplay.searchResultsDataSource = self;
//    self.searchDisplay.searchResultsDelegate = self;
}
- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit]; // bar size
    [self.searchController.searchBar setKeyboardType:UIKeyboardTypeTwitter];
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = true;
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    long num = (tableView == self.searchResultsController.tableView)
        ? self.filteredList.count
        : self.list.count;
    
    NSLog(@"Tag View number of rows in section = %ld", num);
    return num;
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
    
    
    Tag *tag = (tableView == self.searchResultsController.tableView) ? [self.filteredList objectAtIndex:indexPath.row] : [self.list objectAtIndex:indexPath.row];
    
    [cell assignTag:tag];
    return cell;
    
//    if (tableView == self.searchResultsController.tableView)
//    {
//        Tag *tag = (Tag*)[self.filteredList objectAtIndex:indexPath.row];
//        [cell assignTag:tag];
//    }
//    else
//    {
//        if (indexPath.row < self.list.count)
//        {
//            // get the tag and display in this cell
//            Tag *tag = (Tag *)[self.list objectAtIndex:indexPath.row];
//            [cell assignTag:tag];
//        }
//    }
//    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Post view of all posts with the selected tag
    
    Tag *tag = (tableView == self.searchResultsController.tableView) ? [self.filteredList objectAtIndex:indexPath.row] : [self.list objectAtIndex:indexPath.row];
    
//    [self.dataController setTagInFocus:tag];
    
//    if (indexPath.row >= self.list.count)
//    {
//        return;
//    }
//    
//    if (tableView == self.searchDisplay.searchResultsTableView)
//    {
//        [self.dataController setTagInFocus:[self.searchResult objectAtIndex:indexPath.row]];
//    }
//    else
//    {
//        [self.dataController setTagInFocus:[self.dataController.trendingTagsAllColleges objectAtIndex:indexPath.row]];
//    }
    
    TagPostsViewController *controller = [[TagPostsViewController alloc] initWithDataController:self.dataController WithTagMessage:tag.name];
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@""
//                                   style:UIBarButtonItemStylePlain
//                                   target:nil
//                                   action:nil];
//    
    [[self navigationItem] setBackBarButtonItem:[super blankBackButton]];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 56;
//}

#pragma mark - Search Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.searchController.searchBar.text lengthOfBytesUsingEncoding:NSUTF32StringEncoding] > 0)
    {
        NSString *text = self.searchController.searchBar.text;

        if ([text characterAtIndex:0] != '#')
        {
            text = [NSString stringWithFormat:@"#%@", text];
        }
        
        NSLog(@"TagViewController to perform network tag search with: \"%@\"", text);
        
        [super didSelectTag:text];
        
//        if ([Tag withMessageIsValid:text])
//        {
//            NSLog(@"Tag message is valid. Initializing TagPostsViewController with tagMessage = %@", text);
//            TagPostsViewController *controller = [[TagPostsViewController alloc]
//                                                  initWithDataController:self.dataController
//                                                  WithTagMessage:text];
//            [[self navigationItem] setBackBarButtonItem:[super blankBackButton]];
//            [self.navigationController pushViewController:controller
//                                                 animated:YES];
//        }
//        else
//        {
//            [self.dataController.toaster toastInvalidTagSearch];
//        }
    }
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if ([self.searchController.searchBar.text lengthOfBytesUsingEncoding:NSUTF32StringEncoding] > 0)
    {
        if (self.filteredList == nil)
        {
            self.filteredList = [[NSMutableArray alloc] initWithCapacity:self.list.count];
        }
        else
        {
            [self.filteredList removeAllObjects];
        }
        
        NSString *text = self.searchController.searchBar.text;
        
//        if ([text characterAtIndex:0] != '#')
//        {
//            text = [NSString stringWithFormat:@"#%@", text];
//        }
        
        NSLog(@"Local tag search filtering results for \"%@\"", text);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", text];
        NSArray *tempFiltered = [self.list filteredArrayUsingPredicate:predicate];
        [self.filteredList addObjectsFromArray:tempFiltered];
        [self.searchResultsController.tableView reloadData];
                                  
//        if ([Tag withMessageIsValid:text])
//        {
////            NSLog(@"Tag message is valid")
//            TagPostsViewController *controller = [[TagPostsViewController alloc]
//                                                  initWithDataController:self.dataController
//                                                  WithTagMessage:text];
//            [self.navigationController pushViewController:controller
//                                                 animated:YES];
//        }
//        else
//        {
//            [self.dataController.toaster toastInvalidTagSearch];
//        }
    }
}


#pragma mark - UISearchControllerDelegate methods

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:nil completion:nil];
}

#pragma mark - Network Actions

- (void)fetchContent
{
    [super fetchContent];
    if (self.dataController.showingAllColleges)
    {
        NSLog(@"Fetching Trending Tags in all colleges");
        [self.dataController fetchTrendingTagsForAllColleges];
    }
    else
    {
        NSLog(@"Fetching Trending Tags in college ID = %ld", self.dataController.currentCollegeFeedId);
        [self.dataController fetchTrendingTagsForSingleCollege];
    }
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    if ([[[notification userInfo] valueForKey:@"feedName"] isEqualToString:@"trendingTags"])
    {
        NSLog(@"Finished fetching Trending Tags");
        [super finishedFetchRequest:notification];
    }
}

#pragma mark - Local Actions

- (void)changeFeed
{
    [super changeFeed];
}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    if (self.dataController.showingAllColleges)
    {
        [self setList:self.dataController.trendingTagsAllColleges];
    }
    else
    {
        [self setList:self.dataController.trendingTagsSingleCollege];
    }
    
    [super setCorrectList];
}
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSString *tag = searchBar.text;
//    if ([Tag withMessageIsValid:tag])
//    {
//        TagPostsViewController *controller = [[TagPostsViewController alloc] initWithDataController:self.dataController WithTagMessage:tag];
//        [self.navigationController pushViewController:controller animated:YES];
//    }
//    else
//    {
//        [self.dataController.toaster toastInvalidTagSearch];
//    }
//}
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
    }
    
    self.toolBarSpaceFromBottom.constant = MIN(self.toolBarSpaceFromBottom.constant, 50);
    [self.feedToolbar updateConstraintsIfNeeded];
}


@end
