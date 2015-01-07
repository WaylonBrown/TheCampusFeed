//
//  PostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "PostsViewController.h"

@implementation PostsViewController

#pragma mark - Initialization

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        [self setCommentViewController:[[CommentViewController alloc] initWithDataController:self.dataController]];
    }
    return self;
}

#pragma mark - View Loading

- (void)loadView
{
    [super loadView];
}
- (void)viewWillAppear:(BOOL)animated
{   // View is about to appear after being inactive
    
    [self setCorrectList];
    
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (void)makeToolbarButtons
{   // Assigns correct icons and buttons to the upper toolbar
    
    // Show loading indicator until a nearby college is found,
    // then replace it with a compose button

    if ([self.dataController isNearCollege])
    {
        [self placeCreatePost];
    }
    else
    {
        [self placeLoadingIndicatorInToolbar];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSLog(@"Setting tableview to be automatic in %@", [self class]);
    self.tableView.estimatedRowHeight = POST_CELL_HEIGHT_ESTIMATE;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    // this specifies the prototype (TableCell) and assigns the labels
    
    NSUInteger rowNum = indexPath.row;
    NSUInteger listcount = self.list.count;
    if (rowNum == listcount - 1 && !self.hasFetchedAllContent)
    {   // if last post in list
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchContent];
        });
    }
    
    // Build a TableCell for Posts
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = (TableCell *)[[[NSBundle mainBundle]
                              loadNibNamed:CellIdentifier
                              owner:self
                              options:nil] objectAtIndex:0];
    }
    cell.delegate = self;

    // Get the post and display in this cell
    Post *post = [self.list objectAtIndex:indexPath.row];
    
    if([self.dataController.nearbyColleges containsObject:post.college])
    {
        post.isNearCollege = YES;
    }
    [cell assignWithPost:post withCollegeLabel:self.dataController.showingAllColleges];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    if (indexPath.row >= self.list.count)
    {   // Selection was out of bounds
        NSLog(@"ERROR: Out of bounds row selection from a PostsViewController");
        return;
    }
    
    Post *post = [self.list objectAtIndex:indexPath.row];
    [self.dataController setPostInFocus:post];
    self.commentViewController.parentPost = post;
    [self.navigationController pushViewController:self.commentViewController
                                         animated:YES];
//    [[self navigationItem] setBackBarButtonItem:self.commentViewController.backButton];
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    [super fetchContent];
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    [super finishedFetchRequest:notification];
}

#pragma mark - Local Actions

- (void)changeFeed
{
    [super changeFeed];
}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    [super setCorrectList];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.bounces = (scrollView.contentOffset.y < 50);
    
    CGRect frame = self.feedToolbar.frame;
    CGFloat size = frame.size.height;
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    
    self.previousScrollViewYOffset = scrollOffset;
    
    if (scrollOffset < 5)
    {   // keep bar showing if at top of scrollView
        self.toolBarSpaceFromBottom.constant = 50;
    }
    else if (scrollDiff > 0 && (frame.origin.y < scrollHeight))
    {   // flick up / scroll down / hide bar
        self.toolBarSpaceFromBottom.constant -= 4;
    }
    else if (scrollDiff < 0 && (frame.origin.y + size > scrollHeight))
    {   // flick down / scroll up / show bar
        self.toolBarSpaceFromBottom.constant += 4;
    }
    
    self.toolBarSpaceFromBottom.constant = MIN(self.toolBarSpaceFromBottom.constant, 50);
    [self.feedToolbar updateConstraintsIfNeeded];
}

#pragma mark - CreationViewProtocol Delegate Methods

- (void)submitPostCommentCreationWithMessage:(NSString *)message
{
    [self.dataController createPostWithMessage:message
                                 withCollegeId:self.dataController.currentCollegeFeedId
                                     withImage:nil];
    
//    if (!success)
//    {
//        [self.toastController toastPostFailed];
//    }
//    if (success)
//        [self refresh];
}

@end
