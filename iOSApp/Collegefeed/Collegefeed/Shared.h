//
//  Shared.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/27/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shared : NSObject

// Constant lengths
#define MAX_POST_LENGTH     140
#define MAX_COMMENT_LENGTH  140
#define MAX_TAG_LENGTH      50

#define MIN_POST_LENGTH     10
#define MIN_COMMENT_LENGTH  10
#define MIN_TAG_LENGTH      2

// Custom colors
#define cf_lightblue   0x33B5E5 // 51, 181, 229
#define cf_blue        0x0099CC
#define cf_lightgray   0xE6E6E6
#define cf_gray        0x7C7C7C
#define cf_darkgray    0x444444
#define cf_white       0xFFFFFF

// Title view for navigation bar
#define logoImage @"collegefeedlogosmall.png"
#define logoTitleView [[UIImageView alloc] initWithImage:[UIImage imageNamed:logoImage]]


+ (UIColor*)getCustomUIColor:(int)hexValue;

// Colleges
+ (NSURL*)GETAllColleges;

// Comments
+ (NSURL*)POSTCommentWithPostId:(long)postId;

+ (NSURL*)GETCommentsWithPostId:(long)postId;

// Posts
+ (NSURL*)POSTPostWithCollegeId:(long)collegeId;

+ (NSURL*)GETPostsWithTag:(NSString*)tagName;
+ (NSURL*)GETPostsWithCollegeId:(long)collegeId
                        withTag:(NSString*)tagName;

+ (NSURL*)GETAllPostsWithTag:(NSString*)tagName
              withPageNumber:(long)page
           withNumberPerPage:(long)perPage;

+ (NSURL*)GETAllPosts;
+ (NSURL*)GETPostsWithCollegeId:(long)collegeId;

+ (NSURL*)GETRecentPosts;
+ (NSURL*)GETRecentPostsWithCollegeId:(long)collegeId;

+ (NSURL*)GETTrendingPosts;
+ (NSURL*)GETTrendingPostsWithCollegeId:(long)collegeId;

// Tags
+ (NSURL*)GETTagsTrending;

// Votes
+ (NSURL*)POSTVoteWithPostId:(long)postId;
+ (NSURL*)GETVoteScoreWithPostId:(long)postId;

@end
