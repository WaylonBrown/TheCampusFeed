//
//  Comment.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Comment.h"
#import "Post.h"
#import "Vote.h"

@implementation Comment

+ (NSArray *)getListFromJsonData:(NSData *)jsonData error:(NSError **)error;
{
//    {
//        "id": 7,
//        "text": "another test",
//        "score": null,
//        "created_at": "2014-10-20T00:28:33.000Z",
//        "updated_at": "2014-10-20T00:28:33.000Z",
//        "post_id": "2",
//        "hidden": true,
//        "vote_delta": 0
//    }
    
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

@end
