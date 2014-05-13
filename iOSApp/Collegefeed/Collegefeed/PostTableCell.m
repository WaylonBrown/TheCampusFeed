//
//  PostTableCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//
// a subclass of UITableViewCell to enable custom properties

#import "PostTableCell.h"
#import "Post.h"
#import "PostsViewController.h"

@implementation PostTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setPost:(Post *)post
{
    _post = post;
    [self assignProperties];
}
// configure view of the cell according to a post
- (void) assignPropertiesWithPost:(Post *)post
{
    if (post == nil) return;
    
    NSDate *d = (NSDate*)[post date];
    NSString *myAgeLabel = [self getAgeAsString:d];
    
    // assign cell's text labels
    [self.ageLabel setText: myAgeLabel];
    [self.messageLabel setText:post.message];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", (int)post.score]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%d comments", (int)post.commentList.count]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtonsWithVoteValue:post.vote];
}
// configure view of the cell according to the post's delegate ID
- (void) assignProperties
{
    if (self.post == nil)
    {
        [NSException raise:@"Error assign properties to a post cell" format:@"PostTableCell does not have a post reference"];
        return;
    }
    
    Post *post = self.post;
    
    NSDate *d = (NSDate*)[post date];
    NSString *myAgeLabel = [self getAgeAsString:d];
    
    // assign cell's message label and look for hashtags
//    [self.messageLabel setDelegate:self];
    [self.messageLabel setText:post.message];
    NSArray *words = [self.messageLabel.text componentsSeparatedByString:@" "];
    for (NSString *word in words)
    {
        if ([word hasPrefix:@"#"])
        {
            NSRange range = [self.messageLabel.text rangeOfString:word];
            
            [self.messageLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"action://tags?%@", word]] withRange:range];
        }
    }

//    NSRange range = [self.messageLabel.text rangeOfString:@"#"];
//    self.messageLabel add
//    [self.messageLabel addLinkToURL:[NSURL URLWithString:@"google.com"] withRange:range];
    
    // assign cell's plain text labels
    [self.ageLabel setText: myAgeLabel];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", (int)post.score]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%d comments", (int)post.commentList.count]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtonsWithVoteValue:post.vote];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"hash"]) {
            /* load help screen */
//            UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"viewTags" bundle:nil];
//            OIOI_VC_ViewTags *viewController =[storyboard instantiateViewControllerWithIdentifier:@"viewTags"];
//            viewController.str_word = ??????;
//            [self.navigationController pushViewController:viewController animated:YES];
            
        }
    }
}
- (NSString *)getAgeAsString:(NSDate *)creationDate
{   // return string indicating how long ago the post was created

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

- (void) updateVoteButtonsWithVoteValue:(int)vote
{
    // assign appropriate arrow colors (based on user's vote)
    switch (vote)
    {
        case -1:
            [self.upVoteButton setImage:[UIImage imageNamed:@"arrowup.png"] forState:UIControlStateNormal];
            [self.downVoteButton setImage:[UIImage imageNamed:@"arrowdownred.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.upVoteButton setImage:[UIImage imageNamed:@"arrowupblue.png"] forState:UIControlStateNormal];
            [self.downVoteButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            break;
        default:
            [self.upVoteButton setImage:[UIImage imageNamed:@"arrowup.png"] forState:UIControlStateNormal];
            [self.downVoteButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            break;
    }
    
//    [self setNeedsDisplay];
}
- (IBAction)upVotePressed:(id)sender
{
    if (self.post != nil)
    {
        Post *post = self.post;
        [post setVote:(post.vote == 1 ? 0 : 1)];
        [self updateVoteButtonsWithVoteValue:post.vote];
    }
    else
    {
        self.dummyVoteValue = self.dummyVoteValue == 1 ? 0 : 1;
        [self updateVoteButtonsWithVoteValue:self.dummyVoteValue];
    }
}

- (IBAction)downVotePresed:(id)sender
{
    if (self.post != nil)
    {
        Post *post = self.post;
        post.vote = post.vote == -1 ? 0 : -1;
        [self updateVoteButtonsWithVoteValue:post.vote];
    }
    else
    {
        self.dummyVoteValue = self.dummyVoteValue == -1 ? 0 : -1;
        [self updateVoteButtonsWithVoteValue:self.dummyVoteValue];
    }
}

@end