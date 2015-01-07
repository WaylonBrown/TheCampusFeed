//
//  PostTableCell.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "TableCell.h"
#import "Post.h"
#import "Constants.h"
#import "Shared.h"
#import "ChildCellDelegate.h"

@interface PostTableCell : TableCell

@property (nonatomic, strong) Post* object;

- (BOOL)assignWithPost:(Post *)post withCollegeLabel:(BOOL)showLabel;
- (void)setNearCollege;
- (void)setWillDisplayCollege:(BOOL)showLabel;

@end