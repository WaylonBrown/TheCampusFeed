//
//  PostsViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "AppDelegate.h"
#import "TableCell.h"
#import "PostsViewController.h"
#import "Models/Models/Post.h"
#import "CommentViewController.h"
#import "Shared.h"
#import "Models/Models/College.h"

@implementation PostsViewController

#pragma mark - Initializations

- (id)initAsTopPostsWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setTopPosts:YES];
        [self setRecentPosts:NO];
        [self setMyPosts:NO];
        [self setTagPosts:NO];
        [self switchToAllColleges];

        [self setList:controller.topPostsAllColleges];
    }
    return self;
}
- (id)initAsNewPostsWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setTopPosts:NO];
        [self setRecentPosts:YES];
        [self setMyPosts:NO];
        [self setTagPosts:NO];
        [self switchToAllColleges];
        [self setList:controller.recentPostsAllColleges];
        
    }
    return self;
}
- (id)initAsMyPostsWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setTopPosts:NO];
        [self setRecentPosts:NO];
        [self setMyPosts:YES];
        [self setTagPosts:NO];
        [self switchToAllColleges];
        [self setList:controller.userPostsAllColleges];
        
    }
    return self;
}
- (id)initAsTagPostsWithDataController:(DataController *)controller
                 withTagMessage:(NSString*)tagMessage
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setTopPosts:NO];
        [self setRecentPosts:NO];
        [self setMyPosts:NO];
        [self setTagPosts:YES];
        [self setTagMessage:tagMessage];
        [self switchToAllColleges];
        [self setList:controller.allPostsWithTag];
    }
    return self;
}

#pragma mark - View Loading

- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self refresh];
    [self setCommentViewController:[[CommentViewController alloc] initWithDataController:self.dataController]];
}
- (void)loadView
{
    [super loadView];
}

#pragma mark - Table View Override Functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedPost = (Post *)[self.list objectAtIndex:indexPath.row];

    [self.commentViewController setOriginalPost:self.selectedPost];
        
    [self.navigationController pushViewController:self.commentViewController
                                         animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return self.list.count;
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
    NSObject<PostAndCommentProtocol> *postAtIndex = [self.list objectAtIndex:indexPath.row];
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
        [self.dataController fetchTopPosts];
    }
    else if (self.recentPosts)
    {
        [self.dataController fetchNewPosts];
    }
    else if (self.tagPosts && self.tagMessage != nil)
    {
        [self.dataController fetchAllPostsWithTagMessage:self.tagMessage];
    }
}
- (void)switchToSpecificCollege
{
    if (self.topPosts)
    {
        // TODO: this is calling dataController's function and passing its own variable to itself
        [self.dataController fetchTopPostsWithCollegeId:self.dataController.collegeInFocus.collegeID];
    }
    else if (self.recentPosts)
    {
        [self.dataController fetchNewPostsWithCollegeId:self.dataController.collegeInFocus.collegeID];
    }
    else if (self.tagPosts && self.tagMessage != nil)
    {
        [self.dataController fetchAllPostsWithTagMessage:self.tagMessage
                                                   withCollegeId:self.dataController.collegeInFocus.collegeID];
    }
}

#pragma mark - Actions

- (void)refresh
{   // refresh this post view
    if (self.dataController.showingAllColleges)
    {
        [self switchToAllColleges];
    }
    else if (self.dataController.showingSingleCollege)
    {
        [self switchToSpecificCollege];
    }
    [super refresh];
}

#pragma mark - CreationViewProtocl Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
{
    [self.dataController createPostWithMessage:message
                                 withCollegeId:self.dataController.collegeInFocus.collegeID];
}

@end
