//
//  Post.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFModelProtocol.h"
#import "PostAndCommentProtocol.h"
@class College;

@interface Post : NSObject<CFModelProtocol, PostAndCommentProtocol>

// In API JSON
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *post_id;
@property (nonatomic) NSString *text;
@property (nonatomic) NSNumber *score;
@property (nonatomic) NSDate *created_at;
@property (nonatomic) NSDate *updated_at;
@property (nonatomic) NSNumber *college_id;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lon;
@property (nonatomic) NSNumber *hidden;
@property (nonatomic) NSNumber *vote_delta;
@property (nonatomic) NSNumber *comment_count;
@property (nonatomic) NSNumber *image_id;
@property (nonatomic) NSString *image_url;
@property (nonatomic) NSString *image_uri;

// Not in API JSON
@property (nonatomic, strong) Vote *vote;
@property (nonatomic, strong) College *college;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSURL *POSTurl;

- (id)initWithMessage:(NSString *)newMessage
        withCollegeId:(NSNumber *)collegeId
        withUserToken:(NSString *)userToken;

- (id)initWithPostID:(NSNumber *)newPostID
           withScore:(NSNumber *)newScore
         withMessage:(NSString *)newMessage;

@end
