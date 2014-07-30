//
//  Vote.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFModelProtocol.h"

@interface Vote : NSObject<CFModelProtocol>

// voteID: ID of this vote
@property (nonatomic) long voteID;

// upvote: {YES=upvote, NO=downvote}
@property (nonatomic) BOOL upvote;

// parentID: ID of what was voted on (comment/post)
@property (nonatomic) long parentID;

// grandparentID: if this is a comment vote,
//                we need the post ID also for API
@property (nonatomic) long grandparentID;

// votableType: "Post" or "Comment"
@property (nonatomic) ModelType votableType;

@property (nonatomic) long collegeId;

- (id)initWithVoteId:(long)voteId
        WithParentId:(long)parentId
     WithUpvoteValue:(BOOL)isUpvote
       AsVotableType:(ModelType)type;

- (id)initWithParentID:(NSInteger)ID
        withUpvoteValue:(BOOL)isUpvote
          asVotableType:(ModelType)type;


- (id)initFromJSON:(NSDictionary *)jsonObject;

- (NSData*)toJSON;


@end
