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

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell"
                                                 owner:self options:nil];
    self = (PostTableCell *)[nib objectAtIndex:0];
    
    return self;
}
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
        [self.collegeLabel      setText:[post getCollegeName]];
        [self.commentCountLabel setText:[self getCommentLabelString]];
        [self.ageLabel          setText:[self getAgeLabelString:[post getCreated_at]]];
        
        [self findHashTags];
        [self updateVoteButtons];
  
        if ([post hasImage])
        {
            [self populateImageViewFromUrl:[post getImage_url]];
            self.pictureHeight.constant = POST_CELL_PICTURE_HEIGHT_CROPPED;
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
    return [self getMessageHeight:[obj getText]] + LARGE_CELL_TOP_TO_LABEL + LARGE_CELL_LABEL_TO_BOTTOM /*+ CELL_HEIGHT_CUSHION*/ + ([obj hasImage] ? POST_CELL_PICTURE_HEIGHT_CROPPED : 0);
}
- (void)setNearCollege
{
    [self setIsNearCollege:YES];
}
- (void)populateImageViewFromUrl:(NSString *)imgURL
{
    self.pictureView.image = nil;
    [self.pictureActivityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];

        [NSThread sleepForTimeInterval:DELAY_FOR_SLOW_NETWORK];

        // set image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pictureView setImage:[UIImage imageWithData:data]];
            [self.pictureActivityIndicator stopAnimating];
        });
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
    self.collegeLabelViewHeight.constant = 30;
    [self.gpsIconImageView setHidden:!self.object.isNearCollege];
    [self setNeedsDisplay];
}

@end
