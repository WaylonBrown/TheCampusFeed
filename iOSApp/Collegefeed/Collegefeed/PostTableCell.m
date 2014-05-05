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

@implementation PostTableCell

// sythesize properties to automatically generate accessor code
//@synthesize post = _post;

@synthesize messageLabel = _messageLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize commentCountLabel = _commentCountLabel;
@synthesize ageLabel = _ageLabel;
@synthesize upVoteButton = _upVoteButton;
@synthesize downVoteButton = _downVoteButton;
@synthesize collegeLabel = _collegeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
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
    NSString *myAgeLabel = [self getAgeOfPostAsString:d];
    
    // assign cell's text labels
    [_ageLabel setText: myAgeLabel];
    [_messageLabel setText:post.message];
    [_scoreLabel setText:[NSString stringWithFormat:@"%d", (int)post.score]];
    [_commentCountLabel setText:[NSString stringWithFormat:@"%d comments", (int)post.commentList.count]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtonsWithVoteValue:post.vote];
}

// configure view of the cell according to the post's delegate ID
- (void) assignProperties
{
    if (self.post == nil) return;
    
    Post *post = self.post;
    
    NSDate *d = (NSDate*)[post date];
    NSString *myAgeLabel = [self getAgeOfPostAsString:d];
    
    // assign cell's text labels
    [_ageLabel setText: myAgeLabel];
    [_messageLabel setText:post.message];
    [_scoreLabel setText:[NSString stringWithFormat:@"%d", (int)post.score]];
    [_commentCountLabel setText:[NSString stringWithFormat:@"%d comments", (int)post.commentList.count]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtonsWithVoteValue:post.vote];
    
}

// return string indicating how long ago the post was created
- (NSString *)getAgeOfPostAsString:(NSDate *)postDate
{
    int postAgeSeconds = [[NSDate date] timeIntervalSinceDate:postDate];
    int postAgeMinutes = postAgeSeconds / 60;
    int postAgeHours = postAgeMinutes / 60;
    
    if (postAgeHours >= 1)
    {
        return [NSString stringWithFormat:@"%d hours ago", postAgeHours];
    }
    else if (postAgeMinutes >= 1)
    {
        return [NSString stringWithFormat:@"%d minutes ago", postAgeMinutes];
    }
    return [NSString stringWithFormat:@"%d seconds ago", postAgeSeconds];
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
    
    [self setNeedsDisplay];
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