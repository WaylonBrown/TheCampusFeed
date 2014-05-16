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
#import "Constants.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   // Set up of the TabBarController, NavigationControllers, and Custom ViewControllers (Posts, Comments, Tags).
    // i.e. [TabBar] -> [NavigationController]s -> [____ViewController]
    //                   One NavigationController for each ViewController

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(cf_lightblue)];
    
    // Top Posts - PostsViewController
    PostsViewController *topPostsController = [[PostsViewController alloc] init];
    topPostsController.title = @"Top Posts";
    UINavigationController *topPostsNavController = [[UINavigationController alloc] initWithRootViewController:topPostsController];
    [topPostsNavController.navigationBar.topItem setTitleView:logoTitleView];
    
    // New Posts - PostsViewController
    PostsViewController *newPostsController = [[PostsViewController alloc] init];
    newPostsController.title = @"New Posts";
    UINavigationController *newPostsNavController = [[UINavigationController alloc] initWithRootViewController:newPostsController];
    [newPostsNavController.navigationBar.topItem setTitleView:logoTitleView];
    
    // Trending Tags - TagViewController
    TagViewController *tagController = [[TagViewController alloc] init];
    tagController.title = @"Trending Tags";
    UINavigationController *tagNavController = [[UINavigationController alloc] initWithRootViewController:tagController];
    [tagNavController.navigationBar.topItem setTitleView:logoTitleView];

    // Top Colleges - CollegeViewController
    //    CollegeViewController *collegeController = [[CollegeViewController alloc] init];
    //    UINavigationController *collegeNavController = [[UINavigationController alloc] initWithRootViewController:collegeController];
    
    // My Posts - PostsViewController
    PostsViewController *myPostsController = [[PostsViewController alloc] init];
    myPostsController.title = @"My Posts";
    UINavigationController *myPostsNavController = [[UINavigationController alloc] initWithRootViewController:myPostsController];
    [myPostsNavController.navigationBar.topItem setTitleView:logoTitleView];

    // My Comments - PostsViewController
    PostsViewController *myCommentController = [[PostsViewController alloc] init];
    myCommentController.title = @"My Comments";
    UINavigationController *myCommentNavController = [[UINavigationController alloc] initWithRootViewController:myCommentController];
    [myCommentNavController.navigationBar.topItem setTitleView:logoTitleView];

    // assign all navigation controllers to the TabBar
    NSArray *navControllers = [NSArray arrayWithObjects:topPostsNavController, newPostsNavController, tagNavController, myPostsNavController, myCommentNavController, nil];
    [self setTabBarController:[[UITabBarController alloc] init]];
    [self.tabBarController setViewControllers:navControllers];
    
    // finalize window specifications
    [self.window setRootViewController:self.tabBarController];
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
@end