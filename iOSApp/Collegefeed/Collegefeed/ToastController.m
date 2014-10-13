//
//  ToastController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "ToastController.h"
#import "UIView+Toast.h"
#import "College.h"

@implementation ToastController

- (id)init//AsFirstLaunch:(BOOL)isFirst
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
#pragma mark - Public Functions

- (void)toastInvalidDownvote
{
    NSString *message = @"You need to be near the college to downvote";
    [self addToQueue:message];
}
- (void)toastCommentTooShortWithLength:(int)minLength
{
    NSString *message = [NSString stringWithFormat:@"Comment must be at least %d characters long.", minLength];
    [self addToQueue:message];
}
- (void)toastPostTooShortWithLength:(int)minLength
{
    NSString *message = [NSString stringWithFormat:@"Post must be at least %d characters long.", minLength];
    [self addToQueue:message];
}
- (void)toastNoInternetConnection
{
    NSString *message = @"A connection error occurred. Pull down to refresh and try again.";
    [self addToQueue:message];
}
- (void)toastTagSearchTooShortWithLength:(int)minLength
{
    NSString *message = [NSString stringWithFormat:@"Must be at least %d characters long.", minLength];
    [self addToQueue:message];
}
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
- (void)toastPostFailed
{
    NSString *message = @"Failed to post, please try again later.";
    [self addToQueue:message];
}
- (void)toastFlagFailed
{
    NSString *message = @"Failed to flag post, please try again later.";
    [self addToQueue:message];
}
- (void)toastFlagSuccess
{
    NSString *message = @"Post has been flagged, thank you :)";
    [self addToQueue:message];
}
- (void)toastErrorFetchingCollegeList
{
    NSString *message = @"Error fetching college list.";
    [self addToQueue:message];
}
- (void)toastFeedSwitchedToNearbyCollege:(NSString *)collegeName
{
    NSString *message = [NSString stringWithFormat:@"Since you are near %@, you can upvote, downvote, post, and comment", collegeName];
    [self addToQueue:message];
}
- (void)toastFeedSwitchedToDistantCollege:(NSString *)collegeName
{
    NSString *message = [NSString stringWithFormat:@"Since you aren't near %@, you can only upvote", collegeName];
    [self addToQueue:message];
}
- (void)toastTwitterUnavailable
{
    NSString *message = @"You need to have the Twitter app installed to tweet this post.";
    [self addToQueue:message];
}
- (void)toastFacebookUnavailable
{
    NSString *message = @"You need to have the Facebook app installed to share on Facebook.";
    [self addToQueue:message];
}
- (void)toastPostingTooSoon:(NSNumber *)minutesRemaining
{
    NSString *message = [NSString stringWithFormat:@"Sorry, you can only post once every 5 minutes. Try again in %d minutes", [minutesRemaining intValue]];
    [self addToQueue:message];
}
- (void)toastCommentingTooSoon
{
    NSString *message = @"Sorry, you can only comment once every minute";
    [self addToQueue:message];
}
- (void)toastLocationFoundNotNearCollege
{
    NSString *message = @"No colleges were found near you, you can upvote but nothing else.";
    [self addToQueue:message];
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
- (void)toastLocationConnectionError
{
    NSString *message1 = @"There was an error finding your location. You can upvote, but nothing else.";
    NSString *message2 = @"Make sure location services are enabled at \"Settings > TheCampusFeed > Privacy\"";
    [self addToQueue:message1];
    [self addToQueue:message2];
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


@end
