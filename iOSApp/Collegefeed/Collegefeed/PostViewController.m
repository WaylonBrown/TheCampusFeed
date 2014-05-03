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

@implementation PostViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

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
    [tableCell updateVoteButtonsWithVoteValue:post.vote];
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

    [tableCell updateVoteButtonsWithVoteValue:post.vote];
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
    
    PostTableCell *cell = (PostTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // get the post to be displayed in this cell
    Post *postAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    [cell assignPropertiesWithPost:postAtIndex];
    
    return cell;
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


// set selected cell and post message of the selected cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPost = (Post *)[self.dataController objectInListAtIndex:indexPath.row];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
