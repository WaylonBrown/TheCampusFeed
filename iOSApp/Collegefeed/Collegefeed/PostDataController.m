//
//  PostDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostDataController.h"
#import "Post.h"
#import "Shared.h"

@implementation PostDataController

#pragma mark - Initialization

- (id)initWithNetwork
{ // initialize this data controller
    if (self = [super initWithNetwork])
    {
        [self setTopPostsAllColleges:   [[NSMutableArray alloc] init]];
        [self setRecentPostsAllColleges:[[NSMutableArray alloc] init]];
        [self setUserPostsAllColleges:  [[NSMutableArray alloc] init]];
        [self setTopPostsInCollege:     [[NSMutableArray alloc] init]];
        [self setRecentPostsInCollege:  [[NSMutableArray alloc] init]];
        [self setUserPostsInCollege:    [[NSMutableArray alloc] init]];
        
        [self fetchTopPosts];
        [self fetchNewPosts];
        
        return self;
    }
    return nil;
}

#pragma mark - Network Access

- (void)refresh
{
    
}
- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{   // Call getJsonObjectWithUrl to access network,
    // then read JSON result into the provided array
    if (array == nil)
    {
        NSLog(@"nil array passed to fetchWithUrl");
        return;
    }
    @try
    {
        NSArray *jsonArray = (NSArray*)[self getJsonObjectWithUrl:url];
        
        [array removeAllObjects];
        for (int i = 0; i < jsonArray.count; i++)
        {
            // Individual JSON object
            NSDictionary *jsonPost = (NSDictionary *) [jsonArray objectAtIndex:i];
            Post* newPost = [[Post alloc] initFromJSON:jsonPost];
            [array addObject:newPost];
        }
    }
    @catch (NSException *exc)
    {
        NSLog(@"Error fetching all posts");
    }
}

- (void)fetchTopPosts
{
    [self fetchWithUrl:[Shared GETTrendingPosts]
              intoList:self.topPostsAllColleges];
    
    [self setList:self.topPostsAllColleges];
}
- (void)fetchTopPostsWithCollegeId:(long)collegeId
{
    [self fetchWithUrl:[Shared GETTrendingPostsWithCollegeId:collegeId ]
              intoList:self.topPostsInCollege];
    
    [self setList:self.topPostsInCollege];
}
- (void)fetchNewPosts
{
    [self fetchWithUrl:[Shared GETRecentPosts]
              intoList:self.recentPostsAllColleges];
    [self setList:self.recentPostsAllColleges];
}
- (void)fetchNewPostsWithCollegeId:(long)collegeId
{
    [self fetchWithUrl:[Shared GETRecentPostsWithCollegeId:collegeId]
              intoList:self.recentPostsInCollege];
    [self setList:self.recentPostsInCollege];
}

@end
