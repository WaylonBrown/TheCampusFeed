//
//  MenuViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/22/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "MenuViewController.h"
#import "SimpleTableCell.h"
#import "Shared.h"
#import "IIViewDeckController.h"
#import "TutorialViewController.h"
#import "CF_DialogViewController.h"
#import "PostsViewController.h"
#import "TopPostsViewController.h"
#import "NewPostsViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self != nil)
    {
        self.viewControllers = viewControllers;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToNewPosts) name:@"CreatedPost" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToTopPosts) name:@"SwitchToTopPosts" object:nil];
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.selectedIndex = 0;

    self.tableView.backgroundColor = [UIColor darkGrayColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (void)switchToNewPosts
{
    NewPostsViewController *viewController = self.viewControllers[NEW_POSTS_INDEX];
    
    [self.viewDeckController closeLeftView];
    
    self.selectedIndex = NEW_POSTS_INDEX;
    [self.viewDeckController setCenterController:viewController];
    
    [viewController.tableView reloadData];
    [viewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)switchToTopPosts
{
    TopPostsViewController *viewController = self.viewControllers[TOP_POSTS_INDEX];
    
    [self.viewDeckController closeLeftView];
    
    self.selectedIndex = TOP_POSTS_INDEX;
    [self.viewDeckController setCenterController:viewController];

    [viewController.tableView scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
}

#pragma mark - Properties

- (NSArray *)menuItems
{
    return @[@"Top Posts",
             @"New Posts",
             @"Trending Tags",
             @"Most Active Colleges",
             @"My Posts",
             @"My Comments",
             @"Achievements",
             @"Time Crunch",
             @"Help",
             @"Give Feedback"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }
    else if (section == 1)
    {
        return 6;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUInteger index = (indexPath.section * 4) + indexPath.row;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSString *menuItem = self.menuItems[index];
    
    cell.textLabel.text = menuItem;
    cell.backgroundColor = [UIColor darkGrayColor];
    [cell.textLabel setFont:CF_FONT_LIGHT(20)];
    cell.textLabel.textColor = [UIColor whiteColor];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [Shared getCustomUIColor:CF_BLUE];
    cell.selectedBackgroundView = view;
        
    if (index == self.selectedIndex)
    {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_CELL_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5;
    }
    else
    {
        return 20;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        dividerView.backgroundColor = [UIColor darkGrayColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [dividerView addSubview:lineView];
        return dividerView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = (indexPath.section * 4) + indexPath.row;
    [self.viewDeckController closeLeftView];

    if (index == FEEDBACK_INDEX)
    {   // 'Give feedback'
        [self openMail];
    }
    else if (index < self.viewControllers.count)
    {
        UIViewController *viewController = self.viewControllers[index];

        [self.viewDeckController closeLeftView];
        if (index == HELP_INDEX)
        {   // 'Help' selection just displays dialog over currently selected view
            [self.navigationController presentViewController:viewController animated:YES completion:nil];
        }
        else
        {
            self.selectedIndex = index;
            [self.viewDeckController setCenterController:viewController];
        }
    }
    else
    {
        NSLog(@"Error in MenuViewController menu selection, null viewController");

    }
}

- (void)openMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"iOS App Feedback"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"feedback@thecampusfeed.com", nil];
        [mailer setToRecipients:toRecipients];
        
        NSString *emailBody = @"Please enter your feedback here:";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self.navigationController presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTutorial
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);

    TutorialViewController *controller = [[TutorialViewController alloc] init];
    [controller.view setFrame:rect];
    [self.viewDeckController.centerController addChildViewController:controller];
    [self.viewDeckController.centerController.view addSubview:controller.view];
    
}
- (void)showRequiresUpdate
{
    CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:UPDATE];
    [self.viewDeckController.navigationController presentViewController:dialog animated:YES completion:nil];
    
}
@end
