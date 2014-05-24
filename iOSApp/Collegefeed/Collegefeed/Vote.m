//
//  Vote.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Vote.h"
#import "Constants.h"

@implementation Vote

- (id)initWithVotableID:(NSInteger)ID withUpvoteValue:(BOOL)isUpvote;
{
    self = [super init];
    if (self)
    {
        [self setVotableID:ID];
        [self setUpvote:isUpvote];
        [self setPostUrl:voteUrl];
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
{   // Returns an NSData representation of this Vote in JSON
    
    NSString *voteString = [NSString stringWithFormat:@"{\"upvote\":%@,\"votable_id\":%d}",
                            self.upvote == YES ? @"true" : @"false",
                            self.votableID];
    NSData *voteData = [voteString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return voteData;
}
@end
