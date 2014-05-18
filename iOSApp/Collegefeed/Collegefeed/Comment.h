//
//  Comment.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Votable.h"

@interface Comment : Votable

@property (nonatomic) NSInteger commentID;


- (id)initWithCommentID:(NSInteger)newCommentID
              withScore:(NSInteger)newScore
            withMessage:(NSString *)newMessage
             withPostID:(NSInteger)newPostID;

- (id)initWithCommentMessage:(NSString *)message
                    withPost:(Post *)post;

- (id)initWithPost:(Post *)post;

@end
