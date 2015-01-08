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

@interface TagPostsViewController()

@property (strong, nonatomic) NSString *tagMessage;

@end

@implementation TagPostsViewController

#pragma mark - Initialization

- (void)loadView
{
    [super loadView];
}
- (BOOL)assignTagMessage:(NSString *)tag
{
    if (![self.tagMessage isEqualToString:tag])
    {
        NSLog(@"Assigning new tag = %@ in TagPostsViewController", tag);
        self.dataController.pageForTaggedPostsAllColleges = 0;
        self.dataController.pageForTaggedPostsSingleCollege = 0;
        self.tagMessage = tag;
        [self.list removeAllObjects];
//        [self fetchContent];
        return YES;
    }
    
    return NO;
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
    if (self.dataController.showingSingleCollege
        && self.dataController.currentCollegeFeedId > 0)
    {
        NSString *collegeName = [self.dataController getCurrentFeedName];
        NSString *subHeader = [NSString stringWithFormat:@"in feed: %@", collegeName];
        basicText = [NSString stringWithFormat:@"%@\n%@", basicText, subHeader];
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