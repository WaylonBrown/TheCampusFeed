//
//  Vote.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Vote.h"

@implementation Vote

- (id)initWithVotableID:(NSInteger)ID withUpvoteValue:(BOOL)isUpvote;
{
    self = [super init];
    if (self)
    {
        [self setVotableID:ID];
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
        [self setVotableID:-1];
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
                                 self.votableID, @"votable_id",
                                 nil];
    
    NSError *error;
    NSData *voteData = [NSJSONSerialization dataWithJSONObject:requestData
                                                       options:0
                                                         error:&error];
    
    return voteData;
}
@end
