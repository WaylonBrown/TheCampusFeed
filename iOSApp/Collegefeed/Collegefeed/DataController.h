//
//  DataController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "Constants.h"

@class Comment;
@class College;
@class Post;
@class Tag;
@class Vote;
@class ToastController;
@class Watchdog;

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

@interface DataController : NSObject<CLLocationManagerDelegate, UIAlertViewDelegate>


#pragma mark - Member Variables
/****************************/
/***** MEMBER VARIABLES *****/
/****************************/
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) ToastController *toaster;
@property (strong, nonatomic) Watchdog *watchDog;

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
@property (nonatomic, strong) NSMutableArray *postsWithTagAllColleges;
@property (nonatomic, strong) NSMutableArray *topPostsSingleCollege;
@property (nonatomic, strong) NSMutableArray *recentPostsSingleCollege;
@property (nonatomic, strong) NSMutableArray *postsWithTagSingleCollege;
@property (nonatomic, strong) NSMutableArray *userPosts;

// Tag Arrays
@property (nonatomic, strong) NSMutableArray *trendingTagsAllColleges;
@property (nonatomic, strong) NSMutableArray *trendingTagsSingleCollege;

// Vote Arrays
@property (nonatomic, strong) NSMutableArray *userPostVotes;
@property (nonatomic, strong) NSMutableArray *userCommentVotes;

// Lazy Loading Counters
@property (nonatomic) long pageForTopPostsAllColleges;
@property (nonatomic) long pageForTopPostsSingleCollege;
@property (nonatomic) long pageForNewPostsAllColleges;
@property (nonatomic) long pageForNewPostsSingleCollege;
@property (nonatomic) long pageForTaggedPostsAllColleges;
@property (nonatomic) long pageForTaggedPostsSingleCollege;

@property (nonatomic) long pageForTrendingTagsAllColleges;
@property (nonatomic) long pageForTrendingTagsSingleCollege;

@property (nonatomic) long pageForTopColleges;


#pragma mark - Public Functions
/****************************/
/***** PUBLIC FUNCTIONS *****/
/****************************/

/****************************/
/***** Local Data Access ****/
/****************************/

- (NSMutableArray *)getCurrentTagList;

- (void)retrieveUserPosts;
- (void)retrieveUserComments;
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
- (void)fetchTopColleges;
- (void)fetchAllColleges;
- (NSString *)getCollegeNameById:(long)Id;
- (College *)getCollegeById:(long)Id;
- (NSMutableArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon;
- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (BOOL)isNearCollege;
- (BOOL)isNearCollegeWithId:(long)collegeId;

// Comments
- (BOOL)createCommentWithMessage:(NSString *)message
                        withPost:(Post*)post;

- (void)fetchCommentsForPost:(Post *)post;

// Flags
- (BOOL)flagPost:(long)postId;

// Images
- (NSString *)getImageUrlFromId:(NSNumber *)imageID;
- (NSNumber *)postImageToServer:(UIImage *)image fromFilePath:(NSString *)filePath;

// Posts

- (BOOL)createPostWithMessage:(NSString *)message
                withCollegeId:(long)collegeId
                    withImage:(UIImage *)image;

- (void)fetchTopPostsForAllColleges;
- (void)fetchTopPostsForSingleCollege;

- (void)fetchNewPostsForAllColleges;
- (void)fetchNewPostsForSingleCollege;

- (void)fetchPostsWithTagForAllColleges:(NSString*)tagMessage;
- (void)fetchPostsWithTagForSingleCollege:(NSString*)tagMessage;


- (BOOL)fetchMorePostsWithTagMessage:(NSString*)tagMessage;

- (void)fetchUserPostsWithIdArray:(NSArray *)postIds;

- (Post *)fetchPostWithId:(long)postId;
- (Post *)fetchParentPostOfComment:(Comment *)comment;

// Tags
- (void)fetchTrendingTagsForAllColleges;
- (void)fetchTrendingTagsForSingleCollege;

//- (void)fetchTagsWithReset:(BOOL)reset;
//- (BOOL)fetchTagsWithCollegeId:(long)collegeId;

// Votes
- (BOOL)createVote:(Vote *)vote;
- (BOOL)cancelVote:(Vote *)vote;

@end
