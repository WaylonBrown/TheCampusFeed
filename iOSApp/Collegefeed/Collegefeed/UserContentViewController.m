//
//  UserContentViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/9/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "UserContentViewController.h"
#import "Shared.h"
#import "TableCell.h"
#import "DataController.h"
#import "Models/Models/Post.h"
#import "Models/Models/Comment.h"
#import "Models/Models/College.h"

@implementation UserContentViewController

- (id)initWithPosts:(NSMutableArray *)userPosts withComments:(NSMutableArray *)userComments
{
    self = [super initWithNibName:@"UserContentViewController" bundle:nil];
    if (self)
    {
        [self setPostArray:userPosts];
        [self setCommentArray:userComments];
    }
    return self;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitleView:logoTitleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegates

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{   // return the view for the header title
//    
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    [headerLabel setTextAlignment:NSTextAlignmentCenter];
//    [headerLabel setFont:[UIFont systemFontOfSize:12]];
//    [headerLabel setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
//    
//    if (tableView == self.postTableView)
//    {
//        [headerLabel setText:@"My Posts"];
//    }
//    else if (tableView == self.commentTableView)
//    {
//        [headerLabel setText:@"Comments"];
//    }
//    return headerLabel;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 25.0;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.postArray.count;
    }
    else if (section == 1)
    {
        return self.commentArray.count;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
//    [cell setDelegate: self];     // ChildCellDelegate: for voting; user wont be revoting their own content

    if (tableView == self.postTableView)
    {
        Post *postAtIndex = [self.postArray objectAtIndex:indexPath.row];
        // TODO: get college name for this post, (use same method you figure out in PostViewController)
        [cell assign:postAtIndex];
    }
    else if (tableView == self.commentTableView)
    {
        Comment *commentAtIndex = [self.commentArray objectAtIndex:indexPath.row];
        [cell assign:commentAtIndex];
    }
    
    return cell;

}
@end
