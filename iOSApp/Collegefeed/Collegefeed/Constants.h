//
//  Constants.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//


// Testing

#define DELAY_FOR_SLOW_NETWORK 0
#define DEMONSTRATION_MODE YES

// Length Requirements

#define MIN_TAG_LENGTH      4
#define MAX_TAG_LENGTH      140
#define MIN_POST_LENGTH     10
#define MAX_POST_LENGTH     140
#define MIN_COMMENT_LENGTH  10
#define MAX_COMMENT_LENGTH  140

// Custom Colors

#define CF_EXTRALIGHTGRAY 0xE4E4E4
#define CF_LIGHTGRAY   0xE6E6E6
#define CF_GRAY        0x7C7C7C
#define CF_DARKGRAY    0x444444
#define CF_LIGHTBLUE   0x33B5E5 // 51, 181, 229
#define CF_BLUE        0x0099CC
#define CF_WHITE       0xFFFFFF

// TableCell Height Estimates

#define LARGE_CELL_LABEL_WIDTH        252.0f
#define LARGE_CELL_TOP_TO_LABEL       6.0f
#define LARGE_CELL_LABEL_TO_BOTTOM    61.0f
#define LARGE_CELL_MIN_LABEL_HEIGHT   53.0f

#define SMALL_CELL_LABEL_WIDTH        290.0f
#define SMALL_CELL_TOP_TO_LABEL       0
#define SMALL_CELL_LABEL_TO_BOTTOM    10.0f
#define SMALL_CELL_MIN_LABEL_HEIGHT   6.0f

#define TEXT_VIEW_LINE_HEIGHT 17
#define TABLE_HEADER_HEIGHT 25
#define TABLE_CELL_HEIGHT 44

// Custom Fonts

#define CF_FONT_LIGHT(s)    [UIFont fontWithName:@"Roboto-Light" size:s]
#define CF_FONT_ITALIC(s)   [UIFont fontWithName:@"Roboto-LightItalic" size:s]
//#define CF_FONT_MEDIUM(s)   [UIFont fontWithName:@"Omnes_Semibold" size:s]
#define CF_FONT_MEDIUM(s)   [UIFont fontWithName:@"mplus-2c-bold" size:s]
#define CF_FONT_BOLD(s)     [UIFont fontWithName:@"mplus-2c-bold" size:s]

// Network Information

#define WEBSITE_LINK    @"http://www.TheCampusFeed.com"
#define CONTENT_TYPE    @"application/json;charset=UTF-8"
#define API_URL         @"https://www.thecampusfeed.com/api"
#define API_VERSION     @"v1"
#define PAGINATION_NUM  25

// Title view for navigation bar
//#define logoImageWithButton @"thecampusfeedlogosmallwithmenubutton"
//#define logoImage @"thecampusfeedlogosmall.png"
#define logoImageWithButton @"TheCampusFeedLogo"
//#define logoTitleView [[UIImageView alloc] initWithImage:[UIImage imageNamed:logoImage]]

// Numerics

#define MILES_FOR_PERMISSION                15
#define PI_VALUE                            3.14159
#define EARTH_RADIUS_MILES                  3959
#define LOCATION_MANAGER_TIMEOUT            10
#define MINIMUM_POSTING_INTERVAL_MINUTES    5
#define MINIMUM_COMMENTING_INTERVAL_MINUTES 1

// File Names

#define USER_POST_IDS_FILE          @"UserPostIds.txt"
#define USER_COMMENT_IDS_FILE       @"UserCommentIds.txt"

// Core Data Storage

#define STATUS_ENTITY               @"Status"
#define KEY_COMMENT_TIME            @"lastCommentTime"
#define KEY_POST_TIME               @"lastPostTime"
#define KEY_IS_BANNED               @"isBanned"
#define KEY_COLLEGE_LIST_VERSION    @"listVersion"
#define KEY_LAUNCH_COUNT            @"launchCount"
#define KEY_CURRENT_COLLEGE_FEED    @"currentFeed"

#define POST_ENTITY             @"Post"
#define KEY_POST_ID             @"postId"

#define COMMENT_ENTITY          @"Comment"
#define KEY_COMMENT_ID          @"commentId"

#define COLLEGE_ENTITY          @"College"
#define KEY_COLLEGE_ID          @"collegeId"
#define KEY_LAT                 @"lat"
#define KEY_LON                 @"lon"
#define KEY_NAME                @"name"
#define KEY_SHORT_NAME          @"shortName"

#define VOTE_ENTITY             @"Vote"
#define KEY_PARENT_ID           @"parentId"
#define KEY_VOTE_ID             @"voteId"
#define KEY_TYPE                @"type"
#define KEY_UPVOTE              @"upvote"
#define KEY_UPVOTED_POSTS       @"UpvotedPosts"
#define KEY_UPVOTED_COMMENTS    @"UpvotedComments"
#define KEY_DOWNVOTED_POSTS     @"DownvotedPosts"
#define KEY_DOWNVOTED_COMMENTS  @"DownvotedComments"
#define VALUE_POST              @"Post"
#define VALUE_COMMENT           @"Comment"