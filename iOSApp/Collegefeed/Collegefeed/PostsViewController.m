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
#import "CollegeViewController.h"
#import "Shared.h"
#import "College.h"


@implementation PostsViewController

#pragma mark - Initializations

- (id)initAsTopPostsWithDataControllers:(NSArray *)dataControllers
{
    self = [super initWithDataControllers:dataControllers];
    if (self)
    {
        [self setTopPosts:YES];
        [self setRecentPosts:NO];
        [self setMyPosts:NO];
        
        [self switchToAllColleges];
    }
    return self;
}
- (id)initAsNewPostsWithDataControllers:(NSArray *)dataControllers
{
    self = [super initWithDataControllers:dataControllers];
    if (self)
    {
        [self setTopPosts:NO];
        [self setRecentPosts:YES];
        [self setMyPosts:NO];
        
        [self switchToAllColleges];
    }
    return self;
}
- (id)initAsMyPostsWithDataControllers:(NSArray *)dataControllers
{
    self = [super initWithDataControllers:dataControllers];
    if (self)
    {
        [self setTopPosts:NO];
        [self setRecentPosts:NO];
        [self setMyPosts:YES];
        
        [self switchToAllColleges];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    
    [super viewWillAppear:animated];
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
                                    initWithDataControllers:self.getDataControllers]];

    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                  target:self
                                                  action:@selector(create)];
    
    [super loadView];

}

#pragma mark - Table View Override Functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedPost = (Post *)[self.postDataController objectInListAtIndex:indexPath.row];

    [self.commentViewController setOriginalPost:self.selectedPost];
        
    [self.navigationController pushViewController:self.commentViewController
                                         animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return [self.postDataController countOfList];
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
    Post *postAtIndex = (Post*)[self.postDataController objectInListAtIndex:indexPath.row];
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
        [self.postDataController fetchTopPosts];
    }
    else if (self.recentPosts)
    {
        [self.postDataController fetchNewPosts];
    }
}
- (void)switchToSpecificCollege
{
    if (self.topPosts)
    {
        [self.postDataController fetchTopPostsWithCollegeId:[self.delegate getCurrentCollege].collegeID];
    }
    else if (self.recentPosts)
    {
        [self.postDataController fetchNewPostsWithCollegeId:[self.delegate getCurrentCollege].collegeID];
    }
}

#pragma mark - Actions

- (void)create
{   // Display popup to let user type a new post
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Post"
                                                        message:@"What's poppin?"
                                                       delegate:self
                                              cancelButtonTitle:@"nvm.."
                                              otherButtonTitles:@"Post!", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   // Add new post if user submits on the alert view
    
    if (buttonIndex == 0) return;
    Post *newPost = [[Post alloc] initWithMessage:[[alertView textFieldAtIndex:0] text]
                                    withCollegeId:0];
    [self.postDataController addToServer:newPost
                                intoList:self.postDataController.topPostsAllColleges];
     
    [self.tableView reloadData];
}
- (void)refresh
{
    if ([self.delegate getIsAllColleges])
    {
        [self.collegeSegmentControl setSelectedSegmentIndex:0];
        [self switchToAllColleges];
    }
    else if ([self.delegate getIsSpecificCollege])
    {
        if (self.collegeSegmentControl.numberOfSegments < 3)
        {
            [self.collegeSegmentControl insertSegmentWithTitle:[self.delegate getCurrentCollege].name
                                                       atIndex:2 animated:NO];
        }
        else
        {
            [self.collegeSegmentControl setTitle:[self.delegate getCurrentCollege].name
                               forSegmentAtIndex:2];
        }
        
        [self.collegeSegmentControl setSelectedSegmentIndex:2];
        [self switchToSpecificCollege];
    }
    [self.tableView reloadData];
}
@end
