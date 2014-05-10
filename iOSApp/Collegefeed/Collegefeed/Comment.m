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

- (id)initWithCommentID:(NSInteger)newCommentID withMessage:(NSString *)newMessage withPostID:(NSInteger)newPostID
{
    self = [super init];
    if (self)
    {
        [self setCommentID:newCommentID];
        [self setPostID:newPostID];
        [self setCollegeID:0];
        [self setScore:0];
        [self setVote:0];
        [self setMessage:newMessage];
        [self setDate:[NSDate date]];
        
        [self validateComment];
        return self;
    }
    return nil;
    
}
// assign values from the post that was commented on
- (id)initWithPost:(Post *)post
{
    self = [self initDummy];
    if (self)
    {
        [self setPostID:post.postID];
        [self setCollegeID:post.collegeID];
        [self setPostMessage:post.message];

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
            case 0: [self setMessage:@"Comment: Are you achin?"]; break;
            case 1: [self setMessage:@"Comment: Yup yup yup"]; break;
            case 2: [self setMessage:@"Comment: For some bacon?"]; break;
            default: [self setMessage:@"Comment: LUAU!"]; break;
        }
        
        [self validateComment];

        return self;
    }
    return nil;
}
// check for proper length
- (void)validateComment
{
    if (self.message.length < MIN_COMMENT_LENGTH)
    {
        [NSException raise:@"Invalid Comment" format:@"Comment \"%@\" is too short", self.message];
    }
    if (self.message.length > MAX_COMMENT_LENGTH)
    {
        [NSException raise:@"Invalid Comment" format:@"Comment \"%@\" is too long", self.message];
    }
    if (self.vote != -1 && self.vote != 0 && self.vote != 1)
    {
        [NSException raise:@"Invalid Vote value" format:@"Invalid Vote value on comment with id = %d", self.commentID];
    }
}
// assign the comment's vote to -1, 0, or 1
//- (void) setVote:(NSInteger)newVote
//{
//    if (newVote == -1 || newVote == 0 || newVote == 1)
//    {
//        [self setVote:newVote];
//    }
//    else
//    {
//        [NSException raise:@"Invalid Vote value" format:@"Invalid Vote value on comment with id = %d", self.commentID];
//    }
//}
@end
