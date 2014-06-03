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
#import "Post.h"
#import "DataController.h"
#import "PostDataController.h"
#import "CollegeDataController.h"
#import "TagDataController.h"
#import "VoteDataController.h"
#import "Shared.h"
#import "AppDelegate.h"
#import "College.h"

@implementation MasterViewController

#pragma mark - Initialization and View Loading

- (id)initWithAppData:(AppData *)data
{
    self = [super initWithNibName:@"MasterView" bundle:nil];
    if (self)
    {
        [self setAppData:data];
        
        UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        
        [self.collegeSegmentControl setTitleTextAttributes:attributes
                                                  forState:UIControlStateSelected];
    }
    return self;
}
- (void)loadView
{   // called when this view is initially loaded
    
    // place logo at the top of the navigation bar
    [self.navigationController.navigationBar.topItem setTitleView:logoTitleView];
    
    // initialize a loading indicator and place it in top right corner
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self placeLoadingIndicator];
    
    [super loadView];
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

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                           target:self action:@selector(create)]];
    
    [self.activityIndicator stopAnimating];
    [self refresh];
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [self.navigationController.navigationBar.topItem setTitleView:logoTitleView];

    if (self.appData.allColleges == YES)
    {
        [self.collegeSegmentControl setSelectedSegmentIndex:0];
    }
    else if (self.appData.specificCollege == NO)
    {
        [self.collegeSegmentControl setSelectedSegmentIndex:2];
    }
    [self refresh];
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
{   // User changed the feed (all colleges or a specific one)
    NSInteger index = [self.collegeSegmentControl selectedSegmentIndex];
    if (index == 0) // all colleges
    {
        [self.appData switchedToSpecificCollegeOrNil:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (index == 1) // Choose from list of all colleges
    {
        CollegePickerViewController *controller = [[CollegePickerViewController alloc] initAsAllColleges];
        [controller setCollegesList:self.appData.collegeDataController.list];
        [controller setDelegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (index == 2) // My current college
    {
        [self.appData switchedToSpecificCollegeOrNil:self.appData.currentCollege];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self refresh];
}

- (void)create
{   // Display popup to let user type a new post
    College *currentCollege = self.appData.currentCollege;
    if (currentCollege == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must have a college selected before being able to post"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Post"
                                                        message:[NSString stringWithFormat:@"Posting to %@", currentCollege.name]
                                                       delegate:self
                                              cancelButtonTitle:@"nvm.."
                                              otherButtonTitles:@"Post dis bitch!", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   // Add new post if user submits on the alert view
    
    if (buttonIndex == 0)
    {
        return;
    }
    College *currentCollege = self.appData.currentCollege;
    if (currentCollege != nil)
    {
        Post *newPost = [[Post alloc] initWithMessage:[[alertView textFieldAtIndex:0] text]
                                        withCollegeId:currentCollege.collegeID];
        [self.appData.postDataController POSTtoServer:newPost
                                             intoList:self.appData.postDataController.topPostsAllColleges];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A college must be selected to post to"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self refresh];
}

- (void)refresh
{   // refresh the current view

    [self.tableView reloadData];
}

#pragma mark - Delegate Methods

- (void)castVote:(Vote *)vote
{   // vote was cast in a table cell
    [self.appData.voteDataController POSTtoServer:vote
                                         intoList:self.appData.voteDataController.list];
}
- (void)selectedCollege:(College *)college
                   from:(CollegePickerViewController *)sender
{   // A college was selected in either the segmented college picker or the tab bar controller
    
    [self.appData switchedToSpecificCollegeOrNil:college];
    
    if (sender.topColleges)
    {
        [self.tabBarController setSelectedIndex:0];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if (self.collegeSegmentControl.numberOfSegments < 3)
    {
        [self.collegeSegmentControl insertSegmentWithTitle:college.name
                                                   atIndex:2 animated:NO];
    }
    else
    {
        [self.collegeSegmentControl setTitle:college.name
                           forSegmentAtIndex:2];
    }
    
    [self.collegeSegmentControl setSelectedSegmentIndex:2];
    
}

@end
