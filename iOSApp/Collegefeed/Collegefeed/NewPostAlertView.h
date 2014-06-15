//
//  NewPostAlertView.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)postButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
