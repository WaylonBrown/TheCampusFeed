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


@interface CommentViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Post *originalPost;


@end
