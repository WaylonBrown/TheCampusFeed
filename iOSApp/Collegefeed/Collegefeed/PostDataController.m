//
//  PostDataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostDataController.h"
#import "Post.h"

static NSString *requestUrlString = @"http://cfeed.herokuapp.com/api/";
static NSString *apiVersion = @"v1/";

// set to NO to use dummy initialization
static BOOL useNetwork = NO;

@implementation PostDataController

#pragma mark Initialization 

- (id) init
{ // initialize this data controller
    if (self = [super init])
    {
        if (useNetwork)
        {
            [self setMasterPostList:[[NSMutableArray alloc] init]];
            self.postURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",
                                                 requestUrlString, apiVersion, @"posts"]];
            [self fetchAllPosts];
        }
        else // dummy initialization
        {
            [self initializeDefaultList];
        }
        return self;
    }
    return nil;
}
- (void)initializeDefaultList
{ // initialize the post array with placeholder elements

    [self setMasterPostList:[[NSMutableArray alloc] init]];

    for (int i = 0; i < 3; i++)
    {
        Post *post;
        post = [[Post alloc] initDummy];
        post.postID = i;
        [self addPost:post];
    }
}
- (void)setMasterPostList:(NSMutableArray *)newList
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
{   // add post locally to the masterPostList array
    [self.masterPostList addObject:post];
//    [self addPostToServer:post];
}

#pragma mark Network Access (NEEDS WORK)

- (void)fetchAllPosts
{   // call getJsonObjectWithUrl to access network,
    // then read JSON result into list of posts
    
    @try{
        NSArray *allPosts = (NSArray*)[self getJsonObjectWithUrl:self.postURL];
        
        NSLog(@"%@", allPosts);
        
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
                                         withPostMessage:message];
            [self addPost:newPost];
        }
    }
    @catch (NSException *exc)
    {
        NSLog(@"Error fetching all posts");
    }
}
- (id)getJsonObjectWithUrl:(NSURL *)url
{ // used to GET posts
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:30];
    
    // Fetch the JSON response
    NSData *urlData;
    NSHTTPURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response
                                                error:&error];
    
    NSInteger code = [response statusCode];
    if (code != 200 || error != nil)
    {
        NSString *excReason = [NSString stringWithFormat:@"Error accessing %@", url];
        NSException *exc = [NSException exceptionWithName:@"NetworkRequestError"
                                                   reason:excReason
                                                 userInfo:nil];
        @throw exc;
    }
    
    return [NSJSONSerialization JSONObjectWithData:urlData
                                           options:0
                                             error:&error];
}

- (void)addPostToServer:(Post *)post
{   // Serialize new post into JSON and send as POST request to url
    @try
    {
        // Create the request.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.postURL];

        // Convert post to data for HTTPBody
//        NSString *stringData = [NSString stringWithFormat:@"text=%@", post.message];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     post.postMessage, @"text",
                                     nil];
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
        
        // Set header field
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        // Specify that it will be a POST request
        [request setHTTPMethod:@"POST"];
//        [request setHTTPBody:[NSData dataWithBytes:[stringData UTF8String] length:strlen([stringData UTF8String])]];
        [request setHTTPBody:postData];
        
        NSLog(@"%@", request);
        
        // Create url connection and fire request
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                      delegate:self];


        if (!connection)
        {
            NSLog(@"POST was unsuccessful");
        }
        else
        {
            [self addPost:post];
        }
        
    }
    @catch(NSException* e)
    {
        // TODO: handle invalid post
        //          truncate? ignore?
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // should be called when connection received response
    self.responseData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];

}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"response data - %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);

}

@end
