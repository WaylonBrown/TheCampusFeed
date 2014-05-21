//
//  Comment.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Votable.h"

@class Post;

@interface Comment : Votable

@property (nonatomic) NSInteger commentID;

// NOTE: Use this constructor!
- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post;



- (id)initWithCommentID:(NSInteger)newCommentID
              withScore:(NSInteger)newScore
            withMessage:(NSString *)newMessage
             withPostID:(NSInteger)newPostID;

- (id)initWithPost:(Post *)post;

@end
