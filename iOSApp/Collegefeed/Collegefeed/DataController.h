//
//  DataController.h
//  Collegefeed
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
@class Vote;

#define MILES_FOR_PERMISSION        15
#define PI_VALUE                    3.14159
#define EARTH_RADIUS_MILES          3959
#define LOCATION_MANAGER_TIMEOUT    10

#define COLLEGE_LIST_FILE           @"CollegeList.txt"

#define USER_POST_IDS_FILE          @"UserPostIds.txt"
#define USER_COMMENT_IDS_FILE       @"UserCommentIds.txt"

#define COLLEGE_ENTITY          @"College"
#define POST_ENTITY             @"Post"
#define COMMENT_ENTITY          @"Comment"
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
@protocol LocationFinderDelegateProtocol <NSObject>

- (void)foundLocation;
- (void)didNotFindLocation;

@end


@interface DataController : NSObject<CLLocationManagerDelegate>


#pragma mark - Member Variables
/****************************/
/***** MEMBER VARIABLES *****/
/****************************/
@property (strong, nonatomic) id<LocationFinderDelegateProtocol> appDelegate;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

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
@property (nonatomic, strong) NSMutableArray *allTags;
@property (nonatomic, strong) NSMutableArray *allTagsInCollege;

// Vote Arrays
@property (nonatomic, strong) NSMutableArray *userPostVotes;
@property (nonatomic, strong) NSMutableArray *userCommentVotes;

// Location Information
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDegrees         lat;
@property (nonatomic) CLLocationDegrees         lon;
@property (nonatomic) BOOL                      foundLocation;

// Status Information
@property (strong, nonatomic) College   *collegeInFocus;
@property (strong, nonatomic) Post      *postInFocus;
@property (nonatomic) BOOL              showingAllColleges;
@property (nonatomic) BOOL              showingSingleCollege;

// Lazy Loading Counters
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

- (void)saveUserPosts;
- (void)saveUserComments;
- (void)saveUserVotes;
- (void)saveAllUserData;
- (void)retrieveUserData;
- (long)getUserPostScore;
- (long)getUserCommentScore;

- (NSURL *)applicationDocumentsDirectory;
/*************************/
/***** Network Access ****/
/*************************/

// Colleges
- (void)getNetworkCollegeList;
- (void)getTrendingCollegeList;

// Comments
- (BOOL)createCommentWithMessage:(NSString *)message
                        withPost:(Post*)post;

- (void)fetchCommentsWithPostId:(long)postId;
- (void)fetchUserCommentsWithIdArray:(NSArray *)commentIds;

// Flags
- (BOOL)flagPost:(long)postId;

// Posts
- (BOOL)createPostWithMessage:(NSString *)message
                withCollegeId:(long)collegeId;

- (void)fetchTopPosts;
- (void)fetchTopPostsInCollege;

- (void)fetchNewPosts;
- (void)fetchNewPostsInCollege;

- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage;
- (void)fetchAllPostsInCollegeWithTagMessage:(NSString*)tagMessage;
- (BOOL)fetchMorePostsWithTagMessage:(NSString*)tagMessage;

- (void)fetchUserPostsWithIdArray:(NSArray *)postIds;
- (Post *)fetchPostWithId:(long)postId;

// Tags
- (void)fetchAllTags;
- (void)fetchAllTagsWithCollegeId:(long)collegeId;

// Votes
- (BOOL)createVote:(Vote *)vote;
- (BOOL)cancelVote:(Vote *)vote;

@end
