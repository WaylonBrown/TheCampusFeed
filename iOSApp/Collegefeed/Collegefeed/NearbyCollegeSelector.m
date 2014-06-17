//
//  NearbyCollegeSelector.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/7/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "NearbyCollegeSelector.h"
#import "Models/Models/College.h"
#import "AppData.h"
#import "Models/Models/Post.h"
#import "Shared.h"
#import "NewPostAlertView.h"

@implementation NearbyCollegeSelector

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithAppData:(AppData *)appData
{
    self = [super init];
    if (self)
    {
        [self setAppData:appData];
    }
    return self;
}
- (void)displaySelectorForNearbyColleges:(NSArray *)colleges
{   // If the user is near multiple colleges, display a custom alert view to select one
    
    NSUInteger numColleges = colleges.count;
    if (numColleges < 1) return;
    if (numColleges == 1)
    {
        [self displayPostToCollege:[colleges objectAtIndex:0]];
        return;
    }
    
    float width = 290;
    float titleHeight = 50;
    float tableHeight = (numColleges > 3)
                        ? 132
                        : numColleges * 44;
    float totalHeight = titleHeight + tableHeight;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, titleHeight)];
    titleLabel.layer.cornerRadius = 10;
    titleLabel.clipsToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"Select a college to post to"];
    [titleLabel setFont:CF_FONT_LIGHT(20)];
    [titleLabel setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleHeight, width, tableHeight)];
    tableView.layer.cornerRadius = 10;
    tableView.clipsToBounds = YES;
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    
    UIView *fullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, totalHeight)];
    [fullView addSubview:titleLabel];
    [fullView addSubview:tableView];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:fullView];

    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", nil]];
    [alertView setDelegate:self];
    
    [alertView show];
    
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView close];
}
- (void)displayPostToCollege:(College *)college
{   // Prompt the user to post a college
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Post"
                                                    message:[NSString stringWithFormat:@"Posting to %@", college.name]
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Post", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
//
//    float width = 290;
//    float titleHeight = 50;
//    float subTitleHeight = 50;
//    float textFieldHeight = 100;
//    float totalHeight = titleHeight + subTitleHeight + textFieldHeight;
//    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, titleHeight)];
//    title.layer.cornerRadius = 10;
//    title.clipsToBounds = YES;
//    title.textAlignment = NSTextAlignmentCenter;
//    [title setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
//    [title setText:@"New Post"];
//    [title setFont:CF_FONT_LIGHT(20)];
//    
//    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, titleHeight, width, subTitleHeight)];
//    [subTitle setText:[NSString stringWithFormat:@"Posting to %@", college.name]];
//    [subTitle setFont:CF_FONT_ITALIC(16)];
//
//    UITextField *postField = [[UITextField alloc] initWithFrame:CGRectMake(0, titleHeight + subTitleHeight, width, textFieldHeight)];
//
//    [postField setFont:CF_FONT_LIGHT(14)];
//    
//    UIView *fullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, totalHeight)];
//    
//    [fullView addSubview:title];
//    [fullView addSubview:subTitle];
//    [fullView addSubview:postField];
//    
//    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
//    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Post", nil]];
//
//    [alertView setContainerView:fullView];
//    [alertView setDelegate:self];
//    [alertView show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   // Add new post if user submits on the alert view
    
    if (buttonIndex == 0)
    {
        return;
    }
    College *currentCollege = [self.appData.nearbyColleges objectAtIndex:0];
    if (currentCollege != nil)
    {
        Post *newPost = [[Post alloc] initWithMessage:[[alertView textFieldAtIndex:0] text]
                                        withCollegeId:currentCollege.collegeID];
        [self.appData.dataController createPost:newPost];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A college must be selected to post to"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // User selected a college from the list, call delegate's selectedCollege function
    
    [(CustomIOS7AlertView *)tableView.superview.superview.superview close];
    
    College *college = [self.appData.nearbyColleges objectAtIndex:indexPath.row];
    [self displayPostToCollege:college];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of rows for each section.
    return self.appData.nearbyColleges.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // Display a cell representing a college that links to its feed
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    College *college = [self.appData.nearbyColleges objectAtIndex:indexPath.row];
    [cell.textLabel setFont:CF_FONT_LIGHT(16)];
    [cell.textLabel setText:college.name];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
