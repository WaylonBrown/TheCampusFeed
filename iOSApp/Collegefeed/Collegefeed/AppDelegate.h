//
//  AppDelegate.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "DataController.h"

@class College;
@class TopPostsViewController;
@class PostsViewController;
@class TagViewController;
@class CollegePickerViewController;
@class UserPostsViewController;
@class UserCommentsViewController;
@class TrendingCollegesViewController;
@class TutorialViewController;
@class CF_DialogViewController;
@class TimeCrunchViewController;
@class MenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow              *window;
@property (strong, nonatomic) UITabBarController    *tabBarController;

@property (strong, nonatomic) DataController *dataController;

@property (strong, nonatomic) MenuViewController *menuViewController;
@property (strong, nonatomic) TopPostsViewController *topPostsController;
@property (strong, nonatomic) PostsViewController *recentPostsController;
@property (strong, nonatomic) TagViewController *tagController;
@property (strong, nonatomic) CollegePickerViewController *collegeController;
@property (strong, nonatomic) UserPostsViewController* userPostsController;
@property (strong, nonatomic) UserCommentsViewController *userCommentsController;
@property (strong, nonatomic) TrendingCollegesViewController*trendingCollegesController;
@property (strong, nonatomic) TutorialViewController *tutorialController;
@property (strong, nonatomic) CF_DialogViewController *helpController;
@property (strong, nonatomic) TimeCrunchViewController *timeCrunchController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
