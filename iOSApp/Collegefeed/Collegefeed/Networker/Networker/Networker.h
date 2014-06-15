//
//  Networker.h
//  Networker
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>

#define CONTENT_TYPE    @"application/json;charset=UTF-8"
#define API_URL         @"http://cfeed.herokuapp.com/api"
#define API_VERSION     @"v1"

@interface Networker : NSObject

// Colleges
+ (NSData *)GETAllColleges;

// Comments
+ (NSData *)POSTCommentData:(NSData *)data WithPostId:(long)postId;

+ (NSData *)GETCommentsWithPostId:(long)postId;

// Posts
+ (NSData *)POSTPostData:(NSData *)data WithCollegeId:(long)collegeId;

+ (NSData *)GETPostsWithTagName:(NSString *)tagName;
+ (NSData *)GETPostsWithTagName:(NSString *)tagName
                  withCollegeId:(long)collegeId;

+ (NSData *)GETAllPostsWithTag:(NSString *)tagName
                withPageNumber:(long)page
             withNumberPerPage:(long)perPage;

+ (NSData *)GETAllPosts;
+ (NSData *)GETPostsWithCollegeId:(long)collegeId;

+ (NSData *)GETRecentPosts;
+ (NSData *)GETRecentPostsWithCollegeId:(long)collegeId;

+ (NSData *)GETTrendingPosts;
+ (NSData *)GETTrendingPostsWithCollegeId:(long)collegeId;

// Tags
+ (NSData *)GETTagsTrending;

// Votes
+ (NSData *)POSTVoteData:(NSData *)data WithPostId:(long)postId;
+ (NSData *)GETVoteScoreWithPostId:(long)postId;

@end

