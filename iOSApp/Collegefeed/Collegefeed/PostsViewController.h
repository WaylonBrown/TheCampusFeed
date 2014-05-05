//
//  PostsViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePostViewController.h"

@class PostDataController;
@class Post;

// protocol to handle events in subviews
@protocol PostSubViewDelegate <NSObject>

- (void)votedOnPost;
- (void)createdNewPost:(Post *)post;

@end

@interface PostsViewController : UIViewController <PostSubViewDelegate>

@property (strong, nonatomic) PostDataController *dataController;
@property (strong, nonatomic) Post* selectedPost;
@property (weak, nonatomic) IBOutlet UITableView *postTableView;

@end

