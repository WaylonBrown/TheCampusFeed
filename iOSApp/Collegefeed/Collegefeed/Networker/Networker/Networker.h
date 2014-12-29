//
//  Networker.h
//  Networker
//
//  Created by Patrick Sheehan on 6/15/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "../../Constants.h"

@interface Networker : NSObject

+ (NSData *)getIOSAppVersionFromServer;

// Images
+ (NSNumber *)POSTImage:(UIImage *)image fromFilePath:(NSString *)pathToOurFile;
+ (NSData *)GETImageData:(long)imageID;

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


// Tags
+ (NSData *)GetTrendingTagsAtPageNum:(long)pageNum;
+ (NSData *)GetTrendingTagsAtPageNum:(long)pageNum
                       WithCollegeId:(long)collegeId;

// Flags
+ (NSData *)POSTFlagPost:(long)postId;

// Votes
+ (NSData *)POSTVoteData:(NSData *)data WithPostId:(long)postId;
+ (NSData *)POSTVoteData:(NSData *)data WithCommentId:(long)commentId WithPostId:(long)postId;
+ (NSData *)GETVoteScoreWithPostId:(long)postId;
+ (NSData *)GETVoteScoreWithCommentId:(long)commentId;
+ (BOOL)DELETEVoteId:(long)voteId;

@end

