//
//  Comment.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Post.h"

@interface Comment : Post

@property (nonatomic) NSInteger commentID;
@property (nonatomic, copy) NSString *commentMessage;

- (id)initWithCommentID:(NSInteger)commentID
     withCommentMessage:(NSString *)message
             withPostID:(NSInteger)postID;

- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post;

- (id)initWithPost:(Post *)post;
- (id)initDummy;

- (void)validateComment;
@end
