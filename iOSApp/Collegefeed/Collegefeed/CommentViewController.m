//
//  CommentViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TableCell.h"
#import "PostsViewController.h"
#import "Models/Models/Post.h"
#import "PostsViewController.h"
#import "CommentViewController.h"
#import "Models/Models/Comment.h"
#import "TTTAttributedLabel.h"
#import "Shared.h"

@implementation CommentViewController

#pragma mark - Initialization and view loading

- (void)viewWillAppear:(BOOL)animated
{   // this function called right before the comments view appears
    [super viewWillAppear:animated];

    if (self.originalPost != nil)
    {
        [self.appData setPostInFocus:self.originalPost];
        long postID = (long)self.originalPost.postID;
        [self.appData.dataController fetchCommentsWithPostId:postID];
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad
{   // called once the comment view has loaded
    [super viewDidLoad];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];

    [self.tableView reloadData];
}
- (void)loadView
{   // called when the comment view is initially loaded
  
    [super loadView];

    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                  target:self
                                                  action:@selector(create)];
    
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // first section is the original post, second is the post's comments
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Number of rows in table views
    if (section == 0) return 1;
    else return [self.appData.dataController.commentList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // Get the table view cell for the given row
    // This method handles two table views: one for the post and another for it's comments
    
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setDelegate: self];

    if (indexPath.section == 0)
    {   // PostView table; get the original post to display in this table
        [cell assign:self.originalPost];
        return cell;
    }
    else
    {   // CommentView table; get the comment to be displayed in this cell
        Comment *commentAtIndex = (Comment*)[self.appData.dataController.commentList objectAtIndex:indexPath.row];
        [cell assign:commentAtIndex];
        return cell;
    }
    
    return nil;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{   // Return NO if you do not want the specified item to be editable.
    
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{   // Return NO if you do not want the item to be re-orderable.
 
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   // return the header title for the 'Comments' section
    
    if (section != 1) return nil;//[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    UILabel *commentHeader = [[UILabel alloc] initWithFrame:CGRectZero];
    [commentHeader setText:@"Comments"];
    [commentHeader setTextAlignment:NSTextAlignmentCenter];
    [commentHeader setFont:[UIFont systemFontOfSize:12]];
    [commentHeader setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
    
    return commentHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) return 25.0;
    else return 5.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   // In a storyboard-based application, you will often want to do a little preparation before navigation
}

#pragma mark - Actions

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)create
{   // Display popup to let user type a new comment
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Comment"
                                                    message:@"You got an opinion?"
                                                   delegate:self
                                          cancelButtonTitle:@"nope.."
                                          otherButtonTitles:@"Comment!", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   // Add new comment if user submits on the alert view
    
    if (buttonIndex == 0) return;
    
    bool success = [self.appData.dataController createCommentWithMessage:[[alertView textFieldAtIndex:0] text]
                                                                withPost:self.originalPost];
    [self.tableView reloadData];
}

#pragma mark - Helper Methods

- (NSString *)getAgeOfCommentAsString:(NSDate *)commentDate
{   // return string indicating how long ago the comment was created
    int commentAgeSeconds = [[NSDate date] timeIntervalSinceDate:commentDate];
    int commentAgeMinutes = commentAgeSeconds / 60;
    int commentAgeHours = commentAgeMinutes / 60;
    
    if (commentAgeHours >= 1)
    {
        return [NSString stringWithFormat:@"%d hours ago", commentAgeHours];
    }
    else if (commentAgeMinutes >= 1)
    {
        return [NSString stringWithFormat:@"%d minutes ago", commentAgeMinutes];
    }
    return [NSString stringWithFormat:@"%d seconds ago", commentAgeSeconds];
}
- (void)castVote:(Vote *)vote
{
    //TODO: show this only if voting on a comment
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
//                                                    message:@"Cannot currently send a comment's vote to the server"
//                                                   delegate:self
//                                          cancelButtonTitle:@"K"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
    [super castVote:vote];
}

@end
