//
//  Tag.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Tag.h"

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
        NSString *postCount = (NSString*)[jsonObject valueForKey:@"posts_count"];
        
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
- (NSData *)toJSON
{   // Returns an NSData representation of this Tag in JSON
    NSString *tagString = [NSString stringWithFormat:@"{\"id\":%lu, \"text\":\"%@\"}",
                           self.tagID, self.name];
    NSData *tagData = [tagString dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
    return tagData;
}
- (long)getID
{
    return self.tagID;
}
- (void)validate
{
    if ([self.name characterAtIndex:0] != '#')
    {
        self.name = [NSString stringWithFormat:@"#%@", self.name];
    }
}
- (ModelType)getType
{
    return TAG;
}
+ (BOOL)withMessageIsValid:(NSString*)tagMessage
{
    if (tagMessage.length < MIN_TAG_LENGTH
        || tagMessage.length > MAX_TAG_LENGTH
        || [tagMessage characterAtIndex:0] != '#')
    {
        return false;
    }
    
    NSString *messageWithoutHash = [tagMessage substringFromIndex:1];
    NSCharacterSet *specials = [NSCharacterSet characterSetWithCharactersInString:@"!@$%^#&*+,."];

    if ([messageWithoutHash rangeOfCharacterFromSet:specials].location != NSNotFound)
    {
        return false;
    }
    return true;
}

@end
