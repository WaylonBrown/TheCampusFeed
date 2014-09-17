//
//  ToastController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "ToastController.h"
#import "UIView+Toast.h"
#import "College.h"

@implementation ToastController

- (id)init
{
    self.showingNotification = NO;
    self.condition = [[NSCondition alloc] init];

    self.toastQueue = [NSMutableArray new];
    if (![CLLocationManager locationServicesEnabled])
    {   
        [self toastNoLocationServices];
    }
    
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
    NSString *message = @"You have no internet connection. Pull down to refresh and try again.";
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
    NSString *message = @"You aren't near a college, you can upvote but nothing else.";
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

#pragma mark - Private Helpers

- (void)dequeueToast
{
    if (self.toastQueue.count > 0 && !self.showingNotification)
    {
        NSString *message = [self.toastQueue objectAtIndex:0];
    
        [self.toastQueue removeObjectAtIndex:0];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:message forKey:@"message"];
        NSNotification *notification = [[NSNotification alloc] initWithName:@"Toast" object:self userInfo:dictionary];
        self.showingNotification = YES;
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}


@end
