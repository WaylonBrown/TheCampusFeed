//
//  CollegeViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/16/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "College.h"
#import "CollegeViewController.h"
#import "CollegeDataController.h"
#import "PostsViewController.h"

@implementation CollegeViewController

- (void)viewDidLoad
{   // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Comment View for the selected post
    
    self.selectedCollege = (College *)[self.collegeDataController objectInListAtIndex:indexPath.row];
    PostsViewController* controller = [[PostsViewController alloc] init];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - Table View Override Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return [self.collegeDataController countOfList];
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
    College *collegeAtIndex = (College*)[self.collegeDataController objectInListAtIndex:indexPath.row];
    [cell.textLabel setText:collegeAtIndex.name];
    
    return cell;
}


@end
