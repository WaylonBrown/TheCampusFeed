//
//  Post.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Post.h"
#import "Comment.h"
#import "Shared.h"
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
        
        [self setPostUrl:[Shared POSTPostWithCollegeId:collegeId]];
        
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
        //TODO: createdAt
        
        
        if (score == (id)[NSNull null]) score = nil;
        if (lat == (id)[NSNull null]) lat = nil;
        if (lon == (id)[NSNull null]) lon = nil;
        
        [self setPostID:[postID integerValue]];
        [self setScore:[score integerValue]];
        [self setMessage:text];
        [self setLat:[lat floatValue]];
        [self setLon:[lon floatValue]];
        
        return self;
    }
    return nil;
}
- (void)validate
{   // check for proper length

//    if (self.postMessage.length < MIN_POST_LENGTH)
//    {
//        [NSException raise:@"Invalid Post" format:@"Post \"%@\" is too short", self.postMessage];
//    }
//    if (self.postMessage.length > MAX_POST_LENGTH)
//    {
//        [NSException raise:@"Invalid Post" format:@"Post \"%@\" is too long", self.postMessage];
//    }
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
@end
