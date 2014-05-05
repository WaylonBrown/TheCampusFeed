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

@interface CommentViewController ()

- (NSString *)getAgeOfCommentAsString:(NSDate *)commentDate;
- (void) updateVoteButtons:(CommentTableCell *)cell withVoteValue:(int)vote;
- (UIViewController *)backViewController;

@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

// return the previous view controller
- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [[self navigationController] setNavigationBarHidden:NO animated:NO];
//    UIViewController *previousController = (UIViewController *) [self backViewController];
//    
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
//}
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    self.dataController = [[CommentDataController alloc] init];
//    
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataController = [[CommentDataController alloc] initWithPost:_originalPost];
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView.restorationIdentifier compare:@"CommentTableView"] == NSOrderedSame)
    {
        return [self.dataController countOfList];
    }
    else // if ([tableView.restorationIdentifier compare:@"OriginalPostTableView"] == NSOrderedSame)
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView.restorationIdentifier compare:@"OriginalPostTableView"] == NSOrderedSame)
    {
        static NSString *PostCellIdentifier = @"PostTableCell";

        PostTableCell *cell = (PostTableCell *)[tableView dequeueReusableCellWithIdentifier:PostCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:PostCellIdentifier owner:self options:nil];
            cell = [nib1 objectAtIndex:0];
        }
        [cell setPost:(self.originalPost)];
        return cell;
    }
    static NSString *CellIdentifier = @"CommentTableCell";
    
    CommentTableCell *cell = (CommentTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // get the comment to be displayed in this cell
    Comment *commentAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    NSDate *d = (NSDate*)[commentAtIndex date];
    NSString *myAgeLabel = [self getAgeOfCommentAsString:d];
    
    // assign cell's text labels
    [[cell ageLabel] setText: myAgeLabel];
    [[cell messageLabel] setText:commentAtIndex.message];
    [[cell scoreLabel] setText:[NSString stringWithFormat:@"%d", (int)commentAtIndex.score]];
    
    // assign arrow colors according to user's vote
    [self updateVoteButtons:cell withVoteValue:commentAtIndex.vote];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction) Done:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// return string indicating how long ago the comment was created
- (NSString *)getAgeOfCommentAsString:(NSDate *)commentDate
{
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
- (IBAction)handleUpvote:(id)sender
{
    UIButton *upVoteButton = (UIButton *)sender;
    
    //TODO: ya this sucks... add tests to ensure proper casting etc
    CommentTableCell *tableCell = (CommentTableCell *)upVoteButton.superview.superview.superview;
    UITableView *tableView = (UITableView *)tableCell.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:tableCell];
    
    Comment *comment = [self.dataController objectInListAtIndex:indexPath.row];
    
    comment.vote = comment.vote == 1 ? 0 : 1;
    
    [self updateVoteButtons:tableCell withVoteValue:comment.vote];
    
}
- (IBAction)handleDownvote:(id)sender
{
    UIButton *downVoteButton = (UIButton *)sender;
    
    //TODO: ya this sucks... add tests to ensure proper casting etc
    CommentTableCell *tableCell = (CommentTableCell *)downVoteButton.superview.superview.superview;
    UITableView *tableView = (UITableView *)tableCell.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:tableCell];
    
    Comment *comment = [self.dataController objectInListAtIndex:indexPath.row];
    
    comment.vote = comment.vote == -1 ? 0 : -1;
    
    [self updateVoteButtons:tableCell withVoteValue:comment.vote];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end
