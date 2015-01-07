//
//  CreatePostCommentViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/17/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFModelProtocol.h"
#import "Constants.h"

@class College;
@class DataController;
@class ToastController;

@protocol CreationViewProtocol <NSObject>

- (void)submitPostCommentCreationWithMessage:(NSString *)message
                               withCollegeId:(long)collegeId
                               withUserToken:(NSString *)userToken
                                   withImage:(UIImage *)image;

- (void)commentingTooFrequently;

@end

@interface CreatePostCommentViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate,
    UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) CGRect previousMessageRect;
@property (nonatomic) CGRect previousTagRect;
@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic) CGFloat keyboardWidth;

@property (strong, nonatomic) id<CreationViewProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UITextView *tagTextView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;

@property (strong, nonatomic) IBOutlet UIView *takeNewPhotoButton;
@property (strong, nonatomic) IBOutlet UIView *chooseExistingPhotoButton;

@property (strong, nonatomic) ToastController *toastController;

@property (strong, nonatomic) College *collegeForPost;
@property (nonatomic) ModelType modelType;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageTextViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dialogVerticalPosition;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagTextViewHeight;

- (id)initWithType:(ModelType)type
       withCollege:(College *)college
withDataController:(DataController *)controller;

- (IBAction)submit:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)takeNewPhoto:(id)sender;
- (IBAction)useExistingPhoto:(id)sender;

@end

