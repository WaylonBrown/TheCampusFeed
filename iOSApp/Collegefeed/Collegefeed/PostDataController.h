//
//  PostDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

// forward declaration (tell compiler a Post class does exist)
@class Post;

@interface PostDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterPostList;

- (NSUInteger)countOfList;
- (Post *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addPostWithMessage:(Post *)post;

@end
