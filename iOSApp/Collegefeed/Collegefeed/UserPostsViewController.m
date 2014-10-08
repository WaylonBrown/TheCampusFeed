//
//  UserPostsViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "UserPostsViewController.h"
#import "Shared.h"

@interface UserPostsViewController ()

@end

@implementation UserPostsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addScoreFooter];
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

- (void)addScoreFooter
{
    [self.feedToolbar removeFromSuperview];

    long points = [self.dataController getUserPostScore];
    self.scoreLabel.text = [NSString stringWithFormat:@"Post Score: %ld", points];
    [self.scoreLabel setFont:CF_FONT_LIGHT(20)];
    self.scoreToolbar.hidden = NO;
}

@end
