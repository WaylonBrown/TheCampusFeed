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

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   // Set up ViewControllers and DataControllers

    // ***SIMULATE YOUR LOCATION***
    NSManagedObjectContext *context = [self managedObjectContext];

    self.dataController = [[DataController alloc] initWithManagedObjectContext:context];

    
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
    
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:topPostsNavController];
    [topPostsNavController.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.slidingViewController.underLeftViewController  = menuViewController;
    
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Vote" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Vote.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (void) deleteAllObjects
{
    NSArray *stores = [_persistentStoreCoordinator persistentStores];
    
    for(NSPersistentStore *store in stores)
    {
        [_persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end