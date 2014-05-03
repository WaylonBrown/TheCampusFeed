//
//  CommentTableCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CommentTableCell.h"

@implementation CommentTableCell

// sythesize properties to automatically generate accessor code
@synthesize messageLabel = _messageLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize ageLabel = _ageLabel;
@synthesize upVoteButton = _upVoteButton;
@synthesize downVoteButton = _downVoteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
