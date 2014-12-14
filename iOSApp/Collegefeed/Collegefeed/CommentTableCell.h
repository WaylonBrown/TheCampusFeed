//
//  CommentTableCell.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostTableCell.h"
#import "Comment.h"

@interface CommentTableCell : PostTableCell<TableCellProtocol>

@property (nonatomic, strong) Comment* object;

- (BOOL)assignWithComment:(Comment *)comment;

@end
