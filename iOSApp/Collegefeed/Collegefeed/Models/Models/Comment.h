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

@interface Comment : Post

//@property (nonatomic) NSNumber *commentID;

- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post;

- (id)initWithCommentID:(NSInteger)newCommentID
              withScore:(NSInteger)newScore
            withMessage:(NSString *)newMessage
             withPostID:(NSInteger)newPostID;

//- (id)initWithPost:(Post *)post;
//- (NSNumber *)getPost_id;
@end
