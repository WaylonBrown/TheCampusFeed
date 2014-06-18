//
//  Post.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Post.h"
#import "Comment.h"
#import "Vote.h"

@implementation Post

- (id)initWithMessage:(NSString *)newMessage
        withCollegeId:(long)collegeId
{   // NOTE: This constructor to be used when sending to server
    // initializer to create a new post
    
    self = [self init];
    if (self)
    {
        [self setMessage:newMessage];
        [self setCollegeID:collegeId];
                
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
        return self;
    }
    return nil;
}

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
        
        if (score == (id)[NSNull null]) score = nil;
        if (lat == (id)[NSNull null]) lat = nil;
        if (lon == (id)[NSNull null]) lon = nil;
        
        //"created_at":"2014-06-03T00:09:22.621Z
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *createdDate = [dateFormatter dateFromString: created];

        [self setPostID:[postID integerValue]];
        [self setScore:[score integerValue]];
        [self setMessage:text];
        [self setLat:[lat floatValue]];
        [self setLon:[lon floatValue]];
        [self setCreatedAt:createdDate];
        
        return self;
    }
    return nil;
}
- (NSData*)toJSON
{   // Returns an NSData representation of this Post in JSON
    NSString *postString = [NSString stringWithFormat:@"{\"text\":\"%@\"}", self.message];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return postData;
}
- (long)getID
{   // Returns the ID for this Post
    return self.postID;
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