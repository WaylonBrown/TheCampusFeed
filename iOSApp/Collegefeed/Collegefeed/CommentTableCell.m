//
//  CommentTableCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CommentTableCell.h"
#import "Comment.h"

@implementation CommentTableCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setComment:(Comment*)newComment
{
    _comment = newComment;
    [self assignProperties];
}
- (void)assignProperties
{
    if (self.comment == nil)
    {
        [NSException raise:@"Error assigning properties to a comment cell" format:@"CommentTableCell does not have a comment reference"];
        return;
    }
        
    // assign cell's text labels
    [self.ageLabel setText: [self getAgeAsString:(NSDate*)self.comment.date]];
    [self.messageLabel setText:self.comment.commentMessage];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", (int)self.comment.score]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtonsWithVoteValue:self.comment.vote];
}

- (IBAction)upVotePressed:(id)sender
{
    if (self.comment != nil)
    {
        [self.comment setVote:(self.comment.vote == 1 ? 0 : 1)];
        [self updateVoteButtonsWithVoteValue:self.comment.vote];
    }
    else
    {
        self.dummyVoteValue = self.dummyVoteValue == 1 ? 0 : 1;
        [self updateVoteButtonsWithVoteValue:self.dummyVoteValue];
    }
}

- (IBAction)downVotePresed:(id)sender
{
    if (self.comment != nil)
    {
        self.comment.vote = self.comment.vote == -1 ? 0 : -1;
        [self updateVoteButtonsWithVoteValue:self.comment.vote];
    }
    else
    {
        self.dummyVoteValue = self.dummyVoteValue == -1 ? 0 : -1;
        [self updateVoteButtonsWithVoteValue:self.dummyVoteValue];
    }
}
@end
