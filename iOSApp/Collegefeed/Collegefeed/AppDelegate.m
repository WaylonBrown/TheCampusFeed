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
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) ECSlidingViewController *slidingViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   // Set up ViewControllers and DataControllers

    // ***SIMULATE YOUR LOCATION***
    self.dataController = [DataController new];
    [self.dataController setAppDelegate:self];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBarTintColor:[Shared getCustomUIColor:CF_LIGHTBLUE]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(anchorRight)];

    
    // *** Top Posts - PostsViewController *** //
    self.topPostsController = [[PostsViewController alloc] initAsType:TOP_VIEW
                                                   withDataController:self.dataController];
    UINavigationController *topPostsNavController = [[UINavigationController alloc] initWithRootViewController:self.topPostsController];
    self.topPostsController.navigationItem.leftBarButtonItem = menuButton;
    // *************************************** //


    // *** New Posts - PostsViewController *** //
    self.recentPostsController = [[PostsViewController alloc] initAsType:RECENT_VIEW
                                                      withDataController:self.dataController];
    UINavigationController *newPostsNavController = [[UINavigationController alloc] initWithRootViewController:self.recentPostsController];
    self.recentPostsController.navigationItem.leftBarButtonItem = menuButton;
    // *************************************** //
    
    
    // *** Trending Tags - TagViewController *** //
    self.tagController = [[TagViewController alloc] initWithDataController:self.dataController];
    UINavigationController *tagNavController = [[UINavigationController alloc] initWithRootViewController:self.tagController];
    self.tagController.navigationItem.leftBarButtonItem = menuButton;
    // *************************************** //
    
    // *** Trending Colleges - TrendingCollegesViewController *** //
    self.trendingCollegesController = [[TrendingCollegesViewController alloc] initWithDataController:self.dataController];
    UINavigationController *collegeNavController = [[UINavigationController alloc] initWithRootViewController:self.trendingCollegesController];
    self.trendingCollegesController.navigationItem.leftBarButtonItem = menuButton;
    // *************************************** //
    
    // *** User Posts - UserPostsViewController *** //
    self.userPostsController = [[UserPostsViewController alloc] initAsType:USER_POSTS
                                                        withDataController:self.dataController];
    UINavigationController *userPostsNavController = [[UINavigationController alloc] initWithRootViewController:self.userPostsController];
    self.userPostsController.navigationItem.leftBarButtonItem = menuButton;
    // *************************************** //

    // *** User Comments - UserCommentsViewController *** //
    self.userCommentsController = [[UserCommentsViewController alloc] initAsType:USER_COMMENTS
                                                              withDataController:self.dataController];
    UINavigationController *userCommentsNavController = [[UINavigationController alloc] initWithRootViewController:self.userCommentsController];
    self.userCommentsController.navigationItem.leftBarButtonItem = menuButton;
    // *************************************** //

        
    // assign all navigation controllers to the Menu View Controller
    NSArray *navControllers = [NSArray arrayWithObjects:
                               topPostsNavController,
                               newPostsNavController,
                               tagNavController,
                               collegeNavController,
                               userPostsNavController,
                               userCommentsNavController,
                               nil];

    // *** Side Menu - MenuViewController *** //
    MenuViewController *menuViewController  = [[MenuViewController alloc] initWithNavControllers:navControllers];
    menuViewController.view.layer.borderWidth     = 0;
    menuViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    menuViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    menuViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft;
    
    UINavigationController *menuNavController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:topPostsNavController];
    [topPostsNavController.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.slidingViewController.underLeftViewController  = menuNavController;
    
    self.slidingViewController.anchorRightRevealAmount = 225.0;
    // *************************************** //

    self.window.rootViewController = self.slidingViewController;
    
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
- (void)anchorRight
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}



@end