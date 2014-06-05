//
//  AppData.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "AppData.h"

@implementation AppData

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setPostDataController:    [[PostDataController alloc]     init]];
        [self setCommentDataController: [[CommentDataController alloc]  init]];
        [self setVoteDataController:    [[VoteDataController alloc]     init]];
        [self setCollegeDataController: [[CollegeDataController alloc]  init]];
        [self setTagDataController:     [[TagDataController alloc]      init]];
        [self setCollegeFeedPicker:     [[CollegePickerViewController alloc]
                                         initAsAllCollegesWithAppData:self]];
        
        
        [self switchedToSpecificCollegeOrNil:nil];
        
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [self.locationManager setDelegate:self];
//        [self.locationManager setDistanceFilter:locationDistanceFilter];
//        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [self.locationManager startUpdatingLocation];
        return self;
    }
    return nil;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self setLat:self.locationManager.location.coordinate.latitude];
    [self setLon:self.locationManager.location.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];

    [self findNearbyColleges];
    [self.appDelegate foundLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.appDelegate didNotFindLocation];
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
- (void)findNearbyColleges
{   // Populate the nearbyColleges array appropriately using current location

    self.nearbyColleges = [[NSArray alloc] initWithArray:[self.collegeDataController
                                    findNearbyCollegesWithLat:self.lat withLon:self.lon]];

}
- (BOOL)isNearCollege
{
    return self.nearbyColleges.count > 0;
}
@end
