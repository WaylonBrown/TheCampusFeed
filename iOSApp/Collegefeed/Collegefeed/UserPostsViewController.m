//
//  UserPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "UserPostsViewController.h"
#import "Shared.h"
#import <QuartzCore/QuartzCore.h>

#define BUTTON_MARGIN 10
#define BUTTON_HEIGHT 60

@implementation UserPostsViewController

#pragma mark - View Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Build button view
    float buttonWidth = self.view.frame.size.width - (2 * BUTTON_MARGIN);
    self.achievementButtonView = [[UIView alloc] initWithFrame:CGRectMake(BUTTON_MARGIN, BUTTON_MARGIN, buttonWidth, BUTTON_HEIGHT)];
    self.achievementButtonView.backgroundColor = [Shared getCustomUIColor:CF_BLUE];

    // Add shadow
    CALayer *layer = self.achievementButtonView.layer;
    layer.cornerRadius = 5;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 2.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    // Tropy image
    UIImageView *trophy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trophy_small"]];
    trophy.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = trophy.frame;
    frame.size.height = BUTTON_HEIGHT - 2 * BUTTON_MARGIN;
    [trophy setFrame:frame];
    [trophy setCenter:CGPointMake(buttonWidth / 2, BUTTON_HEIGHT / 2)];
    [self.achievementButtonView addSubview:trophy];
    
    // Tap gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToAchievements" object:nil]; }
                                   action:@selector(invoke)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.achievementButtonView addGestureRecognizer:tap];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return BUTTON_HEIGHT + 2 * BUTTON_MARGIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [headerView addSubview:self.achievementButtonView];
    return headerView;
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
