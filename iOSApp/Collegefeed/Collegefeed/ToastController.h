//
//  ToastController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MasterViewController;
@class CreatePostCommentViewController;

typedef NS_ENUM(NSInteger, ToastViewType)
{
    MASTER,
    CREATE
};


@interface ToastController : NSObject

@property (strong, nonatomic) MasterViewController *masterView;
@property (strong, nonatomic) CreatePostCommentViewController *createView;
@property (strong, nonatomic) NSMutableArray *toastQueue;
@property (nonatomic) ToastViewType toastViewType;

- (id)initWithViewController:(UIViewController *)viewController;

// Validation Error
- (void)toastInvalidDownvote;
- (void)toastCommentTooShortWithLength:(int)minLength;
- (void)toastPostTooShortWithLength:(int)minLength;
- (void)toastTagSearchTooShortWithLength:(int)minLength; // ****
- (void)toastTagNeedsHash; // ****

// Network Error
- (void)toastNoInternetConnection; // ****
- (void)toastPostFailed;
- (void)toastFlagFailed; // ****
- (void)toastFlagSuccess; // ****
- (void)toastErrorFetchingCollegeList;
- (void)toastNoLocationServices;
- (void)toastLocationNotFoundOnTimeout;

// Navigation Notification
- (void)toastFeedSwitchedToNearbyCollege:(NSString *)collegeName;
- (void)toastFeedSwitchedToDistantCollege:(NSString *)collegeName;
- (void)toastLocationFoundNotNearCollege;
- (void)toastNearbyColleges:(NSArray *)colleges;


// **** = Need to place toast
//   11/16 placed
@end
