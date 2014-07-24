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
#import "ToastController.h"
#import "Comment.h"

@implementation PostsViewController

#pragma mark - Initializations

- (id)initAsType:(ViewType)type withDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setViewType:type];
        [self switchToAllColleges];
        
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
        NSException *e = [NSException exceptionWithName:@"NoTagFoundException" reason:@"No Tag message provided for a PostsView filtered by Tag" userInfo:nil];
        [e raise];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self refresh];
    [self setCommentViewController:[[CommentViewController alloc] initWithDataController:self.dataController]];
}
- (void)loadView
{
    [super loadView];
}

#pragma mark - Table View Override Functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post

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
    
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    // this specifies the prototype (PostTableCell) and assigns the labels
    int rowNum = indexPath.row;
    int listcount = self.list.count;
    if (!self.hasReachedEndOfList
        && (rowNum + 5) % 25 == 0
        && listcount < rowNum + 10)
    {
        self.hasReachedEndOfList = ![self loadMorePosts];
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

    // get the post and display in this cell
    NSObject<PostAndCommentProtocol> *postAtIndex = [self.list objectAtIndex:indexPath.row];
    
    // TODO: this assigning needs some cleanup, use all in the assign: call
    NSNumber *postID = [NSNumber numberWithLong:[postAtIndex getID]];
    if ([self.dataController.userPostUpvotes containsObject:postID])
    {
        [postAtIndex setVote:[[Vote alloc] initWithVotableID:postID.longValue withUpvoteValue:YES asVotableType:POST]];
    }
    else if ([self.dataController.userPostDownvotes containsObject:postID])
    {
        [postAtIndex setVote:[[Vote alloc] initWithVotableID:postID.longValue withUpvoteValue:NO asVotableType:POST]];
    }
    long collegeId = [postAtIndex getCollegeID];
    College *college = [self.dataController getCollegeById:collegeId];
    [postAtIndex setCollegeName:college.name];
    [cell setUserIsNearCollege:[self.dataController.nearbyColleges containsObject:college]];
    [cell assign:postAtIndex];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    #define LABEL_WIDTH 252.0f
    #define TOP_TO_LABEL 7.0f
    #define LABEL_TO_BOTTOM 59.0f
    #define MIN_LABEL_HEIGHT 53.0f
    

    NSString *text = [((Post *)[self.list objectAtIndex:[indexPath row]]) getMessage];
    CGSize constraint = CGSizeMake(LABEL_WIDTH, 20000.0f);
    CGSize size = [text sizeWithFont:CF_FONT_LIGHT(16) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, MIN_LABEL_HEIGHT);
    float fullHeight = height + TOP_TO_LABEL + LABEL_TO_BOTTOM;

    return fullHeight;
}

#pragma mark - Navigation

- (void)switchToAllColleges
{
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
    switch (self.viewType)
    {
        case TOP_VIEW:
            // TODO: this is calling dataController's function and passing its own variable to itself...
            [self.dataController fetchTopPostsWithCollegeId:self.dataController.collegeInFocus.collegeID];
            [self setList:self.dataController.topPostsInCollege];
            break;
        case RECENT_VIEW:
            [self.dataController fetchNewPostsWithCollegeId:self.dataController.collegeInFocus.collegeID];
            [self setList:self.dataController.recentPostsInCollege];
            break;
        case TAG_VIEW:
            if (self.tagMessage != nil)
            {
                [self setList:self.dataController.allPostsWithTagInCollege];
            }
            [self.dataController fetchAllPostsWithTagMessage:self.tagMessage
                                               withCollegeId:self.dataController.collegeInFocus.collegeID];

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
        case RECENT_VIEW:
            [self.dataController fetchNewPosts];
            [self refresh];
            break;
        case TOP_VIEW:
            [self.dataController fetchTopPosts];
            [self refresh];
            break;
        case TAG_VIEW:
            success = [self.dataController fetchMorePostsWithTagMessage:self.tagMessage];
            [self refresh];
        default:
            break;
    }
    return success;
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
                                 withCollegeId:self.dataController.collegeInFocus.collegeID];
    
    if (!success)
    {
        [self.toastController toastPostFailed];
    }
    [self refresh];
}

@end
