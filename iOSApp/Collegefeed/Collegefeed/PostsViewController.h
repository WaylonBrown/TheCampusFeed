//
//  PostsViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class Post;
@class CommentViewController;

@interface PostsViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Post* selectedPost;
@property (strong, nonatomic) CommentViewController* commentViewController;
@property (nonatomic, strong) NSString* tagMessage;

// should equal YES if looking at 'Top' posts
@property (nonatomic) BOOL topPosts;

// should equal YES if looking at 'New' posts
@property (nonatomic) BOOL recentPosts;

// should equal YES if looking at 'My' posts
@property (nonatomic) BOOL myPosts;

// should equal YES if looking at tag-filtered posts
@property (nonatomic) BOOL tagPosts;


- (id)initAsTopPostsWithDataControllers:(NSArray *)dataControllers;
- (id)initAsNewPostsWithDataControllers:(NSArray *)dataControllers;
- (id)initAsMyPostsWithDataControllers:(NSArray *)dataControllers;
- (id)initAsTagPostsWithDataControllers:(NSArray *)dataControllers
                         withTagMessage:(NSString*)tagMessage;

@end

