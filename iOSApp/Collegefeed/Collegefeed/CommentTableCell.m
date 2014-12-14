//
//  CommentTableCell.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CommentTableCell.h"

@implementation CommentTableCell

- (BOOL)assignmentSuccessWith:(NSObject *)obj
{
    if ([obj class] != [Comment class])
        return NO;
    
    return [self assignWithComment:(Comment *)obj];
}
- (BOOL)assignWithComment:(Comment *)comment
{
    if ([super assignmentSuccessWith:comment])
    {
        [self setObject:comment];
        
        [super shouldShowCollegeLabel:NO];
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
- (CGFloat)getMessageHeight
{
    return [super getMessageHeight];
}
- (CGFloat)getCellHeight
{
    return [super getCellHeight];
}

+ (CGFloat)getCellHeight:(Comment *)obj
{
    return [super getCellHeight:obj];
}
+ (CGFloat)getMessageHeight:(NSString *)text
{
    return [super getMessageHeight:text];
}

@end
