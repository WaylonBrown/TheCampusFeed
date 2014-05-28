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

@property (nonatomic, strong) NSMutableArray *topPostsInCollege;
@property (nonatomic, strong) NSMutableArray *recentPostsInCollege;
@property (nonatomic, strong) NSMutableArray *userPostsInCollege;

@property (nonatomic) NSURL *postURL;
@property (nonatomic) NSMutableData *responseData;


- (void)fetchTopPosts;
- (void)fetchTopPostsWithCollegeId:(NSInteger*)cID;


// TODO: these not implemented yet (waiting on server endpoints)
- (void)fetchNewPosts;
- (void)fetchUserPostsWithUserId:(NSInteger)uID;

- (void)fetchNewPostsWithCollegeId:(NSInteger)cID;
- (void)fetchUserPostsWithUserId:(NSInteger)uID
                   WithCollegeId:(NSInteger)cID;




@end
