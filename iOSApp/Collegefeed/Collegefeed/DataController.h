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
#import "CF_DialogViewController.h"

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
    LOCATION_FOUND,
    LOCATION_SEARCHING,
    LOCATION_NOT_FOUND
};

@interface DataController : NSObject<CLLocationManagerDelegate, UIAlertViewDelegate>

// Core data storage
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Helper objects
@property (nonatomic, strong) ToastController *toaster;
@property (nonatomic, strong) Watchdog *watchDog;

// Runtime status information
@property (nonatomic, strong) College *collegeInFocus;
@property (nonatomic, strong) Post *postInFocus;
@property (nonatomic, strong) Tag *tagInFocus;
@property (nonatomic, strong) College *homeCollegeForTimeCrunch;
@property (nonatomic, strong) TimeCrunchModel *timeCrunch;
@property (nonatomic) BOOL showingAllColleges;
@property (nonatomic) BOOL showingSingleCollege;

// Persistent status information
@property (nonatomic) BOOL hasViewedAchievements;
@property (nonatomic) BOOL isBanned;
@property (nonatomic) long currentCollegeFeedId;
@property (nonatomic) long homeCollegeId;
@property (nonatomic) long collegeListVersion;
@property (nonatomic) long launchCount;
@property (nonatomic) long numPosts;
@property (nonatomic) long numPoints;
@property (nonatomic, strong) NSDate *lastCommentTime;
@property (nonatomic, strong) NSDate *lastPostTime;

// Location information
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDate *locationSearchStart;
@property (nonatomic) CLLocationDegrees lat;
@property (nonatomic) CLLocationDegrees lon;
@property (nonatomic) LocationStatus locStatus;
@property (nonatomic) long locationUpdateAttempts;

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


- (void)restoreAllCoreData;

// Achievements
- (void)fetchAchievements;
- (void)checkAchievements;
- (void)addAchievement:(Achievement *)achievement;

// Colleges
- (College *)getCollegeInFocus;
- (void)fetchTopColleges;
- (void)fetchAllColleges;
- (NSMutableArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon;
- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (BOOL)isNearCollege;
- (BOOL)isNearCollegeWithId:(long)collegeId;
- (void)findNearbyColleges;
- (NSString *)getCurrentFeedName;
- (void)finishedFetchingCollegeList;

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

- (Post *)fetchPostWithId:(long)postId;
- (Post *)fetchParentPostOfComment:(Comment *)comment;

// Tags
- (void)fetchTrendingTagsForAllColleges;
- (void)fetchTrendingTagsForSingleCollege;

// Time Crunch
//- (TimeCrunchModel *)getTimeCrunchModel;
- (void)attemptActivateTimeCrunch;

// User data
- (void)retrieveUserPosts;
- (void)retrieveUserComments;
- (long)getUserPostScore;
- (long)getUserCommentScore;
- (BOOL)isAbleToPost:(NSNumber *)minutesRemaining;
- (BOOL)isAbleToComment;
- (void)findUserLocation;
- (NSURL *)applicationDocumentsDirectory;

// Votes
- (BOOL)createVote:(Vote *)vote;
- (BOOL)cancelVote:(Vote *)vote;

@end
