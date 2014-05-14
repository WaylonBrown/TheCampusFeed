//
//  CommentViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//
#import "PostsViewController.h"
#import "PostDataController.h"
#import "Post.h"
#import "PostsViewController.h"
#import "PostTableCell.h"
#import "CommentViewController.h"
#import "CommentTableCell.h"
#import "CommentDataController.h"
#import "Comment.h"
#import "TTTAttributedLabel.h"

@interface CommentViewController ()

- (NSString *)getAgeOfCommentAsString:(NSDate *)commentDate;
- (void) updateVoteButtons:(CommentTableCell *)cell withVoteValue:(int)vote;
- (UIViewController *)backViewController;

@end

@implementation CommentViewController

#pragma mark - Initialization and view loading

- (id)initWithOriginalPost:(Post*)post withDelegate:(id)postSubViewDelegate
{   // initialize a CommentsView provided info about the previously selected Post

    self = [super init];
    if (self)
    {
        [self setDelegate:postSubViewDelegate];
        [self setOriginalPost:post];
        [self setDataController:[[CommentDataController alloc] initWithPost:post]];
    }
    return self;
}
- (void)awakeFromNib
{   //TODO: (unused/unneeded?)
    [super awakeFromNib];
    self.dataController = [[CommentDataController alloc] init];
}
- (void)loadView
{   // Use CommentsView.xib to show comments on a post
    
    UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"CommentsView"
                                                  owner:self
                                                options:nil]
                    objectAtIndex:0];
    
    [self setView:view];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    


/*
//    NSArray *array = [NSArray arrayWithObject:@"foo"];
//    [self.originalPostTable insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic]
//    [self.originalPostTable setDataSource:array];
    
//    UIImage *image = [UIImage imageNamed:@"collegefeedlogosmall.png"];
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
//    UIViewController *previousController = (UIViewController *) [self backViewController];
//    
//    if ([previousController class] == [PostsViewController
//                                       
//                                       class])
//    {   // invoked if comments view was opened from a posts view
//        PostsViewController *PVC = (PostsViewController *)previousController;
//        Post* selectedPost = PVC.selectedPost;
//        
//        if (selectedPost != nil)
//        {
//            // assign post cell attributes based on post that was selected
//            [[self originalPostCell] assignPropertiesWithPost:selectedPost];
//            
//            [[self originalPostCell] setNeedsDisplay];
//            return;
//        }
//    }
*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Number of rows in table views
    if ([tableView.restorationIdentifier compare:@"CommentTableView"] == NSOrderedSame)
    {   // Comment Table has as many rows as number of comments
        return [self.dataController countOfList];
    }
    else // if ([tableView.restorationIdentifier compare:@"OriginalPostTableView"] == NSOrderedSame)
    {   // only one row in Post Table (the original Post)
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // Get the table view cell for the given row
    // This method handles two table views: one for the post and another for it's comments

    if ([tableView.restorationIdentifier compare:@"OriginalPostTableView"] == NSOrderedSame)
    {   // PostView table
        static NSString *PostCellIdentifier = @"PostTableCell";

        PostTableCell *cell = (PostTableCell *)[tableView dequeueReusableCellWithIdentifier:PostCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:PostCellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell setPost:self.originalPost];
        return cell;
    }
    else
    {   // CommentView table
        static NSString *CellIdentifier = @"CommentTableCell";
        
        CommentTableCell *cell = (CommentTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        // get the comment to be displayed in this cell
        Comment *commentAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
        [cell setComment:commentAtIndex];
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
    return 120;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

#pragma mark - Actions
- (IBAction)done
{   // Called when user is done viewing comments, return to previous view
    [[self navigationController] popViewControllerAnimated:YES];
    id<PostSubViewDelegate> strongDelegate = self.delegate;
    
    // call post delegate method below to reload table data (in case user voted)
    [strongDelegate votedOnPost];
}

- (IBAction)createComment
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
{   // Add new post if user submits on the alert view
    
    if (buttonIndex == 0) return;
    
    Comment *newComment = [[Comment alloc] initWithCommentMessage:[[alertView textFieldAtIndex:0] text]
                                                         withPost:self.originalPost];
    //    [newComment validateComment];
    [self.dataController addComment:newComment];
    [self.commentTable reloadData];
    [self.originalPostTable reloadData];
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
- (void) updateVoteButtons:(CommentTableCell *)cell withVoteValue:(int)vote
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
- (UIViewController *)backViewController
{   //TODO: (unused) return the previous view controller
    
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}



@end
