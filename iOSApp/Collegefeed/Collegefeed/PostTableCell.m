//
//  PostTableCell.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "PostTableCell.h"

@implementation PostTableCell

- (BOOL)assignWithPost:(Post *)post withCollegeLabel:(BOOL)showLabel
{
    if (post != nil)
    {
        [self setObject:post];
        
        self.isNearCollege = post.isNearCollege;
        [self.gpsIconImageView setHidden:post.isNearCollege];
        
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
        
        [self attemptDisplayCollegeView:showLabel];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        return YES;
    }
    
    return NO;
}
- (CGFloat)getMessageHeight
{
    return [PostTableCell getMessageHeight:[self.object getText]];
}
- (CGFloat)getCellHeightWithCollege:(BOOL)withCollege
{
    return [PostTableCell getCellHeightWithObject:self.object withCollege:withCollege];
}
+ (CGFloat)getCellHeightWithObject:(Post *)obj withCollege:(BOOL)withCollege
{
    return [self getMessageHeight:[obj getText]] + LARGE_CELL_TOP_TO_LABEL + LARGE_CELL_LABEL_TO_BOTTOM + ([obj hasImage] ? POST_CELL_PICTURE_HEIGHT_CROPPED : 0) + (withCollege ? DEFAULT_COLLEGE_LABEL_HEIGHT : 0);
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
- (void)attemptDisplayCollegeView:(BOOL)showLabel
{
    [self.collegeLabel setHidden:!showLabel];
    [self.gpsIconImageView setHidden:!showLabel];
    self.collegeLabelViewHeight.constant = showLabel ? POST_CELL_COLLEGE_LABEL_VIEW_HEIGHT : 0;
}

@end
