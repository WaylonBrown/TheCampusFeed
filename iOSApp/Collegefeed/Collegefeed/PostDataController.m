//
//  PostDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostDataController.h"
#import "Post.h"

@interface PostDataController()

- (void) initializeDefaultList;

@end

static NSString* requestUrlString = @"http://cfeed.herokuapp.com/api/v1/";

@implementation PostDataController

#pragma mark Initialization 

- (id) init
{ // initialize this data controller
    if (self = [super init])
    {
        NSMutableArray *postList = [[NSMutableArray alloc] init];
        self.masterPostList = postList;
        [self fetchAllPosts];
        return self;
    }
    return nil;
}

- (void)initializeDefaultList
{ // initialize the post array with placeholder elements

    NSMutableArray *postList = [[NSMutableArray alloc] init];
    self.masterPostList = postList;
    for (int i = 0; i < 3; i++)
    {
        Post *post;
        post = [[Post alloc] initDummy];
        post.postID = i;
        [self addPost:post];
    }
}

- (void) setMasterPostList:(NSMutableArray *)newList
{ // override its default setter method to ensure new array remains mutable
    if (_masterPostList != newList)
    {
        _masterPostList = [newList mutableCopy];
    }
}

#pragma mark Data Access

- (NSUInteger)countOfList
{
    return [self.masterPostList count];
}

- (Post *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.masterPostList objectAtIndex:theIndex];
}

- (void)addPost:(Post *)post
{
    @try
    {
        [self.masterPostList addObject:post];
    }
    @catch(NSException* e)
    {
        // TODO: handle invalid post
        //          truncate? ignore?
    }
}

#pragma mark Network Access

- (void)fetchAllPosts
{ // access API to get list of colleges and populate master list
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", requestUrlString, @"posts"]];
    
    NSArray *allPosts = (NSArray*)[self getJsonObjectWithUrl:url];

    [self.masterPostList removeAllObjects];
    for (int i = 0; i < allPosts.count; i++)
    {
        // this post as a json object
        NSDictionary *jsonPost = (NSDictionary *) [allPosts objectAtIndex:i];
        NSLog(@"%@", jsonPost);
        // values to pass to Post constructor

        NSString *postID    = (NSString*)[jsonPost valueForKey:@"id"];
        NSString *score     = (NSString*)[jsonPost valueForKey:@"score"];
        if (score == (id)[NSNull null]) score = @"0";
        NSString *message   = (NSString*)[jsonPost valueForKey:@"text"];
        
        // create post and add to the masterPostList Array
        Post* newPost = [[Post alloc] initWithPostID:[postID integerValue]
                                           withScore:[score integerValue]
                                         withMessage:message];
        [self addPost:newPost];
    }
}

- (id)getJsonObjectWithUrl:(NSURL*) url
{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", requestUrlString, @"posts"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:30];
    
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response
                                                error:&error];
    
    if (error != nil)
    {
        [NSException raise:@"Error with while GETting posts"
                    format:@"Error with while GETting posts"];
    }
    
    return [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&error];
}


@end
