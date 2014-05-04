//
//  CommentDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comment;

@interface CommentDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterCommentList;

- (NSString *)getPostMessage;
- (NSUInteger)countOfList;
- (Comment *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addCommentWithMessage:(Comment *)post;
- (void) initializeDefaultList;


@end
