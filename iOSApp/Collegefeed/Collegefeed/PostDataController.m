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

- (id)init
{ // initialize this data controller
    if (self = [super init])
    {
        [self fetchTopPosts];
        [self fetchNewPosts];
        
        return self;
    }
    return nil;
}

#pragma mark - Network Access

- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{   // Call GETfromServer to access network,
    // then read JSON result into the provided array
    if (array == nil)
    {
        NSLog(@"nil array passed to fetchWithUrl");
        return;
    }
    NSArray *jsonArray = (NSArray*)[self GETfromServer:url];
    if (jsonArray == nil) return;
    
    [array removeAllObjects];
    for (int i = 0; i < jsonArray.count; i++)
    {
        // Individual JSON object
        NSDictionary *jsonPost = (NSDictionary *) [jsonArray objectAtIndex:i];
        Post* newPost = [[Post alloc] initFromJSON:jsonPost];
        [array addObject:newPost];
    }
}

- (void)fetchTopPosts
{
    [self setTopPostsAllColleges:[[NSMutableArray alloc] init]];

    [self fetchWithUrl:[Shared GETTrendingPosts]
              intoList:self.topPostsAllColleges];
    
    [self setList:self.topPostsAllColleges];
}
- (void)fetchTopPostsWithCollegeId:(long)collegeId
{
    [self setTopPostsInCollege:[[NSMutableArray alloc] init]];

    [self fetchWithUrl:[Shared GETTrendingPostsWithCollegeId:collegeId ]
              intoList:self.topPostsInCollege];
    
    [self setList:self.topPostsInCollege];
}
- (void)fetchNewPosts
{
    [self setRecentPostsAllColleges:[[NSMutableArray alloc] init]];

    [self fetchWithUrl:[Shared GETRecentPosts]
              intoList:self.recentPostsAllColleges];
    [self setList:self.recentPostsAllColleges];
}
- (void)fetchNewPostsWithCollegeId:(long)collegeId
{
    [self setRecentPostsInCollege:[[NSMutableArray alloc] init]];

    [self fetchWithUrl:[Shared GETRecentPostsWithCollegeId:collegeId]
              intoList:self.recentPostsInCollege];
    [self setList:self.recentPostsInCollege];
}
- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage
{
    [self setAllPostsWithTag:[[NSMutableArray alloc] init]];
    
    [self fetchWithUrl:[Shared GETPostsWithTagName:tagMessage]
              intoList:self.allPostsWithTag];
    [self setList:self.allPostsWithTag];
}
- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage
                      withCollegeId:(long)collegeId
{
    [self setAllPostsWithTagInCollege:[[NSMutableArray alloc] init]];
    
    [self fetchWithUrl:[Shared GETPostsWithTagName:tagMessage withCollegeId:collegeId]
              intoList:self.allPostsWithTagInCollege];
    [self setList:self.allPostsWithTagInCollege];
}

- (void)fetchUserPostsWithUserId:(long)userId
{
    [self setUserPostsAllColleges:[[NSMutableArray alloc] init]];

}
- (void)fetchUserPostsWithUserId:(long)userId
                   WithCollegeId:(long)collegeId
{
    [self setUserPostsInCollege:[[NSMutableArray alloc] init]];

}

@end
