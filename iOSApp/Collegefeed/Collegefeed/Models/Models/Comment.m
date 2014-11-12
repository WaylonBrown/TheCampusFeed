//
//  Comment.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Comment.h"
#import "Post.h"
#import "Vote.h"

@implementation Comment


//- (id)initFromNetworkData:(NSData *)data
//{
//    NSDictionary *jsonObject = (NSDictionary *)(NSArray *)[NSJSONSerialization JSONObjectWithData:data
//                                                                                          options:0
//                                                                                            error:nil];
//    return [self initFromJSON:jsonObject];
//}
+ (NSArray *)getListFromJsonData:(NSData *)jsonData error:(NSError **)error;
{
//    {
//        "id": 7,
//        "text": "another test",
//        "score": null,
//        "created_at": "2014-10-20T00:28:33.000Z",
//        "updated_at": "2014-10-20T00:28:33.000Z",
//        "post_id": "2",
//        "hidden": true,
//        "vote_delta": 0
//    }
    
    NSError *localError = nil;
    NSDictionary *list = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:0
                                                           error:&localError];
    
    if (localError != nil)
    {
        *error = localError;
        return nil;
    }
    
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in list)
    {
        Comment *comment = [[Comment alloc] init];
        
        for (NSString *key in dict)
        {
            if ([comment respondsToSelector:NSSelectorFromString(key)])
            {
                [comment setValue:[dict valueForKey:key] forKey:key];
            }
        }
        
        [objects addObject:comment];
    }
    
    return objects;
}


//- (id)initWithCommentMessage:(NSString *)message
//                    withPost:(Post *)post
//{   // NOTE: This constructor to be used when sending to server
//    // assign attributes required by the API's POST request
//    
//    self = [super init];
//    if (self)
//    {
//        [self setPostID:post.postID];
//        [self setText:message];
//        [self validate];
//    }
//    return self;
//}
//
//- (id)initWithCommentID:(NSInteger)newCommentID
//              withScore:(NSInteger)newScore
//            withMessage:(NSString *)newMessage
//             withPostID:(NSInteger)newPostID
//{   // initialize a new Comment
//    self = [super init];
////    if (self)
////    {
////        [self setCommentID:newCommentID];
////        [self setPostID:newPostID];
////        [self setCollegeID:-1];
////        [self setScore:newScore];
////        [self setMessage:newMessage];
////        [self setCollegeName:@"<No College>"];
////        [self setDate:[NSDate date]];
////        [self setVote:nil];
////        [self validate];
////    }
//    return self;
//}
//- (id)initWithPost:(Post *)post
//{
//    if (self)
//    {
//        [self setPostID:post.postID];
//        [self setCollegeID:post.collegeID];
//        [self validate];
//    }
//    return self;
//}
//
//#pragma mark - Protocol Methods
//
//- (id)initFromJSON:(NSDictionary *)jsonObject
//{   // Initialize this Comment using a JSON object as an NSDictionary
//    
//    NSLog(@"DEPRECATION: Comment-(id)initFromJSON:)");
//
//    self = [super init];
////    if (self)
////    {
////        NSString *commentID = (NSString*)[jsonObject valueForKey:@"id"];
////        NSString *text      = (NSString*)[jsonObject valueForKey:@"text"];
////        NSString *votedelta = (NSString*)[jsonObject valueForKey:@"vote_delta"];
////        NSString *postID    = (NSString*)[jsonObject valueForKey:@"post_id"];
////        NSString *created   = (NSString*)[jsonObject valueForKey:@"created_at"];
////        NSString *voteId    = (NSString*)[jsonObject valueForKey:@"initial_vote_id"];
////
////        if (votedelta == (id)[NSNull null]) votedelta = nil;
////        if (voteId == (id)[NSNull null]) voteId = nil;
////
////        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
////        NSDate *createdDate = [dateFormatter dateFromString: created];
////        Vote *initialVote = (voteId == nil) ? nil : [[Vote alloc] initWithVoteId:[voteId integerValue] WithParentId:[commentID integerValue] WithUpvoteValue:YES AsVotableType:COMMENT];
////        
////        [self setCommentID:[commentID integerValue]];
////        [self setScore:[votedelta integerValue]];
////        [self setMessage:text];
////        [self setPostID:[postID integerValue]];
////        [self setCreatedAt:createdDate];
////        [self setVote:initialVote];
////        [self validate];
////
////        return self;
////    }
//    return nil;
//}
- (NSData*)toJSON
{   // Returns an NSData representation of this Comment in JSON
    NSString *commentString = [NSString stringWithFormat:@"{\"text\":\"%@\"}", self.text];
    NSData *commentData = [commentString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return commentData;
}
- (NSNumber *)getID
{   // Returns the ID for this Comment
    return self.commentID;
}
//- (NSString *)getText
//{
//    return self.text;
//}
//- (NSDate *)getCreatedAt
//{
//    return self.createdAt;
//}
//- (NSNumber *)getScore
//{
//    return self.score;
//}
//- (void)decrementScore
//{
//    self.score--;
//}
//- (void)incrementScore
//{
//    self.score++;
//}
//- (NSString *)getCollegeName
//{
//    return self.collegeName;
//}
//- (NSNumber *)getCollegeID
//{
//    return self.collegeID;
//}
- (NSNumber *)getPostID
{
    return self.postID;
}
//- (Vote *)getVote
//{
//    return self.vote;
//}
- (ModelType)getType
{
    return COMMENT;
}

@end
