//
//  TableCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TableCell.h"
#import "Post.h"
#import "Vote.h"
#import "PostsViewController.h"
#import "ChildCellDelegate.h"
#import "Shared.h"
#import "Tag.h"
#import "Comment.h"

@implementation TableCell

#pragma mark - Autogenerated Stubs

- (void)awakeFromNib
{
    // Initialization code
    
    UIImage *image = [UIImage imageNamed:@"card_without_9patch.png"];
    UIImage *stretchableBackground = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 5, 8, 6) resizingMode:UIImageResizingModeStretch];
    self.backgroundImageView.image = stretchableBackground;
    
    // Set font styles
    [self.messageLabel      setFont:CF_FONT_LIGHT(16)];
    [self.commentCountLabel setFont:CF_FONT_MEDIUM(12)];
    [self.ageLabel          setFont:CF_FONT_MEDIUM(12)];
    [self.scoreLabel        setFont:CF_FONT_BOLD(12)];
    [self.collegeLabel      setFont:CF_FONT_ITALIC(14)];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Data Population

- (void)assignWith:(Post *)post IsNearCollege:(BOOL)isNearby WithMessageHeight:(float)height;
{
    [self.gpsIconImageView setHidden:(!isNearby)];
    [self assign:post WithMessageHeight:height];
}

- (void)assign:(NSObject<PostAndCommentProtocol, CFModelProtocol> *)obj WithMessageHeight:(float)height;
{   // configure view of the cell according to obj's properties
    
    if (obj == nil)
    {
        NSLog(@"Error assigning properties to table cell");
        return;
    }
    
    self.postMessageHeight.constant = height;

    [self setObject:obj];
    
    // assign cell's plain text labels
    [self.messageLabel      setText:[obj getMessage]];
    [self.commentCountLabel setText:[self getCommentLabelString]];
    [self.ageLabel          setText:[self getAgeAsString:[obj getCreatedAt]]];
    
    if ([obj getType] == POST)
    {
        [self.collegeLabel      setText:[obj getCollegeName]];
    }
    else
    {
        self.dividerHeight.constant = 0;
        self.collegeLabelHeight.constant = 0;        
    }

    // Parse message for Tags
    [self findHashTags];

    // assign arrow colors according to user's vote
    [self updateVoteButtons];
    
    [self setNeedsDisplay];
}

#pragma mark - Actions

- (IBAction)upVotePressed:(id)sender
{   // User clicked upvote button
    
    id<ChildCellDelegate> strongDelegate = self.delegate;
    
    Vote *existingVote = [self.object getVote];
    Vote *newVote = [[Vote alloc] initWithParentID:[self.object getID]
                                    withUpvoteValue:true
                                      asVotableType:[self.object getType]];
    [newVote setCollegeId:[self.object getCollegeID]];
    
    if (existingVote == nil)
    {   // User is submitting a normal upvote
        if ([strongDelegate castVote:newVote])
        {
            [self.object setVote:newVote];
            [self.object incrementScore];
        }
    }
    else
    {
        [strongDelegate cancelVote:existingVote];
        
        if (existingVote.upvote == true)
        {   // User is undoing an existing upvote; cancel it
            [self.object setVote:nil];
            [self.object decrementScore];
        }
        else if (existingVote.upvote == false)
        {   // User is changing their downvote to an upvote;
            // cancel downvote and cast an upvote
            if ([strongDelegate castVote:newVote])
            {
                [self.object setVote:newVote];
                [self.object incrementScore];
                [self.object incrementScore];
            }
        }
    }
    
    [self updateVoteButtons];
}
- (IBAction)downVotePresed:(id)sender
{   // User clicked downvote button

    id<ChildCellDelegate> strongDelegate = self.delegate;
    
    Vote *existingVote = [self.object getVote];
    Vote *newVote = [[Vote alloc] initWithParentID:[self.object getID]
                                    withUpvoteValue:false
                                      asVotableType:[self.object getType]];
    [newVote setCollegeId:[self.object getCollegeID]];
    
    if (existingVote == nil)
    {   // User is submitting a normal upvote
        if ([strongDelegate castVote:newVote])
        {
            [self.object setVote:newVote];
            [self.object decrementScore];
        }
    }
    else
    {
        [strongDelegate cancelVote:existingVote];
        
        if (existingVote.upvote == false)
        {   // User is undoing an existing downvote; cancel it
            [self.object setVote:nil];
            [self.object incrementScore];
        }
        else if (existingVote.upvote == true)
        {   // User is changing their upvote to a downvote
            // cancel upvote and cast an downvote
            if ([strongDelegate castVote:newVote])
            {
                [self.object setVote:newVote];
                [self.object decrementScore];
                [self.object decrementScore];
            }
        }
    }
    
    [self updateVoteButtons];
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *tagMessage = [url absoluteString];
    [self.delegate didSelectTag:tagMessage];
}

#pragma mark - Helper Methods

- (NSString *)getAgeAsString:(NSDate *)creationDate
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
        return [NSString stringWithFormat:@"%d comments",
                (int)((Post*)self.object).commentCount];
    }
    return @"";
}
- (void)findHashTags
{   // parse cell's message label to assign links to hashtagged words
    [self.messageLabel setDelegate:self];
    NSArray *words = [self.messageLabel.text componentsSeparatedByString:@" "];
    for (NSString *word in words)
    {
        if ([Tag withMessageIsValid:word])
        {
            NSRange range = [self.messageLabel.text rangeOfString:word];
            
            NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName, (id)kCTUnderlineStyleAttributeName, nil];
            NSArray *objects = [[NSArray alloc] initWithObjects:[Shared getCustomUIColor:CF_LIGHTBLUE],[NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
            NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            
            self.messageLabel.linkAttributes = linkAttributes;
            
            
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
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld", [self.object getScore]]];
}

// Old way of assigning; probably slower but not sure yet
//- (void)updateVoteButtons
//{   // assign appropriate arrow colors (based on user's vote)
//    Vote* vote = [self.object getVote];
//    UIImage *regularUp      = [UIImage imageNamed:@"arrowup.png"];
//    UIImage *regularDown    = [UIImage imageNamed:@"arrowdown.png"];
//    UIImage *selectedUp     = [UIImage imageNamed:@"arrowupblue.png"];
//    UIImage *selectedDown   = [UIImage imageNamed:@"arrowdownred.png"];
//    
//    if (vote == nil)
//    {
//        [self.upVoteButton setImage:regularUp
//                           forState:UIControlStateNormal];
//        [self.downVoteButton setImage:regularDown
//                             forState:UIControlStateNormal];
//    }
//    else if (vote.upvote == NO)
//    {
//        [self.upVoteButton setImage:regularUp
//                           forState:UIControlStateNormal];
//        [self.downVoteButton setImage:selectedDown
//                             forState:UIControlStateNormal];
//    }
//    else if (vote.upvote == YES)
//    {
//        [self.upVoteButton setImage:selectedUp
//                           forState:UIControlStateNormal];
//        [self.downVoteButton setImage:regularDown
//                             forState:UIControlStateNormal];
//    }
//    
//    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld", [self.object getScore]]];
//}

@end
