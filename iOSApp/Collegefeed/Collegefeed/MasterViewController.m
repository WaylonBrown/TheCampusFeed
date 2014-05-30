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

#import "DataController.h"
#import "PostDataController.h"
#import "CollegeDataController.h"
#import "TagDataController.h"
#import "VoteDataController.h"
#import "Shared.h"
#import "AppDelegate.h"

#import "College.h"

@implementation MasterViewController

#pragma mark - Initialization

- (id)initWithDelegateId:(id<MasterViewDelegate>)delegate
{
    self = [super initWithNibName:@"MasterView" bundle:nil];
    if (self)
    {
        [self setAppDelegate:delegate];
        
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
    [super loadView];
    [self.navigationController.navigationBar.topItem setTitleView:logoTitleView];
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [self.navigationController.navigationBar.topItem setTitleView:logoTitleView];

    if ([self.appDelegate getIsAllColleges] == YES)
    {
        [self.collegeSegmentControl setSelectedSegmentIndex:0];
    }
    else if ([self.appDelegate getIsSpecificCollege] == NO)
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
        [self.appDelegate switchedToSpecificCollegeOrNil:nil];
    }
    else if (index == 1) // Choose a college
    {
        CollegePickerViewController *controller = [[CollegePickerViewController alloc] init];
        [controller setCollegesList:self.appDelegate.collegeDataController.list];
        [controller setDelegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (index == 2) // My current college
    {
        [self.appDelegate switchedToSpecificCollegeOrNil:[self.appDelegate getCurrentCollege]]; 
    }
    [self refresh];
}
- (void)create
{
    
}
- (void)refresh
{   // refresh the current view
    [self.tableView reloadData];
}

#pragma mark - Delegate Methods

- (void)castVote:(Vote *)vote
{   // vote was cast in a table cell
    [self.appDelegate.voteDataController addToServer:vote
                                intoList:self.appDelegate.voteDataController.list];
}
- (void)selectedCollege:(College *)college
{   // A college was selected in the College Picker View
    [self.navigationController popViewControllerAnimated:YES];

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

    [self.appDelegate switchedToSpecificCollegeOrNil:college];
    [self refresh];
}

@end
