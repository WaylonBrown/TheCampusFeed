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

- (void)toastNearbyColleges:(NSArray *)colleges inView:(MasterViewController *)sender;

@end
