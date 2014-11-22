//
//  CommentViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class CommentDataController;
@class Post;


@interface CommentViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate, CreationViewProtocol>

// View properties
@property (strong, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *postTableHeightConstraint;

@property (strong, nonatomic) UIBarButtonItem *facebookButton;
@property (strong, nonatomic) UIBarButtonItem *twitterButton;
@property (strong, nonatomic) UIBarButtonItem *composeButton;
@property (strong, nonatomic) UIBarButtonItem *flagButton;
@property (strong, nonatomic) UIBarButtonItem *dividerButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;

@end
