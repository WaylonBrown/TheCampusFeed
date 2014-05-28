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

#import "DataController.h"
#import "PostDataController.h"
#import "CollegeDataController.h"
#import "TagDataController.h"
#import "VoteDataController.h"
#import "Shared.h"

#import "College.h"

@implementation MasterViewController

- (id)initWithDataControllers:(NSArray *)dataControllers
{
    self = [super initWithNibName:@"MasterView" bundle:nil];
    if (self)
    {
        // Custom initialization
        [self setPostDataController     :[dataControllers objectAtIndex:0]];
        [self setCommentDataController  :[dataControllers objectAtIndex:1]];
        [self setVoteDataController     :[dataControllers objectAtIndex:2]];
        [self setCollegeDataController  :[dataControllers objectAtIndex:3]];
        [self setTagDataController      :[dataControllers objectAtIndex:4]];

        
        UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        
        [self.collegeSegmentControl setTitleTextAttributes:attributes
                                                  forState:UIControlStateSelected];
        
        
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    [self.navigationController.navigationBar.topItem setTitleView:logoTitleView];
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [self.tableView reloadData];
}
- (NSArray *)getDataControllers
{   // return an array of all 5 universal data controllers
    NSArray *dataControllers = [[NSArray alloc]initWithObjects:
                                self.postDataController,
                                self.commentDataController,
                                self.voteDataController,
                                self.collegeDataController,
                                self.tagDataController, nil];
    
    return dataControllers;
}
#pragma mark - Navigation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{   // User should not directly modify a TableCell
    return NO;
}

#pragma mark - Actions

- (IBAction)changeFeed:(id)sender
{   // User changed the feed (all colleges or a specific one)
    NSInteger index = [self.collegeSegmentControl selectedSegmentIndex];
    if (index == 0) // all colleges
        [self.postDataController setList:self.postDataController.topPostsAllColleges.copy];
    
    else if (index == 1) // Choose a college
    {
        CollegePickerViewController *controller = [[CollegePickerViewController alloc] init];
        [controller setCollegesList:self.collegeDataController.list];
        [controller setDelegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }
    //    else if (index == 2) // My current college
    [self.tableView reloadData];
    
}

#pragma mark - Delegate Methods

- (void)castVote:(Vote *)vote
{   // vote was cast in a table cell
    [self.voteDataController addToServer:vote
                                intoList:self.voteDataController.list];
}

- (void)selectedCollege:(College *)college
{   // A college was selected in the College Picker View
    [self.navigationController popViewControllerAnimated:YES];
    [self.collegeSegmentControl insertSegmentWithTitle:college.name
                                               atIndex:2 animated:NO];
    [self setCurrentCollege:college];
    [self.tableView reloadData];
}

@end
