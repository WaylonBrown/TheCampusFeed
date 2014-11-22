//
//  PostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "AppDelegate.h"
#import "TableCell.h"
#import "PostsViewController.h"
#import "Post.h"
#import "Vote.h"
#import "Tag.h"
#import "CommentViewController.h"
#import "Shared.h"
#import "College.h"
#import "SimpleTableCell.h"
#import "ToastController.h"
#import "Comment.h"
#import "LoadingCell.h"

@implementation PostsViewController

#pragma mark - Initialization

- (id)initAsType:(ViewType)type withDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setViewType:type];
//        [self switchToAllColleges];
        
        [self setCommentViewController:[[CommentViewController alloc] initWithDataController:self.dataController]];
    }
    return self;
}

#pragma mark - View Loading

- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    
    [self setCorrectPostList];
    
    [super viewWillAppear:animated];
    
//    if (self.viewType == TAG_VIEW)
//    {
//        if (self.tagMessage == nil)
//        {
//            NSLog(@"No Tag message provided for a PostsView filtered by Tag");
//        }
//        else
//        {
//            // ToDo: make this method have multithreaded callback
//            [self.dataController fetchPostsWithTagMessage:self.tagMessage];
//        }
//    }
}
- (void)makeToolbarButtons
{   // Assigns correct icons and buttons to the upper toolbar
    
    // Show loading indicator until a nearby college is found,
    // then replace it with a compose button

    if ([self.dataController isNearCollege])
    {
        [self placeCreatePost];
    }
    else
    {
        [self placeLoadingIndicatorInToolbar];
    }
}
- (void)viewDidLoad
{
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)loadView
{
    [super loadView];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post

    if (indexPath.row >= self.list.count)
    {   // Selection was out of bounds
        NSLog(@"ERROR: Out of bounds row selection from a PostsViewController");
        return;
    }
    
    NSObject<PostAndCommentProtocol> *selected = [self.list objectAtIndex:indexPath.row];
    
    if (self.viewType == USER_COMMENTS)
    {   // User selected one of their submitted comments (they are in Post format)
        Post *parentPost = [self.dataController fetchParentPostOfComment:(Comment *)selected];
        if (parentPost != nil)
        {
            [self.dataController setPostInFocus:parentPost];
        }
    }
    else
    {
        [self.dataController setPostInFocus:(Post *)selected];
    }
    
    [self.navigationController pushViewController:self.commentViewController
                                         animated:YES];
    [[self navigationItem] setBackBarButtonItem:self.commentViewController.backButton];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    // this specifies the prototype (PostTableCell) and assigns the labels
    NSUInteger rowNum = indexPath.row;
    NSUInteger listcount = self.list.count;
    
    
    if (rowNum == listcount)
    {
        static NSString *LoadingCellIdentifier = @"LoadingCell";
        LoadingCell *cell = (LoadingCell *)[tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:LoadingCellIdentifier
                                                         owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (!self.hasReachedEndOfList)
        {
            [cell showLoadingIndicator];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSInteger oldCount = listcount;
                self.hasReachedEndOfList = ![self loadMorePosts];
                NSInteger newCount = self.list.count;
                
                if (oldCount != newCount)
                {
                    [self addNewRows:oldCount through:newCount];
                }
                else
                {
                    [cell hideLoadingIndicator];
                }
            });
        }
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];

    }
    [cell setDelegate: self];
    if (self.viewType == USER_COMMENTS)
    {
        Comment *comment = [self.list objectAtIndex:indexPath.row];
        BOOL isNearCollege = NO; //[self.dataController.nearbyColleges containsObject:nil];
        float messageHeight = [Shared getLargeCellMessageHeight:comment.text WithFont:CF_FONT_LIGHT(16)];

        [cell assignWith:comment IsNearCollege:isNearCollege WithMessageHeight:messageHeight];

        return cell;
    }
    
    // get the post and display in this cell
    Post *post = [self.list objectAtIndex:indexPath.row];
    BOOL isNearCollege = [self.dataController.nearbyColleges containsObject:post.college];
    float messageHeight = [Shared getLargeCellMessageHeight:post.text WithFont:CF_FONT_LIGHT(16)];
    [cell assignWith:post IsNearCollege:isNearCollege WithMessageHeight:messageHeight];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSString *text = @"";
    
    if (row < [self.list count])
    {
        Post *post = [self.list objectAtIndex:row];
        text = [post getText];
        return [Shared getLargeCellHeightEstimateWithText:text WithFont:CF_FONT_LIGHT(16)];
    }
    return [Shared getSmallCellHeightEstimateWithText:@"" WithFont:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.viewType == TAG_VIEW && self.tagMessage != nil)
    {
        return 50;
    }
    
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.viewType == TAG_VIEW && self.tagMessage != nil)
    {
        NSString *basicText = [NSString stringWithFormat:@"Posts with %@", self.tagMessage];
        
        CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 50);
        
        UILabel *header = [[UILabel alloc] init];
        if (self.dataController.showingSingleCollege && self.dataController.collegeInFocus.name != nil)
        {
            NSString *collegeSubHeader = [NSString stringWithFormat:@"in feed: %@", self.dataController.collegeInFocus.name];
            basicText = [NSString stringWithFormat:@"%@\n%@", basicText, collegeSubHeader];
            [header setNumberOfLines:2];
        }
        
        [header setFrame:frame];
        [header setText:basicText];
        [header setTextAlignment:NSTextAlignmentCenter];
        [header setFont:CF_FONT_LIGHT(16)];
        [header setBackgroundColor:[Shared getCustomUIColor:CF_EXTRALIGHTGRAY]];

        return header;
    }
    
    return nil;
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    [self setCorrectPostList];
    [self.contentLoadingIndicator startAnimating];
    
    [super fetchContent];
    
    // Spawn separate thread for network access

    BOOL allColleges = self.dataController.showingAllColleges;
    
    switch (self.viewType)
    {
        case TOP_VIEW:
            if (allColleges)
                [self.dataController fetchTopPostsForAllColleges];
            else
                [self.dataController fetchTopPostsInSingleCollege];
            
            break;
        case RECENT_VIEW:
            break;
        case TAG_VIEW:
            break;
        case USER_POSTS:
            break;
        case USER_COMMENTS:
            break;
        default:
            break;
    }
}
- (void)finishedFetchRequest
{
    [super finishedFetchRequest];
    
    [self.tableView reloadData];
    
    // TODO: addNewRows once finished fetching
}
- (BOOL)loadMorePosts
{
    BOOL success = false;
    
//    switch (self.viewType)
//    {
//        case TOP_VIEW:
//            [self.dataController fetchTopPostsForAllColleges];
//            break;
//        case RECENT_VIEW:
//            success = [self.dataController fetchNewPosts];
//            break;
//        case TAG_VIEW:
//            success = [self.dataController fetchMorePostsWithTagMessage:self.tagMessage];
//            break;
//        default:
//            break;
//    }
    
    return success;
}

#pragma mark - Local Actions

- (void)changeFeed
{
    [super changeFeed];
}
- (void)refresh
{   // refresh this post view
    [self setCorrectPostList];
    [super refresh];
    
//    if (self.dataController.showingAllColleges)
//    {
//        [self switchToAllColleges];
//    }
//    else if (self.dataController.showingSingleCollege)
//    {
//        [self switchToSpecificCollege];
//    }
}

#pragma mark - Helper Methods

- (void)setCorrectPostList
{
    BOOL allColleges = self.dataController.showingAllColleges;

    switch (self.viewType)
    {
        case TOP_VIEW:
            if (allColleges)
                [self setList:self.dataController.topPostsAllColleges];
            else
                [self setList:self.dataController.topPostsInCollege];
            
            break;
        case RECENT_VIEW:
            if (allColleges)
                [self setList:self.dataController.recentPostsAllColleges];
            else
                [self setList:self.dataController.recentPostsInCollege];
            
            break;
        case TAG_VIEW:
            if (allColleges)
                [self setList:self.dataController.allPostsWithTag];
            else
                [self setList:self.dataController.allPostsWithTagInCollege];
            
            self.tagMessage = self.dataController.tagInFocus.name;
            
            break;
        case USER_POSTS:
            [self setList:self.dataController.userPosts];
            break;
        case USER_COMMENTS:
            [self setList:self.dataController.userComments];
            break;
        default:
            break;
    }
}
- (void)switchToAllColleges
{
    //    self.hasReachedEndOfList = NO;
    //    switch (self.viewType)
    //    {
    //        case TOP_VIEW:
    //            [self setList:self.dataController.topPostsAllColleges];
    //            break;
    //        case RECENT_VIEW:
    //            [self setList:self.dataController.recentPostsAllColleges];
    //            break;
    //        case TAG_VIEW:
    //            [self setList:self.dataController.allPostsWithTag];
    //            break;
    //        default:
    //            break;
    //    }
}
- (void)switchToSpecificCollege
{
    self.hasReachedEndOfList = NO;
    switch (self.viewType)
    {
        case TOP_VIEW:
            [self.dataController fetchTopPostsInSingleCollege];
            [self setList:self.dataController.topPostsInCollege];
            break;
        case RECENT_VIEW:
            [self.dataController fetchNewPostsInCollege];
            [self setList:self.dataController.recentPostsInCollege];
            break;
        case TAG_VIEW:
            if (self.tagMessage != nil)
            {
                [self.dataController fetchAllPostsInCollegeWithTagMessage:self.tagMessage];
            }
            [self setList:self.dataController.allPostsWithTagInCollege];
            break;
        default:
            break;
    }
    College *college = self.dataController.collegeInFocus;
    if (college != nil)
    {
        if ([self.dataController.nearbyColleges containsObject:college])
        {
            [self.dataController.toaster toastFeedSwitchedToNearbyCollege:college.name];
        }
        else
        {
            [self.dataController.toaster toastFeedSwitchedToDistantCollege:college.name];
        }
    }
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

#pragma mark - CreationViewProtocol Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
{
    BOOL success = [self.dataController createPostWithMessage:message
                                 withCollegeId:self.dataController.collegeInFocus.collegeID];
    
//    if (!success)
//    {
//        [self.toastController toastPostFailed];
//    }
    if (success)
        [self refresh];
}

@end
