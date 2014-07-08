//
//  MasterViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

// Models
#import "Models/Models/College.h"
#import "Models/Models/Post.h"
#import "Models/Models/Vote.h"

// Full views
#import "MasterViewController.h"
#import "CommentViewController.h"

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
        self.toastController = [[ToastController alloc] initWithViewController:self];        
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


    // Place logo at the top of the navigation bar
    [self.navigationItem setTitleView:logoTitleView ];

    // Assign fonts
    [self.currentFeedLabel      setAdjustsFontSizeToFitWidth:YES];
    [self.currentFeedLabel      setFont:CF_FONT_LIGHT(20)];
    [self.showingLabel          setFont:CF_FONT_MEDIUM(11)];
    [self.feedButton.titleLabel setFont:CF_FONT_LIGHT(15)];
}
- (void)viewDidLoad
{
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setAlpha:0.9f];
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
    [self refresh];
}
- (void)placeCreatePost
{   // Place the create post button in the navigation bar (instead of loading indicator)
    [self.activityIndicator stopAnimating];
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                  target:self action:@selector(create)];
    [self.navigationItem setRightBarButtonItem:createButton];
    [self refresh];
}
- (void)foundLocation
{   // Called when the user's location is determined. Allow them to create posts
    if ([self.dataController isNearCollege])
    {
        [self placeCreatePost];
        [self.toastController toastNearbyColleges:self.dataController.nearbyColleges];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:nil];
        [self.toastController toastLocationFoundNotNearCollege];
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

#pragma mark - Actions

- (IBAction)changeFeed;
{   // User wants to change the feed (all colleges, nearby college, or other)

    FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ALL_NEARBY_OTHER];
    [controller setFullCollegeList:self.dataController.collegeList];
    [controller setNearbyCollegeList:self.dataController.nearbyColleges];
    [controller setFeedDelegate:self];
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
        FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ONLY_NEARBY_COLLEGES];
        [controller setNearbyCollegeList:self.dataController.nearbyColleges];
        [controller setPostingDelegate:self];
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
}

#pragma mark - Delegate Methods

- (void)castVote:(Vote *)vote
{   // vote was cast in a table cell

    College *college = [self.dataController getCollegeById:vote.collegeId];
    if (college != nil
        && ![self.dataController.nearbyColleges containsObject:college]
        && vote.upvote == NO)
    {   // users cannot cast downvotes to a distant school
        [self.toastController toastInvalidDownvote];
    }
    else
    {
        [self.dataController createVote:vote];
    }
}

#pragma mark - CreationViewProtocol Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
                                 withCollegeId:(long)collegeId
{
    [self.dataController createPostWithMessage:message withCollegeId:collegeId];
    [self refresh];
}

#pragma mark - FeedSelectionProtocol Delegate Methods

- (void)submitSelectionForFeedWithCollegeOrNil:(College *)college
{
    [self.dataController switchedToSpecificCollegeOrNil:college];
    [self.tabBarController setSelectedIndex:0];
    if (college == nil)
    {
        [self.currentFeedLabel setText:@"All Colleges"];
    }
    else
    {
        [self.currentFeedLabel setText:college.name];
    }
    [self refresh];
}
- (void)showDialogForAllColleges
{
    FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ALL_COLLEGES_WITH_SEARCH];
    [controller setFullCollegeList:self.dataController.collegeList];
    [controller setFeedDelegate:self];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

#pragma mark - CollegeForPostingSelectionProtocol Delegate Methods

- (void)submitSelectionForPostWithCollege:(College *)college
{
    [self showCreationDialogForCollege:college];
}


@end
