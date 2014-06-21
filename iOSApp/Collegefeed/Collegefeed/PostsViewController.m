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

- (id)initAsType:(ViewSortingType)type withDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setViewSortingType:type];
        [self switchToAllColleges];
        
        switch (type)
        {
            case TOP:
                [self setList:controller.topPostsAllColleges];
                break;
            case RECENT:
                [self setList:controller.recentPostsAllColleges];
                break;
            case USER:
                [self setList:controller.userPostsAllColleges];
                break;
            case TAG:
                [self setList:controller.allPostsWithTag];
                break;
            default:
                break;
        }
        
        
    }
    return self;
}

#pragma mark - View Loading

- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    [super viewWillAppear:animated];
    if (self.viewSortingType == TAG && self.tagMessage == nil)
    {
        NSException *e = [NSException exceptionWithName:@"NoTagFoundException" reason:@"No Tag message provided for a PostsView filtered by Tag" userInfo:nil];
        [e raise];
    }
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
    if (self.viewSortingType == TOP)
    {
        [self.dataController fetchTopPosts];
    }
    else if (self.viewSortingType == RECENT)
    {
        [self.dataController fetchNewPosts];
    }
    else if (self.viewSortingType == TAG && self.tagMessage != nil)
    {
        [self.dataController fetchAllPostsWithTagMessage:self.tagMessage];
    }
}
- (void)switchToSpecificCollege
{
    if (self.viewSortingType == TOP)
    {
        // TODO: this is calling dataController's function and passing its own variable to itself
        [self.dataController fetchTopPostsWithCollegeId:self.dataController.collegeInFocus.collegeID];
    }
    else if (self.viewSortingType == RECENT)
    {
        [self.dataController fetchNewPostsWithCollegeId:self.dataController.collegeInFocus.collegeID];
    }
    else if (self.viewSortingType == TAG && self.tagMessage != nil)
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
