//
//  PostDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

// forward declaration (tell compiler a Post class does exist)
@class Post;

@interface PostDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterPostList;
@property (nonatomic) NSURL *postURL;
@property (nonatomic) NSMutableData *responseData;

- (NSUInteger)countOfList;
- (Post *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addPost:(Post *)post;


//- (void)addPostToServer:(Post *)post;
- (void)fetchAllPosts;
- (id)getJsonObjectWithUrl:(NSURL*) url;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
