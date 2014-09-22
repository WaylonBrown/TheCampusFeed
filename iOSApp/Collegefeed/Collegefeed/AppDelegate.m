//
//  AppDelegate.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "AppDelegate.h"
#import "PostsViewController.h"
#import "CommentViewController.h"
#import "TagViewController.h"
#import "UserCommentsViewController.h"
#import "UserPostsViewController.h"
#import "TrendingCollegesViewController.h"
#import "Shared.h"
#import "College.h"
#import "Networker.h"
#import "MenuViewController.h"
#import "IIViewDeckController.h"
#import "TutorialViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) IIViewDeckController *deckController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   // Set up ViewControllers and DataControllers

    // ***SIMULATE YOUR LOCATION***
    self.dataController = [DataController new];
    [self.dataController setAppDelegate:self];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBarTintColor:[Shared getCustomUIColor:CF_BLUE]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    UIBarButtonItem *menuButton         = [[UIBarButtonItem alloc]
                                           initWithImage:[UIImage imageNamed:logoImageWithButton]
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(openLeftMenu)];
    
    self.topPostsController             = [[PostsViewController alloc]
                                           initAsType:TOP_VIEW
                                           withDataController:self.dataController];

    self.recentPostsController          = [[PostsViewController alloc]
                                           initAsType:RECENT_VIEW
                                           withDataController:self.dataController];
    
    self.tagController                  = [[TagViewController alloc]
                                           initWithDataController:self.dataController];
    
    self.trendingCollegesController     = [[TrendingCollegesViewController alloc]
                                           initWithDataController:self.dataController];
    
    self.userPostsController            = [[UserPostsViewController alloc]
                                           initAsType:USER_POSTS
                                           withDataController:self.dataController];
    
    self.userCommentsController         = [[UserCommentsViewController alloc]
                                           initAsType:USER_COMMENTS
                                           withDataController:self.dataController];

    self.tutorialController             = [[TutorialViewController alloc] init];
    
    NSArray *viewControllers            = [NSArray arrayWithObjects:
                                           self.topPostsController,
                                           self.recentPostsController,
                                           self.tagController,
                                           self.trendingCollegesController,
                                           self.userPostsController,
                                           self.userCommentsController,
                                           self.tutorialController,
                                           nil];

    // *** Side Menu - MenuViewController *** //
    MenuViewController *menuViewController  = [[MenuViewController alloc] initWithViewControllers:viewControllers];
    menuViewController.view.layer.borderWidth     = 0;
    menuViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    menuViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    menuViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft;
    
    
    self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.topPostsController leftViewController:menuViewController];
    
    self.deckController.openSlideAnimationDuration = 0.25f;
    self.deckController.closeSlideAnimationDuration = 0.25f;
    self.deckController.leftSize = 100.0f;
    self.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];

    negativeSpacer.width = -16;
    self.deckController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, menuButton, nil];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:self.deckController];
    [controller.navigationBar setTranslucent:NO];
    
    // *************************************** //
    
    self.window.rootViewController = controller;

    [self.window makeKeyAndVisible];

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
- (void)foundLocation
{
    [self.topPostsController foundLocation];
//    [self.recentPostsController foundLocation];
//    [self.tagController foundLocation];
}
- (void)didNotFindLocation
{
    [self.topPostsController didNotFindLocation];
//    [self.recentPostsController didNotFindLocation];
//    [self.tagController didNotFindLocation];
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


@end