//
//  UserCommentsViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "UserCommentsViewController.h"

@interface UserCommentsViewController ()

@end

@implementation UserCommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    long points = [self.dataController getUserCommentScore];
    NSString *feedLabel = [NSString stringWithFormat:@"My Comments (%ld total points)", points];
    [self.currentFeedLabel setText:feedLabel];
    [self.tableView reloadData];
    [self.toolbarSeparator removeFromSuperview];
    [self.feedButton removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
