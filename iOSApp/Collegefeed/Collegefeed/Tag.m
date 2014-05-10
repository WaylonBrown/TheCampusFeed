//
//  Tag.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Tag.h"
#import "Constants.h"

@implementation Tag

- (id)initWithTagID:(NSInteger)tID withScore:(BOOL)tScore withName:(NSString*)tName
{
    self = [super init];
    if (self)
    {
        [self setTagID:tID];
        [self setScore:tScore];
        [self setName:tName];
        
        if ([tName characterAtIndex:0] != '#')
        {
            [self setName:[NSString stringWithFormat:@"#%@", tName]];
        }
        [self validateTag];
        return self;
    }
    return nil;
}
- (id)initDummy
{
    self = [super init];
    if (self)
    {
        [self setTagID:arc4random() % 999];
        [self setScore:arc4random() % 99];
        [self setName:@"#FlamingKittens"];
        [self validateTag];

        return self;
    }
    return nil;
}
//TODO: ensure tag starts with '#' and is of valid length
- (void)validateTag
{
    if ([self.name characterAtIndex:0] != '#')
    {
        [NSException raise:@"Invalid Tag" format:@"Tag \"%@\" must start with '#'", self.name];
    }
    if (self.name.length < MIN_TAG_LENGTH)
    {
        [NSException raise:@"Invalid Tag" format:@"Tag \"%@\" is too short", self.name];
    }
    if (self.name.length > MAX_TAG_LENGTH)
    {
        [NSException raise:@"Invalid Tag" format:@"Tag \"%@\" is too long", self.name];
    }
}
@end
