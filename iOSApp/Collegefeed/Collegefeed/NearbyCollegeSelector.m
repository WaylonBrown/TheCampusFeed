//
//  NearbyCollegeSelector.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/7/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "NearbyCollegeSelector.h"
#import "College.h"
#import "AppData.h"
#import "Post.h"

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
    
    if (colleges.count < 1) return;
    if (colleges.count == 1)
    {
        [self displayPostToCollege:[colleges objectAtIndex:0]];
        return;
    }
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    int numColleges = colleges.count;
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, numColleges * 30)];
    
    for (int i = 0; i < numColleges; i++)
    {
        College *college = [colleges objectAtIndex:i];
        
        float y = 25 * i + 10;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, y, 250, 20)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:college.name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(displayPostToCollege:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [buttonsView addSubview:button];
    }
    
    
    [alertView setContainerView:buttonsView];
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"nvm...", nil]];
    [alertView setDelegate:self];
    
    [alertView show];
    
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView close];
}
- (void)displayPostToCollege:(UIButton*)sender
{   // Prompt the user to post a college
    
    College *college;
    if ([sender class] == [College class])
    {
        college = (College *)sender;
    }
    else if ([sender.superview.superview.superview class] == [CustomIOS7AlertView class])
    {
        [(CustomIOS7AlertView *)sender.superview.superview.superview close];
        college = [self.appData.nearbyColleges objectAtIndex:sender.tag];
    }
    else
    {
        return;
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Post"
                                                    message:[NSString stringWithFormat:@"Posting to %@", college.name]
                                                   delegate:self
                                          cancelButtonTitle:@"nvm.."
                                          otherButtonTitles:@"Post dis bitch!", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
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
        [self.appData.postDataController POSTtoServer:newPost
                                             intoList:self.appData.postDataController.topPostsAllColleges];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A college must be selected to post to"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
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
