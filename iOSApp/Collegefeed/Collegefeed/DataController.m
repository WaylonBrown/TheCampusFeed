//
//  DataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "DataController.h"

@implementation DataController

- (NSUInteger)countOfList
{   // return the number of objects in this list
    return [self.list count];
}

#pragma mark Data Access

- (void)addObjectToList:(NSObject *)obj
{   // add object to local list
    [self.list addObject:obj];
}

- (NSObject *)objectInListAtIndex:(NSUInteger)theIndex
{   // return the object at theIndex
    return [self.list objectAtIndex:theIndex];
}

@end
