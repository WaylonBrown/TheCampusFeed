//
//  TagDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TagDataController.h"
#import "Tag.h"
#import "Constants.h"

@implementation TagDataController

#pragma mark Initialization

- (id) initWithNetwork:(BOOL)useNetwork
{ // initialize this data controller
    if (self = [super init])
    {
        if (useNetwork)
        {
            [self setList:[[NSMutableArray alloc] init]];
            [self fetchWithUrl:tagsUrl
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
- (void)initializeDefaultList
{ // initialize the tag array with placeholder elements
    
    [self setList:[[NSMutableArray alloc] init]];
    
    for (int i = 0; i < 4; i++)
    {
        Tag *tag;
        tag = [[Tag alloc] initDummy];
        tag.tagID = i;
        [self addObjectToList:tag];
    }
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
