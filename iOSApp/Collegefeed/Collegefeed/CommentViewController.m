//
//  CommentViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <Social/Social.h>

#import "TableCell.h"

#import "PostsViewController.h"
#import "Post.h"
#import "PostsViewController.h"
#import "CommentViewController.h"
#import "Comment.h"
#import "TTTAttributedLabel.h"
#import "Shared.h"
#import "ToastController.h"
#import "Vote.h"
#import "UIView+Toast.h"


@implementation CommentViewController

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithNibName:@"CommentView" bundle:nil];
    if (self)
    {
        [self setDataController:controller];
        [self initializeViewElements];
        
    }
    return self;
}

#pragma mark - View Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.postTableView.dataSource = self;
    self.postTableView.delegate = self;
    
    NSLog(@"Setting tableview to be automatic in %@", [self class]);
    self.tableView.estimatedRowHeight = POST_CELL_HEIGHT_ESTIMATE;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.postTableView.estimatedRowHeight = POST_CELL_HEIGHT_ESTIMATE;
    self.postTableView.rowHeight = UITableViewAutomaticDimension;
    
}
- (void)loadView
{   // called when the comment view is initially loaded
  
    [super loadView];
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [super viewWillAppear:animated];

    [self setCorrectList];
    
//    if (self.dataController.postInFocus != nil)
    if (self.parentPost != nil)
    {
        NSLog(@"CommentViewController will appear with non-nil parentPost");
        float postCellHeight = POST_CELL_HEIGHT_ESTIMATE;
        
//        float postCellHeight = [self tableView:self.postTableView heightForRowAtIndexPath:
//                                [NSIndexPath indexPathForRow:0 inSection:0]];
        
        self.postTableHeightConstraint.constant = postCellHeight;
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    
    [self.postTableView reloadData];
    [self.tableView reloadData];
}
- (void)initializeViewElements
{
    // Back button
    self.backButton = [super blankBackButton];
    
    // Compose button
    self.composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                       target:self
                                                                       action:@selector(create)];
    // Flag button
    self.flagButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Flag"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(flag)];
    // Facebook button
    self.facebookButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FacebookLogo"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(shareOnFacebook)];
    // Twitter button
    self.twitterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TwitterLogo"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(shareOnTwitter)];
    // Toolbar buttons divider
    CGRect dividerFrame = CGRectMake(0, 0, 1, self.navigationController.navigationBar.frame.size.height - 16);
    UIView *dividerView = [[UIView alloc] initWithFrame:dividerFrame];
    [dividerView setBackgroundColor:[UIColor whiteColor]];
    self.dividerButton = [[UIBarButtonItem alloc] initWithCustomView:dividerView];
}
- (void)makeToolbarButtons
{   // Assigns correct icons and buttons to the upper toolbar
    
//    Post* parentPost = self.dataController.postInFocus;
    
    [self initializeViewElements];
    
    if (self.parentPost != nil || self.parentPost.college == nil)
    {
        if ([self.dataController isNearCollegeWithId:self.parentPost.college.collegeID])
//        if ([self.dataController.nearbyColleges containsObject:self.parentPost.college])
        {
            self.navigationItem.rightBarButtonItems = @[self.composeButton,
                                                        self.flagButton,
                                                        self.dividerButton,
                                                        self.facebookButton,
                                                        self.twitterButton];
            return;
        }
    }
    
    self.navigationItem.rightBarButtonItems = @[self.facebookButton,
                                                self.twitterButton];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // Get the table view cell for the given row
    // This method handles two table views: one for the post and another for it's comments
    
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                              owner:self
                                            options:nil] objectAtIndex:0];
    }
    
    if (tableView == self.postTableView)
    {   // PostView table; get the original post to display in this table
        [cell assignWithPost:self.parentPost withCollegeLabel:NO];
    }
    else
    {   // CommentView table; get the comments to be displayed
        
        Comment *comment = [self.list objectAtIndex:indexPath.row];
        [cell assignWithComment:comment];
        cell.delegate = self;
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // first section is the original post, second is the post's comments
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Number of rows in table views
    if (tableView == self.postTableView)
    {
        return 1;
    }

    return [self.list count];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   // return the header title for the 'Comments' section
    
    if (tableView != self.postTableView) // self.commentTableView)
    {
        UILabel *commentHeader = [[UILabel alloc] initWithFrame:CGRectZero];
        [commentHeader setTextAlignment:NSTextAlignmentCenter];
        [commentHeader setFont:CF_FONT_LIGHT(13)];
        [commentHeader setTintColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
        [commentHeader setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
        
        if (self.hasFinishedFetchRequest)
        {   // finished network access for comments
            
            if (self.dataController.commentList.count > 0)
            {   // some comments retrieved
                [commentHeader setText:@"Comments"];
            }
            else
            {   // none found
                [commentHeader setText:@"No Comments"];
            }
        }
        else // still loading comments
        {
            [commentHeader setText:@"Loading Comments..."];
        }
        
        return commentHeader;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (tableView == self.tableView) ? 25 : 5;
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];
    
//    [self.contentLoadingIndicator startAnimating];
    
    // Spawn separate thread for network access
//    [self.dataController fetchCommentsForPost:self.dataController.postInFocus];
    [self.dataController fetchCommentsForPost:self.parentPost];
}
- (void)finishedFetchRequest:(NSNotification *)notification
{   // A fetch request was completed, make necessary updates
    
    [super finishedFetchRequest:notification];
    
//    [self.commentTableView reloadData];
}
- (void)shareOnFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Check out TheCampusFeed!"];
        [controller addImage:[UIImage imageNamed:@"icon.png"]];
        [controller addURL:[NSURL URLWithString:WEBSITE_LINK]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        [self.dataController.toaster toastFacebookUnavailable];
    }
}
- (void)shareOnTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"Check out TheCampusFeed! %@", WEBSITE_LINK]];
        [tweetSheet addImage:[UIImage imageNamed:@"icon.png"]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        [self.dataController.toaster toastTwitterUnavailable];
    }
}

#pragma mark - Local Actions

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)create
{   // Display popup to let user type a new comment
    
    CreatePostCommentViewController *alert = [[CreatePostCommentViewController alloc] initWithType:COMMENT
                                                                                       withCollege:nil
                                                                                withDataController:self.dataController];
    [alert setDelegate:self];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)flag
{   // Display popup to let user type a new comment
    NSString *message = @"Are you sure you wish to flag this post as inappropriate? Posts with a certain amount of flags per views are automatically removed. Do your part for TheCampusFeed community and flag any post that: \n\n- Is offensive, bad-natured, or threatening\n- Targets a specific person negatively to the point of bullying\n- Has a phone number\n\nUsers that have more than one post taken down get banned from posting on the app again.";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag as Inappropriate?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {   // attempt to flag a post as inappropriate
//        Post *parentPost = self.dataController.postInFocus;

        if ((self.parentPost != nil) && [self.dataController flagPost:[[self.parentPost getID] longValue]])
        {
            [self.dataController.toaster toastFlagSuccess];
        }
        else
        {
            [self.dataController.toaster toastFlagFailed];
        }
    }
}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    [self setList:self.dataController.commentList];
}
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
- (BOOL)castVote:(Vote *)vote
{
//    Post *parentPost = self.dataController.postInFocus;
    if (self.parentPost != nil)
    {
        [vote setGrandparentID:[[self.parentPost getID] longValue]];
        return [super castVote:vote];
    }
    
    return NO;
}

#pragma mark - CreationViewProtocol Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
                               withCollegeId:(long)collegeId
                               withUserToken:(NSString *)userToken
                                   withImage:(UIImage *)image
{
//    if ([self.dataController isAbleToComment])
    if (true)
    {
        [self.createController dismiss:self];

//        Post *parentPost = self.dataController.postInFocus;
        if (self.parentPost != nil)
        {
            BOOL success = [self.dataController createCommentWithMessage:message withPost:self.parentPost];
            if (success)
            {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataController.commentList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                [self.commentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataController.commentList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
//        else
//        {
//            [self.toastController toastPostFailed];
//        }
    }
//    else
//    {
//        [self.toastController toastCommentingTooSoon];
//    }
    
}

@end
