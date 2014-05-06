//
//  Vote.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vote : NSObject

@property (nonatomic) NSInteger voteID;
@property (nonatomic) BOOL upvote;

- (id)initWithVoteID:(NSInteger)vID withUpvoteValue:(BOOL)isUpvote;
- (id)initDummy;

@end
