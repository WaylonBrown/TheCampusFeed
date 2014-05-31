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
        [self fetchWithUrl:[Shared GETAllColleges]
                  intoList:self.list];
        
        return self;
    }
    return nil;

}

#pragma mark - Network Access

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
@end
