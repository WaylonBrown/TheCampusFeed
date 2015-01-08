//
//  MasterViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
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
#import "TagPostsViewController.h"

// Minor views and dialogs
#import "TableCell.h"
#import "UIView+Toast.h"

// Universal app information
#import "CFNavigationController.h"
#import "DataController.h"
#import "Shared.h"
#import "AppDelegate.h"
#import "ToastController.h"
#import "CF_DialogViewController.h"

#import "TheCampusFeed-Swift.h"

@implementation MasterViewController

#pragma mark - Initialization

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithNibName:@"MasterView" bundle:nil];
    if (self)
    {
        [self setDataController:controller];
        [self setCorrectList];
    }
    return self;
}
- (id)initWithDataController:(DataController *)controller withNibName:(NSString *)nib bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:nib bundle:bundle];
    if (self)
    {
        [self setDataController:controller];
        [self setCorrectList];
    }
    return self;
}

#pragma mark - View Loading

- (void)showLocationActivityIndicator
{
    NSLog(@"Showing location activity indicator");
    if (self.locationActivityIndicator == nil)
    {
        self.locationActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.locationActivityIndicator.hidesWhenStopped = YES;
    }
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:self.locationActivityIndicator];
    
    [self.locationActivityIndicator startAnimating];
    
    [self.navigationItem setRightBarButtonItem:button];
}
- (void)hideLocationActivityIndicator
{
    NSLog(@"Hiding location activity indicator");
    [self.locationActivityIndicator stopAnimating];
    if (self.dataController.nearbyColleges.count > 0)
    {
        [self showComposeButton];
    }
}
- (void)showComposeButton
{
    NSLog(@"Showing compose button");

    [self.locationActivityIndicator stopAnimating];
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                     target:self
                                     action:@selector(create)];
    
    [self.navigationItem setRightBarButtonItem:createButton];

}
- (void)loadView
{   // called when this view is initially loaded
    
    [super loadView];
    
    [self setNotificationObservers];
    
    // Add a refresh control to the top of the table view
    // (assigned to a tableViewController to avoid a 'stutter' in the UI)
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = self.refreshControl;
    
    
    // TODO: put these in TableView for Header/Footer
    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, 5);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[Shared getCustomUIColor:CF_EXTRALIGHTGRAY]];
    self.tableView.tableHeaderView = view;
    
    self.contentLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.contentLoadingIndicator setColor:[Shared getCustomUIColor:CF_BLUE]];
    [self.contentLoadingIndicator startAnimating];
    self.contentLoadingIndicator.frame = CGRectMake(0, 0, 320, 44);
    self.tableView.tableFooterView = self.contentLoadingIndicator;
    
    // Assign fonts
    [self.currentFeedLabel  setFont:CF_FONT_LIGHT(22)];
    [self.showingLabel      setFont:CF_FONT_BOLD(12)];
    [self.chooseLabel       setFont:CF_FONT_LIGHT(17)];
}
- (void)viewDidLoad
{
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [super viewWillAppear:animated];
    
    if (self.list.count == 0)
    {
        [self fetchContent];
    }
    
    [self refreshFeedLabel];
    
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list, plus one additional if there are more to be fetched
    return self.list.count;
}
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
    if (!self.contentLoadingIndicator.isAnimating
        && self.list.count == 0
        && self.hasFetchedAllContent)
    {
        UILabel *label = [[UILabel alloc] init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"No Content to display"];
        [label setFont:CF_FONT_LIGHT(16)];
        [label setTextColor:[UIColor blackColor]];
        
        return label;
    }
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.list.count == 0)
    {
        return 100;
    }
    
    return 0;
}
#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [self.contentLoadingIndicator startAnimating];
    [self setHasFinishedFetchRequest:NO];
    [self setCorrectList];
}
- (void)fetchedCollegeList
{
    [self.dataController finishedFetchingCollegeList];
//    [self locationWasUpdated];
    [self.tableView reloadData];
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    [self setCorrectList];
    [self.refreshControl endRefreshing];

    if ([[[notification userInfo] valueForKey:@"newObjectsCount"] longValue] < PAGINATION_NUM)
    {   // fetched all content for the current feed
        self.hasFetchedAllContent = YES;
        [self.contentLoadingIndicator stopAnimating];
    }
    
    if ([[[notification userInfo] valueForKey:@"feedName"] isEqualToString:@"userPosts"])
    {
        [self.dataController didFinishFetchingUserPosts];
    }
    
    self.hasFinishedFetchRequest = YES;
    
    NSLog(@"MasterViewController finished fetch request about to reload table data");
    [self.tableView reloadData];
}

#pragma mark - Local Actions

- (IBAction)changeFeed
{   // User wants to change the feed (all colleges, nearby college, or other)
    
    if (!self.isShowingTutorial)
    {
        FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithDataController:self.dataController WithFeedDelegate:self];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}
- (void)create
{   // Display popup to let user type a new post
    NSArray *nearbyColleges = [self.dataController getNearbyCollegeList];
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
        NearbyFeedViewController *controller = [[NearbyFeedViewController alloc] initWithDataController:self.dataController postingDelegate:self];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}
- (void)showCreationDialogForCollege:(College *) college
{
    self.createController = [[CreatePostCommentViewController alloc] initWithType:POST
                                                                      withCollege:college
                                                               withDataController:self.dataController];
    [self.createController setDelegate:self];
    [self presentViewController:self.createController animated:YES completion:nil];
}
- (void)pullToRefresh
{
    if ([self.navigationController respondsToSelector:@selector(startMyLocationManager)])
    {
        [self.navigationController performSelector:@selector(startMyLocationManager)];
    }

    [self fetchContent];
}

#pragma mark - Helper Methods

- (void)setNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tutorialFinished) name:@"TutorialFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tutorialStarted) name:@"TutorialStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedFetchRequest:) name:@"FinishedFetching" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchedCollegeList) name:@"FetchedColleges" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(create) name:@"CreatePost" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLocationActivityIndicator) name:@"LocationSearchingDidStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLocationActivityIndicator) name:@"LocationSearchingDidEnd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showComposeButton) name:@"FoundNearbyColleges" object:nil];
}
- (void)refreshFeedLabel
{
   [self.currentFeedLabel setText:[self.dataController getCurrentFeedName]];
    
    self.toolBarSpaceFromBottom.constant = 50;
    [self.feedToolbar updateConstraintsIfNeeded];
}
- (void)setCorrectList
{
    if (self.list == nil)
    {
        self.list = [NSMutableArray new];
    }
}
- (void)tutorialFinished
{
    self.isShowingTutorial = NO;
    [self.dataController.toastController releaseBlockedToasts];
    [self pullToRefresh];
    [self changeFeed];
}
- (void)tutorialStarted
{
    self.dataController.toastController.holdingNotifications = YES;
    self.isShowingTutorial = YES;
}
- (UIBarButtonItem *)blankBackButton
{
    return [[UIBarButtonItem alloc]
            initWithTitle:@""
            style:UIBarButtonItemStylePlain
            target:nil
            action:nil];
}

#pragma mark - ChildCellDelegate

- (void)displayCannotVote
{    // users cannot cast downvotes to a distant school
    [Shared queueToastWithSelector:@selector(toastInvalidDownvote)];
}
- (BOOL)castVote:(Vote *)vote
{   // vote was cast in a table cell
    
    if (vote.upvote)
    {
        NSLog(@"Casting upvote");
        return [self.dataController createVote:vote];
    }
    
    for (College *college in self.dataController.nearbyColleges)
    {
        if (college.collegeID == vote.collegeId
            && college.collegeID != 0)
        {
            NSLog(@"Downvote was confirmed to be in the college's proximity");
            return [self.dataController createVote:vote];
        }
    }
    
    NSLog(@"Failed to cast vote");
    return NO;
}
- (BOOL)cancelVote:(Vote *)vote
{
    return [self.dataController cancelVote:vote];
}
- (void)didSelectTag:(NSString *)tagMessage
{
    NSLog(@"MasterViewController called didSelectTag(). If valid, will display a TagPostsViewController");
    
    if ([Tag withMessageIsValid:tagMessage])
    {
        NSLog(@"Tag message = %@ is valid", tagMessage);
        
        if ([self.navigationController isKindOfClass:[CFNavigationController class]])
        {
            [((CFNavigationController *)self.navigationController) didSelectTag:tagMessage];
        }
        
        else
        {
            NSLog(@"Could not invoke CFNavController.didSelectTag()");;
        }
    }
    else
    {
        NSLog(@"ERROR. Attempted tag search with message = %@ was invalid", tagMessage);
        [Shared queueToastWithSelector:@selector(toastInvalidTagSearch)];
        
        
        
    }
}

#pragma mark - CreationViewProtocolDelegate

- (void)submitPostCommentCreationWithMessage:(NSString *)message
                               withCollegeId:(long)collegeId
                               withUserToken:(NSString *)userToken
                                   withImage:(UIImage *)image
{
    NSNumber *minutesUntilCanPost = [NSNumber new];
    if ([self.dataController isAbleToPost:minutesUntilCanPost])
    {
        [self.createController dismiss:self];

        BOOL success = [self.dataController createPostWithMessage:message
                                                    withCollegeId:collegeId
                                                        withImage:image];
        
        if (success)
        {
            NSLog(@"MasterViewController successfully created post");
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        else
        {
            [Shared queueToastWithSelector:@selector(toastPostFailed)];
        }
    }
    else
    {
        [self.dataController.toastController toastPostingTooSoon:minutesUntilCanPost];
    }
}
- (void)commentingTooFrequently
{
    // TODO
//    [self.toastController toastCommentingTooSoon];
}

#pragma mark - FeedSelectionProtocolDelegate

- (void)switchToFeedForCollegeOrNil:(College *)college
{
    NSLog(@"Switched to feed for college = %@", college.name);
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
    [self.dataController switchedToSpecificCollegeOrNil:college];
    [self setCorrectList];

    if (college == nil)
    {
        if ([self.list count] == 0)
        {
            [self fetchContent];
        }
        [self.tableView reloadData];
    }
    else
    {
        [self.list removeAllObjects];
        self.dataController.pageForNewPostsSingleCollege = 0;
        self.dataController.pageForTopPostsSingleCollege = 0;
        self.dataController.pageForTrendingTagsSingleCollege = 0;
        [self fetchContent];
    }
    
    [self refreshFeedLabel];
    self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
}
- (void)showDialogForAllColleges
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    CollegeSearchViewController *controller = [[CollegeSearchViewController alloc]
                                               initWithDataController:self.dataController
                                               feedDelegate:self];
    
    [[self navigationItem] setBackBarButtonItem:[self blankBackButton]];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - PostingSelectionProtocolDelegate

- (void)submitSelectionForPostWithCollege:(College *)college
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self.view setNeedsDisplay];

    [self showCreationDialogForCollege:college];
}


@end
