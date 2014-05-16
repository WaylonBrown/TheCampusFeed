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
    
    [self setMasterTagList:[[NSMutableArray alloc] init]];
    
    for (int i = 0; i < 4; i++)
    {
        Tag *tag;
        tag = [[Tag alloc] initDummy];
        tag.tagID = i;
        [self addTag:tag];
    }
}
- (void)setMasterTagList:(NSMutableArray *)newList
{ // override its default setter method to ensure new array remains mutable
    if (_masterTagList != newList)
    {
        _masterTagList = [newList mutableCopy];
    }
}

#pragma mark Data Access

- (NSUInteger)countOfList
{
    return [self.masterTagList count];
}
- (Tag *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterTagList objectAtIndex:theIndex];
}
- (void)addTag:(Tag *)tag
{   // add tag locally to the masterTagList array
    [self.masterTagList addObject:tag];
}

@end
