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

- (BOOL)assignWithPost:(Post *)post withCollegeLabel:(BOOL)showLabel;
- (void)setNearCollege;
- (void)shouldShowCollegeLabel:(BOOL)showLabel;

+ (CGFloat)getMessageHeight;
- (CGFloat)getCellHeightWithCollege:(BOOL)withCollege;
+ (CGFloat)getCellHeightWithObject:(Post *)obj withCollege:(BOOL)withCollege;

@end