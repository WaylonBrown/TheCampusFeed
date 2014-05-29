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
#import "CollegeViewController.h"
#import "TagViewController.h"
#import "Shared.h"
#import "College.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   // Set up ViewControllers and DataControllers

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBarTintColor:[Shared getCustomUIColor:cf_lightblue]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
#pragma mark - Data Controller Initializations - start collecting network data
    
    [self setPostDataController:    [[PostDataController alloc]     initWithNetwork]];
    [self setCommentDataController: [[CommentDataController alloc]  initWithNetwork]];
    [self setVoteDataController:    [[VoteDataController alloc]     initWithNetwork]];
    [self setCollegeDataController: [[CollegeDataController alloc]  initWithNetwork]];
    [self setTagDataController:     [[TagDataController alloc]      initWithNetwork]];
    
    NSArray *dataControllers = [[NSArray alloc]initWithObjects:
                                self.postDataController,
                                self.commentDataController,
                                self.voteDataController,
                                self.collegeDataController,
                                self.tagDataController, nil];
    
#pragma mark - Create ViewControllers
    
    // *** Top Posts - PostsViewController *** //
    PostsViewController *topPostsController = [[PostsViewController alloc] initAsTopPostsWithDataControllers:dataControllers];
    [topPostsController setDelegate:self];
    UINavigationController *topPostsNavController = [[UINavigationController alloc] initWithRootViewController:topPostsController];
    // *************************************** //
    
    
    // *** New Posts - PostsViewController *** //
    PostsViewController *newPostsController = [[PostsViewController alloc] initAsNewPostsWithDataControllers:dataControllers];
    [newPostsController setDelegate:self];
    UINavigationController *newPostsNavController = [[UINavigationController alloc] initWithRootViewController:newPostsController];
    // *************************************** //
    
    
    // *** Trending Tags - TagViewController *** //
    TagViewController *tagController = [[TagViewController alloc] initWithDataControllers:dataControllers];
    [tagController setDelegate:self];
    UINavigationController *tagNavController = [[UINavigationController alloc] initWithRootViewController:tagController];
    tagController.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                          target:topPostsController
                                                          action:@selector(create)];
    // *************************************** //
    
    // *** Top Colleges - CollegeViewController *** //
    CollegeViewController *collegeController = [[CollegeViewController alloc] initWithDataControllers:dataControllers];
    [collegeController setDelegate:self];
    UINavigationController *collegeNavController =
            [[UINavigationController alloc] initWithRootViewController:collegeController];
    collegeController.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                          target:topPostsController
                                                          action:@selector(create)];
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

- (void)switchedToSpecificCollegeOrNil:(College *)college
{
    if (college == nil)
    {
        [self setAllColleges:YES];
        [self setSpecificCollege:NO];
    }
    else
    {
        [self setCurrentCollege:college];
        [self setAllColleges:NO];
        [self setSpecificCollege:YES];
    }
}
- (College*)getCurrentCollege
{
    return self.currentCollege;
}
- (BOOL)getIsAllColleges
{
    return self.allColleges;
}
- (BOOL)getIsSpecificCollege
{
    return self.specificCollege;
}
@end