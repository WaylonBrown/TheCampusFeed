//
//  Comment.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Comment.h"
#import "Post.h"
#import "Constants.h"

@implementation Comment

- (id)initWithCommentID:(NSInteger)newCommentID
     withCommentMessage:(NSString *)newMessage
             withPostID:(NSInteger)newPostID
{
    self = [super init];
    if (self)
    {
        [self setCommentID:newCommentID];
        [self setPostID:newPostID];
        [self setCollegeID:0];
        [self setScore:0];
        [self setVote:0];
        [self setCommentMessage:newMessage];
        [self setDate:[NSDate date]];
        
        [self validateComment];
        return self;
    }
    return nil;
    
}
- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post
{   // assign values from the post that was commented on

    self = [self initDummy];
    if (self)
    {
        [self setPostID:post.postID];
        [self setCommentMessage:message];
        [self setCollegeID:post.collegeID];
        [self setScore:0];
        [self setVote:0];
        [self setDate:[NSDate date]];
 
        [self validateComment];
        return self;
    }
    return nil;
    
}
- (id)initWithPost:(Post *)post
{
    self = [self initDummy];
    if (self)
    {
        [self setPostID:post.postID];
        [self setCollegeID:post.collegeID];
        [self setPostMessage:post.postMessage];

        [self validateComment];
        return self;
    }
    return nil;
}
- (id)initDummy
{
    self = [super init];
    if (self)
    {
        [self setCommentID:arc4random() % 999];
        [self setPostID:arc4random() % 999];
        [self setCollegeID:arc4random() % 999];
        [self setScore:arc4random() % 99];
        [self setVote:0];
        [self setDate:[NSDate date]];
        
        switch (self.commentID % 4)
        {
            case 0: [self setCommentMessage:@"Comment: Are you #achin?"]; break;
            case 1: [self setCommentMessage:@"Comment: #Yupyupyup"]; break;
            case 2: [self setCommentMessage:@"Comment: For some #bacon?"]; break;
            default: [self setCommentMessage:@"Comment: #LUAU!"]; break;
        }
        
        [self validateComment];

        return self;
    }
    return nil;
}
// check for proper length
- (void)validateComment
{
//    if (self.commentMessage.length < MIN_COMMENT_LENGTH)
//    {
//        [NSException raise:@"Invalid Comment" format:@"Comment \"%@\" is too short", self.commentMessage];
//    }
//    if (self.commentMessage.length > MAX_COMMENT_LENGTH)
//    {
//        [NSException raise:@"Invalid Comment" format:@"Comment \"%@\" is too long", self.commentMessage];
//    }
//    if (self.vote != -1 && self.vote != 0 && self.vote != 1)
//    {
//        [NSException raise:@"Invalid Vote value" format:@"Invalid Vote value on comment with id = %d", self.commentID];
//    }
}
@end
