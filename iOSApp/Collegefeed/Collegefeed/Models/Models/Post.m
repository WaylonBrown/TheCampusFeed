//
//  Post.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Post.h"
#import "Comment.h"
#import "College.h"
#import "Vote.h"

@implementation Post

- (id)initWithMessage:(NSString *)newMessage
        withCollegeId:(long)collegeId
        withUserToken:(NSString *)userToken
{   // NOTE: This constructor to be used when sending to server
    // initializer to create a new post
    
    self = [self init];
    if (self)
    {
        [self setMessage:newMessage];
        [self setCollegeID:collegeId];
        [self setUserToken:userToken];
        [self validate];
        return self;
    }
    return nil;
}

- (id)initWithPostID:(NSInteger)newPostID
           withScore:(NSInteger)newScore
         withMessage:(NSString *)newMessage
{   // initialize a new post

    self = [super init];
    if (self)
    {
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

#pragma mark - Protocol Methods

- (id)initFromJSON:(NSDictionary *)jsonObject
{   // Initialize this Post using a JSON object as an NSDictionary
    self = [super init];
    if (self)
    {
        NSString *postID    = (NSString*)[jsonObject valueForKey:@"id"];
        NSString *text      = (NSString*)[jsonObject valueForKey:@"text"];
        NSString *score     = (NSString*)[jsonObject valueForKey:@"score"];
        NSString *lat       = (NSString*)[jsonObject valueForKey:@"lat"];
        NSString *lon       = (NSString*)[jsonObject valueForKey:@"lon"];
        NSString *created   = (NSString*)[jsonObject valueForKey:@"created_at"];
        NSString *collegeID = (NSString*)[jsonObject valueForKey:@"college_id"];
        NSString *commCount = (NSString*)[jsonObject valueForKey:@"comment_count"];
        NSString *hidden    = (NSString*)[jsonObject valueForKey:@"hidden"];
        
        if (score == (id)[NSNull null]) score = nil;
        if (lat == (id)[NSNull null]) lat = nil;
        if (lon == (id)[NSNull null]) lon = nil;
        if (collegeID == (id)[NSNull null]) collegeID = nil;
        if (hidden == (id)[NSNull null]) hidden = nil;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *createdDate = [dateFormatter dateFromString: created];

        [self setPostID:[postID integerValue]];
        [self setScore:[score integerValue]];
        [self setMessage:text];
        [self setLat:[lat floatValue]];
        [self setLon:[lon floatValue]];
        [self setCreatedAt:createdDate];
        [self setCollegeID:[collegeID integerValue]];
//        [self setHidden:]
        [self setCommentCount:[commCount integerValue]];
        [self validate];
        return self;
    }
    return nil;
}
- (NSData*)toJSON
{   // Returns an NSData representation of this Post in JSON
    
    NSString *postString = [NSString stringWithFormat:@"{\"text\":\"%@\", \"user_token\":\"%@\"}", self.message, self.userToken];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return postData;
}
- (long)getID
{   // Returns the ID for this Post
    return self.postID;
}
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
- (void)decrementScore
{
    self.score--;
}
- (void)incrementScore
{
    self.score++;
}
- (NSString *)getCollegeName
{
    return self.college.name;
}
- (long)getCollegeID
{
    return self.collegeID;
}
- (Vote *)getVote
{
    return self.vote;
}
- (void)validate
{
//    if (self.message.length < MIN_POST_LENGTH)
//    {
//        NSException *e = [NSException exceptionWithName:@"PostLengthException" reason:@"Post is too short" userInfo:nil];
//        [e raise];
//    }
//    if (self.message.length > MAX_POST_LENGTH)
//    {
//        NSException *e = [NSException exceptionWithName:@"PostLengthException" reason:@"Post is too long" userInfo:nil];
//        [e raise];
//    }
}
- (ModelType)getType
{
    return POST;
}


@end
