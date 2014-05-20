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

@implementation CommentDataController

#pragma mark - Initialization

- (id)init
{   // Initialize with default list
    if (self = [super init])
    {
        [self initializeDefaultList];
        return self;
    }
    return nil;
}
- (id)initWithPost:(Post*)post
{   // Initialize using the post's comment list
    if (self = [super init])
    {
        [self setPost:post];
        [self setList:post.commentList];
        
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

- (void)addObjectToList:(NSObject *)obj
{   // add comment to list maintained by this datacontroller and the post
//    [super addObjectToList:obj];

    [self.post.commentList addObject:obj];
}

@end
