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
    // *************************************** //
    self.topPostsController.navigationItem.leftBarButtonItem = menuButton;
    
    
    // configure under left menu view controller
    MenuViewController *menuViewController  = [[MenuViewController alloc] init];
    menuViewController.view.layer.borderWidth     = 0;
    menuViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    menuViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    menuViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft; // don't go under the top view
    
    
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:topPostsNavController];
    self.slidingViewController.underLeftViewController  = menuViewController;
    
    
    [topPostsNavController.view addGestureRecognizer:self.slidingViewController.panGesture];

    self.slidingViewController.anchorRightRevealAmount = 250.0;
    
    self.window.rootViewController = self.slidingViewController;

//    // *** New Posts - PostsViewController *** //
//    self.recentPostsController = [[PostsViewController alloc] initAsType:RECENT_VIEW
//                                                      withDataController:self.dataController];
//    UINavigationController *newPostsNavController = [[UINavigationController alloc] initWithRootViewController:self.recentPostsController];
//    // *************************************** //
//    
//    
//    // *** Trending Tags - TagViewController *** //
//    self.tagController = [[TagViewController alloc] initWithDataController:self.dataController];
//    UINavigationController *tagNavController = [[UINavigationController alloc] initWithRootViewController:self.tagController];
//    // *************************************** //
//    
//    // *** Trending Colleges - TrendingCollegesViewController *** //
//    self.trendingCollegesController = [[TrendingCollegesViewController alloc] initWithDataController:self.dataController];
//    UINavigationController *collegeNavController = [[UINavigationController alloc] initWithRootViewController:self.trendingCollegesController];
//    // *************************************** //
//    
//    // *** User Posts - UserPostsViewController *** //
//    self.userPostsController = [[UserPostsViewController alloc] initAsType:USER_POSTS
//                                                        withDataController:self.dataController];
//    UINavigationController *userPostsNavController = [[UINavigationController alloc] initWithRootViewController:self.userPostsController];
//    // *************************************** //
//
//    // *** User Comments - UserCommentsViewController *** //
//    self.userCommentsController = [[UserCommentsViewController alloc] initAsType:USER_COMMENTS
//                                                              withDataController:self.dataController];
//    UINavigationController *userCommentsNavController = [[UINavigationController alloc] initWithRootViewController:self.userCommentsController];
//    // *************************************** //
//
//        
//    // assign all navigation controllers to the TabBar
//    NSArray *navControllers = [NSArray arrayWithObjects:
//                               topPostsNavController,
//                               newPostsNavController,
//                               tagNavController,
//                               collegeNavController,
//                               userPostsNavController,
//                               userCommentsNavController,
//                               nil];
//    
//    [self setTabBarController:[[UITabBarController alloc] init]];
//    [self.tabBarController setViewControllers:navControllers];
//    
//    
//    // assign images to tabbar
//    [[self.tabBarController.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"top.png"]];
//    [[self.tabBarController.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"new.png"]];
//    [[self.tabBarController.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"tags.png"]];
//    [[self.tabBarController.tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"colleges.png"]];
//    
//    [((UITabBarItem *)([self.tabBarController.tabBar.items objectAtIndex:4])) setTitle:@"My Posts"];
////    [((UITabBarItem *)([self.tabBarController.tabBar.items objectAtIndex:5])) setTitle:@"My Comments"];
//
//    [self.tabBarController setSelectedIndex:0];
//    // finalize window specifications
//    [self.window setRootViewController:self.tabBarController];
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