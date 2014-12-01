//
//  UserPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "UserPostsViewController.h"
#import "Shared.h"

@implementation UserPostsViewController

#pragma mark - View Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addScoreFooter];
}

#pragma mark - Local Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];
    
    [self.dataController retrieveUserPosts];
}
- (void)finishedFetchRequest
{
    [super finishedFetchRequest];
}

- (void)refresh
{
    [super refresh];
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
