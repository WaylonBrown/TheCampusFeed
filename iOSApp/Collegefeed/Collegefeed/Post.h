//
//  Post.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

// shared with Comment
@property (nonatomic) NSInteger postID;
@property (nonatomic) NSInteger collegeID;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger vote; //-1 = downvote, 0 = nothing, 1 = upvote
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

@end
