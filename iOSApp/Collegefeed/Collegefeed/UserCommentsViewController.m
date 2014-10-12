//
//  UserCommentsViewController.m
// TheCampusFeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "UserCommentsViewController.h"
#import "Shared.h"

@interface UserCommentsViewController ()

@end

@implementation UserCommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [self.tableView reloadData];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath] - 20;
//}

- (void)addScoreFooter
{
    [self.feedToolbar removeFromSuperview];
    long points = [self.dataController getUserCommentScore];
    self.scoreLabel.text = [NSString stringWithFormat:@"Comment Score: %ld", points];
    [self.scoreLabel setFont:CF_FONT_LIGHT(20)];
    self.scoreToolbar.hidden = NO;
}


@end
