//
//  ToastController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MasterViewController;

@interface ToastController : NSObject

@property (strong, nonatomic) MasterViewController *view;
@property (strong, nonatomic) NSMutableArray *toastQueue;

- (id)initWithMasterViewController:(MasterViewController *)viewController;

- (void)toastInvalidDownvote; //**
- (void)toastCommentTooShortWithLength:(int)minLength; //**
- (void)toastPostTooShortWithLength:(int)minLength; //**
- (void)toastNoInternetConnection;
- (void)toastTagSearchTooShortWithLength:(int)minLength;
- (void)toastTagNeedsHash;
- (void)toastPostFailed;
- (void)toastFlagFailed;
- (void)toastFlagSuccess;
- (void)toastErrorFetchingCollegeList;
- (void)toastFeedSwitchedToNearbyCollege:(NSString *)collegeName;
- (void)toastFeedSwitchedToDistantCollege:(NSString *)collegeName;
- (void)toastNoLocationServices; //**
- (void)toastLocationNotFoundOnTimeout;
- (void)toastLocationFoundNotNearCollege;
- (void)toastNearbyColleges:(NSArray *)colleges; //**


// ** = toast has been placed
//   5/16 placed
@end
