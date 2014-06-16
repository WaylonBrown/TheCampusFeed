//
//  Vote.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Vote.h"

@implementation Vote

- (id)initWithVotableID:(NSInteger)ID
        withUpvoteValue:(BOOL)isUpvote;
{
    self = [super init];
    if (self)
    {
        [self setParentID:ID];
        [self setUpvote:isUpvote];
//        [self setPOSTurl:[Shared POSTVoteWithPostId:ID]];
        return self;
    }
    return nil;
}
- (id)initFromJSON:(NSDictionary *)jsonObject
{   // Initialize this Vote using a JSON object as an NSDictionary
    self = [super init];
    if (self)
    {
        NSString *voteID    = (NSString*)[jsonObject valueForKey:@"id"];
        NSString *upvote    = (NSString*)[jsonObject valueForKey:@"upvote"];
        NSString *parentID  = (NSString*)[jsonObject valueForKey:@"votable_ID"];
        NSString *type      = (NSString*)[jsonObject valueForKey:@"votable_type"];
        
        [self setVoteID:[voteID integerValue]];
        [self setParentID:[parentID integerValue]];
        [self setUpvote:(upvote ? YES : NO)];
        [self setVotableType:type];

        return self;
    }
    return nil;
}

- (NSData*)toJSON
{   // Returns an NSData representation of this Vote in JSON
    
    NSString *voteString = [NSString stringWithFormat:@"{\"upvote\":%@}",
                            self.upvote == YES ? @"true" : @"false"];
    
    NSData *voteData = [voteString dataUsingEncoding:NSASCIIStringEncoding
                                allowLossyConversion:YES];
    return voteData;
}
@end
