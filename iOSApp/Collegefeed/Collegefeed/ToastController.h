//
//  ToastController.h
//  Collegefeed
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

- (id)init;

- (void)dequeueToast;
- (void)toastHidden;

// Validation Error
- (void)toastInvalidDownvote;
- (void)toastCommentTooShortWithLength:(int)minLength;
- (void)toastPostTooShortWithLength:(int)minLength;
- (void)toastTagSearchTooShortWithLength:(int)minLength;
- (void)toastTagNeedsHash;
- (void)toastInvalidTagSearch;

// Network Error
- (void)toastNoInternetConnection;
- (void)toastPostFailed;
- (void)toastFlagFailed;
- (void)toastFlagSuccess;
- (void)toastErrorFetchingCollegeList;
- (void)toastNoLocationServices;
- (void)toastLocationNotFoundOnTimeout;
- (void)toastTwitterUnavailable;
- (void)toastFacebookUnavailable;
- (void)toastPostingTooSoon;
- (void)toastCommentingTooSoon;

// Navigation Notification
- (void)toastFeedSwitchedToNearbyCollege:(NSString *)collegeName;
- (void)toastFeedSwitchedToDistantCollege:(NSString *)collegeName;
- (void)toastLocationFoundNotNearCollege;
- (void)toastNearbyColleges:(NSArray *)colleges;

@end
