//
//  Comment.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "Comment.h"
#import "Vote.h"

@implementation Comment

- (id)initWithMessage:(NSString *)message withPostId:(long)postId
{
    self = [super init];
    if (self)
    {
        [self setText:message];
        [self setPost_id:[NSNumber numberWithLong:postId]];
        return self;
    }
    return nil;
}

+ (NSArray *)getListFromJsonData:(NSData *)jsonData error:(NSError **)error;
{
    NSError *localError = nil;
    NSDictionary *list = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:0
                                                           error:&localError];
    
    if (localError != nil)
    {
        *error = localError;
        return nil;
    }
    
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in list)
    {
        Comment *comment = [[Comment alloc] init];
        
        for (NSString *key in dict)
        {
            if ([comment respondsToSelector:NSSelectorFromString(key)])
            {
                [comment setValue:[dict valueForKey:key] forKey:key];
            }
        }
        
        [objects addObject:comment];
    }
    
    return objects;
}
- (NSData*)toJSON
{   // Returns an NSData representation of this Comment in JSON
    NSString *commentString = [NSString stringWithFormat:@"{\"text\":\"%@\"}", self.text];
    NSData *commentData = [commentString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return commentData;
}
- (ModelType)getType
{
    return COMMENT;
}
+ (BOOL)withMessageIsValid:(NSString*)message
{
    return [super withMessageIsValid:message];
}

@end
