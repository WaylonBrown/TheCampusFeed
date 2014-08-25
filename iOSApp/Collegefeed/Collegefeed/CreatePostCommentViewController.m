//
//  CreatePostCommentViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CreatePostCommentViewController.h"
#import "Shared.h"
#import "College.h"
#import "ToastController.h"
#import "UIView+Toast.h"

@implementation CreatePostCommentViewController

- (id)initWithType:(ModelType)type
       withCollege:(College *)college
{
    self = [super init];
    if (self)
    {
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setTransitioningDelegate:self];
        [self setModelType:type];
        [self setCollegeForPost:college];
        self.toastController = [[ToastController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textView setDelegate:self];
    UITextPosition* pos = self.textView.endOfDocument;
    self.previousRect = [self.textView caretRectForPosition:pos];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender
{
    NSString *message = self.textView.text;
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (message.length > MIN_POST_LENGTH
        && message.length < MAX_POST_LENGTH)
    {
        [self.delegate submitPostCommentCreationWithMessage:message
                                              withCollegeId:self.collegeForPost.collegeID
                                              withUserToken:@"EMPTY_TOKEN"];
        [self dismiss:nil];
    }
    else if (message.length < MIN_POST_LENGTH)
    {
        switch (self.modelType)
        {
            case POST:
                [self.toastController toastPostTooShortWithLength:MIN_POST_LENGTH];
                break;
            case COMMENT:
                [self.toastController toastCommentTooShortWithLength:MIN_POST_LENGTH];
            default:
                break;
        }
    }
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)receivedNotification:(NSNotification *) notification
{
    NSDictionary *dictionary = [notification userInfo];
    NSString *toast = [dictionary objectForKey:@"message"];
    
    [self.view makeToast:toast
                duration:2.0
                position:@"top"];
}

#pragma mark - TextView

- (void)textViewDidChange:(UITextView *)textView
{
    UITextPosition* pos = self.textView.endOfDocument;
    CGRect currentRect = [self.textView caretRectForPosition:pos];
    
    if (currentRect.origin.y > self.previousRect.origin.y)
    {
        self.textViewHeight.constant += 17;
        self.dialogVerticalPosition.constant -= 7;
        [self.view setNeedsUpdateConstraints];
    }
    self.previousRect = currentRect;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
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
