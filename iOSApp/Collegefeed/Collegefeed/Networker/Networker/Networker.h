//
//  Networker.h
//  Networker
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>

#define CONTENT_TYPE    @"application/json;charset=UTF-8"
#define API_URL         @"http://www.secretcamp.us/api"
//#define API_URL         @"http://cfeed.herokuapp.com/api"
#define API_VERSION     @"v1"
#define PAGINATION_NUM  25

@interface Networker : NSObject

+ (NSData *)getIOSAppVersionFromServer;

// Colleges
+ (NSData *)GETAllColleges;
+ (NSData *)GETCollegeWithId:(long)collegeId;
+ (NSData *)GETTrendingColleges;
+ (NSData *)GETTrendingCollegesAtPageNum:(long)pageNum;
+ (NSData *)GETCollegeListVersion;

// Comments
+ (NSData *)POSTCommentData:(NSData *)data WithPostId:(long)postId;

+ (NSData *)GETCommentsWithPostId:(long)postId;

+ (NSData *)GETCommentsWithIdArray:(NSArray *)Ids;

// Posts
+ (NSData *)POSTPostData:(NSData *)data WithCollegeId:(long)collegeId;

+ (NSData *)GETAllPostsWithTag:(NSString *)tagName
                     atPageNum:(long)pageNum;

+ (NSData *)GETPostsWithTagName:(NSString *)tagName
                  withCollegeId:(long)collegeId;

+ (NSData *)GETAllPosts;
+ (NSData *)GETPostsWithCollegeId:(long)collegeId;

+ (NSData *)GETRecentPostsAtPageNum:(long)pageNum;
+ (NSData *)GETRecentPostsWithCollegeId:(long)collegeId;

+ (NSData *)GETTrendingPostsAtPageNum:(long)pageNum;
+ (NSData *)GETTrendingPostsWithCollegeId:(long)collegeId;
+ (NSData *)GETPostsWithIdArray:(NSArray *)Ids;

// Flags
+ (NSData *)POSTFlagPost:(long)postId;

// Tags
+ (NSData *)GETTagsTrendingAtPageNum:(long)pageNum;
+ (NSData *)GETTagsWithCollegeId:(long)collegeId AtPageNum:(long)pageNum;

// Votes
+ (NSData *)POSTVoteData:(NSData *)data WithPostId:(long)postId;
+ (NSData *)POSTVoteData:(NSData *)data WithCommentId:(long)commentId WithPostId:(long)postId;
+ (NSData *)GETVoteScoreWithPostId:(long)postId;
+ (NSData *)GETVoteScoreWithCommentId:(long)commentId;
+ (BOOL)DELETEVoteId:(long)voteId;

@end

