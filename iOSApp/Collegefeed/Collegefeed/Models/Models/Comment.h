//
//  Comment.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@class Post;
@class Vote;

@interface Comment : Model<PostAndCommentProtocol>

@property (nonatomic) long commentID;
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
- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post;

- (id)initWithCommentID:(NSInteger)newCommentID
              withScore:(NSInteger)newScore
            withMessage:(NSString *)newMessage
             withPostID:(NSInteger)newPostID;

- (id)initWithPost:(Post *)post;

@end
