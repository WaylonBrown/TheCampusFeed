//
//  Networker.h
//  Networker
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>

#define CONTENT_TYPE    @"application/json;charset=UTF-8"
#define API_URL         @"https://www.thecampusfeed.com/api"
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
+ (NSData *)GetTopPostsAtPageNum:(long)pageNum;
+ (NSData *)GetTopPostsAtPageNum:(long)pageNum
                   WithCollegeId:(long)collegeId;

+ (NSData *)GetNewPostsAtPageNum:(long)pageNum;
+ (NSData *)GetNewPostsAtPageNum:(long)pageNum
                   WithCollegeId:(long)collegeId;

+ (NSData *)GetPostsWithTag:(NSString *)tagMessage
                  AtPageNum:(long)pageNum;
+ (NSData *)GetPostsWithTag:(NSString *)tagMessage
                  AtPageNum:(long)pageNum
              WithCollegeId:(long)collegeId;



+ (NSData *)POSTPostData:(NSData *)data WithCollegeId:(long)collegeId;

+ (NSData *)GETAllPosts;
+ (NSData *)GETPostsWithCollegeId:(long)collegeId;

+ (NSData *)GETPostsWithIdArray:(NSArray *)Ids;
+ (NSData *)GETPostWithId:(long)postId;

// Flags
+ (NSData *)POSTFlagPost:(long)postId;

// Tags
+ (NSData *)GetTagsForAllCollegesAtPageNum:(long)pageNum;
+ (NSData *)GETTagsWithCollegeId:(long)collegeId AtPageNum:(long)pageNum;

// Votes
+ (NSData *)POSTVoteData:(NSData *)data WithPostId:(long)postId;
+ (NSData *)POSTVoteData:(NSData *)data WithCommentId:(long)commentId WithPostId:(long)postId;
+ (NSData *)GETVoteScoreWithPostId:(long)postId;
+ (NSData *)GETVoteScoreWithCommentId:(long)commentId;
+ (BOOL)DELETEVoteId:(long)voteId;

@end

