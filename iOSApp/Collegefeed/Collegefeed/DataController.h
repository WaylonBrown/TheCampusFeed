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

@class Achievement;
@class Comment;
@class College;
@class Post;
@class Tag;
@class Vote;
@class TimeCrunchModel;
@class ToastController;
@class Watchdog;

typedef NS_ENUM(NSInteger, LocationStatus)
{
    LOCATION_NOT_FOUND,
    LOCATION_SEARCHING,
    LOCATION_FOUND
};

@interface DataController : NSObject<CLLocationManagerDelegate, UIAlertViewDelegate>

// Core data storage
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Helper objects
@property (nonatomic, strong) ToastController *toastController;
@property (nonatomic, strong) Watchdog *watchDog;

// Runtime status information
@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) College *collegeInFocus;
@property (nonatomic, strong) Post *postInFocus;
@property (nonatomic, strong) College *homeCollegeForTimeCrunch;
@property (nonatomic, strong) TimeCrunchModel *timeCrunch;
@property (nonatomic) BOOL showingAllColleges;
@property (nonatomic) BOOL showingSingleCollege;
@property (nonatomic) LocationStatus locationStatus;

// Persistent status information
@property (nonatomic) BOOL hasViewedAchievements;
@property (nonatomic) BOOL isBanned;
@property (nonatomic) long currentCollegeFeedId;
@property (nonatomic) long homeCollegeId;
@property (nonatomic) long collegeListVersion;
@property (nonatomic) long launchCount;
@property (nonatomic, strong) NSDate *lastCommentTime;
@property (nonatomic, strong) NSDate *lastPostTime;

// Achievement Arrays
@property (nonatomic, strong) NSMutableArray *achievementList;

// College Arrays
@property (nonatomic, strong) NSMutableArray *collegeList;
@property (nonatomic, strong) NSMutableArray *nearbyColleges;
@property (nonatomic, strong) NSMutableArray *trendingColleges;

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

// Page counters for lazy loading
@property (nonatomic) long pageForTopPostsAllColleges;
@property (nonatomic) long pageForTopPostsSingleCollege;
@property (nonatomic) long pageForNewPostsAllColleges;
@property (nonatomic) long pageForNewPostsSingleCollege;
@property (nonatomic) long pageForTaggedPostsAllColleges;
@property (nonatomic) long pageForTaggedPostsSingleCollege;
@property (nonatomic) long pageForTrendingTagsAllColleges;
@property (nonatomic) long pageForTrendingTagsSingleCollege;
@property (nonatomic) long pageForTopColleges;

//TODO: Move to CFNavigationController
- (NSString *)getCurrentFeedName;
// ^^^


- (void)restoreAllCoreData;

// Achievements
- (void)didViewAchievements;

// Colleges
- (void)fetchAllColleges;
- (void)fetchTopColleges;
- (College *)getCollegeInFocus;
- (College *)getCollegeById:(long)collegeId;

- (void)setFoundUserLocationWithLat:(float)userLat
                            withLon:(float)userLon;
- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (NSArray *)getNearbyCollegeList;
- (BOOL)isNearCollege;
- (BOOL)isNearCollegeWithId:(long)collegeId;
- (void)finishedFetchingCollegeList;

// Comments
- (Comment *)submitCommentToNetworkWithMessage:(NSString *)message
                                    withPostId:(long)postId;

//- (BOOL)createCommentWithMessage:(NSString *)message
//                        withPost:(Post*)post;
- (void)fetchCommentsForPost:(Post *)post;
- (void)retrieveUserComments;

// Flags
- (BOOL)flagPost:(long)postId;

// Images
- (NSString *)getImageUrlFromId:(NSNumber *)imageID;
- (NSNumber *)postImageToServer:(UIImage *)image fromFilePath:(NSString *)filePath;

// Posts
- (Post *)submitPostToNetworkWithMessage:(NSString *)message
                           withCollegeId:(long)collegeId
                               withImage:(UIImage *)image;

- (void)fetchTopPostsForAllColleges;
- (void)fetchTopPostsForSingleCollege;

- (void)fetchNewPostsForAllColleges;
- (void)fetchNewPostsForSingleCollege;

- (void)fetchPostsWithTagForAllColleges:(NSString*)tagMessage;
- (void)fetchPostsWithTagForSingleCollege:(NSString*)tagMessage;

- (Post *)fetchPostWithId:(long)postId;
- (Post *)fetchParentPostOfComment:(Comment *)comment;

- (void)retrieveUserPosts;
- (void)didFinishFetchingUserPosts;

// Tags
- (void)fetchTrendingTagsForAllColleges;
- (void)fetchTrendingTagsForSingleCollege;

// Time Crunch
- (void)attemptActivateTimeCrunch;

// Toasts
- (void)queueToastWithSelector:(SEL)selector;
- (ToastController *)getMyToastController;

// User data
- (long)getUserPostScore;
- (long)getUserCommentScore;
- (BOOL)isAbleToPost:(NSNumber *)minutesRemaining;
- (BOOL)isAbleToComment;

// Votes
- (BOOL)createVote:(Vote *)vote;
- (BOOL)cancelVote:(Vote *)vote;

@end
