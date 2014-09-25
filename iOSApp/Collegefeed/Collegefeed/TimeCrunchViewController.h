//
//  TimeCrunchViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 9/25/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TimeCrunchViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *onOffLabel;
@property (strong, nonatomic) IBOutlet UILabel *comingSoonLabel;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UILabel *buttonLabel;
- (IBAction)showCrunchDialog:(id)sender;

@end
