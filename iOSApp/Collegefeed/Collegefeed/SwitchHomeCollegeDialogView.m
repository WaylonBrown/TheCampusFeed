//
//  SwitchHomeCollegeDialogView.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/5/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

#import "SwitchHomeCollegeDialogView.h"

@implementation SwitchHomeCollegeDialogView

- (id)init
{
    self = [super init];
    if (self)
    {
        self.buttonCount = 2;
    }
    return self;
}
- (id)initWithAcceptanceBlock:(void (^)(void))block
{
    self = [self init];
    if (self)
    {
        self.acceptanceBlock = block;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleTextView.text = @"Change home college for Time Crunch?";
    self.contentView.text = @"You posted to a college that isn't your Time Crunch college, meaning no hours were added to your Time Crunch. Want to switch your college to this one? All current Time Crunch hours will be wiped.";
    
    [self fixHeights];
    
    [self.button1 setTitle:@"No" forState:UIControlStateNormal];
    [self.button2 setTitle:@"Yes" forState:UIControlStateNormal];
    
    [self.button1 addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 addTarget:^{ NSLog(@"Did not change home college"); } action:@selector(invoke) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button2 addTarget:self.acceptanceBlock action:@selector(invoke) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
