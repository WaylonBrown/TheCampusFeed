//
//  HelpScreenViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 9/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpScreenViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *contentString;

- (id)initWithTitle:(NSString *)title withContent:(NSString *)content;

- (void)setTitle:(NSString *)title;
- (void)setContent:(NSString *)content;
- (void)setAsHelpScreen;
- (IBAction)dismiss:(id)sender;

@end
