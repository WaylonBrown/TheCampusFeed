//
//  ToastController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "ToastController.h"
#import "MasterViewController.h"
#import "UIView+Toast.h"

#import "Models/Models/College.h"

@implementation ToastController

- (id)initWithMasterViewController:(MasterViewController *)viewController
{
    [self setView:viewController];
    self.toastQueue = [NSMutableArray new];
    
    if (![CLLocationManager locationServicesEnabled])
    {   // In the UI is probably not proper place to put this, but it works
        [self toastNoLocationServices];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(dequeueToast)
                                   userInfo:nil
                                    repeats:YES];
    return self;
}

#pragma mark - Public Functions

- (void)toastInvalidDownvote
{
    NSString *message = @"You need to be near the college to downvote";
    [self.toastQueue addObject:message];
}
- (void)toastCommentTooShortWithLength:(int)minLength
{
    NSString *message = [NSString stringWithFormat:@"Comment must be at least %d characters long.", minLength];
    [self.toastQueue addObject:message];
}
- (void)toastPostTooShortWithLength:(int)minLength
{
    NSString *message = [NSString stringWithFormat:@"Post must be at least %d characters long.", minLength];
    [self.toastQueue addObject:message];
}
- (void)toastNoInternetConnection
{
    NSString *message = @"You have no internet connection. Pull down to refresh and try again.";
    [self.toastQueue addObject:message];
}
- (void)toastTagSearchTooShortWithLength:(int)minLength
{
    NSString *message = [NSString stringWithFormat:@"Must be at least %d characters long.", minLength];
    [self.toastQueue addObject:message];
}
- (void)toastTagNeedsHash
{
    NSString *message = @"Must start with #";
    [self.toastQueue addObject:message];
}
- (void)toastPostFailed
{
    NSString *message = @"Failed to post, please try again later.";
    [self.toastQueue addObject:message];
}
- (void)toastFlagFailed
{
    NSString *message = @"Failed to flag post, please try again later.";
    [self.toastQueue addObject:message];
}
- (void)toastFlagSuccess
{
    NSString *message = @"Post has been flagged, thank you :)";
    [self.toastQueue addObject:message];
}
- (void)toastErrorFetchingCollegeList
{
    NSString *message = @"Error fetching college list.";
    [self.toastQueue addObject:message];
}
- (void)toastFeedSwitchedToNearbyCollege:(NSString *)collegeName
{
    NSString *message = [NSString stringWithFormat:@"Since you are near %@, you can upvote, downvote, post, and comment", collegeName];
    [self.toastQueue addObject:message];
}
- (void)toastFeedSwitchedToDistantCollege:(NSString *)collegeName
{
    NSString *message = [NSString stringWithFormat:@"Since you aren't near %@, you can only upvote", collegeName];
    [self.toastQueue addObject:message];
}
- (void)toastNoLocationServices
{
    NSString *message1 = @"Location Services are turned off.";
    NSString *message2 = @"You can upvote, but nothing else.";
    [self.toastQueue addObject:message1];
    [self.toastQueue addObject:message2];
}
- (void)toastLocationNotFoundOnTimeout
{
    NSString *message = @"Couldn't find location. You can upvote, but nothing else.";
    [self.toastQueue addObject:message];
}
- (void)toastLocationFoundNotNearCollege
{
    NSString *message = @"You aren't near a college, you can upvote but nothing else.";
    [self.toastQueue addObject:message];
}
- (void)toastNearbyColleges:(NSArray *)colleges
{
    NSString *collegeMessage = @"";
    for (int i = 0; i < colleges.count; i++)
    {
        College *college = [colleges objectAtIndex:i];
        
        if (i == 0)
        {
            collegeMessage = [NSString stringWithFormat:@"You're near %@", college.name];
        }
        else if (i > 0)
        {
            collegeMessage = [NSString stringWithFormat:@"%@ and %@", collegeMessage, college.name];
        }
    }
    [self.toastQueue addObject:collegeMessage];
    
    NSString *infoMessage = @"You can upvote, downvote, post, and comment on that college's posts";
    [self.toastQueue addObject:infoMessage];
}

#pragma mark - Private Helpers

- (void)dequeueToast
{
    if (self.toastQueue.count > 0)
    {
        NSString *message = [self.toastQueue objectAtIndex:0];
    
        [self.toastQueue removeObjectAtIndex:0];
        [self showToast:message inView:self.view];
    }
}
- (void)showToast:(NSString *)message inView:(MasterViewController *)sender
{
    float x = sender.feedToolbar.frame.size.width / 2;
    float y = sender.feedToolbar.frame.origin.y - 45;
    CGPoint point = CGPointMake(x, y);

    [sender.view makeToast:message
                  duration:2.0
                  position:[NSValue valueWithCGPoint:point]];
}


@end
