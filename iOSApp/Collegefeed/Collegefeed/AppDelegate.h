//
//  AppDelegate.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppData.h"

@class College;
@class PostsViewController;
@class TagViewController;
@class CollegePickerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, AppDataDelegateProtocol>

@property (strong, nonatomic) UIWindow              *window;
@property (strong, nonatomic) UITabBarController    *tabBarController;
@property (strong, nonatomic) AppData               *appData;

@property (strong, nonatomic) PostsViewController *topPostsController;
@property (strong, nonatomic) PostsViewController *recentPostsController;
@property (strong, nonatomic) TagViewController *tagController;
@property (strong, nonatomic) CollegePickerViewController *collegeController;

@end
