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
    Post *post1, *post2, *post3;
    post1 = [[Post alloc] initWithContent:@"Gig 'em Aggies! Whoop!!"];
    post2 = [[Post alloc] initWithContent:@"Hullabaloo, Caneck, Caneck!"];
    post3 = [[Post alloc] initWithContent:@"Ay Whoop!"];
    [self addPostWithContent:post1];
    [self addPostWithContent:post2];
    [self addPostWithContent:post3];
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

- (void)addPostWithContent:(Post *)post
{
    [self.masterPostList addObject:post];
}


@end
