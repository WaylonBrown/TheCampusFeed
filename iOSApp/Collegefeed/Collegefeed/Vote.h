//
//  Vote.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vote : NSObject

// upvote: {YES=upvote, NO=downvote}
@property (nonatomic) BOOL upvote;

// votableID: ID of what was voted on
@property (nonatomic) NSInteger votableID;

@property (nonatomic, strong) NSURL *POSTurl;

- (id)initWithVotableID:(NSInteger)ID
        withUpvoteValue:(BOOL)isUpvote;
- (id)initDummy;

- (NSData*)toJSON;

@end
