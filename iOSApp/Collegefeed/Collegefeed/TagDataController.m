//
//  TagDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TagDataController.h"
#import "Tag.h"

static NSString *requestUrlString = @"http://cfeed.herokuapp.com/api/";
static NSString *apiVersion = @"v1/";

@implementation TagDataController

#pragma mark Initialization

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

@end
