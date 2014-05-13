//
//  PostsViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostsViewController.h"
#import "PostTableCell.h"
#import "PostDataController.h"
#import "Post.h"
#import "CommentViewController.h"
#import "CreateViewController.h"

@implementation PostsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataController = [[PostDataController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// A little preparation before navigation to different view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* vc = [segue destinationViewController];
    
    if ([vc class] == [CommentViewController class] && [sender class] == [PostTableCell class])
    {   // When switching to comment view
        PostTableCell *cell = sender;
        CommentViewController * cvc = (CommentViewController *) vc;
        [cvc setDelegate:self];
        [cvc setOriginalPost:cell.post];
        return;
    }
    
    if ([vc class] == [CreateViewController class] && [sender class] == [UIBarButtonItem class])
    {   // When creating a new post
        CreateViewController *createView = (CreateViewController *)vc;
        [createView setPDelegate:self];
        [createView.createLabel setText:@"Create new post"];
        [createView.createButton setTitle:@"Post!" forState:UIControlStateNormal];
        return;
    }
}
 

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of posts in the list
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfList];
}
// invoked every time a table row needs to be shown.
// this specifies the prototype (PostTableCell) and assigns the labels
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: check if these cells should be of type PostTableCellWithCollege instead
    static NSString *CellIdentifier = @"PostTableCell";
    
    PostTableCell *cell = (PostTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // get the post and display in this cell
    Post *postAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    [cell setPost:postAtIndex];
    
    return cell;
}
// User should not directly modify a PostTableCell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
// TODO: This should probably not be hardcoded; revist
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
// set selected cell and post message of the selected cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPost = (Post *)[self.dataController objectInListAtIndex:indexPath.row];
}

#pragma mark - Child view delegate methods

// User created a new post
- (void)createdNewPost:(Post *)post
{
    [self.dataController addPost:post];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    // reload the table
    [self.postTableView reloadData];
}

// User voted on post (usually in subview)
- (void)votedOnPost
{
    [self.postTableView reloadData];
}

@end
