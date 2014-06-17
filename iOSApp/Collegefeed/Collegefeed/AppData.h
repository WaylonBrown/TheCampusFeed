//
//  AppData.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#import "DataController.h"
#import "CollegePickerViewController.h"


@protocol AppDataDelegateProtocol;

@interface AppData : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) id<AppDataDelegateProtocol> appDelegate;

@property (strong, nonatomic) Post *postInFocus;
@property (strong, nonatomic) DataController *dataController;

@property (strong, nonatomic) CollegePickerViewController *collegeFeedPicker;

@property (strong, nonatomic) NSArray *nearbyColleges;
@property (strong, nonatomic) College *currentCollege;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDegrees         lat;
@property (nonatomic) CLLocationDegrees         lon;

@property (nonatomic) BOOL allColleges;
@property (nonatomic) BOOL specificCollege;


- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (BOOL)isNearCollege;

@end

@protocol AppDataDelegateProtocol <NSObject>

- (void)foundLocation;
- (void)didNotFindLocation;

@end
