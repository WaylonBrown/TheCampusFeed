//
//  MasterViewDelegate.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/29/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PostDataController;
@class CommentDataController;
@class VoteDataController;
@class CollegeDataController;
@class TagDataController;

@protocol MasterViewDelegate <NSObject>

@property (strong, nonatomic) PostDataController    *postDataController;
@property (strong, nonatomic) CommentDataController *commentDataController;
@property (strong, nonatomic) VoteDataController    *voteDataController;
@property (strong, nonatomic) CollegeDataController *collegeDataController;
@property (strong, nonatomic) TagDataController     *tagDataController;

@property (strong, nonatomic) College *currentCollege;
@property (nonatomic) BOOL allColleges;
@property (nonatomic) BOOL specificCollege;


- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (College*)getUsersCurrentCollege;
- (BOOL)getIsAllColleges;
- (BOOL)getIsSpecificCollege;

@end