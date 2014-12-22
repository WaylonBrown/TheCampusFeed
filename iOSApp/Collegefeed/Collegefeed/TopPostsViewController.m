//
//  TopPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TopPostsViewController.h"

@implementation TopPostsViewController

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];
    
    if (self.dataController.showingAllColleges)
    {
        [self.dataController fetchTopPostsForAllColleges];
    }
    else
    {
        [self.dataController fetchTopPostsForSingleCollege];
    }
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    [super finishedFetchRequest:notification];
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
        [self setList:self.dataController.topPostsAllColleges];
    }
    else
    {
        [self setList:self.dataController.topPostsSingleCollege];
    }
    
    [super setCorrectList];
}

@end
