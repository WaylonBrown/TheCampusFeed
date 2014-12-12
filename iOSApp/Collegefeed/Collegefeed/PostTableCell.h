//
//  PostTableCell.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TableCell.h"
#import "Post.h"
#import "Constants.h"
#import "Shared.h"
#import "ChildCellDelegate.h"

@interface PostTableCell : TableCell<TableCellProtocol>

@property (nonatomic, strong) Post* object;
@property (weak, nonatomic) IBOutlet UIImageView *collegeLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collegeLabelViewHeight;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *pictureActivityIndicator;

- (void)setNearCollege;
- (void)hideCollegeLabel;
- (void)showCollegeLabel;

@end