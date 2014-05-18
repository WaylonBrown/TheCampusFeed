//
//  Post.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Votable.h"

@class Vote;

@interface Post : Votable

@property (nonatomic) NSMutableArray *commentList;


- (id)initWithPostID:(NSInteger)newPostID
           withScore:(NSInteger)newScore
         withMessage:(NSString *)newMessage;

- (id)initWithMessage:(NSString *)newMessage;

@end
