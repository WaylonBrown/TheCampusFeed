//
//  TopPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "TopPostsViewController.h"

@implementation TopPostsViewController

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];
    
    if (self.dataController.showingAllColleges)
    {
        NSLog(@"Fetching Top Posts in all colleges");
        [self.dataController fetchTopPostsForAllColleges];
    }
    else
    {
        NSLog(@"Fetching Top Posts in %@", self.dataController.collegeInFocus.name);
        [self.dataController fetchTopPostsForSingleCollege];
    }
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    if ([[[notification userInfo] valueForKey:@"feedName"] isEqualToString:@"topPosts"])
    {
        NSLog(@"Finished fetching Top Posts");
        [super finishedFetchRequest:notification];
    }
}
#pragma mark - Local Actions

- (void)changeFeed
{
    [super changeFeed];
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
