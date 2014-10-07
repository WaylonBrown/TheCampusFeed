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
};

@property DialogType dialogType;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dialogHeight;

@property (strong, nonatomic) IBOutlet UIView *dialogView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *contentString;

@property float landscapeHeight;
@property float portraitHeight;

- (id)initWithTitle:(NSString *)title withContent:(NSString *)content;

- (void)setTitle:(NSString *)title;
- (void)setContent:(NSString *)content;
- (void)setAsHelpScreen;
- (void)setAsTimeCrunchInfo;
- (void)setAsRequiredUpdate;

- (IBAction)dismiss:(id)sender;

@end
