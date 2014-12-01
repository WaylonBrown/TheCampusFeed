//
//  PostsViewController.h
//  TheCampusFeed
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

@property (nonatomic) ViewType viewType;
@property (nonatomic) BOOL hasReachedEndOfList;

- (id)initAsType:(ViewType)type withDataController:(DataController *)controller;

- (void)setCorrectList;
- (void)fetchContent;
- (void)finishedFetchRequest;

@end

