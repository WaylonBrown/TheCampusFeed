//
//  UserPostsViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "UserPostsViewController.h"

@interface UserPostsViewController ()

@end

@implementation UserPostsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    long points = [self.dataController getUserPostScore];
    NSString *feedLabel = [NSString stringWithFormat:@"My Posts (%ld total points)", points];
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
}

@end
