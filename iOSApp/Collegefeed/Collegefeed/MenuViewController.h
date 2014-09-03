//
//  MenuViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *navControllers;

- (id)initWithNavControllers:(NSArray *)navControllers;


@property (strong, nonatomic) NSArray *viewControllers;

- (id)initWithViewControllers:(NSArray *)viewControllers;

@end
