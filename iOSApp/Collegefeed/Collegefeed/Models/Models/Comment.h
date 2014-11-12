//
//  Comment.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFModelProtocol.h"
#import "PostAndCommentProtocol.h"
#import "Post.h"

@class Post;

@interface Comment : Post //NSObject<CFModelProtocol, PostAndCommentProtocol>

@property (nonatomic) NSNumber *post_id;
@property (nonatomic) NSNumber *commentID;
//@property (nonatomic) NSNumber *postID;
//@property (nonatomic) NSNumber *collegeID;
//@property (nonatomic) NSNumber *score;
//@property (nonatomic, strong) Vote *vote;

//@property (nonatomic, strong) NSString *text;
//@property (nonatomic, strong) NSString *collegeName;
//@property (nonatomic, strong) NSDate *date;

//@property (nonatomic, strong) NSDate *createdAt;
//@property (nonatomic, strong) NSDate *updatedAt;

//@property (nonatomic, strong) NSURL *POSTurl;

- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post;

- (id)initWithCommentID:(NSInteger)newCommentID
              withScore:(NSInteger)newScore
            withMessage:(NSString *)newMessage
             withPostID:(NSInteger)newPostID;

- (id)initWithPost:(Post *)post;
- (NSNumber *)getPostID;
@end
