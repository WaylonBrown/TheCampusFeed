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

@property (nonatomic) long postID;
@property (nonatomic) long collegeID;
@property (nonatomic) long score;
@property (nonatomic, strong) Vote *vote;

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) NSURL *POSTurl;

- (id)initFromJSON:(NSDictionary *)jsonObject;
- (NSData*)toJSON;

- (long)getID;
- (void)validate;
- (void)castVote:(BOOL)isUpVote;

@end
