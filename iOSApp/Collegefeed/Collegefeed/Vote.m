//
//  Vote.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Vote.h"

@implementation Vote

@synthesize voteID;
@synthesize upvote;

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

@end
