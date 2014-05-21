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

- (id)initWithTagID:(NSInteger)tID
          withScore:(BOOL)tScore
           withName:(NSString*)tName
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
        [self validate];
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
        
        switch (self.tagID % 3)
        {
            case 0: [self setName:@"#FlamingKittens"]; break;
            case 1: [self setName:@"#drankt"]; break;
            default: [self setName:@"#america"]; break;
        }
        
        [self validate];

        return self;
    }
    return nil;
}
- (id)initFromJSON:(NSDictionary *)jsonObject
{   // Initialize this Tag using a JSON object as an NSDictionary
    self = [super init];
    if (self)
    {
        NSString *tagID     = (NSString*)[jsonObject valueForKey:@"id"];
        NSString *text      = (NSString*)[jsonObject valueForKey:@"text"];
        NSString *postID    = (NSString*)[jsonObject valueForKey:@"post_id"];
        NSString *postCount = (NSString*)[jsonObject valueForKey:@"post_count"];
        
        if (postID == (id)[NSNull null]) postID = nil;
        if (postCount == (id)[NSNull null]) postCount = nil;

        
        [self setPostID:[postID integerValue]];
        [self setTagID:[tagID integerValue]];
        [self setName:text];
        [self setScore:[postCount integerValue]];
        
        [self validate];
        return self;
    }
    return nil;
}
- (void)validate
{
    if ([self.name characterAtIndex:0] != '#')
    {
        [self setName:[NSString stringWithFormat:@"#%@", self.name]];
    }
//    if (self.name.length < MIN_TAG_LENGTH)
//    {
//        [NSException raise:@"Invalid Tag" format:@"Tag \"%@\" is too short", self.name];
//    }
//    if (self.name.length > MAX_TAG_LENGTH)
//    {
//        [NSException raise:@"Invalid Tag" format:@"Tag \"%@\" is too long", self.name];
//    }
}
@end
