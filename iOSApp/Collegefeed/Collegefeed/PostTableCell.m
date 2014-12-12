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
        
        if ([post hasImage])
        {
            [self populateImageViewFromUrl:[post getImage_url]];
            self.pictureHeight.constant = CELL_CROPPED_PICTURE_HEIGHT;
        }
        else
        {
            self.pictureHeight.constant = 0;
        }
        
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
    
    return [self getMessageHeight] + LARGE_CELL_TOP_TO_LABEL + LARGE_CELL_LABEL_TO_BOTTOM  /*+ CELL_HEIGHT_CUSHION*/ + self.pictureHeight.constant + self.collegeLabelViewHeight.constant;
}
+ (CGFloat)getCellHeight:(Post *)obj
{
    return [self getMessageHeight:[obj getText]] + LARGE_CELL_TOP_TO_LABEL + LARGE_CELL_LABEL_TO_BOTTOM /*+ CELL_HEIGHT_CUSHION*/ + ([obj hasImage] ? CELL_CROPPED_PICTURE_HEIGHT : 0);
}
- (void)setNearCollege
{
    [self setIsNearCollege:YES];
}
- (void)populateImageViewFromUrl:(NSString *)imgURL
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
//        //set your image on main thread.
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.pictureView setImage:[UIImage imageWithData:data]];
//        });
    });
}
- (void)hideCollegeLabel
{
    self.collegeLabelViewHeight.constant = 0;
    [self.gpsIconImageView setHidden:YES];
    [self setNeedsDisplay];
}
- (void)showCollegeLabel
{
    UIImage *image = [UIImage imageNamed:@"card_without_9patch.png"];
    UIImage *stretchableBackground = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 8, 6) resizingMode:UIImageResizingModeStretch];
    self.collegeLabelView.image = stretchableBackground;
    
    self.collegeLabelViewHeight.constant = 30;
    [self.gpsIconImageView setHidden:!self.object.isNearCollege];
    [self setNeedsDisplay];
}

@end
