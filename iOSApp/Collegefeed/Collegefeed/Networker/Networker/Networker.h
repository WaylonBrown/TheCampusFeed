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
#define PAGINATION_NUM  25

@interface Networker : NSObject

// Colleges
+ (NSData *)GETAllColleges;
+ (NSData *)GETCollegeWithId:(long)collegeId;

// Comments
+ (NSData *)POSTCommentData:(NSData *)data WithPostId:(long)postId;

+ (NSData *)GETCommentsWithPostId:(long)postId;

+ (NSData *)GETCommentsWithIdArray:(NSArray *)Ids;

// Posts
+ (NSData *)POSTPostData:(NSData *)data WithCollegeId:(long)collegeId;

//+ (NSData *)GETPostsWithTagName:(NSString *)tagName;
+ (NSData *)GETAllPostsWithTag:(NSString *)tagName
                     atPageNum:(long)pageNum;  // PAGINATION IN PROGRESS

+ (NSData *)GETPostsWithTagName:(NSString *)tagName
                  withCollegeId:(long)collegeId;

+ (NSData *)GETAllPosts;
+ (NSData *)GETPostsWithCollegeId:(long)collegeId;

+ (NSData *)GETRecentPostsAtPageNum:(long)pageNum; // PAGINATION DONE
+ (NSData *)GETRecentPostsWithCollegeId:(long)collegeId;

+ (NSData *)GETTrendingPostsAtPageNum:(long)pageNum; // PAGINATION DONE
+ (NSData *)GETTrendingPostsWithCollegeId:(long)collegeId;
+ (NSData *)GETPostsWithIdArray:(NSArray *)Ids;

// Flags
+ (NSData *)POSTFlagPost:(long)postId;

// Tags
+ (NSData *)GETTagsTrending;

// Votes
+ (NSData *)POSTVoteData:(NSData *)data WithPostId:(long)postId;
+ (NSData *)POSTVoteData:(NSData *)data WithCommentId:(long)commentId;
+ (NSData *)GETVoteScoreWithPostId:(long)postId;
+ (NSData *)GETVoteScoreWithCommentId:(long)commentId;

@end

