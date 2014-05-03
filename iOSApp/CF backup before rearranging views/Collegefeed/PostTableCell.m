//
//  PostTableCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//
// a subclass of UITableViewCell to enable custom properties

#import "PostTableCell.h"

@implementation PostTableCell

// sythesize properties to automatically generate accessor code
@synthesize messageLabel = _messageLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize commentCountLabel = _commentCountLabel;
@synthesize ageLabel = _ageLabel;
@synthesize upVoteButton = _upVoteButton;
@synthesize downVoteButton = _downVoteButton;

// TODO: collegeLabel

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
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
