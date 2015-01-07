//
//  CFNavigationController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/7/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

#import "CFNavigationController.h"

#import "CommentViewController.h"
#import "CreatePostCommentViewController.h"
#import "DataController.h"
#import "IIViewDeckController.h"
#import "MenuViewController.h"
#import "NewPostsViewController.h"
#import "TagViewController.h"
#import "TopPostsViewController.h"
#import "TrendingCollegesViewController.h"
#import "TutorialViewController.h"
#import "UserPostsViewController.h"
#import "UserCommentsViewController.h"

#import "TheCampusFeed-Swift.h"

@interface CFNavigationController ()

@property (strong, nonatomic) DataController *dataController;

@property (strong, nonatomic) IIViewDeckController *deckController;
@property (strong, nonatomic) MenuViewController *menuViewController;
@property (strong, nonatomic) TopPostsViewController *topPostsController;
@property (strong, nonatomic) NewPostsViewController *recentPostsController;
@property (strong, nonatomic) TagViewController *tagController;
@property (strong, nonatomic) CollegePickerViewController *collegeController;
@property (strong, nonatomic) UserPostsViewController* userPostsController;
@property (strong, nonatomic) UserCommentsViewController *userCommentsController;
@property (strong, nonatomic) TrendingCollegesViewController*trendingCollegesController;
@property (strong, nonatomic) TutorialViewController *tutorialController;
@property (strong, nonatomic) CF_DialogViewController *helpController;
@property (strong, nonatomic) TimeCrunchViewController *timeCrunchController;
@property (strong, nonatomic) AchievementViewController *achievementController;

@end

@implementation CFNavigationController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dataController = [[DataController alloc] init];
        [self initViewControllersWithDataController:self.dataController];
        [self setUpMenuBar];
        [self showDialogForLaunchCount:self.dataController.launchCount];

        [self pushViewController:[self getMyDeckController] animated:NO];
    }
    
    return self;
}
- (BOOL)shouldAutorotate
{
    id currentViewController = self.topViewController;
    
    if ([currentViewController isKindOfClass:[IIViewDeckController class]])
    {
        currentViewController = ((IIViewDeckController *)currentViewController).centerController;
    }
    
    if ([currentViewController isKindOfClass:[TimeCrunchViewController class]]
        || [currentViewController isKindOfClass:[CreatePostCommentViewController class]])
        
        return NO;
    
    return YES;
}
- (void)showDialogForLaunchCount:(long)count
{
    if (count == 1)
    {
        [[self getMyMenuViewController] showTutorial];
    }
    else if (count == 5)
    {
        CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:TWITTER];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];
    }
    else if (count == 10)
    {
        CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:WEBSITE];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];
    }
}
- (void)initViewControllersWithDataController:(DataController *)data
{
    if (data == nil)
    {
        NSLog(@"CFNavigationController received a nil DataController object in initViewControllersWithDataController");
        return;
    }
    
    self.topPostsController = [[TopPostsViewController alloc] initWithDataController:data];
    
    self.recentPostsController = [[NewPostsViewController alloc] initWithDataController:data];
    
    self.tagController = [[TagViewController alloc] initWithDataController:data];
    
    self.trendingCollegesController = [[TrendingCollegesViewController alloc]
                                           initWithDataController:data];
    
    self.userPostsController = [[UserPostsViewController alloc] initWithDataController:data];
    
    
    
    self.userCommentsController = [[UserCommentsViewController alloc] initWithDataController:data];
    
    self.tutorialController = [[TutorialViewController alloc] init];
    
    self.helpController = [[CF_DialogViewController alloc] initWithDialogType:HELP];
    
    self.timeCrunchController = [[TimeCrunchViewController alloc] initWithDataController:data];
    
    self.achievementController = [[AchievementViewController alloc] initWithDataController:data];
}
- (MenuViewController *)getMyMenuViewController
{
    if (self.menuViewController == nil)
    {
        self.menuViewController = [[MenuViewController alloc] initWithViewControllers:[self getMyViewControllers]];
        self.menuViewController.view.layer.borderWidth = 0;
        self.menuViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        self.menuViewController.view.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        
        // TODO: play with this thing to fix shadows
        self.menuViewController.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft;
    }
    
    return self.menuViewController;
}
- (NSArray *)getMyViewControllers
{
   return [NSArray arrayWithObjects:
           self.topPostsController,
           self.recentPostsController,
           self.tagController,
           self.trendingCollegesController,
           self.userPostsController,
           self.userCommentsController,
           self.achievementController,
           self.timeCrunchController,
           self.helpController, nil];
}
- (IIViewDeckController *)getMyDeckController
{
    if (self.deckController == nil)
    {
        self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.topPostsController leftViewController:[self getMyMenuViewController]];
        
        self.deckController.openSlideAnimationDuration = 0.25f;
        self.deckController.closeSlideAnimationDuration = 0.25f;
        self.deckController.leftSize = 100.0f;
        self.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    }
    
    return self.deckController;
}
- (void)openLeftMenu
{
    if ([[self getMyDeckController] isSideOpen:IIViewDeckLeftSide])
    {
        [[self getMyDeckController] closeLeftView];
    }
    else
    {
        [[self getMyDeckController] openLeftView];
    }
}
- (void)setUpMenuBar
{
    [self.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setBarTintColor:[Shared getCustomUIColor:CF_BLUE]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"TheCampusFeedLogo"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(openLeftMenu)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -16;
    [[self getMyDeckController] navigationItem].leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, menuButton, nil];

//    self.deckController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, menuButton, nil];
}


@end
