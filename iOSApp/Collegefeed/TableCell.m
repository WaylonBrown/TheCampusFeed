//
//  TableCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TableCell.h"
#import "Post.h"
#import "Comment.h"

@implementation TableCell

@synthesize cellPost;
@synthesize cellComment;

- (void)awakeFromNib
{
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setAsPostCell:(Post *)post
{
    [self setCellComment:nil];
    [self setCellPost:post];
    [self assignProperties:post];
}
- (void)setAsCommentCell:(Comment*)comment
{
    [self setCellPost:nil];
    [self setCellComment:comment];
    [self assignProperties:comment];
}
- (void)assignProperties
{   // configure view of the cell according to the post's delegate ID
    
    if (self.post == nil)
    {
        [NSException raise:@"Error assign properties to a post cell" format:@"PostTableCell does not have a post reference"];
        return;
    }
    
    Post *post = self.post;
    
    NSDate *d = (NSDate*)[post date];
    NSString *myAgeLabel = [self getAgeAsString:d];
    
    // assign cell's message label and look for hashtags
    [self.messageLabel setText:post.message];
    
    @try{
        [self.messageLabel setDelegate:self];
    }
    @catch(NSException* e)
    {
        NSLog((NSString*)e.description);
    }
    NSArray *words = [self.messageLabel.text componentsSeparatedByString:@" "];
    for (NSString *word in words)
    {
        if ([word hasPrefix:@"#"])
        {
            NSRange range = [self.messageLabel.text rangeOfString:word];
            
            [self.messageLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", word]] withRange:range];
        }
    }
    
    // assign cell's plain text labels
    [self.ageLabel setText: myAgeLabel];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", (int)post.score]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%d comments", (int)post.commentList.count]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtonsWithVoteValue:post.vote];
}

/*
- (void) assignProperties:(NSObject *)obj
{   // configure view of the cell according provided Post/Comment
    
    // obj must a Comment or a Post
    Class class = [obj class];
    if ((class != [Post class] && class != [Comment class])
        || obj == nil)
    {
        [NSException raise:@"Error assigning properties to table cell"
                    format:@"Cell does not have a valid post or comment reference"];
        return;
    }
    
//    Post *post = self.post;
    
    NSDate *d = (NSDate*)[obj date];
    NSString *myAgeLabel = [self getAgeAsString:d];
    
    // assign cell's message label and look for hashtags
    [self.messageLabel setText:post.message];
    
    @try{
        [self.messageLabel setDelegate:self];
    }
    @catch(NSException* e)
    {
        NSLog((NSString*)e.description);
    }
    NSArray *words = [self.messageLabel.text componentsSeparatedByString:@" "];
    for (NSString *word in words)
    {
        if ([word hasPrefix:@"#"])
        {
            NSRange range = [self.messageLabel.text rangeOfString:word];
            
            [self.messageLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", word]] withRange:range];
        }
    }
    
    // assign cell's plain text labels
    [self.ageLabel setText: myAgeLabel];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", (int)post.score]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%d comments", (int)post.commentList.count]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtonsWithVoteValue:post.vote];
}
*/

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString* tagMessage = [url absoluteString];
    NSLog(@"tag = %@", tagMessage);
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
- (void)updateVoteButtonsWithVoteValue:(int)vote
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
