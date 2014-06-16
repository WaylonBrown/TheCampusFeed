//
//  CollegeDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataController.h"

@class College;

@interface CollegeDataController : DataController

@property (nonatomic) NSURL *collegeURL;
@property (nonatomic) NSMutableData *responseData;

- (NSArray *)findNearbyCollegesWithLat:(float)userLat
                               withLon:(float)userLon;

- (void)getNetworkCollegeList;
- (void)getHardCodedCollegeList;
@end
