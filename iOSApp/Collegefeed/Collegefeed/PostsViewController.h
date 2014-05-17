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

@interface PostsViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) Post* selectedPost;

//@property (weak, nonatomic) IBOutlet UITableView *postTableView;

//- (IBAction)createPost:(id)sender;

@end

