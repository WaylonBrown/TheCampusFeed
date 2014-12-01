//
//  TutorialViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@class College;
@class DataController;


@interface TutorialViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

- (id)init;
- (IBAction)okPressed:(UIButton *)sender;


@end
