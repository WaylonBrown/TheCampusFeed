//
//  CollegeDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CollegeDataController.h"
#import "College.h"

@implementation CollegeDataController


#pragma mark - Initialization

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

- (void)fetchAllWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{   // call getJsonObjectWithUrl to access network,
    // then read JSON result into the provided array
    
    @try
    {
        NSArray *jsonCollegesArray = (NSArray*)[self getJsonObjectWithUrl:url];
        
        NSLog(@"%@", jsonCollegesArray);
        
        [array removeAllObjects];
        for (int i = 0; i < jsonCollegesArray.count; i++)
        {
            // this post as a json object
            NSDictionary *jsonComment = (NSDictionary *) [jsonCollegesArray objectAtIndex:i];
            NSLog(@"%@", jsonComment);
            
            // values to pass to College constructor
            NSString *collegeID = (NSString*)[jsonComment valueForKey:@"id"];
            NSString *name      = (NSString*)[jsonComment valueForKey:@"name"];
            NSString *lat       = (NSString*)[jsonComment valueForKey:@"lat"];
            NSString *lon       = (NSString*)[jsonComment valueForKey:@"lon"];
            NSString *size      = (NSString*)[jsonComment valueForKey:@"size"];

            
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
