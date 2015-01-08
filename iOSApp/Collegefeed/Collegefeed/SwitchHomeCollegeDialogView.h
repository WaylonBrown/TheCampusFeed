//
//  SwitchHomeCollegeDialogView.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/5/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

#import "CF_DialogViewController.h"

@interface SwitchHomeCollegeDialogView : CF_DialogViewController

@property (strong, nonatomic) void(^ acceptanceBlock)();

- (id)initWithAcceptanceBlock:(void (^)(void))block;

@end
