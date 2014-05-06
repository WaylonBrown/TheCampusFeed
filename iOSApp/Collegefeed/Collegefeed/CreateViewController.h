//
//  CreateViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostSubViewDelegate;
@protocol CommentSubViewDelegate;

@interface CreateViewController : UIViewController

@property (nonatomic, weak) id<PostSubViewDelegate> pDelegate;
@property (nonatomic, weak) id<CommentSubViewDelegate> cDelegate;

@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

- (IBAction)cancel;
- (IBAction)create;
//- (IBAction)createPost;
//- (IBAction)createComment;

@end
