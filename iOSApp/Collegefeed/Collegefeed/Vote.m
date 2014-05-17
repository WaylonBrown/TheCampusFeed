//
//  Vote.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Vote.h"

@implementation Vote

- (id)initWithVoteID:(NSInteger)vID withUpvoteValue:(BOOL)isUpvote
{
    self = [super init];
    if (self)
    {
        [self setVoteID:vID];
        [self setUpvote:isUpvote];
        return self;
    }
    return nil;
}
- (id)initDummy
{
    self = [super init];
    if (self)
    {
        [self setVoteID:arc4random() % 999];
        [self setUpvote:NO];
        return self;
    }
    return nil;
}
- (NSData*)toJSON
{   // Returns an NSData representation of this Post in JSON
    NSString* stringUpvote = self.upvote ? @"true" : @"false";
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 stringUpvote, @"upvote",
                                 self.voteID, @"votable_id",
                                 nil];
    
    NSError *error;
    NSData *voteData = [NSJSONSerialization dataWithJSONObject:requestData
                                                       options:0
                                                         error:&error];
    
    return voteData;
}
@end
