//
//  Constants.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//


// Testing

#define DELAY_FOR_SLOW_NETWORK 0.5
#define DEMONSTRATION_MODE YES

// Restrictions

#define MIN_TAG_LENGTH      4
#define MAX_TAG_LENGTH      140
#define MIN_POST_LENGTH     10
#define MAX_POST_LENGTH     140
#define MIN_COMMENT_LENGTH  10
#define MAX_COMMENT_LENGTH  140
#define MINIMUM_POSTING_INTERVAL_MINUTES    5
#define MINIMUM_COMMENTING_INTERVAL_MINUTES 1
#define MILES_FOR_PERMISSION                60
#define LOCATION_MANAGER_TIMEOUT            10

// Custom Colors

#define CF_EXTRALIGHTGRAY 0xE4E4E4
#define CF_LIGHTGRAY   0xE6E6E6
#define CF_GRAY        0x7C7C7C
#define CF_DARKGRAY    0x444444
#define CF_LIGHTBLUE   0x33B5E5 // 51, 181, 229
#define CF_BLUE        0x0099CC
#define CF_WHITE       0xFFFFFF

// TableCell Height Estimates
#define POST_CELL_PICTURE_HEIGHT_CROPPED     125
#define LARGE_CELL_TOP_TO_LABEL       11
#define LARGE_CELL_LABEL_TO_BOTTOM    31
#define LARGE_CELL_MIN_LABEL_HEIGHT   53

#define TABLE_VIEW_FOOTER_HEIGHT    100

#define MESSAGE_HEIGHT_TOP_CUSHION      10
#define DEFAULT_CELL_HEIGHT           100
#define LARGE_CELL_LABEL_WIDTH        252.0f

#define SMALL_CELL_LABEL_WIDTH        290.0f
#define SMALL_CELL_TOP_TO_LABEL       0
#define SMALL_CELL_LABEL_TO_BOTTOM    10.0f
#define SMALL_CELL_MIN_LABEL_HEIGHT   6.0f

#define TEXT_VIEW_LINE_HEIGHT 17
#define TABLE_HEADER_HEIGHT 25
#define TABLE_CELL_HEIGHT 50

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
#define logoImageWithButton @"TheCampusFeedLogo"

// Numerics

#define PI_VALUE                            3.14159
#define EARTH_RADIUS_MILES                  3959

// Core Data Storage

#define STATUS_ENTITY               @"Status"
#define KEY_COMMENT_TIME            @"lastCommentTime"
#define KEY_POST_TIME               @"lastPostTime"
#define KEY_IS_BANNED               @"isBanned"
#define KEY_COLLEGE_LIST_VERSION    @"listVersion"
#define KEY_LAUNCH_COUNT            @"launchCount"
#define KEY_CURRENT_COLLEGE_FEED    @"currentFeed"
#define KEY_NUM_HOURS               @"numTimeCrunchHours"
#define KEY_HAS_VIEWED_ACHIEVEMENTS @"hasViewedAchievements"
#define KEY_HOME_COLLEGE            @"homeCollegeId"

// Achievements
#define POST_COUNT_ACHIEVEMENT_ID 100
#define POST_POINTS_ACHIEVEMENT_ID 200
#define VIEW_ACHIEVEMENT_ID 300
#define SHORT_AND_SWEET_ACHIEVEMENT_ID 400
#define MANY_HOURS_ACHIEVEMENT_ID 500

#define ACHIEVEMENT_ID      @"AchievementId"
#define ACHIEVEMENT_ENTITY      @"Achievement"
#define KEY_AMOUNT_CURRENTLY    @"amountCurrently"
#define KEY_AMOUNT_REQUIRED     @"amountRequired"
#define KEY_HOURS_REWARD        @"hoursForReward"
#define KEY_HAS_ACHIEVED        @"hasAchieved"

#define VALUE_POST_ACHIEVEMENT      @"PostAchievement"
#define POST_COUNT_TO_HOURS_MULTIPLIER 10

#define VALUE_SCORE_ACHIEVEMENT     @"ScoreAchievement"
#define POST_POINTS_TO_HOURS_MULTIPLIER 10

#define VALUE_VIEW_ACHIEVEMENT   @"ViewAchievement"
#define VALUE_MANY_HOURS_ACHIEVEMENT   @"ManyHoursAchievement"

#define TYPE_SHORT_AND_SWEET_ACHIEVEMENT   @"ShortAndSweetAchievement"
#define WORDS_FOR_SHORT_AND_SWEET_ACHIEVEMENT 3
#define POINTS_FOR_SHORT_AND_SWEET_ACHIEVEMENT 100
#define HOURS_FOR_SHORT_AND_SWEET_ACHIEVEMENT 2000

#define HOURS_FOR_VIEW_ACHIEVEMENT 10

#define HOURS_FOR_EARN_MANY_HOURS_ACHIEVEMENT 2000
#define REQUIRED_NUMBER_OF_CRUNCH_HOURS_FOR_MANY_HOURS_ACHIEVEMENT 2000

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

#define TIME_CRUNCH_ENTITY      @"TimeCrunch"
#define KEY_HOURS_EARNED        @"hoursEarned"
#define KEY_TIME_ACTIVATED_AT   @"timeActivatedAt"

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

#define MIN_NUM_COLLEGES_IN_CORE_DATA_BEFORE_FETCH_FROM_NETWORK 25

// Time Crunch
#define TIME_CRUNCH_HOURS_FOR_POST 24
#define NUMBER_TIME_CRUNCHES_ALLOWED 1
