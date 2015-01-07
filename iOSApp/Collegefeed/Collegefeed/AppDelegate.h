//
//  AppDelegate.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "DataController.h"

@class CFNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CFNavigationController *navController;

@end
