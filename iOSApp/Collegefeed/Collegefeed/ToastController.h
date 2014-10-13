//
//  ToastController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
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

// Validation Error
- (void)toastInvalidDownvote;
- (void)toastCommentTooShortWithLength:(int)minLength;
- (void)toastPostTooShortWithLength:(int)minLength;
- (void)toastTagSearchTooShortWithLength:(int)minLength;
- (void)toastTagNeedsHash;
- (void)toastInvalidTagSearch;

// Network Error
- (void)toastLocationConnectionError;
- (void)toastPostFailed;
- (void)toastFlagFailed;
- (void)toastFlagSuccess;
- (void)toastErrorFetchingCollegeList;
- (void)toastTwitterUnavailable;
- (void)toastFacebookUnavailable;
- (void)toastPostingTooSoon:(NSNumber *)minutesRemaining;
- (void)toastCommentingTooSoon;

// Navigation Notification
- (void)toastFeedSwitchedToNearbyCollege:(NSString *)collegeName;
- (void)toastFeedSwitchedToDistantCollege:(NSString *)collegeName;
- (void)toastLocationFoundNotNearCollege;
- (void)toastNearbyColleges:(NSArray *)colleges;

@end
