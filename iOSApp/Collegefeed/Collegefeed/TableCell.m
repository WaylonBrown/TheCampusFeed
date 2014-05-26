//
//  TableCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TableCell.h"
#import "Votable.h"
#import "Post.h"
#import "Vote.h"
#import "PostsViewController.h"

@implementation TableCell

#pragma mark - Autogenerated Stubs

- (void)awakeFromNib
{
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Data Population

- (void)assign:(Votable *)obj;
{   // configure view of the cell according to obj's properties
    
    if (obj == nil)
    {
        [NSException raise:@"Error assigning properties to table cell"
                    format:@"Cell does not have a valid Votable reference"];
        return;
    }

    [self setObject:obj];
    
    // assign cell's plain text labels
    [self.ageLabel setText: [self getAgeAsString:(NSDate*)[obj date]]];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", (int)obj.score]];
    [self.messageLabel setText:obj.message];
    [self.commentCountLabel setText:[self getCommentLabelString]];
    [self.collegeLabel setText:obj.collegeName];
    
    // Parse message for Tags
    [self findHashTags];

    // assign arrow colors according to user's vote
    [self updateVoteButtons];
}

#pragma mark - Actions

- (IBAction)upVotePressed:(id)sender
{   // User clicked upvote button
    [self.object castVote:YES];
    [self updateVoteButtons];
    
    id<ChildCellDelegate> strongDelegate = self.delegate;
    [strongDelegate castVote:[[Vote alloc] initWithVotableID:self.object.getID
                                            withUpvoteValue:YES]];
}
- (IBAction)downVotePresed:(id)sender
{   // User clicked downvote button
    [self.object castVote:NO];
    [self updateVoteButtons];
    
    id<ChildCellDelegate> strongDelegate = self.delegate;
    [strongDelegate castVote:[[Vote alloc] initWithVotableID:self.object.getID
                                             withUpvoteValue:YES]];
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString* tagMessage = [url absoluteString];
    PostsViewController *controller = [[PostsViewController alloc] init];

    
    PostsViewController *strongDelegate = (PostsViewController*)self.delegate;
    [strongDelegate.navigationController pushViewController:controller animated:YES];

    // [self.navigationController pushViewController:controller animated:YES];

    NSLog(@"tag = %@", tagMessage);
}

#pragma mark - Helper Methods

- (NSString *)getAgeAsString:(NSDate *)creationDate
{   // return string indicating how long ago the post was created
    
    if (creationDate == nil) return @"";
        
    int seconds = [[NSDate date] timeIntervalSinceDate:creationDate];
    int minutes = seconds / 60;
    int hours = minutes / 60;
    
    if (hours >= 1)
    {
        return [NSString stringWithFormat:@"%d hours ago", hours];
    }
    else if (minutes >= 1)
    {
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
    return [NSString stringWithFormat:@"%d seconds ago", seconds];
}
- (NSString *)getCommentLabelString
{   // Gets a string for the comment count label if this cell represents a Post
    if ([self.object class] == [Post class])
    {
        return [NSString stringWithFormat:@"%d comments",
                (int)((Post*)self.object).commentList.count];
    }
    return @"";
}
- (void)findHashTags
{   // parse cell's message label to assign links to hashtagged words
    [self.messageLabel setDelegate:self];
    NSArray *words = [self.messageLabel.text componentsSeparatedByString:@" "];
    for (NSString *word in words)
    {
        if ([word hasPrefix:@"#"])
        {
            NSRange range = [self.messageLabel.text rangeOfString:word];
            
            [self.messageLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", word]]
                                  withRange:range];
        }
    }

}
- (void)updateVoteButtons
{   // assign appropriate arrow colors (based on user's vote)
    Vote* vote = self.object.vote;
    UIImage *regularUp      = [UIImage imageNamed:@"arrowup.png"];
    UIImage *regularDown    = [UIImage imageNamed:@"arrowdown.png"];
    UIImage *selectedUp     = [UIImage imageNamed:@"arrowupblue.png"];
    UIImage *selectedDown   = [UIImage imageNamed:@"arrowdownred.png"];

    if (vote == nil)
    {
        [self.upVoteButton setImage:regularUp
                           forState:UIControlStateNormal];
        [self.downVoteButton setImage:regularDown
                             forState:UIControlStateNormal];
    }
    else if (vote.upvote == NO)
    {
            [self.upVoteButton setImage:regularUp
                               forState:UIControlStateNormal];
            [self.downVoteButton setImage:selectedDown
                                 forState:UIControlStateNormal];
    }
    else if (vote.upvote == YES)
    {
        [self.upVoteButton setImage:selectedUp
                           forState:UIControlStateNormal];
        [self.downVoteButton setImage:regularDown
                             forState:UIControlStateNormal];
    }
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", self.object.score]];
}

@end
