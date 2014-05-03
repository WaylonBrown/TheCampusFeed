//
//  PostViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostViewController.h"
#import "PostTableCell.h"
#import "PostDataController.h"
#import "Post.h"

@interface PostViewController()

- (NSString *)getAgeOfPostAsString:(NSDate *)postDate;
- (void) updateVoteButtons:(PostTableCell *)cell withVoteValue:(int)vote;

@end

@implementation PostViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[PostDataController alloc] init];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handleUpvote:(id)sender
{
    UIButton *upVoteButton = (UIButton *)sender;
    
    //TODO: ya this sucks... add tests to ensure proper casting etc
    PostTableCell *tableCell = (PostTableCell *)upVoteButton.superview.superview.superview;
    UITableView *tableView = (UITableView *)tableCell.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:tableCell];
    
    Post *post = [self.dataController objectInListAtIndex:indexPath.row];
    
    post.vote = post.vote == 1 ? 0 : 1;
    
    [self updateVoteButtons:tableCell withVoteValue:post.vote];

}
- (IBAction)handleDownvote:(id)sender
{
    UIButton *downVoteButton = (UIButton *)sender;
    
    //TODO: ya this sucks... add tests to ensure proper casting etc
    PostTableCell *tableCell = (PostTableCell *)downVoteButton.superview.superview.superview;
    UITableView *tableView = (UITableView *)tableCell.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:tableCell];
    
    Post *post = [self.dataController objectInListAtIndex:indexPath.row];
    
    post.vote = post.vote == -1 ? 0 : -1;
    
    [self updateVoteButtons:tableCell withVoteValue:post.vote];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of posts in the list
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfList];
}

// invoked every time a table row needs to be shown.
// this specifies the prototype (PostTableCell) and assigns the labels
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostTableCell";
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    PostTableCell *cell = (PostTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // get the post to be displayed in this cell
    Post *postAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    NSDate *d = (NSDate*)[postAtIndex date];
    NSString *myAgeLabel = [self getAgeOfPostAsString:d];
    
    // assign cell's text labels
    [[cell ageLabel] setText: myAgeLabel];
    [[cell messageLabel] setText:postAtIndex.message];
    [[cell scoreLabel] setText:[NSString stringWithFormat:@"%d", (int)postAtIndex.score]];
    [[cell commentCountLabel] setText:[NSString stringWithFormat:@"%d comments", (int)postAtIndex.commentList.count]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtons:cell withVoteValue:postAtIndex.vote];
    
    return cell;
}

- (void) updateVoteButtons:(PostTableCell *)cell withVoteValue:(int)vote
{
    // assign appropriate arrow colors (based on user's vote)
    switch (vote)
    {
        case -1:
            [[cell upVoteButton] setImage:[UIImage imageNamed:@"arrowup.png"] forState:UIControlStateNormal];
            [[cell downVoteButton] setImage:[UIImage imageNamed:@"arrowdownred.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [[cell upVoteButton] setImage:[UIImage imageNamed:@"arrowupblue.png"] forState:UIControlStateNormal];
            [[cell downVoteButton] setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            break;
        default:
            [[cell upVoteButton] setImage:[UIImage imageNamed:@"arrowup.png"] forState:UIControlStateNormal];
            [[cell downVoteButton] setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            break;
    }
    
    [cell setNeedsDisplay];
}

// User should not directly modify a PostTableCell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// TODO: This should probably not be hardcoded; revist
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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

@end
