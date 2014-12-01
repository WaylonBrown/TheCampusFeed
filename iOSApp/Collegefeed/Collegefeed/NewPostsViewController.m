//
//  NewPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "NewPostsViewController.h"

@implementation NewPostsViewController

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];
    
    if (self.dataController.showingAllColleges)
    {
        [self.dataController fetchNewPostsForAllColleges];
    }
    else
    {
        [self.dataController fetchNewPostsForSingleCollege];
    }
}
- (void)finishedFetchRequest
{
    [super finishedFetchRequest];
}

#pragma mark - Local Actions

- (void)changeFeed
{
    [super changeFeed];
}
- (void)refresh
{   // refresh this post view
    [super refresh];
}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    if (self.dataController.showingAllColleges)
    {
        [self setList:self.dataController.recentPostsAllColleges];
    }
    else
    {
        [self setList:self.dataController.recentPostsSingleCollege];
    }
    
    [super setCorrectList];
}

@end