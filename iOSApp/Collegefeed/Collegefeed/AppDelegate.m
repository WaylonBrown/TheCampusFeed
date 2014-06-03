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
#import "Shared.h"
#import "College.h"
#import "CollegePickerViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   // Set up ViewControllers and DataControllers

    // ***SIMULATE YOUR LOCATION***
    
    self.appData = [[AppData alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBarTintColor:[Shared getCustomUIColor:cf_lightblue]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
#pragma mark - Create ViewControllers
    
    // *** Top Posts - PostsViewController *** //
    PostsViewController *topPostsController = [[PostsViewController alloc] initAsTopPostsWithAppData:self.appData];
    UINavigationController *topPostsNavController = [[UINavigationController alloc] initWithRootViewController:topPostsController];
    // *************************************** //
    
    
    // *** New Posts - PostsViewController *** //
    PostsViewController *newPostsController = [[PostsViewController alloc] initAsNewPostsWithAppData:self.appData];
    UINavigationController *newPostsNavController = [[UINavigationController alloc] initWithRootViewController:newPostsController];
    // *************************************** //
    
    
    // *** Trending Tags - TagViewController *** //
    TagViewController *tagController = [[TagViewController alloc] initWithAppData:self.appData];
    UINavigationController *tagNavController = [[UINavigationController alloc] initWithRootViewController:tagController];
    // *************************************** //
    
    
    // *** Top Colleges - CollegePickerViewController *** //
    CollegePickerViewController *collegeController = [[CollegePickerViewController alloc] initAsTopColleges];
    [collegeController setCollegesList:self.appData.collegeDataController.list];
    [collegeController setDelegate:topPostsController];
    UINavigationController *collegeNavController =
            [[UINavigationController alloc] initWithRootViewController:collegeController];
    // *************************************** //

    
    // assign all navigation controllers to the TabBar
    NSArray *navControllers = [NSArray arrayWithObjects:
                               topPostsNavController,
                               newPostsNavController,
                               tagNavController,
                               collegeNavController, nil];
    
    [self setTabBarController:[[UITabBarController alloc] init]];
    [self.tabBarController setViewControllers:navControllers];
    
    
    // assign images to tabbar
    [[self.tabBarController.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"top.png"]];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"new.png"]];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"tags.png"]];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"colleges.png"]];

    
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