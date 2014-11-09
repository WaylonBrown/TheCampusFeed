//
//  MasterViewController.m
//  TheCampusFeed
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
#import "CF_DialogViewController.h"

@implementation MasterViewController

#pragma mark - Initialization and View Loading

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithNibName:@"MasterView" bundle:nil];
    if (self)
    {
        [self setDataController:controller];
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tutorialFinished) name:@"TutorialFinished" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tutorialStarted) name:@"TutorialStarted" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationWasUpdated) name:@"LocationUpdated" object:nil];
        
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
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];

    tableViewController.refreshControl = self.refreshControl;
    
    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, 5);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    [view setBackgroundColor:[Shared getCustomUIColor:CF_EXTRALIGHTGRAY]];

                                      
    self.tableView.tableHeaderView = view;

                                      
                                      
    // Assign fonts
    [self.currentFeedLabel  setFont:CF_FONT_LIGHT(22)];
    [self.showingLabel      setFont:CF_FONT_BOLD(12)];
    [self.chooseLabel       setFont:CF_FONT_LIGHT(17)];
}
- (void)viewDidLoad
{
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
        [self placeLoadingIndicatorInToolbar];
    }

}
- (void)placeLoadingIndicatorInToolbar
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
- (void)locationWasUpdated
{
    [self.activityIndicator stopAnimating];
    
    if ([self.dataController isNearCollege])
    {
        [self placeCreatePost];
        [self.tableView reloadData];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:nil];
    }
    
    UIViewController *presented = [self presentedViewController];
    if (presented)
    {
        if ([presented class] == [FeedSelectViewController class])
        {
            [((FeedSelectViewController *)presented) updateLocation];
        }
    }

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
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
}

#pragma mark - Actions

- (IBAction)changeFeed
{   // User wants to change the feed (all colleges, nearby college, or other)

    if (!self.isShowingTutorial)
    {
        FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ALL_NEARBY_OTHER WithDataController:self.dataController WithFeedDelegate:self];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}
- (void)tutorialFinished
{
    self.isShowingTutorial = NO;
    [self.dataController.toaster releaseBlockedToasts];
    [self pullToRefresh];
    [self changeFeed];
}
- (void)tutorialStarted
{
    self.dataController.toaster.holdingNotifications = YES;
    self.isShowingTutorial = YES;
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
- (void)pullToRefresh
{
    if (self.dataController.locStatus != LOCATION_FOUND)
    {
        [self.dataController findUserLocation];
    }
    
    [self refresh];
}
- (void)refresh
{   // refresh the current view

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

#pragma mark - ChildCellDelegate Methods

- (void)displayCannotVote
{    // users cannot cast downvotes to a distant school
    [self.dataController.toaster toastInvalidDownvote];
}
- (BOOL)castVote:(Vote *)vote
{   // vote was cast in a table cell
    College *college = [self.dataController getCollegeById:vote.collegeId];
    if ((college != nil && [self.dataController.nearbyColleges containsObject:college])
        || vote.upvote == YES)
    {
        return [self.dataController createVote:vote];
    }

    // users cannot cast downvotes to a distant school
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
        bool success = [self.dataController createPostWithMessage:message
                                     withCollegeId:collegeId];
        if (success)
        {
            [self refresh];
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.list.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
//        else
//        {
//            [self.toastController toastPostFailed];
//        }
        [self refresh];
    }
//    else
//    {
//        [self.toastController toastPostingTooSoon:minutesUntilCanPost];
//    }
}
//- (void)commentingTooFrequently
//{
//    [self.toastController toastCommentingTooSoon];
//}

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
