//
//  AppDelegate.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "AppDelegate.h"


#import "TopPostsViewController.h"
#import "NewPostsViewController.h"
#import "TagViewController.h"
#import "TrendingCollegesViewController.h"
#import "UserPostsViewController.h"
#import "UserCommentsViewController.h"

#import "CommentViewController.h"

#import "Shared.h"
#import "College.h"
#import "Networker.h"
#import "MenuViewController.h"
#import "IIViewDeckController.h"
#import "TutorialViewController.h"
#import "CF_DialogViewController.h"
#import "TheCampusFeed-Swift.h"

@interface AppDelegate ()

@property (nonatomic, strong) IIViewDeckController *deckController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   // Set up ViewControllers and DataControllers

    self.dataController = [DataController new];
    [self.dataController incrementLaunchNumber];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    

    [self initViewControllers];
    [self setUpMenuBar];
    
    [self.window makeKeyAndVisible];
    
    
    switch ([self.dataController getLaunchNumber])
    {
        case 1:
        {
            [self.menuViewController showTutorial];
            break;
        }
        case 5:
        {
            CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:TWITTER];
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];

            break;
        }
        case 10:
        {
            CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:WEBSITE];
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];
            break;
        }
        default:
            break;
    }

    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.dataController saveCurrentFeed];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)openLeftMenu
{
    if ([self.deckController isSideOpen:IIViewDeckLeftSide])
    {
        [self.deckController closeLeftView];
    }
    else
    {
        [self.deckController openLeftView];
    }
}
- (void)initViewControllers
{
    self.topPostsController             = [[TopPostsViewController alloc] initWithDataController:self.dataController];
    
    self.recentPostsController          = [[NewPostsViewController alloc] initWithDataController:self.dataController];
    
    self.tagController                  = [[TagViewController alloc] initWithDataController:self.dataController];
    
    self.trendingCollegesController     = [[TrendingCollegesViewController alloc]
                                           initWithDataController:self.dataController];
    
    self.userPostsController            = [[UserPostsViewController alloc] initWithDataController:self.dataController];
    
    self.userCommentsController         = [[UserCommentsViewController alloc]
                                           initAsType:USER_COMMENTS
                                           withDataController:self.dataController];
    
    self.tutorialController             = [[TutorialViewController alloc] init];
    
    self.helpController                 = [[CF_DialogViewController alloc] initWithDialogType:HELP];
    
    self.timeCrunchController           = [[TimeCrunchViewController alloc] init];

    NSArray *viewControllers            = [NSArray arrayWithObjects:
                                           self.topPostsController,
                                           self.recentPostsController,
                                           self.tagController,
                                           self.trendingCollegesController,
                                           self.userPostsController,
                                           self.userCommentsController,
                                           self.timeCrunchController,
                                           self.helpController,
                                           //                                           self.tutorialController,
                                           nil];
    
    // *** Side Menu - MenuViewController *** //
    self.menuViewController  = [[MenuViewController alloc] initWithViewControllers:viewControllers];
    self.menuViewController.view.layer.borderWidth     = 0;
    self.menuViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    self.menuViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    self.menuViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft;
    
    self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.topPostsController
                                                                  leftViewController:self.menuViewController];
    
    self.deckController.openSlideAnimationDuration = 0.25f;
    self.deckController.closeSlideAnimationDuration = 0.25f;
    self.deckController.leftSize = 100.0f;
    self.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:self.deckController];
    [controller.navigationBar setTranslucent:NO];
    self.window.rootViewController = controller;


}
- (void)setUpMenuBar
{
    [[UINavigationBar appearance] setBarTintColor:[Shared getCustomUIColor:CF_BLUE]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    UIBarButtonItem *menuButton         = [[UIBarButtonItem alloc]
                                           initWithImage:[UIImage imageNamed:@"TheCampusFeedLogo"]
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(openLeftMenu)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -16;
    self.deckController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, menuButton, nil];
}

@end