//
//  Comment.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Comment.h"
#import "Post.h"
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
        
//        [self setPOSTurl:[Shared POSTCommentWithPostId:(long)post.getID]];
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
        NSString *postID    = (NSString*)[jsonObject valueForKey:@"post_id"];
        NSString *created   = (NSString*)[jsonObject valueForKey:@"created_at"];

        if (score == (id)[NSNull null]) score = nil;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *createdDate = [dateFormatter dateFromString: created];
        
        [self setCommentID:[commentID integerValue]];
        [self setScore:[score integerValue]];
        [self setMessage:text];
        [self setPostID:[postID integerValue]];
        [self setCreatedAt:createdDate];
        
        return self;
    }
    return nil;
}
- (NSData*)toJSON
{   // Returns an NSData representation of this Comment in JSON
    NSString *commentString = [NSString stringWithFormat:@"{\"text\":\"%@\"}", self.message];
    NSData *commentData = [commentString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return commentData;
}
- (long)getID
{   // Returns the ID for this Comment
    return self.commentID;
}

#pragma mark - Protocol Methods

- (NSString *)getMessage
{
    return self.message;
}
- (NSDate *)getCreatedAt
{
    return self.createdAt;
}
- (long)getScore
{
    return self.score;
}
- (NSString *)getCollegeName
{
    return self.collegeName;
}
- (void)setVote:(Vote *)vote
{
    [self setVote:vote];
}
- (Vote *)getVote
{
    return self.vote;
}

@end
