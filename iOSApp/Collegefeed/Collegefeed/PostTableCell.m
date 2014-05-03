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

// called when user upvotes a comment; just change arrow colors
- (IBAction)handleUpVote:(id)sender
{
    if ([_upVoteButton isSelected])
    {   // deselect upvote
        [_upVoteButton setImage:[UIImage imageNamed:@"arrowup.png"] forState:UIControlStateNormal];
        [_upVoteButton setSelected:NO];
    }
    else
    {   // select upvote, deselect downvote
        [_upVoteButton setImage:[UIImage imageNamed:@"arrowupblue.png"] forState:UIControlStateSelected];
        [_upVoteButton setSelected:YES];
        
        [_downVoteButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        [_downVoteButton setSelected:NO];
    }
}
// called when user downvotes a comment; just change arrow colors
- (IBAction)handleDownVote:(id)sender
{
    if ([_downVoteButton isSelected])
    {   // deselect downvote
        [_downVoteButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        [_downVoteButton setSelected:NO];
    }
    else
    {   // select downvote, deselect upvote
        [_downVoteButton setImage:[UIImage imageNamed:@"arrowdownred.png"] forState:UIControlStateSelected];
        [_downVoteButton setSelected:YES];
        
        [_upVoteButton setImage:[UIImage imageNamed:@"arrowup.png"] forState:UIControlStateNormal];
        [_upVoteButton setSelected:NO];
    }
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
