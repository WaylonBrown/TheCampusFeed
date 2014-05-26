//
//  Votable.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Vote;

// This interface to be implemented by Post and Comment
@interface Votable : NSObject

@property (nonatomic) NSInteger postID;
@property (nonatomic) NSInteger collegeID;
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) Vote *vote;

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) NSURL *postUrl;
@property (nonatomic, strong) NSURL *getUrl;

- (id)initFromJSON:(NSDictionary *)jsonObject;
- (NSData*)toJSON;

- (id)initDummy;

- (NSInteger)getID;
- (void)validate;
- (void)castVote:(BOOL)isUpVote;

@end