//
//  PostsViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "AppDelegate.h"
#import "TableCell.h"
#import "PostsViewController.h"
#import "Post.h"
#import "Vote.h"
#import "CommentViewController.h"
#import "Shared.h"
#import "College.h"
#import "SimpleTableCell.h"
#import "ToastController.h"
#import "Comment.h"
#import "LoadingCell.h"

@implementation PostsViewController

#pragma mark - Initializations

- (id)initAsType:(ViewType)type withDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setViewType:type];
        [self switchToAllColleges];
        
        [self setCommentViewController:[[CommentViewController alloc] initWithDataController:self.dataController]];
        
        switch (type)
        {
            case TOP_VIEW:
                [self setList:controller.topPostsAllColleges];
                break;
            case RECENT_VIEW:
                [self setList:controller.recentPostsAllColleges];
                break;
            case USER_POSTS:
                [self setList:controller.userPosts];
                break;
            case USER_COMMENTS:
                [self setList:controller.userComments];
                break;
            case TAG_VIEW:
                [self setList:controller.allPostsWithTag];
                break;
            default:
                break;
        }
    }
    return self;
}

#pragma mark - View Loading

- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [super viewWillAppear:animated];
    if (self.viewType == TAG_VIEW && self.tagMessage == nil)
    {
        NSLog(@"No Tag message provided for a PostsView filtered by Tag");
//        NSException *e = [NSException exceptionWithName:@"NoTagFoundException" reason:@"No Tag message provided for a PostsView filtered by Tag" userInfo:nil];
//        [e raise];
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
    
    // Place logo at the top of the navigation bar
    [self.navigationItem setTitleView:logoTitleView];
}

#pragma mark - Table View Override Functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post

    if (indexPath.row >= self.list.count)
    {
        return;
    }
    
    if (self.viewType == USER_COMMENTS)
    {
        Comment *selectedComment = (Comment *)[self.list objectAtIndex:indexPath.row];
        long postId = selectedComment.postID;
        self.selectedPost = [self.dataController fetchPostWithId:postId];
    }
    else
    {
        self.selectedPost = (Post *)[self.list objectAtIndex:indexPath.row];
    }
    
    [self.commentViewController setOriginalPost:self.selectedPost];
    
    [self.navigationController pushViewController:self.commentViewController
                                         animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    NSUInteger num = self.list.count;

    return num == 0 ? 0 : num + 1;
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
        float messageHeight = [Shared getLargeCellMessageHeight:comment.message WithFont:CF_FONT_LIGHT(16)];
        [cell assign:comment WithMessageHeight:messageHeight];
        return cell;
    }
    
    // get the post and display in this cell
    Post *post = [self.list objectAtIndex:indexPath.row];
    BOOL isNearCollege = [self.dataController.nearbyColleges containsObject:post.college];
    float messageHeight = [Shared getLargeCellMessageHeight:post.message WithFont:CF_FONT_LIGHT(16)];
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
        text = [post getMessage];
        return [Shared getLargeCellHeightEstimateWithText:text WithFont:CF_FONT_LIGHT(16)];
    }
    return [Shared getSmallCellHeightEstimateWithText:@"" WithFont:nil];
}

#pragma mark - Navigation

- (void)switchToAllColleges
{
    self.hasReachedEndOfList = NO;
    switch (self.viewType)
    {
        case TOP_VIEW:
            [self setList:self.dataController.topPostsAllColleges];
            break;
        case RECENT_VIEW:
            [self setList:self.dataController.recentPostsAllColleges];
            break;
        case TAG_VIEW:
            [self setList:self.dataController.allPostsWithTag];
            break;
        default:
            break;
    }
}
- (void)switchToSpecificCollege
{
    self.hasReachedEndOfList = NO;
    switch (self.viewType)
    {
        case TOP_VIEW:
            [self.dataController fetchTopPostsInCollege];
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
            [self.toastController toastFeedSwitchedToNearbyCollege:college.name];
        }
        else
        {
            [self.toastController toastFeedSwitchedToDistantCollege:college.name];
        }
    }
}

#pragma mark - Actions

- (BOOL)loadMorePosts
{
    BOOL success = false;

    switch (self.viewType)
    {
        case TOP_VIEW:
            success = [self.dataController fetchTopPosts];
            break;
        case RECENT_VIEW:
            success = [self.dataController fetchNewPosts];
            break;
        case TAG_VIEW:
            success = [self.dataController fetchMorePostsWithTagMessage:self.tagMessage];
            break;
        default:
            break;
    }
    
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
{   // refresh this post view
    if (self.dataController.showingAllColleges)
    {
        [self switchToAllColleges];
    }
    else if (self.dataController.showingSingleCollege)
    {
        [self switchToSpecificCollege];
    }
    [super refresh];
}

#pragma mark - CreationViewProtocol Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
{
    BOOL success = [self.dataController createPostWithMessage:message
                                 withCollegeId:self.dataController.collegeInFocus.collegeID withUserToken:@"EMPTY_TOKEN"];
    
    if (!success)
    {
        [self.toastController toastPostFailed];
    }
    [self refresh];
}

@end
