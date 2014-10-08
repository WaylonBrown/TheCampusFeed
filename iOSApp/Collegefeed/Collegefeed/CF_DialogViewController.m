//
//  CF_DialogViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 9/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CF_DialogViewController.h"
#import "Shared.h"

@implementation CF_DialogViewController

- (id)initWithDialogType:(DialogType)type
{
    self = [self init];
    if (self)
    {
        [self setDialogType:type];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title withContent:(NSString *)content
{
    self = [self init];

    if (self)
    {
        [self.titleLabel setText:title];
        [self.contentView setText:content];
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"CF_DialogViewController" bundle:nil];
    if (self)
    {
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setTransitioningDelegate:self];
        self.portraitHeight = 340;
        self.landscapeHeight = 250;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:0.75]];
    [self.contentView scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    switch (self.dialogType) {
        case HELP:
            [self setAsHelpScreen];
            break;
        case TIME_CRUNCH:
            [self setAsTimeCrunchInfo];
            break;
        case UPDATE:
            [self setAsRequiredUpdate];
            break;
        case TWITTER:
            [self setAsTwitterReminder];
            break;
        case WEBSITE:
            [self setAsWebsiteReminder];
            break;
        default:
            break;
    }
    
    [self.titleLabel setFont:CF_FONT_LIGHT(24)];
    [self.contentView setFont:CF_FONT_LIGHT(15)];

    [self fixHeights];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)fixHeights
{
    float displayHeight         = self.contentView.frame.size.height;
    float dialogHeightMinusText = self.dialogView.frame.size.height - displayHeight;
    
    float textHeight = [self.contentView sizeThatFits:CGSizeMake(self.contentView.frame.size.width, MAXFLOAT)].height + 10;
    
    self.dialogHeight.constant = textHeight + dialogHeightMinusText;

    [self.view setNeedsUpdateConstraints];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self fixHeights];
}

#pragma mark - Specific Screens

- (void)setAsHelpScreen
{
    self.dialogType = HELP;
    self.portraitHeight = 340;
    self.landscapeHeight = 250;
    [self.titleLabel setText:@"Help"];
    [self.contentView setText:@"TheCampusFeed is an anonymous message board. No logins, no accounts. Anyone can view any college's feed, as well as the All Colleges feed which is a mixture of all colleges' posts put together.\n\nIf you make a post that gets a certain amount of flags, it will be automatically removed. If you have multiple posts removed, you will be banned from posting to the app. Think before you post! To view the rules, click the Flag icon for any post near you."];
}
- (void)setAsTimeCrunchInfo
{
    self.dialogType = TIME_CRUNCH;
    self.portraitHeight = 400;
    [self.titleLabel setText:@"What is Time Crunch?"];
    [self.contentView setText:@"Want to post and comment on your University\'s feed this Summer as if you\'re actually there, but are instead visiting home? What about this Winter Break?\n\nFor every post you make to your University, 24 hours get added to your Time Crunch. Once you activate Time Crunch, your current location at your University is saved in the app for that long! You can get extra hours added by unlocking Achievements.\n\nNOTE: If you turn off Time Crunch once it is active, your hours will be reset to 0!"];
}
- (void)setAsRequiredUpdate
{
    self.dialogType = UPDATE;
    
    self.portraitHeight = 150;
    self.landscapeHeight = 100;
    
    [self.titleLabel setText:@"Required Update"];
    [self.contentView setText:@"There is a new required app update"];
    [self.button1.titleLabel setText:@"Update App"];
    
    [self.button1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.button1 addTarget:self action:@selector(goToAppStoreForUpdate) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setAsTwitterReminder
{
    self.dialogType = TWITTER;
    [self.titleLabel setText:@"Follow TheCampusFeed on Twitter!"];
    [self.contentView setText:@"Want to see our pick of the top post on TheCampusFeed per day? Be sure to follow us on Twitter at @The_Campus_Feed!"];
    
    [self.button1 setTitle:@"No Thanks" forState:UIControlStateNormal];
    [self.button2 setTitle:@"Follow on Twitter" forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(followOnTwitter) forControlEvents:UIControlEventTouchUpInside];

    self.button2Width.constant = self.dialogView.frame.size.width / 2;
}
- (void)setAsWebsiteReminder
{
    self.dialogType = WEBSITE;
    [self.titleLabel setText:@"Don't forget TheCampusFeed is also on the web!"];
    [self.contentView setText:@"Want to check out posts while you're on your computer? Be sure to check out www.TheCampusFeed.com!"];
}

#pragma mark - Helpers for Specific Screens

- (void)followOnTwitter
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/intent/user?screen_name=The_Campus_Feed"]];
    [self dismiss:nil];
}
- (void)goToAppStoreForUpdate
{
    [self dismiss:nil];
}

#pragma mark - Transitioning Protocol Methods

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController: (UIViewController *)presenting sourceController: (UIViewController *)source
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
        v2.alpha = 0;
        v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [UIView animateWithDuration:0.25 animations:^{
            v2.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    { // dismissing
        [UIView animateWithDuration:0.25 animations:^{
            v1.alpha = 0;
        } completion:^(BOOL finished) {
            v2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
