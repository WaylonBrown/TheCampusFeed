//
//  CreatePostViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/4/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;
@protocol PostSubViewDelegate;

@interface CreatePostViewController : UIViewController

@property (nonatomic, weak) id<PostSubViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *postTextField;

- (IBAction)cancel;
- (IBAction)createPost;

@end
