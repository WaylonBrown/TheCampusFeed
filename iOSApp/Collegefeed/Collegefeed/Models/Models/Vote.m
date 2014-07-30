//
//  Vote.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Vote.h"

@implementation Vote

- (id)initWithVoteId:(long)voteId
        WithParentId:(long)parentId
     WithUpvoteValue:(BOOL)isUpvote
       AsVotableType:(ModelType)type
{
    self = [super init];
    if (self)
    {
        [self setVoteID:voteId];
        [self setParentID:parentId];
        [self setUpvote:isUpvote];
        [self setVotableType:type];
        return self;
    }
    return nil;
}
- (id)initWithParentID:(NSInteger)ID
        withUpvoteValue:(BOOL)isUpvote
          asVotableType:(ModelType)type
{
    self = [super init];
    if (self)
    {
        [self setParentID:ID];
        [self setUpvote:isUpvote];
        [self setVotableType:type];
        [self setCollegeId:-1];
        return self;
    }
    return nil;
}
- (id)initFromJSON:(NSDictionary *)jsonObject
{   // Initialize this Vote using a JSON object as an NSDictionary
    self = [super init];
    if (self)
    {
        NSString *voteID    = (NSString*)[jsonObject valueForKey:@"id"];
        NSString *upvote    = [jsonObject valueForKey:@"upvote"];
        NSString *parentID  = (NSString*)[jsonObject valueForKey:@"votable_id"];
        NSString *type      = (NSString*)[jsonObject valueForKey:@"votable_type"];
        
        [self setVoteID:[voteID integerValue]];
        [self setParentID:[parentID integerValue]];
        [self setUpvote:([upvote isEqual:@(YES)] ? YES : NO)];
        [self setCollegeId:-1];

        if ([type isEqualToString:@"Post"])
        {
            [self setVotableType:POST];
        }
        else if ([type isEqualToString:@"Comment"])
        {
            
            [self setVotableType:COMMENT];
        }

        return self;
    }
    return nil;
}
- (NSData*)toJSON
{   // Returns an NSData representation of this Vote in JSON
    NSString *voteString;
    if (self.voteID == 0)
    {   // Not yet posted to network; use only simple JSON conversion
        
        voteString = [NSString stringWithFormat:
                      @"{\"upvote\":%@}",
                      self.upvote == YES ? @"true" : @"false"];
    }
    else
    {   // Converting a vote that has been accepted by network; use full conversion
        //      Being converted like this so it can be written to file
        voteString = [NSString stringWithFormat:
                      @"{\"id\":%ld,\"upvote\":%@,\"votable_id\":%ld,\"votable_type\":%@}",
                      self.voteID,
                      self.upvote == YES ? @"true" : @"false",
                      self.parentID,
                      self.votableType == POST ? @"Post" : @"Comment"];
    }
    
    NSData *voteData = [voteString dataUsingEncoding:NSASCIIStringEncoding
                                allowLossyConversion:YES];
    return voteData;
}
- (long)getID
{
    return self.voteID;
}
- (void)validate
{
    
}
- (ModelType)getType
{   // return POST or COMMENT
    return self.votableType;
}

@end
