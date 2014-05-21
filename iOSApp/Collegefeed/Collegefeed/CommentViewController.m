//
//  CommentViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TableCell.h"
#import "PostsViewController.h"
#import "PostDataController.h"
#import "Post.h"
#import "PostsViewController.h"
#import "CommentViewController.h"
#import "CommentDataController.h"
#import "Comment.h"
#import "TTTAttributedLabel.h"
#import "Constants.h"

@implementation CommentViewController

#pragma mark - Initialization and view loading

- (id)initWithOriginalPost:(Post*)post// withDelegate:(id)postSubViewDelegate
{   // initialize a CommentsView provided info about the previously selected Post

    self = [super init];
    if (self)
    {
        [self setOriginalPost:post];
        [self setDataController:[[CommentDataController alloc] initWithNetwork:YES
                                                                      withPost:post]];
    }
    return self;
}
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
////    self.dataController = [[CommentDataController alloc] init];
//}
//- (void)loadView
//{   // Use CommentsView.xib to show comments on a post
//    
//    UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"CommentsView"
//                                                  owner:self
//                                                options:nil]
//                    objectAtIndex:0];
//    
//    [self setView:view];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.cancelButton.enabled = YES;
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Number of rows in table views
    if (section == 0) return 1;
    else return [self.dataController countOfList];
    
//    if ([tableView.restorationIdentifier compare:@"CommentTableView"] == NSOrderedSame)
//    {   // Comment Table has as many rows as number of comments
//        return [self.dataController countOfList];
//    }
//    else // if ([tableView.restorationIdentifier compare:@"OriginalPostTableView"] == NSOrderedSame)
//    {   // only one row in Post Table (the original Post)
//        return 1;
//    }
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
    
    if (indexPath.section == 0)
    {   // PostView table; get the original post to display in this table
        [cell assign:self.originalPost];
        return cell;
    }
    else
    {   // CommentView table; get the comment to be displayed in this cell
        Comment *commentAtIndex = (Comment*)[self.dataController objectInListAtIndex:indexPath.row];
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
    [commentHeader setBackgroundColor:UIColorFromRGB(cf_lightgray)];
    
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

- (IBAction)cancel:(id)sender
{   // Called when user is done viewing comments, dismiss this view
    [self dismissViewControllerAnimated:YES completion:nil];
  
}
- (IBAction)create:(id)sender
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
    
    Comment *newComment = [[Comment alloc] initWithCommentMessage:[[alertView textFieldAtIndex:0] text]
                                                         withPost:self.originalPost];
    [self.dataController addObjectToList:newComment];
//    [self.commentTable reloadData];
//    [self.originalPostTable reloadData];
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

@end
