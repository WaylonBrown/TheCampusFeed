//
//  CommentViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class CommentDataController;
@class Post;


@interface CommentViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate, CreationViewProtocol>

@property (strong, nonatomic) Post *originalPost;
@property (strong, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *postTableHeightConstraint;

@end
