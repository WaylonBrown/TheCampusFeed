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
#define MAX_POST_LENGTH      140
#define MAX_COMMENT_LENGTH   140
#define MAX_TAG_LENGTH       50
#define MIN_POST_LENGTH      10
#define MIN_COMMENT_LENGTH   10
#define MIN_TAG_LENGTH       2
#define MILES_FOR_PERMISSION 15

// Custom colors
#define CF_LIGHTBLUE   0x33B5E5 // 51, 181, 229
#define CF_BLUE        0x0099CC
#define CF_LIGHTGRAY   0xE6E6E6
#define CF_GRAY        0x7C7C7C
#define CF_DARKGRAY    0x444444
#define CF_WHITE       0xFFFFFF

// Custom fonts
#define CF_FONT_LIGHT(s)    [UIFont fontWithName:@"Roboto-Light" size:s]
#define CF_FONT_ITALIC(s)   [UIFont fontWithName:@"Roboto-LightItalic" size:s]

//#define CF_FONT_MEDIUM(s)   [UIFont fontWithName:@"Omnes_Semibold" size:s]
#define CF_FONT_MEDIUM(s)   [UIFont fontWithName:@"mplus-2c-bold" size:s]

#define CF_FONT_BOLD(s)     [UIFont fontWithName:@"mplus-2c-bold" size:s]


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

+ (NSURL*)GETPostsWithTagName:(NSString*)tagName;
+ (NSURL*)GETPostsWithTagName:(NSString*)tagName
                withCollegeId:(long)collegeId;

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
