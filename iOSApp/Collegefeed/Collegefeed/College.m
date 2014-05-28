//
//  College.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/6/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "College.h"

@implementation College

- (id)initWithCollegeID:(NSInteger)cID withName:(NSString*)cName
{
    self = [super init];
    if (self)
    {
        [self setCollegeID:cID];
        [self setName:cName];
        
        [self validateCollege];
        return self;
    }
    return nil;
}
- (id)initWithCollegeID:(NSInteger)cID withName:(NSString*)cName
                withLat:(NSInteger)lat withLon:(NSInteger)lon
{
    self = [super init];
    if (self)
    {
        [self setCollegeID:cID];
        [self setName:cName];
        [self setLat:lat];
        [self setLon:lon];
        
        [self validateCollege];
        return self;
    }
    return nil;
}

- (id)initWithCollegeID:(NSInteger)cID withName:(NSString*)cName withShortName:(NSString*)cShortName
{
    self = [super init];
    if (self)
    {
        [self setCollegeID:cID];
        [self setName:cName];
        [self setShortName:cShortName];
        
        [self validateCollege];
        return self;
    }
    return nil;
}
- (void)validateCollege
{   //TODO: ensure college is valid here

//    if (false)
//    {
//        [NSException raise:@"Invalid College" format:@"College \"%@\" invalid", self.name];
//    }
}

@end
