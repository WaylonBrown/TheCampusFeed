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

//@property (nonatomic, strong) UINavigationController *transitionsNavigationController;

@end

@implementation MenuViewController

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
////    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
//    // Need to set tableview delegate and datasource?
//    //
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//#pragma mark - Properties
//
//- (NSArray *)menuItems
//{
//    return @[@"Top Posts",
//           @"New Posts",
//           @"Trending Tags",
//           @"Most Active Colleges",
//           @"My Posts",
//           @"My Content"];
//}
//
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.menuItems.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"MenuCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuViewController"
//                                                     owner:self options:nil];
//        cell = [nib objectAtIndex:1];
//    }
//    
//    NSString *menuItem = self.menuItems[indexPath.row];
//    
//    cell.textLabel.text = menuItem;
////    [cell setBackgroundColor:[UIColor clearColor]];
//    
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *menuItem = self.menuItems[indexPath.row];
//    
//    // This undoes the Zoom Transition's scale because it affects the other transitions.
//    // You normally wouldn't need to do anything like this, but we're changing transitions
//    // dynamically so everything needs to start in a consistent state.
////    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    
//    if ([menuItem isEqualToString:@"Top Posts"])
//    {
//        // Show Top Posts!!
//    }
//    
//    
//    [self.slidingViewController resetTopViewAnimated:YES];
//}

@end
