//
//  CollegeDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CollegeDataController.h"
#import "College.h"
#import "Shared.h"

@implementation CollegeDataController


#pragma mark - Initialization

- (id)init
{
    if (self = [super init])
    {
//        [self getNetworkCollegeList];
        [self getHardCodedCollegeList];
        return self;
    }
    return nil;

}

#pragma mark - Network Access

- (void)getNetworkCollegeList
{
    [self fetchWithUrl:[Shared GETAllColleges]
              intoList:self.list];
}
- (void)getHardCodedCollegeList
{   // Populate the college list with a recent
    // list of colleges instead of accessing the network
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CollegeList" ofType:@"txt"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    if (myData == nil)
    {
        NSLog(@"Could not get hard-coded list in CollegeList.txt");
        return;
    }
    NSArray *jsonCollegesArray = [NSJSONSerialization JSONObjectWithData:myData
                                                                 options:0
                                                                   error:nil];
    
    [self.list removeAllObjects];
    for (int i = 0; i < jsonCollegesArray.count; i++)
    {
        // this college as a json object
        NSDictionary *jsonCollege = (NSDictionary *) [jsonCollegesArray objectAtIndex:i];
        
        // values to pass to College constructor
        NSString *collegeID = (NSString*)[jsonCollege valueForKey:@"id"];
        NSString *name      = (NSString*)[jsonCollege valueForKey:@"name"];
        NSString *lat       = (NSString*)[jsonCollege valueForKey:@"lat"];
        NSString *lon       = (NSString*)[jsonCollege valueForKey:@"lon"];
        //            NSString *size      = (NSString*)[jsonCollege valueForKey:@"size"];
        
        // create college and add to the provided array
        College* newCollege = [[College alloc] initWithCollegeID:[collegeID integerValue]
                                                        withName:name
                                                         withLat:[lat floatValue]
                                                         withLon:[lon floatValue]];
        
        [self.list addObject:newCollege];
    }
    
}
- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{   // Call GETfromServer to access network,
    // then read JSON result into the provided array
    
    @try
    {
        NSArray *jsonCollegesArray = (NSArray*)[self GETfromServer:url];
        
        [array removeAllObjects];
        for (int i = 0; i < jsonCollegesArray.count; i++)
        {
            // this college as a json object
            NSDictionary *jsonCollege = (NSDictionary *) [jsonCollegesArray objectAtIndex:i];
            
            // values to pass to College constructor
            NSString *collegeID = (NSString*)[jsonCollege valueForKey:@"id"];
            NSString *name      = (NSString*)[jsonCollege valueForKey:@"name"];
            NSString *lat       = (NSString*)[jsonCollege valueForKey:@"lat"];
            NSString *lon       = (NSString*)[jsonCollege valueForKey:@"lon"];
//            NSString *size      = (NSString*)[jsonCollege valueForKey:@"size"];
            
            // create college and add to the provided array
            College* newCollege = [[College alloc] initWithCollegeID:[collegeID integerValue]
                                                            withName:name
                                                             withLat:[lat floatValue]
                                                             withLon:[lon floatValue]];
            
            [array addObject:newCollege];
        }
    }
    @catch (NSException *exc)
    {
        NSLog(@"Error fetching all posts");
    }
}
- (NSArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon
{
    NSMutableArray *colleges = [[NSMutableArray alloc] init];
    
    double degreesForPermissions = MILES_FOR_PERMISSION / 50.0;	//roughly 50 miles per degree

    for (College *college in self.list)
    {
        //TODO: change to formula James is using that takes into account the roundness of the earth
        double degreesAway = sqrt(pow((userLat - college.lat), 2) + pow((userLon - college.lon), 2));
        
        if(degreesAway <= degreesForPermissions)
        {
            [colleges addObject:college];
        }
        
    }
    return colleges;
}
@end
