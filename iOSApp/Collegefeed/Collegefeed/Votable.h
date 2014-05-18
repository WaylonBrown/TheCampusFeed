//
//  Votable.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Vote;
@class Post;
@class Comment;

// This interface to be implemented by Post and Comment
@interface Votable : NSObject

@property (nonatomic) NSInteger postID;
@property (nonatomic) NSInteger collegeID;
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) Vote *vote;

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSDate *date;

- (id)initDummy;

- (NSInteger)getID;
- (void)validate;
- (NSData*)toJSON;
- (void)castVote:(BOOL)isUpVote;

@end
