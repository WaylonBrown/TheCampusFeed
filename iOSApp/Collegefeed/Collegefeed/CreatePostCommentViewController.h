//
//  CreatePostCommentViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models/Models/CFModelProtocol.h"

@class College;

@protocol CreationViewProtocol <NSObject>

- (void)submitPostCommentCreationWithMessage:(NSString *)message
                               withCollegeId:(long)collegeId;
@end

@interface CreatePostCommentViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) id<CreationViewProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (strong, nonatomic) College *collegeForPost;
@property (nonatomic) ModelType modelType;

- (id)initWithType:(ModelType)type
       withCollege:(College *)college;

- (IBAction)submit:(id)sender;
- (IBAction)dismiss:(id)sender;

@end
