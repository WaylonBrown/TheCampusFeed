//
//  MasterViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

// Models
#import "College.h"
#import "Post.h"
#import "Vote.h"

// Full views
#import "MasterViewController.h"
#import "CommentViewController.h"
#import "PostsViewController.h"
#import "TutorialViewController.h"

// Minor views and dialogs
#import "TableCell.h"
#import "UIView+Toast.h"

// Universal app information
#import "DataController.h"
#import "Shared.h"
#import "AppDelegate.h"
#import "ToastController.h"


@implementation MasterViewController

#pragma mark - Initialization and View Loading

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithNibName:@"MasterView" bundle:nil];
    if (self)
    {
        [self setDataController:controller];
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.toastController = [[ToastController alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"Toast" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self.toastController selector:@selector(toastHidden) name:@"ToastHidden" object:nil];
    }
    return self;
}
- (void)loadView
{   // called when this view is initially loaded
    
    [super loadView];
    
    // Add a refresh control to the top of the table view
    // (assigned to a tableViewController to avoid a 'stutter' in the UI)
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;

    // Assign fonts
    [self.currentFeedLabel      setAdjustsFontSizeToFitWidth:YES];
    [self.currentFeedLabel      setFont:CF_FONT_LIGHT(22)];
    [self.showingLabel          setFont:CF_FONT_BOLD(12)];
    [self.feedButton.titleLabel setFont:CF_FONT_LIGHT(17)];
}
- (void)viewDidLoad
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"Toast" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self.toastController selector:@selector(toastHidden) name:@"ToastHidden" object:nil];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self refresh];
    
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [super viewWillAppear:animated];
    [self refresh];

    // Show loading indicator until a nearby college is found,
    // then replace it with a create post button
     
    if ([self.dataController isNearCollege])
    {
        [self placeCreatePost];
    }
    else
    {
        [self placeLoadingIndicator];
    }

}
- (void)placeLoadingIndicator
{   // Place the loading indicator in the navigation bar (instead of create post button)
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];

    [self.navigationItem setRightBarButtonItem:button];
    
    [self.activityIndicator startAnimating];
}
- (void)placeCreatePost
{   // Place the create post button in the navigation bar (instead of loading indicator)
    [self.activityIndicator stopAnimating];
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                  target:self action:@selector(create)];
    [self.navigationItem setRightBarButtonItem:createButton];
}
- (void)foundLocation
{   // Called when the user's location is determined. Allow them to create posts
    if ([self.dataController isNearCollege])
    {
        [self placeCreatePost];
        [self.tableView reloadData];
        [self.toastController toastNearbyColleges:self.dataController.nearbyColleges];
    }
    else
    {
        [self placeLoadingIndicator];
        [self.toastController toastLocationFoundNotNearCollege];
    }
    
    UIViewController *presented = [self presentedViewController];
    if (presented)
    {
        if ([presented class] == [FeedSelectViewController class])
        {
            [((FeedSelectViewController *)presented) foundLocation];
        }
    }
}
- (void)didNotFindLocation
{   // Called when the user's location cannot be determined. Stop and remove activity indicator
    [self.activityIndicator stopAnimating];
    [self.navigationItem setRightBarButtonItem:nil];
    [self.toastController toastLocationNotFoundOnTimeout];
}

#pragma mark - UITableView Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // return the number of sections in the table view
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{   // User should not directly modify a TableCell
    return NO;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
}

#pragma mark - Actions

- (IBAction)changeFeed;
{   // User wants to change the feed (all colleges, nearby college, or other)
    FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ALL_NEARBY_OTHER WithDataController:self.dataController WithFeedDelegate:self];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}
- (void)showCreationDialogForCollege:(College *) college
{
    CreatePostCommentViewController *alert = [[CreatePostCommentViewController alloc] initWithType:POST withCollege:college];
    [alert setDelegate:self];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)create
{   // Display popup to let user type a new post
    
    NSArray *nearbyColleges = self.dataController.nearbyColleges;
    if (nearbyColleges.count == 0)
    {   // None nearby
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You cannot post because you are not within range of any known colleges"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (nearbyColleges.count == 1)
    {   // One college is nearby
        College *collegeNearby = [nearbyColleges objectAtIndex:0];
        [self showCreationDialogForCollege:collegeNearby];
    }
    else
    {   // Multiple colleges are nearby
        FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ONLY_NEARBY_COLLEGES WithDataController:self.dataController WithPostingDelegate:self];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}
- (void)refresh
{   // refresh the current view
    if (self.dataController.collegeList == nil || self.dataController.collegeList.count == 0)
    {
        [self.toastController toastErrorFetchingCollegeList];
    }
    NSString *feedName = self.dataController.collegeInFocus.name;
    if (feedName == nil)
    {
        feedName = @"All Colleges";
    }
    
    [self.currentFeedLabel setText:feedName];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    self.toolBarSpaceFromBottom.constant = 50;
    [self.feedToolbar updateConstraintsIfNeeded];
}

#pragma mark - Toasts

- (void)receivedNotification:(NSNotification *) notification
{
    NSDictionary *dictionary = [notification userInfo];
    NSString *toast = [dictionary objectForKey:@"message"];
    [self toastMessage:toast];
}
- (void)toastMessage:(NSString *)message
{
    float x = self.view.frame.size.width / 2;
    float y = self.view.frame.size.height - 95;
    CGPoint point = CGPointMake(x, y);
    
    [self.view makeToast:message
                duration:2.0
                position:[NSValue valueWithCGPoint:point]];
}

#pragma mark - ChildCellDelegate Methods

- (BOOL)castVote:(Vote *)vote
{   // vote was cast in a table cell
    College *college = [self.dataController getCollegeById:vote.collegeId];
    if ((college != nil && [self.dataController.nearbyColleges containsObject:college])
        || vote.upvote == YES)
    {
        return [self.dataController createVote:vote];
    }

    // users cannot cast downvotes to a distant school
    [self.toastController toastInvalidDownvote];
    return NO;
}
- (BOOL)cancelVote:(Vote *)vote
{
    return [self.dataController cancelVote:vote];
}
- (void)didSelectTag:(NSString *)tagMessage
{
    PostsViewController  *controller = [[PostsViewController alloc] initAsType:TAG_VIEW
                                                            withDataController:self.dataController];
    [controller setTagMessage:tagMessage];
    if (self.dataController.showingSingleCollege)
    {
        [self.dataController fetchAllPostsInCollegeWithTagMessage:tagMessage];
    }
    else
    {
        [self.dataController fetchPostsWithTagMessage:tagMessage];
    }
    
    
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - CreationViewProtocol Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
                               withCollegeId:(long)collegeId
                               withUserToken:(NSString *)userToken
{
    NSNumber *minutesUntilCanPost = [NSNumber new];
    if ([self.dataController isAbleToPost:minutesUntilCanPost])
    {
        [self.dataController createPostWithMessage:message
                                     withCollegeId:collegeId];
        [self refresh];
    }
    else
    {
        [self.toastController toastPostingTooSoon:minutesUntilCanPost];
    }
}
- (void)commentingTooFrequently
{
    [self.toastController toastCommentingTooSoon];
}

#pragma mark - FeedSelectionProtocol Delegate Methods

- (void)submitSelectionForFeedWithCollegeOrNil:(College *)college
{
    [self.dataController switchedToSpecificCollegeOrNil:college];
    if (college == nil)
    {
        [self.currentFeedLabel setText:@"All Colleges"];
    }
    else
    {
        [self.currentFeedLabel setText:college.name];
    }

    [self refresh];
    self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
}
- (void)showDialogForAllColleges
{
    FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ALL_COLLEGES_WITH_SEARCH WithDataController:self.dataController WithFeedDelegate:self];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

#pragma mark - CollegeForPostingSelectionProtocol Delegate Methods

- (void)submitSelectionForPostWithCollege:(College *)college
{
    [self showCreationDialogForCollege:college];
}


@end
