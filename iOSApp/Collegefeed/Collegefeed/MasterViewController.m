//
//  MasterViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "MasterViewController.h"
#import "CommentViewController.h"

#import "PostDataController.h"
#import "CollegeDataController.h"
#import "TagDataController.h"
#import "VoteDataController.h"

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
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    
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
{   // User should not directly modify a PostTableCell
    
    return NO;
}

#pragma mark - Actions

- (IBAction)create:(id)sender
{   // Display popup to let user type a new post
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Post"
//                                                    message:@"What's poppin?"
//                                                   delegate:self
//                                          cancelButtonTitle:@"nvm.."
//                                          otherButtonTitles:@"Post!", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   // Add new post if user submits on the alert view
    
//    if (buttonIndex == 0) return;
    //TODO
//    Post *newPost = [[Post alloc] initWithPostMessage:[[alertView textFieldAtIndex:0] text]];
//    [self.postDataController addPost:newPost];
//    [self.tableView reloadData];
    
}
- (IBAction)cancel:(id)sender
{
    
    
}

#pragma mark - Delegate Methods

- (void)castVote:(Vote *)vote
{
    [self.voteDataController addToServer:vote
                                intoList:self.voteDataController.list];
}


@end
