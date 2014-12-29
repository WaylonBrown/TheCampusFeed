//
//  TagPostsViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "TagPostsViewController.h"
#import "College.h"
#import "Shared.h"

@implementation TagPostsViewController

#pragma mark - Initialization

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithDataController:controller];
    if (self)
    {
        self.tag = self.dataController.tagInFocus;
        self.tagMessage = (self.tag == nil) ? @"" : self.tag.name;

    }
    
    return self;
}
- (id)initWithDataController:(DataController *)controller WithTagMessage:(NSString *)text
{
    self = [super initWithDataController:controller];
    if (self)
    {
        self.tagMessage = (text == nil) ? @"" : text;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
}
#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tagMessage == nil || [self.tagMessage isEqualToString:@""])
    {
        return 0;
    }
    
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tagMessage == nil || [self.tagMessage isEqualToString:@""])
    {
        return nil;
    }
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

#pragma mark - Network Actions

- (void)fetchContent
{   // Fetches new content for this view
    
    [super fetchContent];
    
    if (self.dataController.showingAllColleges)
    {
        [self.dataController fetchPostsWithTagForAllColleges:self.tagMessage];
    }
    else
    {
        [self.dataController fetchPostsWithTagForSingleCollege:self.tagMessage];
    }
}
- (void)finishedFetchRequest:(NSNotification *)notification
{
    [super finishedFetchRequest:notification];
}
#pragma mark - Local Actions

- (void)changeFeed
{
    [super changeFeed];
}
//- (void)refresh
//{   // refresh this post view
//    [super refresh];
//}

#pragma mark - Helper Methods

- (void)setCorrectList
{
    if (self.dataController.showingAllColleges)
    {
        [self setList:self.dataController.postsWithTagAllColleges];
    }
    else
    {
        [self setList:self.dataController.postsWithTagSingleCollege];
    }
    
    [super setCorrectList];
}

@end