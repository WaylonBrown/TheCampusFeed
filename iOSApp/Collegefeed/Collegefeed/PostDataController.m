//
//  PostDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostDataController.h"
#import "Post.h"
#import "Constants.h"

@implementation PostDataController

#pragma mark - Initialization

- (id)initWithNetwork:(BOOL)useNetwork
{ // initialize this data controller
    if (self = [super init])
    {
//        [self setTopPostsAllColleges:[[NSMutableArray alloc] init]];
//        [self setRecentPostsAllColleges:[[NSMutableArray alloc] init]];
//        [self setUserPostsAllColleges:[[NSMutableArray alloc] init]];
//        [self setTopPostsInCollege:[[NSMutableArray alloc] init]];
//        [self setRecentPostsInCollege:[[NSMutableArray alloc] init]];
//        [self setUserPostsInCollege:[[NSMutableArray alloc] init]];
        
        if (useNetwork)
        {
            [self setList:[[NSMutableArray alloc] init]];
            [self fetchWithUrl:postsUrl
                      intoList:self.list];
        }
        else // dummy initialization
        {
            [self initializeDefaultList];
        }
        return self;
    }
    return nil;
}
- (void)initializeDefaultList
{ // initialize the post array with placeholder elements

    [self setList:[[NSMutableArray alloc] init]];

    for (int i = 0; i < 3; i++)
    {
        Post *post;
        post = [[Post alloc] initDummy];
        post.postID = i;
        [self addObjectToList:post];
    }
}

#pragma mark - Network Access

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


@end
