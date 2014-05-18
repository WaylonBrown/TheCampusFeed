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
#import "Vote.h"

@implementation Comment

- (id)initWithCommentID:(NSInteger)newCommentID
              withScore:(NSInteger)newScore
            withMessage:(NSString *)newMessage
             withPostID:(NSInteger)newPostID
{   // initialize a new Comment
    self = [super init];
    if (self)
    {
        [self setCommentID:newCommentID];
        [self setPostID:newPostID];
        [self setCollegeID:-1];
        [self setScore:newScore];
        [self setMessage:newMessage];
        [self setCollegeName:@"<No College>"];
        [self setDate:[NSDate date]];
        [self setVote:nil];
        
        [self validate];
        return self;
    }
    return nil;
}
- (id)initDummy
{   // dummy initializer for dev/testing
    NSString* dummyMessage;
    switch (arc4random() % 4)
    {
        case 0: dummyMessage = @"Comment: Are you #achin?"; break;
        case 1: dummyMessage = @"Comment: #Yupyupyup"; break;
        case 2: dummyMessage = @"Comment: For some #bacon?"; break;
        default: dummyMessage = @"Comment: #LUAU!"; break;
    }
    
    self = [self initWithCommentID:(arc4random() % 999)
                         withScore:(arc4random() % 99)
                       withMessage:dummyMessage
                        withPostID:(arc4random() % 999)];
    
    return self;
}
- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post
{   // assign values from the post that was commented on

    self = [self initWithCommentID:-1
                         withScore:0
                       withMessage:message
                        withPostID:post.postID];

    
    [self setCollegeID:post.collegeID];
    
    return self;
}
- (id)initWithPost:(Post *)post
{
    self = [self initDummy];
    if (self)
    {
        [self setPostID:post.postID];
        [self setCollegeID:post.collegeID];

        [self validate];
        return self;
    }
    return nil;
}
- (void)validate
{   // check for proper length

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
- (NSData*)toJSON
{   // Returns an NSData object representing this Comment in JSON
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%d", self.postID], @"post_id",
                                       self.message, @"text", nil];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:0 error:&error];
    
    return data;
}

@end
