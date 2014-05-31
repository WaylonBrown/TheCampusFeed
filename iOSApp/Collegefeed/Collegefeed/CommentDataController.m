//
//  CommentDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CommentDataController.h"
#import "Comment.h"
#import "Post.h"
#import "Shared.h"

@implementation CommentDataController

#pragma mark - Data Access

- (NSString *)getPostMessage
{   // return a string of the master post for these comments

    if (self.post != nil)
        return self.post.message;
    return @"[Post's message not found]";
}

#pragma mark - Network Access

- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array
{   // Call GETfromServer to access network,
    // then read JSON result into the provided array
    if (array == nil)
    {
        NSLog(@"nil array passed to fetchWithUrl");
        return;
    }
    @try
    {
        NSArray *jsonArray = (NSArray*)[self GETfromServer:url];
        
        [array removeAllObjects];
        for (int i = 0; i < jsonArray.count; i++)
        {
            // Individual JSON object
            NSDictionary *jsonComment = (NSDictionary *) [jsonArray objectAtIndex:i];
            Comment* newComment = [[Comment alloc] initFromJSON:jsonComment];
            [array addObject:newComment];
        }
    }
    @catch (NSException *exc)
    {
        NSLog(@"Error fetching all posts");
    }
}
@end
