//
//  PostDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataController.h"

@interface PostDataController : DataController

@property (nonatomic, strong) NSMutableArray *topPostsAllColleges;
@property (nonatomic, strong) NSMutableArray *recentPostsAllColleges;
@property (nonatomic, strong) NSMutableArray *userPostsAllColleges;
@property (nonatomic, strong) NSMutableArray *allPostsWithTag;

@property (nonatomic, strong) NSMutableArray *topPostsInCollege;
@property (nonatomic, strong) NSMutableArray *recentPostsInCollege;
@property (nonatomic, strong) NSMutableArray *userPostsInCollege;
@property (nonatomic, strong) NSMutableArray *allPostsWithTagInCollege;

@property (nonatomic) NSURL *postURL;
@property (nonatomic) NSMutableData *responseData;


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




@end
