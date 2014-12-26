//
//  CreatePostCommentViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/17/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "CreatePostCommentViewController.h"
#import "Shared.h"
#import "College.h"
#import "ToastController.h"
#import "UIView+Toast.h"
#import "Tag.h"
#import "DataController.h"

@implementation CreatePostCommentViewController

- (id)initWithType:(ModelType)type
       withCollege:(College *)college
withDataController:(DataController *)controller
{
    self = [super init];
    if (self)
    {
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setTransitioningDelegate:self];
        [self setModelType:type];
        [self setCollegeForPost:college];
//        self.toastController = [[ToastController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];

    [self.messageTextView setDelegate:self];
    [self.tagTextView setDelegate:self];
    UITextPosition* pos = self.messageTextView.endOfDocument;
    self.previousMessageRect = [self.messageTextView caretRectForPosition:pos];
    self.previousTagRect = CGRectZero;
    
    self.alertView.layer.borderWidth = 2;
    self.alertView.layer.cornerRadius = 5;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:0.75]];
    
    if (self.modelType == POST)
    {
        [self.titleLabel setText:@"New Post"];
        [self.subtitleLabel setText:[NSString stringWithFormat:@"Posting to %@", self.collegeForPost.name]];
        [self.createButton.titleLabel setText:@"Post"];
    }
    else if (self.modelType == COMMENT)
    {
        [self.titleLabel setText:@"New Comment"];
        [self.subtitleLabel setText:@""];
        [self.createButton.titleLabel setText:@"Comment"];
    }
    
    // Set fonts
    [self.titleLabel setFont:CF_FONT_LIGHT(30)];
    [self.subtitleLabel setFont:CF_FONT_ITALIC(14)];
    [self.createButton.titleLabel setFont:CF_FONT_LIGHT(16)];
    [self.messageTextView setFont:CF_FONT_LIGHT(16)];
    [self.messageTextView setTintColor:[Shared getCustomUIColor:CF_DARKGRAY]];
    
    [self.messageTextView setDelegate:self];
    [self.tagTextView setDelegate:self];
    
    [self.messageTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)submit:(id)sender
{
    NSString *message = self.messageTextView.text;
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self.delegate submitPostCommentCreationWithMessage:message
                                          withCollegeId:self.collegeForPost.collegeID
                                          withUserToken:@"EMPTY_TOKEN"
                                              withImage:nil];

//    [self dismiss:nil];
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraButtonPressed:(id)sender
{
    [self takePicture];
//    [self selectPicture];
}


- (void)selectPicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)takePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)receivedNotification:(NSNotification *) notification
{
    NSDictionary *dictionary = [notification userInfo];
    NSString *toast = [dictionary objectForKey:@"message"];
    
    [self.view makeToast:toast
                duration:2.0
                position:@"top"];
}

#pragma mark - View Adjustments

- (void)fixDialogPositionAndUpdateConstraints
{
    float dialogHeight = self.alertView.frame.size.height;
    float visibleHeight = self.view.frame.size.height - self.keyboardHeight;
    
    float blankSpace = visibleHeight - dialogHeight;
    float newConstant = blankSpace / 2;
    float oldConstant = self.dialogVerticalPosition.constant;
    
    if (oldConstant != newConstant && newConstant >= 20)
    {
        self.dialogVerticalPosition.constant = newConstant;
    }
    
    [self.view setNeedsUpdateConstraints];
    
}
- (void)updateTagTextView
{
    UITextPosition* pos = self.tagTextView.endOfDocument;
    CGRect currentRect = [self.tagTextView caretRectForPosition:pos];
    
    NSString *tagsString = self.tagTextView.text;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tagsString];
    
    if (self.tagTextViewHeight.constant == 0)
    {
        self.tagTextViewHeight.constant = 30;
    }
    else if (currentRect.origin.y > self.previousTagRect.origin.y)
    {
        self.tagTextViewHeight.constant += TEXT_VIEW_LINE_HEIGHT;
    }
    else if (currentRect.origin.y < self.previousTagRect.origin.y)
    {
        self.tagTextViewHeight.constant -= TEXT_VIEW_LINE_HEIGHT;
    }
    
    self.previousTagRect = currentRect;
    
    NSRange range = NSMakeRange(6, tagsString.length - 6);
    [string addAttribute:NSForegroundColorAttributeName value:[Shared getCustomUIColor:CF_BLUE] range:range];
    [self.tagTextView setAttributedText:string];
    [self.tagTextView setFont:CF_FONT_LIGHT(16)];
}

#pragma mark - Keyboard

- (void)keyboardWasShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Given size may not account for screen rotation
    self.keyboardHeight = MIN(keyboardSize.height, keyboardSize.width);
    self.keyboardWidth = MAX(keyboardSize.height, keyboardSize.width);
    
    [self fixDialogPositionAndUpdateConstraints];
}
- (void)keyboardWasHidden:(NSNotification *)notification
{
    // Given size may not account for screen rotation
    self.keyboardHeight = 0;
    self.keyboardWidth = 0;
    
    [self fixDialogPositionAndUpdateConstraints];
}

#pragma mark - TextView

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.messageTextView)
    {
        UITextPosition* pos = textView.endOfDocument;
        CGRect currentRect = [textView caretRectForPosition:pos];
        if (currentRect.origin.y > self.previousMessageRect.origin.y)
        {
            self.messageTextViewHeight.constant += TEXT_VIEW_LINE_HEIGHT;
        }
        else if (currentRect.origin.y < self.previousMessageRect.origin.y)
        {
            self.messageTextViewHeight.constant -= TEXT_VIEW_LINE_HEIGHT;
        }
        
        self.previousMessageRect = currentRect;
        
        [self fixDialogPositionAndUpdateConstraints];

        
        // Check for tags
        NSString *message = self.messageTextView.text;
        NSString *filteredMessage = @"Tags:";
        
        int numTags = 0;
        
        NSArray *words = [message componentsSeparatedByString:@" "];
        for (NSString *word in words)
        {
            if ([Tag withMessageIsValid:word])
            {
                filteredMessage = [NSString stringWithFormat:@"%@ %@", filteredMessage, word];
                numTags++;
            }
        }
        if (numTags > 0)
        {
            [self.tagTextView setText:filteredMessage];
            [self updateTagTextView];
            [self fixDialogPositionAndUpdateConstraints];
        }
        else
        {
            [self.tagTextView setText:@""];
            self.tagTextViewHeight.constant = 0;
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        [self fixDialogPositionAndUpdateConstraints];
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    
    if (textView != self.messageTextView) return YES;

    return textView.text.length + (text.length - range.length) <= 140;
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    self.imageViewHeight.constant = 200;

    [self fixDialogPositionAndUpdateConstraints];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Transitioning Protocol Methods

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    
    if (vc2 == self)
    { // presenting
        [con addSubview:v2];
        v2.frame = v1.frame;
        self.alertView.transform = CGAffineTransformMakeScale(1.6,1.6);
        v2.alpha = 0;
        v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [UIView animateWithDuration:0.25 animations:^{
            v2.alpha = 1;
            self.alertView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    { // dismissing
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(0.5,0.5);
            v1.alpha = 0;
        } completion:^(BOOL finished) {
            v2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
