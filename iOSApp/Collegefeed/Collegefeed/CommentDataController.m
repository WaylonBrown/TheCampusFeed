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

- (id) init
{
    if (self = [super init])
    {
        [self initializeDefaultList];
        return self;
    }
    return nil;
}
- (id) initWithPost:(Post*)post
{
    if (self = [super init])
    {
        [self setPost:post];
        self.masterCommentList = post.commentList;
        
        return self;
    }
    return nil;
}

// initialize the comment array with a placeholder element
- (void)initializeDefaultList
{
    NSMutableArray *commentList = [[NSMutableArray alloc] init];
    self.masterCommentList = commentList;
    Post *post = [[Post alloc] initDummy];

    for (int i = 0; i < 4; i++)
    {
        Comment *comment;
        comment = [[Comment alloc] initWithPost:post];
        [self addCommentWithMessage:comment];
    }
}
// return a string of the post that this comment is on
- (NSString *)getPostMessage
{
    if (self.masterCommentList.count == 0)
        return @"[Post's message not found]";
    NSString *message1 = ((Comment *)self.masterCommentList.firstObject).postMessage;
    NSString *message2 = ((Comment *)self.masterCommentList.lastObject).postMessage;
    
    if ([message1 isEqualToString:message2])
    {
        return message1;
    }
    return @"[Comments' post messages inconsistent]";
}
// override its default setter method to ensure new array remains mutable
- (void) setMasterCommentList:(NSMutableArray *)newList
{
    if (_masterCommentList != newList)
    {
        _masterCommentList = [newList mutableCopy];
    }
}

- (NSUInteger) countOfList
{
    return [self.masterCommentList count];
}

- (Comment *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterCommentList objectAtIndex:theIndex];
}

- (void)addCommentWithMessage:(Comment *)comment
{
    [self.masterCommentList addObject:comment];
}


@end
