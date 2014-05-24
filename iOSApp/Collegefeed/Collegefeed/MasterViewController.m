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

#import "PostDataController.h"
#import "CollegeDataController.h"
#import "TagDataController.h"
#import "VoteDataController.h"
#import "Constants.h"

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MasterView" bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.postDataController = [[PostDataController alloc] initWithNetwork:YES];
        self.tagDataController = [[TagDataController alloc] initWithNetwork:YES];
        self.collegeDataController = [[CollegeDataController alloc] initWithNetwork:YES];
        self.voteDataController = [[VoteDataController alloc] init];
        
        UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];

        [self.collegeSegmentControl setTitleTextAttributes:attributes
                                                  forState:UIControlStateSelected];
        [self.navigationController.navigationBar.topItem setTitleView:logoTitleView];


    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [self.navigationController.navigationBar.topItem setTitleView:logoTitleView];
    [self.navigationItem setTitleView:logoTitleView];

    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
{
    NSInteger index = [self.collegeSegmentControl selectedSegmentIndex];
    if (index == 0) // all colleges
        [self.postDataController setList:self.postDataController.topPostsAllColleges.copy];
    
    else if (index == 1) // Choose a college
    {
        CollegePickerViewController *controller = [[CollegePickerViewController alloc] init];
        [controller setCollegesList:self.collegeDataController.list];
        [self.navigationController pushViewController:controller animated:YES];
       
    }
    //    else if (index == 2) // My current college
    [self.tableView reloadData];
    
}

#pragma mark - Delegate Methods

- (void)castVote:(Vote *)vote
{
    [self.voteDataController addToServer:vote
                                intoList:self.voteDataController.list];
}


@end
