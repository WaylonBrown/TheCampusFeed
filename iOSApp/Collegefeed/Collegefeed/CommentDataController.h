//
//  CommentDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comment;
@class Post;

@interface CommentDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterCommentList;
@property (nonatomic, strong) Post* post;

- (id) initWithPost:(Post*)post;
- (NSString *)getPostMessage;
- (NSUInteger)countOfList;
- (Comment *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addComment:(Comment *)comment;
- (void) initializeDefaultList;


@end
