//
//  ToastController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/2/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "ToastController.h"
#import "UIView+Toast.h"
#import "College.h"

@implementation ToastController

- (id)init
{
    self.holdingNotifications = NO;
    self.showingNotification = NO;
    self.condition = [[NSCondition alloc] init];

    self.toastQueue = [NSMutableArray new];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toastHidden) name:@"ToastHidden" object:nil];
    
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ToastHidden" object:nil];
}
- (void)addToQueue:(NSString *)message
{
    [self.toastQueue addObject:message];
    [self dequeueToast];
}
- (void)toastHidden
{
    self.showingNotification = NO;
    [self dequeueToast];
}
- (void)releaseBlockedToasts
{
    self.holdingNotifications = NO;
    [self dequeueToast];
}

#pragma mark - Private Helpers

- (void)dequeueToast
{
    if (self.toastQueue.count > 0 && !self.holdingNotifications && !self.showingNotification)
    {
        NSString *message = [self.toastQueue objectAtIndex:0];
        
        NSLog(@"Dequeuing toast: %@", message);
        [self.toastQueue removeObjectAtIndex:0];
        
        self.showingNotification = YES;
        
        UIView *currentView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
        float x = currentView.frame.size.width / 2;
        float y = currentView.frame.size.height - 95;
        CGPoint point = CGPointMake(x, y);
        [currentView makeToast:message duration:2.0 position:[NSValue valueWithCGPoint:point]];
    }
}

#pragma mark - Public Functions

- (void)toastCustomMessage:(NSString *)message
{
    [self addToQueue:message];
}


#pragma mark - Permissions

- (void)toastInvalidDownvote
{
    // Downvote a post from a college that user doesn't have permissions to
    // Downvote a comment from ...
    
    NSString *message = @"You need to be near the college to downvote";
    [self addToQueue:message];
}
- (void)toastPostingTooSoon:(int)minutesLeft
{
    NSString *message = [NSString stringWithFormat:@"You're doing that too quickly, try again in %d minute%@", minutesLeft, (minutesLeft == 1) ? @"" : @"s"];
    [self addToQueue:message];
}
- (void)toastCommentingTooSoon:(int)minutesLeft
{
    NSString *message = [NSString stringWithFormat:@"You're doing that too quickly, try again in %d minute%@", minutesLeft, (minutesLeft == 1) ? @"" : @"s"];
    [self addToQueue:message];
}
- (void)toastErrorFindingTimeCrunchCollege
{
    NSString *message = @"Error retrieving Time Crunch college. Make a post to set your home college";
    [self addToQueue:message];
}
- (void)toastTwitterUnavailable
{
    NSString *message = @"Sorry, there was an error opening the Twitter app";
    [self addToQueue:message];
}
- (void)toastFacebookUnavailable
{
    NSString *message = @"Sorry, there was an error opening the Facebook app";
    [self addToQueue:message];
}

#pragma mark - Location

- (void)toastLocationSearchFailed
{
    NSString *message = @"Could not get location. Please check Settings to make sure location services for TheCampusFeed are enabled";
    [self addToQueue:message];
}
- (void)toastLocationFoundNotNearCollege
{
    NSString *message = @"No colleges were found nearby, you can still upvote";
    [self addToQueue:message];
}

#pragma mark - Formatting

- (void)toastCommentTooShort
{
    NSString *message = [NSString stringWithFormat:@"Comment must be at least %d characters long", MIN_COMMENT_LENGTH];
    [self addToQueue:message];
}
- (void)toastPostTooShort
{
    NSString *message = [NSString stringWithFormat:@"Post must be at least %d characters long", MIN_POST_LENGTH];
    [self addToQueue:message];
}
- (void)toastTagTooShort
{
    NSString *message = [NSString stringWithFormat:@"Must be at least %d characters long", MIN_TAG_LENGTH];
    [self addToQueue:message];
}

#pragma mark - Network Error

- (void)toastNoInternetConnection
{
    NSString *message = @"A connection error occurred. Pull down to refresh and try again";
    [self addToQueue:message];
}
- (void)toastPostFailed
{
    // Network failure when submitting post
    NSString *message = @"Failed to post, please try again later";
    [self addToQueue:message];
}
- (void)toastCommentFailed
{
    // Network failure when submitting comment
    NSString *message = @"Failed to comment, please try again later";
    [self addToQueue:message];
}
- (void)toastFlagFailed
{
    NSString *message = @"Failed to flag post, please try again later";
    [self addToQueue:message];
}
- (void)toastErrorFetchingCollegeList
{
    NSString *message = @"Error fetching college list";
    [self addToQueue:message];
}

#pragma mark - Network Success

- (void)toastFlagSuccess
{
    NSString *message = @"Post has been flagged, thank you";
    [self addToQueue:message];
}
- (void)toastFoundNearbyColleges:(NSArray *)colleges
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
    [self addToQueue:collegeMessage];
    
    if (colleges.count > 1)
    {
        NSString *infoMessage = @"You can upvote, downvote, post, and comment on those colleges' posts";
        [self addToQueue:infoMessage];
    }
    else if (colleges.count == 1)
    {
        NSString *infoMessage = @"You can upvote, downvote, post, and comment on that college's posts";
        [self addToQueue:infoMessage];
    }
}

#pragma mark - Navigation

- (void)toastSwitchedToCollegeNearby:(NSString *)collegeName
{
    NSString *message = [NSString stringWithFormat:@"Since you are near %@, you can upvote, downvote, post, and comment", collegeName];
    [self addToQueue:message];
}
- (void)toastSwitchedToCollegeDistant:(NSString *)collegeName
{
    NSString *message = [NSString stringWithFormat:@"Since you aren't near %@, you can only upvote", collegeName];
    [self addToQueue:message];
}


#pragma mark -

- (void)toastTagNeedsHash
{
    NSString *message = @"Must start with #";
    [self addToQueue:message];
}
- (void)toastInvalidTagSearch
{
    NSString *message = @"A search for a tag cannot include the symbols !, $, %, ^, &, *, +, or .";
    [self addToQueue:message];
}

@end
