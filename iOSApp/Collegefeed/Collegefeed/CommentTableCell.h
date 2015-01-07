//
//  CommentTableCell.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "PostTableCell.h"
#import "Comment.h"

@interface CommentTableCell : PostTableCell

@property (nonatomic, strong) Comment* object;

- (BOOL)assignWithComment:(Comment *)comment;

@end
