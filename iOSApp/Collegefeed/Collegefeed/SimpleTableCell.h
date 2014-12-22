//
//  SimpleTableCell.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/11/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableCellProtocol.h"

@class Tag;
@class College;

@interface SimpleTableCell : UITableViewCell <TableCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

- (void)assignTag:(Tag *)tag;
- (void)assignCollege:(College *)college withRankNumberOrNil:(NSNumber *)rankNo;// withMessageHeight:(float)height;
- (void)assignSimpleText:(NSString *)text;
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@end
