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

- (id) init
{ // initialize this data controller
    if (self = [super init])
    {
        [self fetchWithUrl:[Shared GETTagsTrending]
                  intoList:self.list];

        return self;
    }
    return nil;
}

#pragma mark - Network Access

- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{   // Call GETfromServer to access network,
    // then read JSON result into the provided array
    if (array == nil)
    {
        NSLog(@"nil array passed to fetchWithUrl");
        return;
    }
    @try
    {
        NSArray *jsonArray = (NSArray*)[self GETfromServer:url];
        
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
- (void)fetchAllTags
{   // fetch tags trending across all colleges
    [self setAllTags:[[NSMutableArray alloc] init]];
    
    [self fetchWithUrl:[Shared GETTagsTrending]
              intoList:self.allTags];
    
    [self setList:self.allTags];
}
- (void)fetchAllTagsWithCollegeId:(long)collegeId
{   // fetch tags trending in a particular college
    [self setAllTagsInCollege:[[NSMutableArray alloc] init]];
    
    //TODO: need a url to get all trending tags for a school, but waiting on a server endpoint
    [self fetchWithUrl:[Shared GETTagsTrending]
              intoList:self.allTagsInCollege];
    
    [self setList:self.allTagsInCollege];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:@"Cannot currently fetch tags for specific college. Showing all tags instead"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

@end
