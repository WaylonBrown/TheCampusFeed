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

@class Comment;
@class College;
@class Post;
@class Vote;

#define MILES_FOR_PERMISSION 15
#define PI_VALUE 3.14159
#define EARTH_RADIUS_MILES 3959

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

// College Arrays
@property (strong, nonatomic) NSMutableArray *collegeList;
@property (strong, nonatomic) NSMutableArray *nearbyColleges;

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
@property (nonatomic, strong) NSMutableArray *userVotes;

// Location Information
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDegrees         lat;
@property (nonatomic) CLLocationDegrees         lon;

// Status Information
@property (strong, nonatomic) College   *collegeInFocus;
@property (strong, nonatomic) Post      *postInFocus;
@property (nonatomic) BOOL              showingAllColleges;
@property (nonatomic) BOOL              showingSingleCollege;


#pragma mark - Public Functions
/****************************/
/***** PUBLIC FUNCTIONS *****/
/****************************/

// Initialization
//- (id)init;

/****************************/
/***** Local Data Access ****/
/****************************/
- (NSString *)getCollegeNameById:(long)Id;
- (void)getHardCodedCollegeList;
- (NSMutableArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon;

- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (BOOL)isNearCollege;

- (void)retrieveUserData;

/*************************/
/***** Network Access ****/
/*************************/
// Colleges
- (void)getNetworkCollegeList;

// Comments
- (BOOL)createCommentWithMessage:(NSString *)message
                        withPost:(Post*)post;

- (void)fetchCommentsWithPostId:(long)postId;

// Posts
- (BOOL)createPostWithMessage:(NSString *)message
                withCollegeId:(long)collegeId;

- (void)fetchTopPosts;
- (void)fetchTopPostsWithCollegeId:(long)collegeId;

- (void)fetchNewPosts;
- (void)fetchNewPostsWithCollegeId:(long)collegeId;

- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage;
- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage
                      withCollegeId:(long)collegeId;

// Tags
- (void)fetchAllTags;
- (void)fetchAllTagsWithCollegeId:(long)collegeId;

// Votes
- (BOOL)createVote:(Vote *)vote;

@end
