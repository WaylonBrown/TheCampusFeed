//
//  AppDelegate.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataController.h"

@class College;
@class PostsViewController;
@class TagViewController;
@class CollegePickerViewController;
@class UserContentViewController;
@class UserPostsViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, LocationFinderDelegateProtocol
    //AppDataDelegateProtocol,
    >

@property (strong, nonatomic) UIWindow              *window;
@property (strong, nonatomic) UITabBarController    *tabBarController;
//@property (strong, nonatomic) AppData               *appData;

@property (strong, nonatomic) DataController *dataController;

@property (strong, nonatomic) PostsViewController *topPostsController;
@property (strong, nonatomic) PostsViewController *recentPostsController;
@property (strong, nonatomic) TagViewController *tagController;
@property (strong, nonatomic) CollegePickerViewController *collegeController;
@property (strong, nonatomic) UserContentViewController *userContentController;
@property (strong, nonatomic) UserPostsViewController* userPostsController;

@end
