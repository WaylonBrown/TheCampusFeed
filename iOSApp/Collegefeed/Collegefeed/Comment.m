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

- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post
{   // NOTE: This constructor to be used when sending to server
    // assign attributes required by the API's POST request
    
    self = [super init];
    if (self)
    {
        [self setPostID:post.getID];
        [self setMessage:message];
        [self setPostUrl:commentsUrl];
        
        [self validate];
        return self;
    }
    return nil;
}

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
- (id)initFromJSON:(NSDictionary *)jsonObject
{   // Initialize this Comment using a JSON object as an NSDictionary
    self = [super init];
    if (self)
    {
        NSString *commentID = (NSString*)[jsonObject valueForKey:@"id"];
        NSString *text      = (NSString*)[jsonObject valueForKey:@"text"];
        NSString *score     = (NSString*)[jsonObject valueForKey:@"score"];

        if (score == (id)[NSNull null]) score = nil;
        
        [self setCommentID:[commentID integerValue]];
        [self setScore:[score integerValue]];
        [self setMessage:text];
        
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
{   // Returns an NSData representation of this Comment in JSON
    NSString *commentString = [NSString stringWithFormat:@"{\"post_id\":%d,\"text\":\"%@\"}",
                            self.postID, self.message];
    NSData *commentData = [commentString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return commentData;
}
- (NSInteger)getID
{   // Returns the ID for this Comment
    return self.commentID;
}

@end
