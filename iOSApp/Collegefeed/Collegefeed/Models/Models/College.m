//
//  College.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/6/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
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

#pragma mark - CFModelProtocol Methods

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
- (id)initFromNetworkData:(NSData *)data
{
    NSDictionary *jsonObject = (NSDictionary *)(NSArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                                          options:0
                                                                                            error:nil];
    return [self initFromJSON:jsonObject];
}

+ (NSArray *)getListFromJsonData:(NSData *)jsonData error:(NSError **)error;
{
    NSError *localError = nil;
    NSDictionary *collegeList = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:0
                                                                  error:&localError];
    
    if (localError != nil)
    {
        *error = localError;
        return nil;
    }
    
    
    NSMutableArray *colleges = [[NSMutableArray alloc] init];
    
    for (NSDictionary *collegeDict in collegeList)
    {
        College *college = [[College alloc] initFromJSON:collegeDict];
        [colleges addObject:college];
    }
    
    return colleges;
}
- (NSData*)toJSON
{
    return nil;
}
- (NSNumber *)getID
{
    return [NSNumber numberWithLong:self.collegeID];
}
- (ModelType)getType
{
    return COLLEGE;
}

@end
