//
//  AppDelegate.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "PostDataController.h"
#import "CommentDataController.h"
#import "VoteDataController.h"
#import "CollegeDataController.h"
#import "TagDataController.h"
#import "MasterViewController.h"

@class College;

@interface AppDelegate : UIResponder <UIApplicationDelegate, MasterViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow                *window;
@property (strong, nonatomic) UITabBarController      *tabBarController;

@property (strong, nonatomic) PostDataController    *postDataController;
@property (strong, nonatomic) CommentDataController *commentDataController;
@property (strong, nonatomic) VoteDataController    *voteDataController;
@property (strong, nonatomic) CollegeDataController *collegeDataController;
@property (strong, nonatomic) TagDataController     *tagDataController;

@property (strong, nonatomic) College *currentCollege;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDegrees         lat;
@property (nonatomic) CLLocationDegrees         lon;

@property (nonatomic) BOOL allColleges;
@property (nonatomic) BOOL specificCollege;

- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (College*)getUsersCurrentCollege;
- (BOOL)getIsAllColleges;
- (BOOL)getIsSpecificCollege;

@end
