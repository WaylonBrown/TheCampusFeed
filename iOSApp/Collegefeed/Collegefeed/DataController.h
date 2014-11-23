//
//  DataController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Comment;
@class College;
@class Post;
@class Tag;
@class Vote;
@class ToastController;

#define MILES_FOR_PERMISSION                15
#define PI_VALUE                            3.14159
#define EARTH_RADIUS_MILES                  3959
#define LOCATION_MANAGER_TIMEOUT            10
#define MINIMUM_POSTING_INTERVAL_MINUTES    5
#define MINIMUM_COMMENTING_INTERVAL_MINUTES 1


#define USER_POST_IDS_FILE          @"UserPostIds.txt"
#define USER_COMMENT_IDS_FILE       @"UserCommentIds.txt"

#define STATUS_ENTITY           @"Status"
#define KEY_COMMENT_TIME        @"lastCommentTime"
#define KEY_POST_TIME           @"lastPostTime"
#define KEY_IS_BANNED           @"isBanned"
#define KEY_COLLEGE_LIST_VERSION    @"listVersion"
#define KEY_LAUNCH_COUNT        @"launchCount"
#define KEY_CURRENT_COLLEGE_FEED @"currentFeed"

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

#pragma mark - Protocol Definitions
/********************************/
/***** PROTOCOL DEFINITIONS *****/
/********************************/

typedef NS_ENUM(NSInteger, LocationStatus)
{
    LOCATION_FOUND,
    LOCATION_SEARCHING,
    LOCATION_NOT_FOUND
};

//@interface NSMutableArray (Utilities)
//- (void)insertObjectsWithUniqueIds:(NSArray *)arr;
//@end

@interface DataController : NSObject<CLLocationManagerDelegate>


#pragma mark - Member Variables
/****************************/
/***** MEMBER VARIABLES *****/
/****************************/
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) ToastController *toaster;

// Status Information
@property (strong, nonatomic) College   *collegeInFocus;
@property (strong, nonatomic) Post      *postInFocus;
@property (strong, nonatomic) Tag       *tagInFocus;
@property (nonatomic) BOOL              showingAllColleges;
@property (nonatomic) BOOL              showingSingleCollege;
@property (nonatomic) long              collegeListVersion;
@property (strong, nonatomic) NSDate    *locationSearchStart;
@property (nonatomic) BOOL              isFirstLaunch;
@property (nonatomic) BOOL              needsUpdate;
@property (nonatomic) NSInteger         launchCount;

// Location Information
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDegrees         lat;
@property (nonatomic) CLLocationDegrees         lon;
@property LocationStatus                        locStatus;
@property (nonatomic) NSInteger     locationUpdateAttempts;

// College Arrays
@property (strong, nonatomic) NSMutableArray *collegeList;
@property (strong, nonatomic) NSMutableArray *nearbyColleges;
@property (strong, nonatomic) NSMutableArray *trendingColleges;

// Comment Array
@property (nonatomic, strong) NSMutableArray *commentList;
@property (nonatomic, strong) NSMutableArray *userComments;

// Post Arrays
@property (nonatomic, strong) NSMutableArray *topPostsAllColleges;
@property (nonatomic, strong) NSMutableArray *recentPostsAllColleges;
@property (nonatomic, strong) NSMutableArray *userPosts;
@property (nonatomic, strong) NSMutableArray *allPostsWithTag;

@property (nonatomic, strong) NSMutableArray *topPostsInCollege;
@property (nonatomic, strong) NSMutableArray *recentPostsInCollege;
@property (nonatomic, strong) NSMutableArray *allPostsWithTagInCollege;

// Tag Arrays
@property (nonatomic, strong) NSMutableArray *tagListForAllColleges;
@property (nonatomic, strong) NSMutableArray *tagListForCollege;

// Vote Arrays
@property (nonatomic, strong) NSMutableArray *userPostVotes;
@property (nonatomic, strong) NSMutableArray *userCommentVotes;

// Lazy Loading Counters
@property (nonatomic) long tagPage;
@property (nonatomic) long topPostsPage;
@property (nonatomic) long recentPostsPage;
@property (nonatomic) long tagPostsPage;
@property (nonatomic) long trendingCollegesPage;


#pragma mark - Public Functions
/****************************/
/***** PUBLIC FUNCTIONS *****/
/****************************/

/****************************/
/***** Local Data Access ****/
/****************************/
- (NSString *)getCollegeNameById:(long)Id;
- (College *)getCollegeById:(long)Id;
- (void)getHardCodedCollegeList;
- (NSMutableArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon;

- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (BOOL)isNearCollege;
- (BOOL)isNearCollegeWithId:(long)collegeId;

- (NSMutableArray *)getCurrentTagList;
- (void)retrieveUserData;
- (long)getUserPostScore;
- (long)getUserCommentScore;
- (NSInteger)getLaunchNumber;
- (BOOL)isAbleToPost:(NSNumber *)minutesRemaining;
- (BOOL)isAbleToComment;
- (void)incrementLaunchNumber;
- (void)saveCurrentFeed;
- (void)restoreSavedFeed;

- (NSURL *)applicationDocumentsDirectory;
/*************************/
/***** Network Access ****/
/*************************/

- (void)findUserLocation;

// Colleges
- (void)getNetworkCollegeList;
- (void)getTrendingCollegeList;
- (BOOL)needsNewCollegeList;

// Comments
- (BOOL)createCommentWithMessage:(NSString *)message
                        withPost:(Post*)post;

- (void)fetchCommentsForPost:(Post *)post; /* MULTITHREADED COMPLETE */
- (void)fetchUserCommentsWithIdArray:(NSArray *)commentIds;

// Flags
- (BOOL)flagPost:(long)postId;

// Posts
- (BOOL)createPostWithMessage:(NSString *)message
                withCollegeId:(long)collegeId;

- (void)fetchTopPostsForAllColleges;
- (void)fetchTopPostsInSingleCollege;

- (BOOL)fetchNewPosts;
- (void)fetchNewPostsInCollege;

- (void)fetchPostsWithTagMessage:(NSString*)tagMessage;
- (void)fetchAllPostsInCollegeWithTagMessage:(NSString*)tagMessage;
- (BOOL)fetchMorePostsWithTagMessage:(NSString*)tagMessage;

- (void)fetchUserPostsWithIdArray:(NSArray *)postIds;
- (Post *)fetchPostWithId:(long)postId;
- (Post *)fetchParentPostOfComment:(Comment *)comment;

// Tags
- (void)fetchTagsWithReset:(BOOL)reset;
//- (BOOL)fetchTagsWithCollegeId:(long)collegeId;

// Votes
- (BOOL)createVote:(Vote *)vote;
- (BOOL)cancelVote:(Vote *)vote;

@end
