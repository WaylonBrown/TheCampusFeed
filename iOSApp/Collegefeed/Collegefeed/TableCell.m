//
//  TableCell.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "TableCell.h"
#import "Post.h"
#import "Vote.h"
#import "PostsViewController.h"
#import "Shared.h"
#import "Tag.h"
#import "Comment.h"

@implementation TableCell

#pragma mark - Assignments

- (BOOL)assignWithPost:(Post *)post withCollegeLabel:(BOOL)showLabel
{
    if (post == nil)
    {
        [self setObject:nil];
        self.isNearCollege = NO;
        self.gpsIconImageView.hidden = YES;
        self.messageLabel.text = @"Post not found";
        self.collegeLabel.text = @"";
        self.commentCountLabel.text = @"0 comments";
        self.ageLabel.text = @"";
    }
    else
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
        
        [self populateImageForPost:post];
  
        [self setWillDisplayCollege:showLabel];
        
        [self setNeedsLayout];
        
        return YES;
    }
    
    return NO;
}
- (void)populateImageForPost:(Post *)post
{
    self.pictureHeight.constant = [post hasImage] ? POST_CELL_PICTURE_HEIGHT_CROPPED : 0;
    self.pictureView.image = nil;
    [self.pictureActivityIndicator stopAnimating];
    [self setNeedsLayout];
    
    if ([post hasImage])
    {
        NSLog(@"TableCell assigning image to post");
        [self.pictureActivityIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *imgURL = [post getImage_url];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
            
            [NSThread sleepForTimeInterval:DELAY_FOR_SLOW_NETWORK];
            
            // set image on main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data == nil)
                {
                    NSLog(@"TableCell unsuccessful at fetching image");
                    self.pictureHeight.constant = 0;
                    [self setNeedsLayout];
                    [self layoutIfNeeded];
                }
                else
                {
                    NSLog(@"TableCell successfully fetched image");
                    [self.pictureView setImage:[UIImage imageWithData:data]];
                    [post setImage:[UIImage imageWithData:data]];
                }
                
                [self.pictureActivityIndicator stopAnimating];
                [self setNeedsLayout];

            });
        });
    }
    
    [self layoutIfNeeded];
}
- (BOOL)assignWithComment:(Comment *)comment
{
    if (comment != nil)
    {
        [self setObject:comment];
        self.isNearCollege = comment.isNearCollege;
        
        [self setWillDisplayCollege:NO];
        [self.commentCountLabel setHidden:YES];
        
        self.pictureHeight.constant = 0;
        
        self.messageLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        [self.messageLabel setText:[comment getText]];
        
        [self.ageLabel setText:[self getAgeLabelString:[comment getCreated_at]]];
        
        [self findHashTags];
        [self updateVoteButtons];
        
        [self setNeedsDisplay];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Actions

- (IBAction)upVotePressed:(id)sender
{   // User clicked upvote button
    
    id<ChildCellDelegate> strongDelegate = self.delegate;
    
    Vote *existingVote = [self.object getVote];
    
    Vote *newVote = [[Vote alloc] initWithVoteId:-1 WithParentId:[[self.object getID] longValue] WithUpvoteValue:YES AsVotableType:[self.object getType]];
    [newVote setCollegeId:[[self.object getCollege_id] longValue]];
    
    if (existingVote == nil)
    {   // User is submitting a normal upvote
    
        [self.object setVote:newVote];
        [self.object incrementScore];
        [self updateVoteButtons];
        [strongDelegate castVote:newVote];
    }
    else
    {
        if (existingVote.upvote == true)
        {   // User is undoing an existing upvote; cancel it
            [self.object setVote:nil];
            [self.object decrementScore];
            [self updateVoteButtons];
            [strongDelegate cancelVote:existingVote];
        }
        else if (existingVote.upvote == false)
        {   // User is changing their downvote to an upvote;
            // cancel downvote and cast an upvote
            [self.object setVote:newVote];
            [self.object incrementScore];
            [self.object incrementScore];
            [self updateVoteButtons];
            [strongDelegate cancelVote:existingVote];
            [strongDelegate castVote:newVote];
        }
    }
}
- (IBAction)downVotePresed:(id)sender
{   // User clicked downvote button
    id<ChildCellDelegate> strongDelegate = self.delegate;

    if (!self.isNearCollege)
    {
        [strongDelegate displayCannotVote];
        return;
    }
    
    Vote *existingVote = [self.object getVote];
    Vote *newVote = [[Vote alloc] initWithVoteId:-1 WithParentId:[[self.object getID] longValue]
                                    WithUpvoteValue:NO
                                      AsVotableType:[self.object getType]];
    [newVote setCollegeId:[[self.object getCollege_id] longValue]];
    
    if (existingVote == nil)
    {   // User is submitting a normal downvote

        [self.object setVote:newVote];
        [self.object decrementScore];
        [self updateVoteButtons];
        [strongDelegate castVote:newVote];
    }
    else
    {
        if (existingVote.upvote == false)
        {   // User is undoing an existing downvote; cancel it
            [self.object setVote:nil];
            [self.object incrementScore];
            [self updateVoteButtons];
            [strongDelegate cancelVote:existingVote];
        }
        else if (existingVote.upvote == true)
        {   // User is changing their upvote to a downvote
            // cancel upvote and cast an downvote
            [self.object setVote:newVote];
            [self.object decrementScore];
            [self.object decrementScore];
            [self updateVoteButtons];
            [strongDelegate cancelVote:existingVote];
            [strongDelegate castVote:newVote];
        }
    }
    
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *tagMessage = [url absoluteString];
    [self.delegate didSelectTag:tagMessage];
}
- (void)setNearCollege
{
    [self setIsNearCollege:YES];
}

#pragma mark - Helper Methods

- (NSString *)getAgeLabelString:(NSDate *)creationDate
{   // return string indicating how long ago the post was created
    
    if (creationDate == nil) return @"";
        
    int seconds = [[NSDate date] timeIntervalSinceDate:creationDate];
    int minutes = seconds / 60;
    int hours = minutes / 60;
    int days = hours / 24;

    if (days > 1)
    {
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    else if (days == 1)
    {
        return @"Yesterday";
    }
    else if (hours > 1)
    {
        return [NSString stringWithFormat:@"%d hours ago", hours];
    }
    else if (hours == 1)
    {
        return @"One hour ago";
    }
    else if (minutes > 1)
    {
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
    else if (minutes == 1)
    {
        return @"One minute ago";
    }
    return [NSString stringWithFormat:@"%d seconds ago", seconds];
}
- (NSString *)getCommentLabelString
{   // Gets a string for the comment count label if this cell represents a Post
    if ([self.object class] == [Post class])
    {
        NSNumber *count = ((Post *)self.object).comment_count;
        long countLongValue = [count longValue];
        return [NSString stringWithFormat:@"%ld comments",
                countLongValue];
    }
    return @"";
}
- (void)findHashTags
{   // parse cell's message label to assign links to hashtagged words
    [self.messageLabel setDelegate:self];
    NSCharacterSet *acceptableSet = [NSCharacterSet characterSetWithCharactersInString:@"qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789#_"];
    NSCharacterSet *unacceptableSet = [acceptableSet invertedSet];
    NSArray *words = [self.messageLabel.text componentsSeparatedByCharactersInSet:unacceptableSet];
    
    for (NSString *word in words)
    {
        if ([Tag withMessageIsValid:word])
        {
            NSRange range = [self.messageLabel.text rangeOfString:word];
            
            NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName, (id)kCTUnderlineStyleAttributeName,  nil];
            NSArray *objects = [[NSArray alloc] initWithObjects:[Shared getCustomUIColor:CF_LIGHTBLUE],[NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
            NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            
            self.messageLabel.linkAttributes = linkAttributes;
            self.messageLabel.activeLinkAttributes = linkAttributes;
            
            [self.messageLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", word]]
                                  withRange:range];
        }
    }
}
- (void)updateVoteButtons
{   // assign appropriate arrow colors (based on user's vote)
    Vote* vote = [self.object getVote];

    if (vote == nil)
    {
        [self.upVoteButton setSelected:NO];
        [self.downVoteButton setSelected:NO];
    }
    else if (vote.upvote == NO)
    {
        [self.upVoteButton setSelected:NO];
        [self.downVoteButton setSelected:YES];
    }
    else if (vote.upvote == YES)
    {
        [self.upVoteButton setSelected:YES];
        [self.downVoteButton setSelected:NO];
    }

    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld", [[self.object getScore] longValue]]];
}
- (void)setWillDisplayCollege:(BOOL)showLabel
{
    self.collegeLabel.hidden = !showLabel;
    self.gpsIconImageView.hidden = !showLabel;
    self.dividerView.hidden = !showLabel;
    
    self.collegeLabelViewHeight.constant = showLabel ? POST_CELL_COLLEGE_LABEL_VIEW_HEIGHT : 0;
}

@end
