//
//  MenuViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "SimpleTableCell.h"

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Properties

- (NSArray *)menuItems
{
    return @[@"Top Posts",
           @"New Posts",
           @"Trending Tags",
           @"Most Active Colleges",
           @"My Posts",
           @"My Comments"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = self.menuItems.count;
    return count;
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
    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    cell.textLabel.text = menuItem;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navController = self.navControllers[indexPath.row];
    if (navController == nil || [navController class] != [UINavigationController class])
    {
        [self.slidingViewController resetTopViewAnimated:YES];
        return;
    }
    else
    {
        [self.slidingViewController setTopViewController:navController];
        [navController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
