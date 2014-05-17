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
- (id)initDummy
{
    self = [super init];
    if (self)
    {
        [self setCollegeID:arc4random() % 999];
        [self setLat:arc4random() % 99];
        [self setLat:arc4random() % 99];
        
        switch (self.collegeID % 4)
        {
            case 0: [self setName:@"Texas A&M University"];
                    [self setShortName:@"TAMU"];
                    break;
            case 1: [self setName:@"University of Texas"];
                    [self setShortName:@"TU"];
                    break;
            case 2: [self setName:@"Louisiana State University"];
                    [self setShortName:@"LSU"];
                    break;
            default:[self setName:@"University of North Texas"];
                    [self setShortName:@"UNT"];
                    break;
        }
        
        
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
