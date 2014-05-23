//
//  CollegePickerViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/23/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CollegePickerViewController.h"
#import "College.h"

@interface CollegePickerViewController ()

@end

@implementation CollegePickerViewController

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
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCollegesList:(NSMutableArray *)collegeList
{
    self.list = [[NSMutableArray alloc] initWithArray:collegeList];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Override Functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   //TODO: the code below is taken from PostViewController
    
    
    // Present a Comment View for the selected post
    
//    self.selectedPost = (Post *)[self.postDataController objectInListAtIndex:indexPath.row];
//    CommentViewController* controller = [[CommentViewController alloc] initWithOriginalPost:self.selectedPost];
//    
//    // when not in a navigation controller
//    [self presentViewController:controller animated:YES completion:nil];
//    
//    // if in a navigation controller
//    // [self.navigationController pushViewController:controller animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of posts in the list
    
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // Display
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//    [cell setDelegate: self];
    
    College *college = (College *)[self.list objectAtIndex:indexPath.row];
    [cell.textLabel setText:college.name];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   // TODO: This should probably not be hardcoded; revist
    
    // if not showing college name
    return 50;
    
    // if showing college name
    //    return 120;
}

@end
