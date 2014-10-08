//
//  SimpleTableCell.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/11/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tag;
@class College;

@interface SimpleTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

- (void)assignTag:(Tag *)tag;
- (void)assignCollege:(College *)college withRankNumber:(long)rankNo withMessageHeight:(float)height;
- (void)assignSimpleText:(NSString *)text;
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@end
