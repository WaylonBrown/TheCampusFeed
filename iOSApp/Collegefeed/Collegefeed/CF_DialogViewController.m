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


- (id)initWithTitle:(NSString *)title withContent:(NSString *)content
{
    self = [self init];

    if (self)
    {
        [self setTitleString:title];
        [self setContentString:content];
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
    }
    return self;

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:0.75]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.titleLabel setText:self.titleString];
    [self.contentView setText:self.contentString];
    [self.titleLabel setFont:CF_FONT_LIGHT(24)];
    [self.contentView setFont:CF_FONT_LIGHT(15)];
    [self fixHeights];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle:(NSString *)title
{
    [self setTitleString:title];
}
- (void)setContent:(NSString *)content
{
    [self setContentString:content];
}
- (void)setAsHelpScreen
{
    [self setTitle:@"Help"];
    [self setContentString:@"TheCampusFeed is an anonymous message board. No logins, no accounts. Anyone can view any college's feed, as well as the All Colleges feed which is a mixture of all colleges' posts put together.\n\nIf you make a post that gets a certain amount of flags, it will be automatically removed. If you have multiple posts removed, you will be banned from posting to the app. Think before you post! To view the rules, click the Flag icon for any post near you."];
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)fixHeights
{
    [self.view setNeedsDisplay];
    
    
    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:self.contentString];
    
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
        
    }
    else
    {
        UITextView *calculationView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.view.frame.size.height)]; //2000.0f
        [calculationView setAttributedText:aString];
        
        CGRect textRect = [calculationView.text
                           boundingRectWithSize:calculationView.frame.size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:CF_FONT_LIGHT(15)}
                           context:ctx];
        
        self.contentHeight.constant = textRect.size.height + 10;
    
    }
    [self.view setNeedsUpdateConstraints];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self fixHeights];
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
