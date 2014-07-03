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
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(dequeueToast)
                                   userInfo:nil
                                    repeats:YES];
    return self;
}

- (void)toastNearbyColleges:(NSArray *)colleges inView:(MasterViewController *)sender
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
