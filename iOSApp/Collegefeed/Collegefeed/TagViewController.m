//
//  TagViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//


#import "College.h"
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Post view of all posts with the selected tag
    self.selectedTag = (Tag *)[self.appDelegate.tagDataController objectInListAtIndex:indexPath.row];
    PostsViewController* controller = [[PostsViewController alloc] initAsTagPostsWithDelegateId:self.appDelegate
                                                                                 withTagMessage:self.selectedTag.name];
    
    
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - UITableView Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return [self.appDelegate.tagDataController countOfList];
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
    Tag *tagAtIndex = (Tag*)[self.appDelegate.tagDataController objectInListAtIndex:indexPath.row];
    [cell.textLabel setText:tagAtIndex.name];
    
    return cell;
}

#pragma mark - Actions

- (void)refresh
{   // refresh this tag view
    if ([self.appDelegate getIsAllColleges])
    {
        [self.collegeSegmentControl setSelectedSegmentIndex:0];
        [self.appDelegate.tagDataController fetchAllTags];
    }
    else if ([self.appDelegate getIsSpecificCollege])
    {
        if (self.collegeSegmentControl.numberOfSegments < 3)
        {
            [self.collegeSegmentControl insertSegmentWithTitle:[self.appDelegate getUsersCurrentCollege].name
                                                       atIndex:2 animated:NO];
        }
        else
        {
            [self.collegeSegmentControl setTitle:[self.appDelegate getUsersCurrentCollege].name
                               forSegmentAtIndex:2];
        }
        
        [self.collegeSegmentControl setSelectedSegmentIndex:2];
        [self.appDelegate.tagDataController fetchAllTagsWithCollegeId:[self.appDelegate getUsersCurrentCollege].collegeID];
    }
    [super refresh];
}

@end
