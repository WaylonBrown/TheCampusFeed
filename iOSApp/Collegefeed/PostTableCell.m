//
//  PostTableCell.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostTableCell.h"

// Represents the most basic cell for Posts (no images or college names)
@implementation PostTableCell

- (BOOL)assignmentSuccessWith:(Post *)post
{
    if ([super assignmentSuccessWith:post])
    {
        [self setObject:post];
        
        [self.gpsIconImageView setHidden:post.isNearCollege];
        self.messageHeight.constant = [self getMessageHeight];;
        
        // assign cell's plain text labels
        self.messageLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        [self.messageLabel      setText:[post getText]];
        [self.commentCountLabel setText:[self getCommentLabelString]];
        [self.ageLabel          setText:[self getAgeLabelString:[post getCreated_at]]];
        
        [self.dividerHeight setConstant:0];
        [self.collegeLabelHeight setConstant:0];
        
        // Parse message for Tags
        [self findHashTags];
        
        // assign arrow colors according to user's vote
        [self updateVoteButtons];
        
        [self setNeedsDisplay];
        
        return YES;
    }
    
    return NO;
}

- (CGFloat)getMessageHeight
{
    return [PostTableCell getMessageHeight:[self.object getText]];
}

- (CGFloat)getCellHeight
{
    #define CELL_HEIGHT_CUSHION 13
    
    return [self getMessageHeight] + LARGE_CELL_TOP_TO_LABEL + LARGE_CELL_LABEL_TO_BOTTOM + CELL_HEIGHT_CUSHION;
}

+ (CGFloat)getCellHeight:(Post *)obj
{
    return [self getMessageHeight:[obj getText]] + LARGE_CELL_TOP_TO_LABEL + LARGE_CELL_LABEL_TO_BOTTOM + CELL_HEIGHT_CUSHION;
    
}
- (void)setNearCollege
{
    [self setIsNearCollege:YES];
}

@end
