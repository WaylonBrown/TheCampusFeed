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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   // A little preparation before navigation to different view

    UIViewController* vc = [segue destinationViewController];
    
//    if ([vc class] == [CommentViewController class] && [sender class] == [PostTableCell class])
//    {   // When switching to comment view
//        PostTableCell *cell = sender;
//        CommentViewController * cvc = (CommentViewController *) vc;
//        [cvc setDelegate:self];
//        [cvc setOriginalPost:cell.post];
//        return;
//    }
    
    if ([vc class] == [CreateViewController class] && [sender class] == [UIBarButtonItem class])
    {   // When creating a new post
        CreateViewController *createView = (CreateViewController *)vc;
        [createView setPDelegate:self];
        [createView.createLabel setText:@"Create new post"];
        [createView.createButton setTitle:@"Post!" forState:UIControlStateNormal];
        return;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedPost = (Post *)[self.dataController objectInListAtIndex:indexPath.row];
    CommentViewController* controller = [[CommentViewController alloc] initWithOriginalPost:self.selectedPost
                                                                               withDelegate:self];
    
    [self.navigationController presentViewController:controller
                                            animated:YES
                                          completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return [self.dataController countOfList];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    // this specifies the prototype (PostTableCell) and assigns the labels
    
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{   // User should not directly modify a PostTableCell

    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should probably not be hardcoded; revist

    return 100;
}


#pragma mark - Child view delegate methods

- (void)createdNewPost:(Post *)post
{   // User created a new post

    [self.dataController addPost:post];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    // reload the table
    [self.postTableView reloadData];
}
- (void)votedOnPost
{   // User voted on post (usually in subview)

    [self.postTableView reloadData];
}

@end
