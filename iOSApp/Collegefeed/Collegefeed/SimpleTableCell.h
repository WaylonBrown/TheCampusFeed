//
//  SimpleTableCell.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/11/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tag;
@class College;
@class Achievement;

@interface SimpleTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

- (void)assignTag:(Tag *)tag;
- (void)assignCollege:(College *)college withRankNumberOrNil:(NSNumber *)rankNo;
- (void)assignAchievement:(Achievement *)achievement;

- (void)assignSimpleText:(NSString *)text;
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@end
