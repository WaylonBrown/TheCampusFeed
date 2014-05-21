//
//  CollegeDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CollegeDataController.h"
#import "College.h"
#import "Constants.h"

@implementation CollegeDataController


#pragma mark - Initialization

- (id)initWithNetwork:(BOOL)useNetwork
{
    if (self = [super init])
    {
        if (useNetwork)
        {
            [self setList:[[NSMutableArray alloc] init]];
            [self fetchWithUrl:collegesUrlAll
                      intoList:self.list];
        }
        else // dummy initialization
        {
            [self initializeDefaultList];
        }
        return self;
    }
    return nil;

}
- (id)initWithNetwork:(BOOL)useNetwork
              nearLat:(float)lat
              nearLon:(float)lon
{
    if (self = [super init])
    {
        if (useNetwork)
        {
            [self setList:[[NSMutableArray alloc] init]];
            [self fetchWithUrl:collegesUrlNearby(lat, lon)
                      intoList:self.list];
        }
        else // dummy initialization
        {
            [self initializeDefaultList];
        }
        return self;
    }
    return nil;
}
- (id) init
{ // initialize this data controller
    if (self = [super init])
    {   // dummy initialization
        {
            [self initializeDefaultList];
        }
        return self;
    }
    return nil;
}
- (void)initializeDefaultList
{ // initialize the college array with placeholder elements
    
    [self setList:[[NSMutableArray alloc] init]];
    
    for (int i = 0; i < 4; i++)
    {
        College *college;
        college = [[College alloc] initDummy];
        college.collegeID = i;
        [self addObjectToList:college];
    }
}

#pragma mark - Network Access

- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{   // call getJsonObjectWithUrl to access network,
    // then read JSON result into the provided array
    
    @try
    {
        NSArray *jsonCollegesArray = (NSArray*)[self getJsonObjectWithUrl:url];
        
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
            NSString *size      = (NSString*)[jsonCollege valueForKey:@"size"];
            
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
@end
