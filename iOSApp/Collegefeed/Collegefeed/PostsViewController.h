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
@property (strong, nonatomic) NSString* tagMessage;

@property (nonatomic) ViewType viewType;

- (id)initAsType:(ViewType)type withDataController:(DataController *)controller;

@end

