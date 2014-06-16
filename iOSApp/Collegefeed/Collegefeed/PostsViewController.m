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
#import "PostDataController.h"
#import "Post.h"
#import "CommentViewController.h"
#import "Shared.h"
#import "College.h"

@implementation PostsViewController

#pragma mark - Initializations

- (id)initAsTopPostsWithAppData:(AppData *)data
{
    self = [super initWithAppData:data];
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
- (id)initAsNewPostsWithAppData:(AppData *)data
{
    self = [super initWithAppData:data];
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
- (id)initAsMyPostsWithAppData:(AppData *)data
{
    self = [super initWithAppData:data];
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
- (id)initAsTagPostsWithAppData:(AppData *)data
                    withTagMessage:(NSString*)tagMessage
{
    self = [super initWithAppData:data];
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
    [self setCommentViewController:[[CommentViewController alloc] initWithAppData:self.appData]];

}
- (void)loadView
{
    [super loadView];
}

#pragma mark - Table View Override Functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedPost = (Post *)[self.appData.postDataController objectInListAtIndex:indexPath.row];

    [self.commentViewController setOriginalPost:self.selectedPost];
        
    [self.navigationController pushViewController:self.commentViewController
                                         animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return [self.appData.postDataController countOfList];
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
    Post *postAtIndex = (Post*)[self.appData.postDataController objectInListAtIndex:indexPath.row];
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
        [self.appData.postDataController fetchTopPosts];
    }
    else if (self.recentPosts)
    {
        [self.appData.postDataController fetchNewPosts];
    }
    else if (self.tagPosts && self.tagMessage != nil)
    {
        [self.appData.postDataController fetchAllPostsWithTagMessage:self.tagMessage];
    }
}
- (void)switchToSpecificCollege
{
    if (self.topPosts)
    {
        [self.appData.postDataController fetchTopPostsWithCollegeId:self.appData.currentCollege.collegeID];
    }
    else if (self.recentPosts)
    {
        [self.appData.postDataController fetchNewPostsWithCollegeId:self.appData.currentCollege.collegeID];
    }
    else if (self.tagPosts && self.tagMessage != nil)
    {
        [self.appData.postDataController fetchAllPostsWithTagMessage:self.tagMessage
                                                       withCollegeId:self.appData.currentCollege.collegeID];
    }
}

#pragma mark - Actions

- (void)refresh
{   // refresh this post view
    if (self.appData.allColleges)
    {
        [self switchToAllColleges];
    }
    else if (self.appData.specificCollege)
    {
        [self switchToSpecificCollege];
    }
    [super refresh];
}

@end
