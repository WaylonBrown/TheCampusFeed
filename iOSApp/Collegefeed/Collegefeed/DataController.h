//
//  DataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Comment;
@class Post;
@class Vote;

#define MILES_FOR_PERMISSION 15

@interface DataController : NSObject

// College Array
@property (nonatomic, strong) NSMutableArray *collegeList;

// Comment Array
@property (nonatomic, strong) NSMutableArray *commentList;

// Post Arrays
@property (nonatomic, strong) NSMutableArray *topPostsAllColleges;
@property (nonatomic, strong) NSMutableArray *recentPostsAllColleges;
@property (nonatomic, strong) NSMutableArray *userPostsAllColleges;
@property (nonatomic, strong) NSMutableArray *allPostsWithTag;

@property (nonatomic, strong) NSMutableArray *topPostsInCollege;
@property (nonatomic, strong) NSMutableArray *recentPostsInCollege;
@property (nonatomic, strong) NSMutableArray *userPostsInCollege;
@property (nonatomic, strong) NSMutableArray *allPostsWithTagInCollege;

// Tag Arrays
@property (nonatomic, strong) NSMutableArray *allTags;
@property (nonatomic, strong) NSMutableArray *allTagsInCollege;


// Initializations
- (id)init;

// Networker Access - Colleges
- (void)getNetworkCollegeList;

// Networker Access - Comments
- (BOOL)createCommentWithMessage:(NSString *)message
                        withPost:(Post*)post;

- (void)fetchCommentsWithPostId:(long)postId;

// Networker Access - Posts
- (BOOL)createPostWithMessage:(NSString *)message
                withCollegeId:(long)collegeId;

- (void)fetchTopPosts;
- (void)fetchTopPostsWithCollegeId:(long)collegeId;

- (void)fetchNewPosts;
- (void)fetchNewPostsWithCollegeId:(long)collegeId;

- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage;
- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage
                      withCollegeId:(long)collegeId;

    // TODO: these not implemented yet
- (void)fetchUserPostsWithUserId:(long)userId;
- (void)fetchUserPostsWithUserId:(long)userId
                   WithCollegeId:(long)collegeId;


// Networker Access - Tags
- (void)fetchAllTags;
- (void)fetchAllTagsWithCollegeId:(long)collegeId;

// Networker Access - Votes
- (BOOL)createVote:(Vote *)vote;

// Local Data Access
- (void)getHardCodedCollegeList;
- (NSArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon;

@end
