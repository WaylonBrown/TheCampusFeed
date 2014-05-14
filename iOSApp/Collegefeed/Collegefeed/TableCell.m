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
- (void) assignProperties:(Post *)obj
{   // configure view of the cell according to the provided Post/Comment
    // NOTE: Comment is subclass of Post
    
    if (obj == nil)
    {
        [NSException raise:@"Error assigning properties to table cell"
                    format:@"Cell does not have a valid post or comment reference"];
        return;
    }
    
    // assign cell's plain text labels
    [self.ageLabel setText: [self getAgeAsString:(NSDate*)[obj date]]];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", (int)obj.score]];
    
    if (self.cellPost != nil && self.cellComment == nil)
    {   // if this is a Post
        [self.commentCountLabel setText:[NSString stringWithFormat:@"%d comments",
                                         (int)obj.commentList.count]];
        
        [self.messageLabel setText:obj.postMessage];

    }
    else if (self.cellComment != nil && self.cellPost == nil)
    {   // if this is a Comment
        [self.commentCountLabel setText:@""];
        [self.messageLabel setText:((Comment*)obj).commentMessage];
    }
    
    // look for hashtags in cell's message label
    @try
    {
        [self.messageLabel setDelegate:self];
    }
    @catch(NSException* e)
    {
        NSLog(@"Exception thrown in -TableCell.assignProperties");
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
    
    // assign arrow colors according to user's vote
    [self updateVoteButtonsWithVoteValue:obj.vote];
}


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
{   // assign appropriate arrow colors (based on user's vote)
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
    BOOL isPost = self.cellPost != nil && self.cellComment == nil;
    BOOL isComment = self.cellComment != nil && self.cellPost == nil;
  
    if (isPost)
    {
        Post *post = self.cellPost;
        [post setVote:(post.vote == 1 ? 0 : 1)];
        [self updateVoteButtonsWithVoteValue:post.vote];
    }
    else if (isComment)
    {
        Comment *comment = self.cellComment;
        [comment setVote:(comment.vote == 1 ? 0 : 1)];
        [self updateVoteButtonsWithVoteValue:comment.vote];
    }
}

- (IBAction)downVotePresed:(id)sender
{
    BOOL isPost = self.cellPost != nil && self.cellComment == nil;
    BOOL isComment = self.cellComment != nil && self.cellPost == nil;
    
    if (isPost)
    {
        Post *post = self.cellPost;
        [post setVote:(post.vote == -1 ? 0 : -1)];
        [self updateVoteButtonsWithVoteValue:post.vote];
    }
    else if (isComment)
    {
        Comment *comment = self.cellComment;
        [comment setVote:(comment.vote == -1 ? 0 : -1)];
        [self updateVoteButtonsWithVoteValue:comment.vote];
    }
}

@end
