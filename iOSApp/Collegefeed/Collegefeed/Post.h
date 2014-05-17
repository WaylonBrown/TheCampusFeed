//
//  Post.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Vote;

@interface Post : NSObject

// these properties inherited by Comment
@property (nonatomic) NSInteger postID;
@property (nonatomic) NSInteger collegeID;
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) Vote *vote;

@property (nonatomic, strong) NSString *postMessage;
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSDate *date;

// should only be for Post
@property (nonatomic) NSMutableArray *commentList;


- (id)initWithPostID:(NSInteger)newPostID
           withScore:(NSInteger)score
     withPostMessage:(NSString *)newPostMessage;

- (id)initWithPostMessage:(NSString *)newPostMessage;
- (id)initDummy;
- (void)validatePost;
- (NSData*)toJSON;
- (void)castVote:(BOOL)isUpVote;

@end
