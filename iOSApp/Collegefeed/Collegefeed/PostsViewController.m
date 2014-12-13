//
//  PostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "AppDelegate.h"
#import "PostTableCell.h"

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

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setCommentViewController:[[CommentViewController alloc] initWithDataController:self.dataController]];
    }
    return self;
}

#pragma mark - View Loading

- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    
    [self setCorrectList];
    
    [super viewWillAppear:animated];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list, plus one additional if there are more to be fetched
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    // this specifies the prototype (PostTableCell) and assigns the labels
//    NSUInteger rowNum = indexPath.row;
//    NSUInteger listcount = self.list.count;
//    
//    if (rowNum == listcount)
//    {
//        static NSString *LoadingCellIdentifier = @"LoadingCell";
//        LoadingCell *cell = (LoadingCell *)[tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
//        
//        if (cell == nil)
//        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:LoadingCellIdentifier
//                                                         owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }
//        
////        if (!self.hasReachedEndOfList)
//        if (!self.hasFetchedAllContent)
//        {
//            [cell showLoadingIndicator];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                NSInteger oldCount = listcount;
////                self.hasReachedEndOfList = ![self loadMorePosts];
//                
//                [self loadMorePosts];
//                NSInteger newCount = self.list.count;
//                
//                if (oldCount != newCount)
//                {
//                    [self addNewRows:oldCount through:newCount];
//                }
//                else
//                {
//                    [cell hideLoadingIndicator];
//                }
//            });
//        }
//        
//        return cell;
//    }
    
    // Build a TableCell for Posts
    static NSString *CellIdentifier = @"TableCell";
    PostTableCell *cell = (PostTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [PostTableCell new];
    }
    [cell setDelegate: self];

    // Get the post and display in this cell
    Post *post = [self.list objectAtIndex:indexPath.row];
    
    if([self.dataController.nearbyColleges containsObject:post.college])
    {   // TODO: make this assignment done automatically somewhere when Post model is being built
        post.isNearCollege = YES;
    }
    [cell assignmentSuccessWith:post];
    if (self.dataController.showingAllColleges)
    {
        [cell showCollegeLabel];
    }
    else
    {
        [cell hideCollegeLabel];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    if (indexPath.row >= self.list.count)
    {   // Selection was out of bounds
        NSLog(@"ERROR: Out of bounds row selection from a PostsViewController");
        return;
    }
    
    Post *selectedPost = [self.list objectAtIndex:indexPath.row];
    [self.dataController setPostInFocus:selectedPost];
    
    [self.navigationController pushViewController:self.commentViewController
                                         animated:YES];
    [[self navigationItem] setBackBarButtonItem:self.commentViewController.backButton];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    if (row < [self.list count])
    {
        Post *post = [self.list objectAtIndex:row];
        return [PostTableCell getCellHeight:post];
    }
    
    return DEFAULT_CELL_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    [super fetchContent];
}
- (void)finishedFetchRequest
{
    [super finishedFetchRequest];
    
    if (self.list.count == 0)
    {
        // TODO: Show "No Posts to display" or something
    }
}

#pragma mark - Local Actions

- (void)changeFeed
{
    [super changeFeed];
}
- (void)refresh
{   // refresh this post view
    [super refresh];
}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    [super setCorrectList];
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
