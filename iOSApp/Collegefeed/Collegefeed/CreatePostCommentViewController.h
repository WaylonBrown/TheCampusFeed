//
//  CreatePostCommentViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class College;


@protocol CreationViewProtocol <NSObject>

- (void)submitPostCommentCreationWithMessage:(NSString *)message
                               withCollegeId:(long)collegeId;
@end


typedef NS_ENUM(NSInteger, CreationType)
{
    POST,
    COMMENT
};


@interface CreatePostCommentViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) id<CreationViewProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (strong, nonatomic) College *collegeForPost;
@property (nonatomic) CreationType creationType;

- (id)initWithType:(CreationType)type
       withCollege:(College *)college;

- (IBAction)submit:(id)sender;
- (IBAction)dismiss:(id)sender;

@end

