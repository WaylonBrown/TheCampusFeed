//
//  ToastController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/2/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ToastController : NSObject

@property (strong, nonatomic) NSMutableArray *toastQueue;
@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic) BOOL showingNotification;
@property (nonatomic) BOOL holdingNotifications;

- (id)init;
- (void)dequeueToast;
- (void)toastHidden;
- (void)releaseBlockedToasts;
- (void)toastCustomMessage:(NSString *)message;

// Permissions
- (void)toastInvalidDownvote;
- (void)toastCommentingTooSoon;
- (void)toastPostingTooSoon;
- (void)toastErrorFindingTimeCrunchCollege;
- (void)toastTwitterUnavailable;
- (void)toastFacebookUnavailable;

// Location
- (void)toastLocationFoundNotNearCollege;
- (void)toastLocationSearchFailed;

// Formatting
//- (void)toastCommentInvalid; // TODO: uses toastPostTooShort
//- (void)toastPostTooShort;

// TODO:
- (void)toastInvalidPost;
- (void)toastInvalidComment;
// *****

- (void)toastInvalidTagSearch;

// Network Error
//- (void)toastNoInternetConnection;
- (void)toastPostFailed;
- (void)toastCommentFailed;
- (void)toastFlagFailed;
- (void)toastErrorFetchingCollegeList;

// Network Success
- (void)toastFlagSuccess;
- (void)toastFoundNearbyColleges:(NSArray *)colleges;

// Navigation
- (void)toastSwitchedToCollegeNearby:(NSString *)collegeName;
- (void)toastSwitchedToCollegeDistant:(NSString *)collegeName;


@end
