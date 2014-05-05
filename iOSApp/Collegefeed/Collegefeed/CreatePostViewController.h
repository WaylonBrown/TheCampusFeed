//
//  CreatePostViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/4/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;

@protocol CreatePostViewControllerDelegate;


@interface CreatePostViewController : UIViewController

@property (nonatomic, weak) id<CreatePostViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *postTextField;

- (IBAction)cancel;
- (IBAction)createPost;

@end


@protocol CreatePostViewControllerDelegate <NSObject>

- (void)createPostViewController:(CreatePostViewController *)viewController createdNewPost:(Post *)post;

@end