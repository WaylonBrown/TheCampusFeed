//
//  College.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/6/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "College.h"

@implementation College

#pragma mark - Initializations

- (id)initWithCollegeID:(long)cID withName:(NSString*)cName
{
    self = [super init];
    if (self)
    {
        [self setCollegeID:cID];
        [self setName:cName];
        return self;
    }
    return nil;
}
- (id)initWithCollegeID:(long)cID withName:(NSString*)cName
                withLat:(float)lat withLon:(float)lon
{
    self = [super init];
    if (self)
    {
        [self setCollegeID:cID];
        [self setName:cName];
        [self setLat:lat];
        [self setLon:lon];
        return self;
    }
    return nil;
}

- (id)initWithCollegeID:(long)cID withName:(NSString*)cName withShortName:(NSString*)cShortName
{
    self = [super init];
    if (self)
    {
        [self setCollegeID:cID];
        [self setName:cName];
        [self setShortName:cShortName];
        return self;
    }
    return nil;
}

#pragma mark - Model Interface Methods

- (id)initFromJSON:(NSDictionary *)jsonObject
{
    // values to pass to College constructor
    NSString *collegeID = (NSString*)[jsonObject valueForKey:@"id"];
    NSString *name      = (NSString*)[jsonObject valueForKey:@"name"];
    NSString *lat       = (NSString*)[jsonObject valueForKey:@"lat"];
    NSString *lon       = (NSString*)[jsonObject valueForKey:@"lon"];
    //            NSString *size      = (NSString*)[jsonCollege valueForKey:@"size"];
    
    return [self initWithCollegeID:[collegeID integerValue]
                          withName:name
                           withLat:[lat floatValue]
                           withLon:[lon floatValue]];
    
}
- (NSData*)toJSON
{
    return nil;
}
- (long)getID
{
    return self.collegeID;
}
- (void)validate
{
    
}
@end
