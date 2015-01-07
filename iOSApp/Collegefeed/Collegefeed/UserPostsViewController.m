//
//  UserPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "UserPostsViewController.h"
#import "Shared.h"

#define BUTTON_MARGIN 15
#define BUTTON_HEIGHT 75

@implementation UserPostsViewController

#pragma mark - View Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return BUTTON_HEIGHT + 2 * BUTTON_MARGIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float buttonWidth = tableView.frame.size.width - (2 * BUTTON_MARGIN);
    UIView *achievementButton = [[UIView alloc] initWithFrame:CGRectMake(BUTTON_MARGIN, BUTTON_MARGIN, buttonWidth, BUTTON_HEIGHT)];
    achievementButton.backgroundColor = [Shared getCustomUIColor:CF_GREEN];
    
    return achievementButton;
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];

    [self.dataController retrieveUserPosts];
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    [super finishedFetchRequest:notification];
    [self addScoreFooter];
}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    [self setList:self.dataController.userPosts];
    [super setCorrectList];
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
