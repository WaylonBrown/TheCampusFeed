//
//  TimeCrunchViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 9/25/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TimeCrunchViewController.h"
#import "Shared.h"

@interface TimeCrunchViewController ()

@end

@implementation TimeCrunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.buttonView.layer.cornerRadius = 5;
    
    [self.buttonView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.buttonView.layer setShadowOpacity:0.8];
    [self.buttonView.layer setShadowRadius:2.0];
    [self.buttonView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self.buttonLabel setFont:CF_FONT_LIGHT(22)];
    [self.comingSoonLabel setFont:CF_FONT_LIGHT(20)];
    [self.onOffLabel setFont:CF_FONT_LIGHT(20)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCrunchDialog:(id)sender
{
    
}
@end
