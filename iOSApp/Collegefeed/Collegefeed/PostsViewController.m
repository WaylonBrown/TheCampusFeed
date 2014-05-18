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

@implementation PostsViewController

//- (void)viewWillAppear:(BOOL)animated
//{   // View is about to appear after being inactive
//    
//    [super viewWillAppear:animated];
//    // refresh dataController?
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.postDataController = [[PostDataController alloc] init];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   // A little preparation before navigation to different view

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedPost = (Post *)[self.postDataController objectInListAtIndex:indexPath.row];
    CommentViewController* controller = [[CommentViewController alloc] initWithOriginalPost:self.selectedPost
                                                                               withDelegate:self];
    
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - Table View Override Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return [self.postDataController countOfList];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    // this specifies the prototype (PostTableCell) and assigns the labels
    
    //TODO: check if these cells should be of type PostTableCellWithCollege instead
    static NSString *CellIdentifier = @"TableCell";
    
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // get the post and display in this cell
    Post *postAtIndex = [self.postDataController objectInListAtIndex:indexPath.row];
    [cell assign:postAtIndex];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should probably not be hardcoded; revist
    
    // if not showing college name
    return 100;
    
    // if showing college name
//    return 120;
}


@end
