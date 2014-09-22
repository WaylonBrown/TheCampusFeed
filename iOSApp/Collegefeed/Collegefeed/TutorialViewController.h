//
//  TutorialViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABLE_HEADER_HEIGHT 20
#define TABLE_CELL_HEIGHT 44

@class College;
@class DataController;


@interface TutorialViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

- (id)init;
- (IBAction)okPressed:(UIButton *)sender;


@end
