//
//  CommentViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TableCell.h"
#import "PostsViewController.h"
#import "Post.h"
#import "PostsViewController.h"
#import "CommentViewController.h"
#import "Comment.h"
#import "TTTAttributedLabel.h"
#import "Shared.h"
#import "ToastController.h"

@implementation CommentViewController

#pragma mark - Initialization and view loading

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithNibName:@"CommentView" bundle:nil];
    if (self)
    {
        [self setDataController:controller];
        self.toastController = [[ToastController alloc] initWithViewController:self];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{   // this function called right before the comments view appears
    [super viewWillAppear:animated];

    if (self.originalPost != nil)
    {
        [self.dataController setPostInFocus:self.originalPost];
        long postID = (long)self.originalPost.postID;
        [self.dataController fetchCommentsWithPostId:postID];

        float postCellHeight = [self tableView:self.postTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGRect frame = self.postTableView.frame;
        frame.size.height = postCellHeight;
        [self.postTableView setFrame:frame];
        
         [self.postTableView reloadData];
        [self.commentTableView reloadData];
//        [self.tableView reloadData];
        
        College *college = [self.dataController getCollegeById:self.originalPost.collegeID];
        if ([self.dataController.nearbyColleges containsObject:college])
        {
            UIBarButtonItem *create = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                    target:self
                                                                                    action:@selector(create)];
            
            UIImage *image = [UIImage imageNamed:@"flag.png"];
            UIBarButtonItem *flag = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(flag)];
            
            self.navigationItem.rightBarButtonItems = @[create, flag];
        }
        else
        {
            [self.navigationItem setRightBarButtonItems:nil];
        }
    }
}
- (void)viewDidLoad
{   // called once the comment view has loaded
    [super viewDidLoad];
    
    
    [self.postTableView reloadData];
    [self.commentTableView reloadData];
    //        [self.tableView reloadData];
}
- (void)loadView
{   // called when the comment view is initially loaded
  
    [super loadView];
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // first section is the original post, second is the post's comments
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Number of rows in table views
    if (tableView == self.postTableView) return 1;
    else if (tableView == self.commentTableView) return [self.dataController.commentList count];
    
    return 0;
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

    if (tableView == self.postTableView)
    {   // PostView table; get the original post to display in this table
        [cell assign:self.originalPost];
        return cell;
    }
    else if (tableView == self.commentTableView)
    {   // CommentView table; get the comment to be displayed in this cell
        Comment *commentAtIndex = (Comment*)[self.dataController.commentList objectAtIndex:indexPath.row];
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
    #define LABEL_WIDTH 252.0f
    #define TOP_TO_LABEL 7.0f
    #define LABEL_TO_BOTTOM 59.0f
    #define MIN_LABEL_HEIGHT 53.0f
    NSString *text = @"";
    
    if (tableView == self.postTableView)
    {
        text = self.originalPost.message;
    }
    else if (tableView == self.commentTableView)
    {
        text = [(Comment *)[self.list objectAtIndex:[indexPath row]] getMessage];
    }
    
    CGSize constraint = CGSizeMake(LABEL_WIDTH, 20000.0f);
    CGSize size = [text sizeWithFont:CF_FONT_LIGHT(16) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, MIN_LABEL_HEIGHT);
    float fullHeight = height + TOP_TO_LABEL + LABEL_TO_BOTTOM;
    return fullHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   // return the header title for the 'Comments' section
    
    if (tableView == self.commentTableView)
    {
        UILabel *commentHeader = [[UILabel alloc] initWithFrame:CGRectZero];
        [commentHeader setText:@"Comments"];
        [commentHeader setTextAlignment:NSTextAlignmentCenter];
        [commentHeader setFont:[UIFont systemFontOfSize:12]];
        [commentHeader setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
        
        return commentHeader;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.commentTableView) return 25.0;
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
    
    CreatePostCommentViewController *alert = [[CreatePostCommentViewController alloc] initWithType:COMMENT withCollege:nil];
    [alert setDelegate:self];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)flag
{   // Display popup to let user type a new comment
    NSString *message = @"Are you sure you wish to flag this post as inappropriate? Posts with a certain amount of flags per views are automatically removed. Do your part for the CollegeFeed community and flag any post that: \n\n - Is offensive, bad-natured, or threatening\n - Targets a specific person negatively to the point of bullying\n - Has a phone number\n\nUsers that have more than one post taken down get banned from posting on the app again.";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag as Inappropriate?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if ([self.dataController flagPost:self.originalPost.postID])
        {
            [self.toastController toastFlagSuccess];
        }
        else
        {
            [self.toastController toastFlagFailed];
        }
    }
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
    [super castVote:vote];
}

#pragma mark - CreationViewProtocol Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
                               withCollegeId:(long)collegeId
{
    BOOL success = [self.dataController createCommentWithMessage:message withPost:self.originalPost];
    
    if (!success)
    {
        [self.toastController toastPostFailed];
    }
    [self refresh];
    
}

#pragma mark - Vanishing Bottom Toolbar

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.feedToolbar.frame;
    CGFloat size = frame.size.height;
    CGFloat scrollOffset = scrollView.contentOffset.y + self.postTableView.frame.size.height;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height + self.postTableView.frame.size.height;
    
    if (scrollOffset < 5)
    {   // keep bar showing if at top of scrollView
        frame.origin.y = scrollHeight - 50;
    }
    else if (scrollDiff > 0 && (frame.origin.y < scrollHeight))
    {   // flick up / scroll down / hide bar
        frame.origin.y += 4;
    }
    else if (scrollDiff < 0 && (frame.origin.y + size > scrollHeight))
    {   // flick down / scroll up / show bar
        frame.origin.y -= 4;
    }
    
    [self.feedToolbar setFrame:frame];
    
    self.previousScrollViewYOffset = scrollOffset;
}

@end
