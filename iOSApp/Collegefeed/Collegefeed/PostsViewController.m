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
- (void)viewWillAppear:(BOOL)animated
{   // Post View is about to appear; reload table data
    [self.postTableView reloadData];
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

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedPost = (Post *)[self.dataController objectInListAtIndex:indexPath.row];
    CommentViewController* controller = [[CommentViewController alloc] initWithOriginalPost:self.selectedPost
                                                                               withDelegate:self];
    
    [self.navigationController pushViewController:controller
                                         animated:YES];
//                                          completion:nil];
}

#pragma mark - Table View Override Functions

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
    
    // if not showing college name
    return 100;
    
    // if showing college name
//    return 120;
}

#pragma mark - Actions

- (IBAction)createPost:(id)sender
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
    
    Post *newPost = [[Post alloc] initWithPostMessage:[[alertView textFieldAtIndex:0] text]];
//    [newPost validatePost];
    [self.dataController addPost:newPost];
    [self.postTableView reloadData];

}
- (void)votedOnPost
{   //TODO: I dont like this
    // just called to refresh table when child (comments) view is finished

//    [self.postTableView reloadData];
}


@end
