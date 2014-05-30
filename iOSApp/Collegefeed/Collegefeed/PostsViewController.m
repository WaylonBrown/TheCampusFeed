//
//  PostsViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TableCell.h"
#import "PostsViewController.h"
#import "PostDataController.h"
#import "Post.h"
#import "CommentViewController.h"
#import "Shared.h"
#import "College.h"
#import "MasterViewDelegate.h"

@implementation PostsViewController

#pragma mark - Initializations

- (id)initAsTopPostsWithDelegateId:(id<MasterViewDelegate>)delegate
{
    self = [super initWithDelegateId:delegate];
    if (self)
    {
        [self setTopPosts:YES];
        [self setRecentPosts:NO];
        [self setMyPosts:NO];
        [self setTagPosts:NO];
        
        [self switchToAllColleges];
    }
    return self;
}
- (id)initAsNewPostsWithDelegateId:(id<MasterViewDelegate>)delegate
{
    self = [super initWithDelegateId:delegate];
    if (self)
    {
        [self setTopPosts:NO];
        [self setRecentPosts:YES];
        [self setMyPosts:NO];
        [self setTagPosts:NO];
        
        [self switchToAllColleges];
    }
    return self;
}
- (id)initAsMyPostsWithDelegateId:(id<MasterViewDelegate>)delegate
{
    self = [super initWithDelegateId:delegate];
    if (self)
    {
        [self setTopPosts:NO];
        [self setRecentPosts:NO];
        [self setMyPosts:YES];
        [self setTagPosts:NO];
        
        [self switchToAllColleges];
    }
    return self;
}
- (id)initAsTagPostsWithDelegateId:(id<MasterViewDelegate>)delegate
                    withTagMessage:(NSString*)tagMessage
{
    self = [super initWithDelegateId:delegate];
    if (self)
    {
        [self setTopPosts:NO];
        [self setRecentPosts:NO];
        [self setMyPosts:NO];
        [self setTagPosts:YES];
        [self setTagMessage:tagMessage];
        [self switchToAllColleges];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive

    [super viewWillAppear:animated];
    [self.navigationItem setTitleView:logoTitleView];

    [self refresh];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}
- (void)loadView
{
    [self setCommentViewController:[[CommentViewController alloc]
                                    initWithDelegateId:self.appDelegate]];

    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                  target:self
                                                  action:@selector(create)];
    
    [super loadView];

}

#pragma mark - Table View Override Functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedPost = (Post *)[self.appDelegate.postDataController objectInListAtIndex:indexPath.row];

    [self.commentViewController setOriginalPost:self.selectedPost];
        
    [self.navigationController pushViewController:self.commentViewController
                                         animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return [self.appDelegate.postDataController countOfList];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    // this specifies the prototype (PostTableCell) and assigns the labels
    
    static NSString *CellIdentifier = @"TableCell";
    
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setDelegate: self];

    // get the post and display in this cell
    Post *postAtIndex = (Post*)[self.appDelegate.postDataController objectInListAtIndex:indexPath.row];
    [cell assign:postAtIndex];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should not be hardcoded; revist
    
    return 100;
}

#pragma mark - Navigation

- (void)switchToAllColleges
{
    if (self.topPosts)
    {
        [self.appDelegate.postDataController fetchTopPosts];
    }
    else if (self.recentPosts)
    {
        [self.appDelegate.postDataController fetchNewPosts];
    }
    else if (self.tagPosts && self.tagMessage != nil)
    {
        [self.appDelegate.postDataController fetchAllPostsWithTagMessage:self.tagMessage];
    }
}
- (void)switchToSpecificCollege
{
    if (self.topPosts)
    {
        [self.appDelegate.postDataController fetchTopPostsWithCollegeId:[self.appDelegate getCurrentCollege].collegeID];
    }
    else if (self.recentPosts)
    {
        [self.appDelegate.postDataController fetchNewPostsWithCollegeId:[self.appDelegate getCurrentCollege].collegeID];
    }
    else if (self.tagPosts && self.tagMessage != nil)
    {
        [self.appDelegate.postDataController fetchAllPostsWithTagMessage:self.tagMessage
                                               withCollegeId:[self.appDelegate getCurrentCollege].collegeID];
    }
}

#pragma mark - Actions

- (void)create
{   // Display popup to let user type a new post
    College *currentCollege = [self.appDelegate getCurrentCollege];
    if (currentCollege == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must have a college selected before being able to post"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Post"
                                                        message:[NSString stringWithFormat:@"Posting to %@", currentCollege.name]
                                                       delegate:self
                                              cancelButtonTitle:@"nvm.."
                                              otherButtonTitles:@"Post dis bitch!", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   // Add new post if user submits on the alert view
    
    if (buttonIndex == 0) return;
    College *currentCollege = [self.appDelegate getCurrentCollege];
    if (currentCollege != nil)
    {
        Post *newPost = [[Post alloc] initWithMessage:[[alertView textFieldAtIndex:0] text]
                                    withCollegeId:currentCollege.collegeID];
        [self.appDelegate.postDataController addToServer:newPost
                                    intoList:self.appDelegate.postDataController.topPostsAllColleges];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A college must be selected to post to"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
     
    [self.tableView reloadData];
}
- (void)refresh
{   // refresh this post view
    if ([self.appDelegate getIsAllColleges])
    {
        [self.collegeSegmentControl setSelectedSegmentIndex:0];
        [self switchToAllColleges];
    }
    else if ([self.appDelegate getIsSpecificCollege])
    {
        if (self.collegeSegmentControl.numberOfSegments < 3)
        {
            [self.collegeSegmentControl insertSegmentWithTitle:[self.appDelegate getCurrentCollege].name
                                                       atIndex:2 animated:NO];
        }
        else
        {
            [self.collegeSegmentControl setTitle:[self.appDelegate getCurrentCollege].name
                               forSegmentAtIndex:2];
        }
        
        [self.collegeSegmentControl setSelectedSegmentIndex:2];
        [self switchToSpecificCollege];
    }
    [super refresh];
}

@end
