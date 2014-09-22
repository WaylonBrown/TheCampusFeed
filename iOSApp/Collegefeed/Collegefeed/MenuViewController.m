//
//  MenuViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "MenuViewController.h"
#import "SimpleTableCell.h"
#import "Shared.h"
#import "IIViewDeckController.h"
#import "TutorialViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNavControllers:(NSArray *)navControllers
{
    self = [super init];
    if (self != nil)
    {
        self.navControllers = navControllers;
    }
    return self;
}
- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self != nil)
    {
        self.viewControllers = viewControllers;
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

#pragma mark - Properties

- (NSArray *)menuItems
{
    return @[@"Top Posts",
             @"New Posts",
             @"Trending Tags",
             @"Most Active Colleges",
             @"My Posts",
             @"My Comments",
             @"Help",
             @"Suggest Feedback"];
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
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    NSUInteger index = (indexPath.section * 4) + indexPath.row;
    
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
    float windowHeight = self.view.frame.size.height;
    float cellHeight = (windowHeight - 30.0) / 8.0f;
    return cellHeight;
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
    self.selectedIndex = indexPath.row;
    NSUInteger index = (indexPath.section * 4) + indexPath.row;
    
//    if (index == 6)
//    {
//
//
//        [self.viewDeckController closeLeftView];
//        
//        // TODO: this is temporary to be able to see tutorial screen
//        
//        
//        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
//        
//        TutorialViewController *controller = [[TutorialViewController alloc] init];
//        [controller.view setFrame:rect];
//        [self.viewDeckController.centerController addChildViewController:controller];
//        [self.viewDeckController.centerController.view addSubview:controller.view];
//        
//        return;
//    }
    
    UIViewController *viewController = self.viewControllers[index];
    
    if (viewController == nil)
    {
        NSLog(@"Error in MenuViewController menu selection");
    }
    else
    {
        [self.viewDeckController setCenterController:viewController];
    }
    
    [self.viewDeckController closeLeftView];
}

@end
