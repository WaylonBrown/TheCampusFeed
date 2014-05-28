//
//  Votable.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Votable.h"
#import "Vote.h"

@implementation Votable

- (void)castVote:(BOOL)isUpVote
{
    // Sets the vote for this Object and updates the score
    // Removes the vote if the same one is given
    // e.g. If (isUpVote && already upvoted) then (remove upvote/decrease score)
    //  - (similarly for repeat downvotes)
    
    if (self.vote == nil)
    {   // New vote on this object, one did not previously exist
        Vote *newVote = [[Vote alloc] initWithVotableID:self.postID
                                        withUpvoteValue:isUpVote];
        [self setVote:newVote];
    }
    else
    {   // This object already had a vote; update/delete
        
        // undo the original vote
        self.score = self.vote.upvote
        ? self.score - 1
        : self.score + 1;
        
        if (self.vote.upvote == isUpVote)
        {   // if a duplicate vote was cast, remove the vote
            [self setVote:nil];
            return;
        }
        
        [self.vote setUpvote:isUpVote];
    }
    
    // update score with new vote
    self.score = self.vote.upvote
    ? self.score + 1
    : self.score - 1;
}

- (id)initFromJSON:(NSDictionary *)jsonObject
{
    return nil;
}
- (NSData*)toJSON
{
    return nil;
}
- (long)getID
{
    return -1;
}
- (void)validate{}

@end