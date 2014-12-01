//
//  TopPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TopPostsViewController.h"
#import "TableCell.h"
#import "Post.h"

@implementation TopPostsViewController

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    [super fetchContent];

    [self setCorrectPostList];
    
    if (self.list.count == 0)
    {
        [self.contentLoadingIndicator startAnimating];
    }
    
    // Spawn separate thread for network access
    
    if (self.dataController.showingAllColleges)
    {
        [self.dataController fetchTopPostsForAllColleges];
    }
    else
    {
        [self.dataController fetchTopPostsForSingleCollege];
    }
}
- (void)finishedFetchRequest
{
    [super finishedFetchRequest];
}
- (BOOL)loadMorePosts
{
    if (self.dataController.showingAllColleges)
    {
        [self.dataController fetchTopPostsForAllColleges];
    }
    else
    {
        [self.dataController fetchTopPostsForSingleCollege];
    }
    
    return YES;
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

- (void)setCorrectPostList
{
    if (self.dataController.showingAllColleges)
    {
        [self setList:self.dataController.topPostsAllColleges];
    }
    else
    {
        [self setList:self.dataController.topPostsInCollege];
    }
    
    [super setCorrectPostList];
}

@end
