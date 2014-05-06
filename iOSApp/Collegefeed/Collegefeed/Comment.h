//
//  Comment.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Post;

@interface Comment : NSObject

@property (nonatomic) NSInteger commentID;
@property (nonatomic) NSInteger postID;
@property (nonatomic) NSInteger collegeID;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger vote; //-1 = downvote, 0 = nothing, 1 = upvote

@property (nonatomic, copy) NSString *postMessage;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSDate *date;

- (id)initWithCommentID:(NSInteger)commentID withMessage:(NSString *)message withPostID:(NSInteger)postID;
- (id)initWithPost:(Post *)post;
- (id)initDummy;

- (void)validateComment;
@end
