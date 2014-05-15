//
//  PostsViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostDataController;
@class Post;

@interface PostsViewController : UIViewController

@property (strong, nonatomic) PostDataController *dataController;
@property (weak, nonatomic) Post* selectedPost;

@property (weak, nonatomic) IBOutlet UITableView *postTableView;

- (IBAction)createPost:(id)sender;

@end

