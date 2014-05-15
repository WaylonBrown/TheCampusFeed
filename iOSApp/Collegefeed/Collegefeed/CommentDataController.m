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
        [self setMasterCommentList:post.commentList];
        
        return self;
    }
    return nil;
}
- (void)initializeDefaultList
{   // initialize the comment array with placeholder elements
 
    NSMutableArray *commentList = [[NSMutableArray alloc] init];
    self.masterCommentList = commentList;
    Post *post = [[Post alloc] initDummy];

    for (int i = 0; i < 4; i++)
    {
        Comment *comment;
        comment = [[Comment alloc] initWithPost:post];
        [self addComment:comment];
    }
}

#pragma mark - Data Access

- (NSString *)getPostMessage
{   // return a string of the post that this comment is on

    if (self.masterCommentList.count == 0)
        return @"[Post's message not found]";
    
    //TODO: move this to a test class
    NSString *message1 = ((Comment *)self.masterCommentList.firstObject).postMessage;
    NSString *message2 = ((Comment *)self.masterCommentList.lastObject).postMessage;
    
    if ([message1 isEqualToString:message2])
    {
        return message1;
    }
    return @"[Comments' post messages inconsistent]";
}
- (void)setMasterCommentList:(NSMutableArray *)newList
{   // override its default setter method to ensure new array remains mutable
    if (_masterCommentList != newList)
    {
        _masterCommentList = [newList mutableCopy];
    }
}
- (NSUInteger)countOfList
{
    return [self.masterCommentList count];
}
- (Comment *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterCommentList objectAtIndex:theIndex];
}
- (void)addComment:(Comment *)comment
{   // add comment to list maintained by this datacontroller and the post
    [self.masterCommentList addObject:comment];
    [self.post.commentList addObject:comment];
}

@end
