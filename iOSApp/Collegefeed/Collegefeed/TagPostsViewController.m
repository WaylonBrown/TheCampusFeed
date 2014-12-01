//
//  TagPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TagPostsViewController.h"
#import "College.h"
#import "Shared.h"

@implementation TagPostsViewController

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tagMessage != nil)
    {
        return 50;
    }
    
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tagMessage != nil)
    {
        NSString *basicText = [NSString stringWithFormat:@"Posts with %@", self.tagMessage];
        
        CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 50);
        
        UILabel *header = [[UILabel alloc] init];
        if (self.dataController.showingSingleCollege && self.dataController.collegeInFocus.name != nil)
        {
            NSString *collegeSubHeader = [NSString stringWithFormat:@"in feed: %@", self.dataController.collegeInFocus.name];
            basicText = [NSString stringWithFormat:@"%@\n%@", basicText, collegeSubHeader];
            [header setNumberOfLines:2];
        }
        
        [header setFrame:frame];
        [header setText:basicText];
        [header setTextAlignment:NSTextAlignmentCenter];
        [header setFont:CF_FONT_LIGHT(16)];
        [header setBackgroundColor:[Shared getCustomUIColor:CF_EXTRALIGHTGRAY]];
        
        return header;
    }
    
    return nil;
}

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    if (self.dataController.showingAllColleges)
    {
        [self.dataController fetchPostsWithTagForAllColleges:self.tagMessage];
    }
    else
    {
        [self.dataController fetchPostsWithTagForSingleCollege:self.tagMessage];
    }
}
- (void)finishedFetchRequest
{
    [super finishedFetchRequest];
}
#pragma mark - Local Actions

- (void)changeFeed
{
    [super changeFeed];
}
- (void)refresh
{   // refresh this post view
    [super refresh];
}

#pragma mark - Helper Methods

- (void)setCorrectPostList
{
    if (self.dataController.showingAllColleges)
    {
        [self setList:self.dataController.postsWithTagAllColleges];
    }
    else
    {
        [self setList:self.dataController.postsWithTagInCollege];
    }
    
    [super setCorrectPostList];
}

@end