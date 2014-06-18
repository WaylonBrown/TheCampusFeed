//
//  MasterViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "MasterViewController.h"
#import "CommentViewController.h"
#import "CollegePickerViewController.h"
#import "TableCell.h"
#import "Models/Models/Post.h"
#import "DataController.h"
#import "Shared.h"
#import "AppDelegate.h"
#import "Models/Models/College.h"
#import "NearbyCollegeSelector.h"
#import "NewPostAlertView.h"
#import "CreatePostCommentViewController.h"

@implementation MasterViewController

#pragma mark - Initialization and View Loading

- (id)initWithAppData:(AppData *)data
{
    self = [super initWithNibName:@"MasterView" bundle:nil];
    if (self)
    {
        [self setAppData:data];
        
        // Initialize a loading indicator, refresh control, and nearby college selector
        self.refreshControl     = [[UIRefreshControl alloc] init];
        self.selector           = [[NearbyCollegeSelector alloc] initWithAppData:self.appData];
        self.activityIndicator  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

        [self.refreshControl addTarget:self action:@selector(refresh)
                      forControlEvents:UIControlEventValueChanged];
    }
    return self;
}
- (void)loadView
{   // called when this view is initially loaded
    
    [super loadView];

    // Show loading indicator until a nearby college is found,
    // then replace it with a create post button
    if ([self.appData isNearCollege])
    {
        [self placeCreatePost];
    }
    else
    {
        [self placeLoadingIndicator];
    }
    
    [self.tableView addSubview:self.refreshControl];

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
    if ([self.appData isNearCollege])
    {
        [self placeCreatePost];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:nil];
    }
}
- (void)didNotFindLocation
{   // Called when the user's location cannot be determined. Stop and remove activity indicator
    [self.activityIndicator stopAnimating];
    [self.navigationItem setRightBarButtonItem:nil];
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
    
    CollegePickerViewController *controller = self.appData.collegeFeedPicker;
    [controller setDelegate:self];
    [self.navigationController pushViewController:controller animated:YES];
    [self refresh];
}
- (void)create
{   // Display popup to let user type a new post
    CreatePostCommentViewController *alert = [CreatePostCommentViewController new];
    [self presentViewController:alert animated:YES completion:nil];
    
//    
//    NSArray *nearbyColleges = self.appData.nearbyColleges;
//    if (nearbyColleges.count == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:@"You cannot post because you are not within range of any known colleges"
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else
//    {
//        [self.selector displaySelectorForNearbyColleges:nearbyColleges];
//    }
}
- (void)refresh
{   // refresh the current view
    NSString *feedName = self.appData.currentCollege.name;
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
    [self.appData.dataController createVote:vote];
}
- (void)selectedCollegeOrNil:(College *)college
                        from:(CollegePickerViewController *)sender
{   // A feed was selected from either the 'top colleges' in tab bar or from the 'change' button on toolbar
    
    [self.appData switchedToSpecificCollegeOrNil:college];
    
    if (sender.topColleges)
    {   // change to 'top posts' tab if selection made from 'top colleges' tab
        [self.tabBarController setSelectedIndex:0];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self refresh];
    //    if (college == nil)
//    {
//        [self.currentFeedLabel setText:@"All Colleges"];
//    }
//    else
//    {
//        [self.currentFeedLabel setText:college.name];
//    }
}

@end
