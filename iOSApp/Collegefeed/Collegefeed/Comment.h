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

- (id)initWithCommentID:(NSInteger)commentID withMessage:(NSString *)message withPostID:(NSInteger)postID;
- (id)initWithPost:(Post *)post;
- (id)initDummy;

- (void)validateComment;
@end
