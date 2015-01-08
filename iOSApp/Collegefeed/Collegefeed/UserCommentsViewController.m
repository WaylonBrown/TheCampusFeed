//
//  UserCommentsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/21/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
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
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];
    
    [self.dataController retrieveUserComments];
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    [super finishedFetchRequest:notification];
    
    [self addScoreFooter];
}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    [self setList:self.dataController.userComments];
    
    [super setCorrectList];
}
- (void)addScoreFooter
{
    [self.feedToolbar removeFromSuperview];
    long points = [self.dataController getUserCommentScore];
    self.scoreLabel.text = [NSString stringWithFormat:@"Comment Score: %ld", points];
    [self.scoreLabel setFont:CF_FONT_LIGHT(20)];
    self.scoreToolbar.hidden = NO;
}


@end
