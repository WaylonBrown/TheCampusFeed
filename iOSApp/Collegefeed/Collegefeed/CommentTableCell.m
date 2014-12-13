//
//  CommentTableCell.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CommentTableCell.h"

@implementation CommentTableCell

- (BOOL)assignmentSuccessWith:(Comment *)comment
{
    if ([super assignmentSuccessWith:comment])
    {
        [self setObject:comment];
        
        [self.gpsIconImageView setHidden:YES];
        self.collegeLabelViewHeight.constant = 0;
        self.pictureHeight.constant = 0;
        self.messageHeight.constant = [self getMessageHeight];;
        
        // assign cell's plain text labels
        self.messageLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        [self.messageLabel      setText:[comment getText]];
        [self.commentCountLabel setText:[self getCommentLabelString]];
        [self.ageLabel          setText:[self getAgeLabelString:[comment getCreated_at]]];
        
        [self findHashTags];
        [self updateVoteButtons];
        
        
        [self setNeedsDisplay];
        
        return YES;
    }
    
    return NO;
}


@end
