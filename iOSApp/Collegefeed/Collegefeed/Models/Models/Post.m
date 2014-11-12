//
//  Post.m
//  TheCampusFeed
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
        withCollegeId:(NSNumber *)collegeId
        withUserToken:(NSString *)userToken
{   // NOTE: This constructor to be used when sending to server
    // initializer to create a new post
    
    self = [self init];
    if (self)
    {
        [self setText:newMessage];
        [self setCollegeID:collegeId];
        [self setUserToken:userToken];
        return self;
    }
    return nil;
}

- (id)initWithPostID:(NSNumber *)newPostID
           withScore:(NSNumber *)newScore
         withMessage:(NSString *)newMessage
{   // initialize a new post

    self = [super init];
    if (self)
    {
        [self setPostID:newPostID];
        [self setCollegeID:[NSNumber numberWithInt:-1]];
        [self setScore:newScore];
        [self setText:newMessage];
        [self setCollegeName:@"<No College>"];
        [self setDate:[NSDate date]];
        [self setVote:nil];
        return self;
    }
    return nil;
}

#pragma mark - Protocol Methods
- (id)initFromNetworkData:(NSData *)data
{
    NSDictionary *jsonObject = (NSDictionary *)(NSArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:nil];
    return [self initFromJSON:jsonObject];
}

+ (NSArray *)getListFromJsonData:(NSData *)jsonData error:(NSError **)error;
{
//    {
//        "id": 1,
//        "text": "its a #test post 1",
//        "score": null,
//        "created_at": "2014-10-20T00:28:32.000Z",
//        "updated_at": "2014-10-20T00:28:32.000Z",
//        "college_id": 2015,
//        "lat": null,
//        "lon": null,
//        "hidden": false,
//        "vote_delta": 1,
//        "comment_count": 0,
//        "image_id": null
//    }
    
    
    NSError *localError = nil;
    NSDictionary *postList = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:0
                                                               error:&localError];
    
    if (localError != nil)
    {
        *error = localError;
        return nil;
    }
    
    
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    for (NSDictionary *postDict in postList)
    {
        Post *post = [[Post alloc] init];
        
        for (NSString *key in postDict)
        {
            if ([post respondsToSelector:NSSelectorFromString(key)])
            {
                [post setValue:[postDict valueForKey:key] forKey:key];
            }
        }
        
        [posts addObject:post];
    }
    
    return posts;
}

- (id)initFromJSON:(NSDictionary *)jsonDict
{   // Initialize this Post using a JSON object as an NSDictionary
    
    self = [super init];

    
    if (self)
    {
        for (NSString *key in jsonDict)
        {
            if ([key isEqualToString:@"hidden"])
            {
                NSNumber *val = [jsonDict valueForKey:key];
                self.hidden = val.boolValue;
            }
            else if ([key isEqualToString:@"created_at"] || [key isEqualToString:@"updated_at"])
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSDate *date = [dateFormatter dateFromString:[jsonDict valueForKey:key]];
                [self setValue:date forKey:key];
            }
            else if ([self respondsToSelector:NSSelectorFromString(key)])
            {
                [self setValue:[jsonDict valueForKey:key] forKey:key];
            }
        }

        
        
        
////        NSString *postID    = (NSString*)[jsonObject valueForKey:@"id"];
////        NSString *text      = (NSString*)[jsonObject valueForKey:@"text"];
////        NSString *votedelta = (NSString*)[jsonObject valueForKey:@"vote_delta"];
////        NSString *lat       = (NSString*)[jsonObject valueForKey:@"lat"];
////        NSString *lon       = (NSString*)[jsonObject valueForKey:@"lon"];
////        NSString *created   = (NSString*)[jsonObject valueForKey:@"created_at"];
////        NSString *collegeID = (NSString*)[jsonObject valueForKey:@"college_id"];
////        NSString *commCount = (NSString*)[jsonObject valueForKey:@"comment_count"];
////        NSString *hidden    = (NSString*)[jsonObject valueForKey:@"hidden"];
////        NSString *voteId    = (NSString*)[jsonObject valueForKey:@"initial_vote_id"];
////        
////        if (votedelta == (id)[NSNull null]) votedelta = nil;
////        if (lat == (id)[NSNull null]) lat = nil;
////        if (lon == (id)[NSNull null]) lon = nil;
////        if (collegeID == (id)[NSNull null]) collegeID = nil;
////        if (hidden == (id)[NSNull null]) hidden = nil;
////        if (voteId == (id)[NSNull null]) voteId = nil;
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
//        NSDate *createdDate = [dateFormatter dateFromString: created];
        
        
        // ToDo: initial vote
        
        
        
//        Vote *initialVote = (voteId == nil) ? nil : [[Vote alloc] initWithVoteId:[voteId integerValue] WithParentId:[postID integerValue] WithUpvoteValue:YES AsVotableType:POST];
//
//        [self setPostID:[postID integerValue]];
//        [self setScore:[votedelta integerValue]];
//        [self setText:text];
//        [self setLat:[NSNumber numberWithFloat:[lat floatValue]]];
//        [self setLon:[lon floatValue]];
//        [self setCreatedAt:createdDate];
//        [self setCollegeID:[collegeID integerValue]];
//        [self setCommentCount:[commCount integerValue]];
//        [self setVote:initialVote];
//        [self validate];
        
        return self;
    }
    return nil;
}
- (NSData*)toJSON
{   // Returns an NSData representation of this Post in JSON
    
    NSString *postString = [NSString stringWithFormat:@"{\"text\":\"%@\", \"user_token\":\"%@\"}", self.text, self.userToken];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return postData;
}
- (NSNumber *)getID
{   // Returns the ID for this Post
    return self.postID;
}
- (NSNumber *)getPostID
{
    return self.postID;
}
- (NSString *)getText
{
    return self.text;
}
- (NSDate *)getCreated_at
{
    return self.created_at;
}
- (NSNumber *)getScore
{
    return self.score;
}
- (void)decrementScore
{
    [self setScore:[NSNumber numberWithInt:[self.score intValue] - 1]];
}
- (void)incrementScore
{
    [self setScore:[NSNumber numberWithInt:[self.score intValue] + 1]];
}
- (NSString *)getCollegeName
{
    return self.college.name;
}
- (NSNumber *)getCollegeID
{
    return self.collegeID;
}
- (Vote *)getVote
{
    return self.vote;
}
- (void)setCollegeName:(NSString *)name
{
    self.collegeName = name;
}
- (ModelType)getType
{
    return POST;
}


@end
