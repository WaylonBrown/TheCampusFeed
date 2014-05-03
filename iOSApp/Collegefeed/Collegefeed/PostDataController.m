//
//  PostDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostDataController.h"
#import "Post.h"

// class extension to add a private method
@interface PostDataController()

-(void) initializeDefaultList;

@end


@implementation PostDataController

// initialize this data controller
-(id) init
{
    if (self = [super init])
    {
        [self initializeDefaultList];
        return self;
    }
    return nil;
}

// initialize the post array with a placeholder element
- (void)initializeDefaultList
{
    NSMutableArray *postList = [[NSMutableArray alloc] init];
    self.masterPostList = postList;
    for (int i = 0; i < 14; i++)
    {
        Post *post;
        post = [[Post alloc] initDummy];
        [self addPostWithMessage:post];
    }
}

// override its default setter method to ensure new array remains mutable
- (void) setMasterPostList:(NSMutableArray *)newList
{
    if (_masterPostList != newList)
    {
        _masterPostList = [newList mutableCopy];
    }
}

- (NSUInteger) countOfList
{
    return [self.masterPostList count];
}

- (Post *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterPostList objectAtIndex:theIndex];
}

- (void)addPostWithMessage:(Post *)post
{
    [self.masterPostList addObject:post];
}


@end
