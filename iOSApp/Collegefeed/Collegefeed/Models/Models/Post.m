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
        [self setCollege_id:collegeId];
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
        [self setPost_id:newPostID];
        [self setCollege_id:[NSNumber numberWithInt:-1]];
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
// Example JSON data for a single Post
//    
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
        Post *post = [[Post alloc] initFromJSON:postDict];
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
            id value = [jsonDict valueForKey:key];
            if ([value isKindOfClass:[NSNull class]] || value == nil)
                continue;
            
            else if ([key isEqualToString:@"created_at"] || [key isEqualToString:@"updated_at"])
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSDate *date = [dateFormatter dateFromString:value];
                [self setValue:date forKey:key];
            }
            else if ([self respondsToSelector:NSSelectorFromString(key)])
            {
                [self setValue:value forKey:key];
            }
        }
        
        NSNumber *voteId = [jsonDict valueForKey:@"initial_vote_id"];
        Vote *initialVote = (voteId == nil) ? nil : [[Vote alloc] initWithVoteId:[voteId integerValue] WithParentId:[self.id longValue] WithUpvoteValue:YES AsVotableType:POST];
        [self setVote:initialVote];
        
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
    return self.id;
}
- (NSNumber *)getPost_id
{
    return self.post_id;
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
    return self.vote_delta;
}
- (void)decrementScore
{
    self.vote_delta = [NSNumber numberWithInt:[self.vote_delta intValue] - 1];
}
- (void)incrementScore
{
    self.vote_delta = [NSNumber numberWithInt:[self.vote_delta intValue] + 1];
}
- (NSString *)getCollegeName
{
    return self.college.name;
}
- (NSNumber *)getCollege_id
{
    return self.college_id;
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
- (NSString *)getImage_url
{
    return (self.image_url == nil) ? self.image_uri : self.image_uri;
}
- (BOOL)hasImage
{
    return self.image_url != nil;
}

@end
