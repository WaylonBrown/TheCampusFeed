//
//  CF_DialogViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 9/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CF_DialogViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

typedef NS_ENUM(NSInteger, DialogType)
{
    HELP,
    TIME_CRUNCH,
    UPDATE,
    TWITTER,
    WEBSITE
};

@property DialogType dialogType;


@property (strong, nonatomic) IBOutlet UIView *dialogView;
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *button1Width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dialogHeight;

@property NSInteger buttonCount;
//@property float landscapeHeight;
//@property float portraitHeight;

- (id)initWithDialogType:(DialogType)type;
- (id)initWithTitle:(NSString *)title withContent:(NSString *)content;

- (void)setAsHelpScreen;
- (void)setAsTimeCrunchInfo;
- (void)setAsRequiredUpdate;
- (void)setAsTwitterReminder;
- (void)setAsWebsiteReminder;

- (IBAction)dismiss:(id)sender;

@end
