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

@end
