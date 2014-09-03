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
             @"Help"];
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
        return 3;
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
    cell.textLabel.textColor = [UIColor whiteColor];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [Shared getCustomUIColor:CF_LIGHTBLUE];
    cell.selectedBackgroundView = view;
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = (indexPath.section * 4) + indexPath.row;
    
    if (index == 6)
    {
        // TODO: the help screen
        return;
    }
    
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
