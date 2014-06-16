//
//  Post.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@class Vote;

@interface Post : Model

@property (nonatomic) NSMutableArray *commentList;
@property (nonatomic) float lat;
@property (nonatomic) float lon;
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

// NOTE: Use this constructor!
- (id)initWithMessage:(NSString *)newMessage
        withCollegeId:(long)collegeId;

- (id)initWithPostID:(NSInteger)newPostID
           withScore:(NSInteger)newScore
         withMessage:(NSString *)newMessage;


@end
