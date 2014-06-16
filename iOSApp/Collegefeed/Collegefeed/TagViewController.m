//
//  TagViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//


#import "Models/Models/College.h"
#import "Models/Models/Tag.h"
#import "TagViewController.h"
#import "PostsViewController.h"
#import "Shared.h"
#import "SimpleTableCell.h"

@implementation TagViewController

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self.view setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Present a Post view of all posts with the selected tag
    self.selectedTag = (Tag *)[self.appData.dataController.allTags objectAtIndex:indexPath.row];
    PostsViewController* controller = [[PostsViewController alloc] initAsTagPostsWithAppData:self.appData
                                                                              withTagMessage:self.selectedTag.name];
    
    
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

#pragma mark - UITableView Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    return self.appData.dataController.allTags.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // invoked every time a table row needs to be shown.
    
    static NSString *CellIdentifier = @"SimpleTableCell";
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // get the post and display in this cell
    Tag *tagAtIndex = (Tag*)[self.appData.dataController.allTags objectAtIndex:indexPath.row];
    [cell assignTag:tagAtIndex];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should not be hardcoded; revist
    
    return 56;
}

#pragma mark - Actions

- (void)refresh
{   // refresh this tag view
    if (self.appData.allColleges)
    {
        [self.appData.dataController fetchAllTags];
    }
    else if (self.appData.specificCollege)
    {
        [self.appData.dataController fetchAllTagsWithCollegeId:self.appData.currentCollege.collegeID];
    }
    [super refresh];
}

@end
