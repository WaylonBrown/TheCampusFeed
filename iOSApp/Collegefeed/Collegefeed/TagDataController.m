//
//  TagDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TagDataController.h"
#import "Tag.h"
#import "Shared.h"

@implementation TagDataController

#pragma mark Initialization

- (id) initWithNetwork
{ // initialize this data controller
    if (self = [super initWithNetwork])
    {
        [self fetchWithUrl:[Shared GETTagsTrending]
                  intoList:self.list];

        return self;
    }
    return nil;
}

#pragma mark - Network Access

- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{   // Call getJsonObjectWithUrl to access network,
    // then read JSON result into the provided array
    if (array == nil)
    {
        NSLog(@"nil array passed to fetchWithUrl");
        return;
    }
    @try
    {
        NSArray *jsonArray = (NSArray*)[self getJsonObjectWithUrl:url];
        
        [array removeAllObjects];
        for (int i = 0; i < jsonArray.count; i++)
        {
            // Individual JSON object
            NSDictionary *jsonTag = (NSDictionary *) [jsonArray objectAtIndex:i];
            Tag* newTag = [[Tag alloc] initFromJSON:jsonTag];
            [array addObject:newTag];
        }
    }
    @catch (NSException *exc)
    {
        NSLog(@"Error fetching all posts");
    }
}

@end
