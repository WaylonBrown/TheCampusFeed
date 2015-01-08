//
//  PostsViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Post.h"
#import "Vote.h"
#import "Tag.h"
#import "CommentViewController.h"
#import "Shared.h"
#import "College.h"
#import "SimpleTableCell.h"
#import "ToastController.h"
#import "TableCell.h"
#import "Comment.h"

@class Post;
@class CommentViewController;

@interface PostsViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Post* selectedPost;
@property (strong, nonatomic) CommentViewController* commentViewController;

@property (nonatomic) BOOL hasReachedEndOfList;

- (void)setCorrectList;
- (void)fetchContent;
- (void)finishedFetchRequest:(NSNotification *)notification;

@end

