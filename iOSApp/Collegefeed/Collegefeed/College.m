//
//  College.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/6/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "College.h"

@implementation College

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
        [self setName:@"Texas A&M University"];
        [self setShortName:@"TAMU"];
        
        [self validateCollege];
        return self;
    }
    return nil;
}
//TODO: ensure college is valid here
- (void)validateCollege
{
//    if (false)
//    {
//        [NSException raise:@"Invalid College" format:@"College \"%@\" invalid", self.name];
//    }
}

@end
