//
//  NewPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "NewPostsViewController.h"

@implementation NewPostsViewController

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];
    
    if (self.dataController.showingAllColleges)
    {
        NSLog(@"Fetching New Posts in all colleges");
        [self.dataController fetchNewPostsForAllColleges];
    }
    else
    {
        NSLog(@"Fetching New Posts in %@", self.dataController.collegeInFocus.name);
        [self.dataController fetchNewPostsForSingleCollege];
    }
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    if ([[[notification userInfo] valueForKey:@"feedName"] isEqualToString:@"newPosts"])
    {
        NSLog(@"Finished fetching New Posts");
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
        [self setList:self.dataController.recentPostsAllColleges];
    }
    else
    {
        [self setList:self.dataController.recentPostsSingleCollege];
    }
    
    [super setCorrectList];
}

@end