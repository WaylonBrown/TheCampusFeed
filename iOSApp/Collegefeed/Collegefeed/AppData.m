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
        [self setDataController:    [[DataController alloc] init]];
        
        [self setCollegeFeedPicker: [[CollegePickerViewController alloc]
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
    [self setCurrentCollege:college];

    if (college == nil)
    {
        [self setAllColleges:YES];
        [self setSpecificCollege:NO];
    }
    else
    {
        [self setAllColleges:NO];
        [self setSpecificCollege:YES];
    }
}
- (void)findNearbyColleges
{   // Populate the nearbyColleges array appropriately using current location

    self.nearbyColleges = [[NSArray alloc] initWithArray:[self.dataController
                                    findNearbyCollegesWithLat:self.lat withLon:self.lon]];

}
- (BOOL)isNearCollege
{
    return self.nearbyColleges.count > 0;
}
@end
