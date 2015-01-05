//
//  CF_DialogViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 9/22/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DialogType)
{
    HELP,
    TIME_CRUNCH,
    UPDATE,
    TWITTER,
    WEBSITE
};

@interface CF_DialogViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property DialogType dialogType;

@property (strong, nonatomic) IBOutlet UIView *dialogView;
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
@property (strong, nonatomic) IBOutlet UITextView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *button1Width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dialogHeight;

@property NSInteger buttonCount;

- (id)initWithDialogType:(DialogType)type;
- (id)initWithTitle:(NSString *)title withContent:(NSString *)content;

- (void)setAsHelpScreen;
- (void)setAsTimeCrunchInfo;
- (void)setAsRequiredUpdate;
- (void)setAsTwitterReminder;
- (void)setAsWebsiteReminder;
- (void)setAsTimeCrunchSwitchCollegePrompt;

- (IBAction)dismiss:(id)sender;

@end
