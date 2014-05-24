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
#import "Constants.h"

@implementation TagViewController

- (void)viewDidLoad
{
//    [self.navigationController.navigationBar.topItem setTitleView:logoTitleView];

    // Do any additional setup after loading the view.
    [super viewDidLoad];

    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   // A little preparation before navigation to different view
    
}
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

// Code when testing the attributed label

/*
-(IBAction) something
{
    NSArray *words = [self.tagsLabel.text componentsSeparatedByString:@" "];
    for (NSString *word in words)
    {
        if ([word hasPrefix:@"#"])
        {
            NSRange range = [self.tagsLabel.text rangeOfString:word];
            
            [self.tagsLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", word]] withRange:range];
        }
    }
}

- (void)showTagsList:(NSString *)tag
{
    UIViewController* controller = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil]  instantiateViewControllerWithIdentifier:@"tagView"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString* tagMessage = [url absoluteString];
    NSLog(@"tag = %@", tagMessage);
}
*/

@end
