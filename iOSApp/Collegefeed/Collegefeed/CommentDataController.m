//
//  CommentDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CommentDataController.h"
#import "Comment.h"
#import "Post.h"
#import "Constants.h"

@implementation CommentDataController

#pragma mark - Initialization

- (id)initWithNetwork:(BOOL)useNetwork
{   // Initialize with default list
    return [self initWithNetwork:useNetwork withPost:nil];
}
- (id)initWithNetwork:(BOOL)useNetwork withPost:(Post*)post
{   // Initialize using the post's comment list
    if (self = [super init])
    {
        [self setPost:post];
        if (useNetwork)
        {
            [self setList:[[NSMutableArray alloc] init]];
            [self fetchWithUrl:commentsUrlGet(post.postID)
                      intoList:self.list];
        }
        else
        {
            [self initializeDefaultList];
        }
        return self;
    }
    return nil;
}
- (void)initializeDefaultList
{   // initialize the comment array with placeholder elements
 
    NSMutableArray *commentList = [[NSMutableArray alloc] init];
    self.list = commentList;
    Post *post = [[Post alloc] initDummy];

    for (int i = 0; i < 4; i++)
    {
        Comment *comment;
        comment = [[Comment alloc] initWithPost:post];
        [self addObjectToList:comment];
    }
}

#pragma mark - Data Access

- (NSString *)getPostMessage
{   // return a string of the master post for these comments

    if (self.post != nil)
        return self.post.message;
    return @"[Post's message not found]";
}
//- (void)addObjectToList:(NSObject *)obj
//{   // add comment to list maintained by this datacontroller and the post
//
//    [self.post.commentList addObject:obj];
//}

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
            NSDictionary *jsonComment = (NSDictionary *) [jsonArray objectAtIndex:i];
            Comment* newComment = [[Comment alloc] initFromJSON:jsonComment];
            [array addObject:newComment];
        }
    }
    @catch (NSException *exc)
    {
        NSLog(@"Error fetching all posts");
    }
}
@end
