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
#import "ToastController.h"

@implementation PostsViewController

#pragma mark - Initializations

- (id)initAsType:(ViewType)type withDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setViewType:type];
        [self switchToAllColleges];
        
        switch (type)
        {
            case TOP_VIEW:
                [self setList:controller.topPostsAllColleges];
                break;
            case RECENT_VIEW:
                [self setList:controller.recentPostsAllColleges];
                break;
            case USER_VIEW:
                [self setList:controller.userPosts];
                break;
            case TAG_VIEW:
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
    if (self.viewType == TAG && self.tagMessage == nil)
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
    
    [self.navigationController.navigationItem setHidesBackButton:YES];
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
    NSString *collegeName = [self.dataController getCollegeNameById:[postAtIndex getCollegeID]];
    [postAtIndex setCollegeName:collegeName];
    [cell assign:postAtIndex];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should not be hardcoded; revist
    if (self.dataController.showingAllColleges)
    {
        return 120;
    }
    else
    {
        return 100;
    }
}

#pragma mark - Navigation

- (void)switchToAllColleges
{
    switch (self.viewType)
    {
        case TOP_VIEW:
            [self.dataController fetchTopPosts];
            [self setList:self.dataController.topPostsAllColleges];
            break;
        case RECENT_VIEW:
            [self.dataController fetchNewPosts];
            [self setList:self.dataController.recentPostsAllColleges];
            break;
        case TAG_VIEW:
            if (self.tagMessage != nil)
            {
                [self.dataController fetchAllPostsWithTagMessage:self.tagMessage];
            }
            [self setList:self.dataController.allPostsWithTag];
            break;
        default:
            break;
    }
}
- (void)switchToSpecificCollege
{
    switch (self.viewType)
    {
        case TOP_VIEW:
            // TODO: this is calling dataController's function and passing its own variable to itself
            [self.dataController fetchTopPostsWithCollegeId:self.dataController.collegeInFocus.collegeID];
            [self setList:self.dataController.topPostsInCollege];
            break;
        case RECENT_VIEW:
            [self.dataController fetchNewPostsWithCollegeId:self.dataController.collegeInFocus.collegeID];
            [self setList:self.dataController.recentPostsInCollege];
            break;
        case TAG_VIEW:
            if (self.tagMessage != nil)
            {
                [self setList:self.dataController.allPostsWithTagInCollege];
            }
            [self.dataController fetchAllPostsWithTagMessage:self.tagMessage
                                               withCollegeId:self.dataController.collegeInFocus.collegeID];

            break;
        default:
            break;
    }
    College *college = self.dataController.collegeInFocus;
    if (college != nil)
    {
        if ([self.dataController.nearbyColleges containsObject:college])
        {
            [self.toastController toastFeedSwitchedToNearbyCollege:college.name];
        }
        else
        {
            [self.toastController toastFeedSwitchedToDistantCollege:college.name];
        }
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

#pragma mark - CreationViewProtocol Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
{
    BOOL success = [self.dataController createPostWithMessage:message
                                 withCollegeId:self.dataController.collegeInFocus.collegeID];
    
    if (!success)
    {
        [self.toastController toastPostFailed];
    }
    [self refresh];
}

@end
