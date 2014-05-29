//
//  TagViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//


#import "Tag.h"
#import "TagViewController.h"
#import "TagDataController.h"
#import "PostsViewController.h"
#import "Shared.h"

@implementation TagViewController

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];

    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

#pragma mark - Navigation

//- (void)switchToAllColleges
//{
//    [super switchToAllColleges];
//}
//- (void)switchToSpecificCollege
//{
//    [super switchToSpecificCollege];
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedTag = (Tag *)[self.tagDataController objectInListAtIndex:indexPath.row];
    PostsViewController* controller = [[PostsViewController alloc] init];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - Table View Override Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return [self.tagDataController countOfList];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    
    static NSString *CellIdentifier = @"BasicTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // get the post and display in this cell
    Tag *tagAtIndex = (Tag*)[self.tagDataController objectInListAtIndex:indexPath.row];
    [cell.textLabel setText:tagAtIndex.name];
    
    return cell;
}

@end
