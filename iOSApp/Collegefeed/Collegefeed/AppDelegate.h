//
//  AppDelegate.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppData.h"
#import "AppDataDelegateProtocol.h"

@class College;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow              *window;
@property (strong, nonatomic) UITabBarController    *tabBarController;
@property (strong, nonatomic) AppData               *appData;

@end
