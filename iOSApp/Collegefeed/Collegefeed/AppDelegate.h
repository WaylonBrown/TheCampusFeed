//
//  AppDelegate.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PostDataController.h"
#import "CommentDataController.h"
#import "VoteDataController.h"
#import "CollegeDataController.h"
#import "TagDataController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow              *window;
@property (strong, nonatomic) UITabBarController    *tabBarController;

@property (strong, nonatomic) PostDataController    *postDataController;
@property (strong, nonatomic) CommentDataController *commentDataController;
@property (strong, nonatomic) VoteDataController    *voteDataController;
@property (strong, nonatomic) CollegeDataController *collegeDataController;
@property (strong, nonatomic) TagDataController     *tagDataController;


@end
